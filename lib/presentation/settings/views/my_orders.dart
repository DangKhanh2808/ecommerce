import 'package:ecommerce/common/helper/navigator/app_navigator.dart';
import 'package:ecommerce/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce/domain/order/entities/order.dart';
import 'package:ecommerce/presentation/settings/bloc/order_display_state.dart';
import 'package:ecommerce/presentation/settings/bloc/orders_display_cubit.dart';
import 'package:ecommerce/presentation/settings/views/order_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/theme_helper.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(
        title: Text('My Orders'),
      ),
      body: BlocProvider(
        create: (context) => OrdersDisplayCubit(),
        child: _MyOrdersContent(),
      ),
    );
  }
}

class _MyOrdersContent extends StatefulWidget {
  @override
  State<_MyOrdersContent> createState() => _MyOrdersContentState();
}

class _MyOrdersContentState extends State<_MyOrdersContent> {
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure the widget is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<OrdersDisplayCubit>().displayOrders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersDisplayCubit, OrdersDisplayState>(
      builder: (context, state) {
        if (state is OrdersLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        if (state is OrdersLoaded) {
          if (state.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: ThemeHelper.getTextSecondaryColor(context),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No orders found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: ThemeHelper.getTextPrimaryColor(context),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You haven\'t placed any orders yet',
                    style: TextStyle(
                      fontSize: 14,
                      color: ThemeHelper.getTextSecondaryColor(context),
                    ),
                  ),
                ],
              ),
            );
          }
          return _orders(state.orders);
        }

        if (state is LoadOrdersFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load orders',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: ThemeHelper.getTextPrimaryColor(context),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.errorMessage,
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemeHelper.getTextSecondaryColor(context),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<OrdersDisplayCubit>().displayOrders();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        return Container();
      },
    );
  }

  Widget _orders(List<OrderEntity> orders) {
    return Builder(
      builder: (context) => Container(
        color: ThemeHelper.getBackgroundColor(context),
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetailPage(
                        orderEntity: orders[index],
                      ),
                    ));
                
                // Nếu quay lại với result = true, refresh danh sách đơn hàng
                if (result == true) {
                  context.read<OrdersDisplayCubit>().refreshOrders();
                }
              },
              child: Container(
                constraints: const BoxConstraints(minHeight: 80),
                padding: const EdgeInsets.all(16),
                decoration: ThemeHelper.getCardDecoration(context),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.receipt_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #${orders[index].code}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: ThemeHelper.getTextPrimaryColor(context),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 4,
                            runSpacing: 2,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                '${orders[index].products.length} items',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: ThemeHelper.getTextSecondaryColor(context),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '•',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: ThemeHelper.getTextSecondaryColor(context),
                                ),
                              ),
                              Text(
                                '\$${orders[index].totalPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: ThemeHelper.getTextPrimaryColor(context),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          _buildOrderStatus(orders[index]),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ThemeHelper.getIconSecondaryColor(context),
                      size: 16,
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemCount: orders.length,
        ),
      ),
    );
  }

  Widget _buildOrderStatus(OrderEntity order) {
    // Tìm trạng thái cuối cùng của đơn hàng
    String statusText = 'Processing';
    Color statusColor = Colors.orange;
    
    if (order.orderStatus.isNotEmpty) {
      // Tìm trạng thái cuối cùng (done = true)
      final lastStatus = order.orderStatus.lastWhere(
        (status) => status.done,
        orElse: () => order.orderStatus.first,
      );
      
      switch (lastStatus.title) {
        case 'Cancelled':
          statusText = 'Cancelled';
          statusColor = Colors.red;
          break;
        case 'Delivered':
          statusText = 'Delivered';
          statusColor = Colors.green;
          break;
        case 'Shipped':
          statusText = 'Shipped';
          statusColor = Colors.blue;
          break;
        case 'Processing':
          statusText = 'Processing';
          statusColor = Colors.orange;
          break;
        default:
          statusText = lastStatus.title;
          statusColor = Colors.grey;
      }
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: statusColor,
        ),
      ),
    );
  }
}
