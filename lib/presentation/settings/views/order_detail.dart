import 'package:ecommerce/common/helper/navigator/app_navigator.dart';
import 'package:ecommerce/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce/domain/order/entities/order.dart';
import 'package:ecommerce/domain/order/usecases/cancel_order.dart';
import 'package:ecommerce/domain/order/usecases/rebuy_product.dart';
import 'package:ecommerce/presentation/settings/views/order_items.dart';
import 'package:ecommerce/service_locator.dart';
import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/theme_helper.dart';

class OrderDetailPage extends StatefulWidget {
  final OrderEntity orderEntity;
  const OrderDetailPage({required this.orderEntity, super.key});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  bool _isLoading = false;
  bool _isCancelling = false;

  // Kiểm tra xem đơn hàng có thể hủy được không
  bool _canCancelOrder() {
    // Kiểm tra xem đơn hàng đã bị hủy chưa
    bool isCancelled = widget.orderEntity.orderStatus.any((status) => 
        status.title == 'Cancelled' && status.done == true);
    
    // Kiểm tra xem đơn hàng đã được giao chưa
    bool isDelivered = widget.orderEntity.orderStatus.any((status) => 
        status.title == 'Delivered' && status.done == true);
    
    // Kiểm tra xem đơn hàng đã được ship chưa
    bool isShipped = widget.orderEntity.orderStatus.any((status) => 
        status.title == 'Shipped' && status.done == true);
    
    // Chỉ có thể hủy nếu chưa bị hủy, chưa được giao và chưa được ship
    return !isCancelled && !isDelivered && !isShipped;
  }

  Future<void> _rebuyAllProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      int successCount = 0;
      int totalProducts = widget.orderEntity.products.length;

      for (var product in widget.orderEntity.products) {
        final result = await sl<RebuyProductUseCase>().call(
          params: product,
        );

        result.fold(
          (error) {
            // Continue with other products even if one fails
          },
          (success) {
            successCount++;
          },
        );
      }

      if (successCount == totalProducts) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('All $totalProducts products added to cart successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (successCount > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$successCount out of $totalProducts products added to cart successfully.'),
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add products to cart. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _cancelOrder() async {
    // Hiển thị dialog nhập lý do hủy
    String? cancelReason = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return CancelOrderDialog();
      },
    );

    if (cancelReason == null || cancelReason.trim().isEmpty) return;

    setState(() {
      _isCancelling = true;
    });

    try {
      final result = await sl<CancelOrderUseCase>().call(
        params: {
          'orderId': widget.orderEntity.orderId,
          'cancelReason': cancelReason,
        },
      );

      result.fold(
        (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: Colors.red,
            ),
          );
        },
        (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Order has been cancelled successfully'),
              backgroundColor: Colors.green,
            ),
          );
          // Quay lại trang trước và refresh danh sách đơn hàng
          Navigator.of(context).pop(true);
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
                      content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isCancelling = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BasicAppbar(
          title: Text(
            'Order #${widget.orderEntity.code.length > 10 ? '${widget.orderEntity.code.substring(0, 10)}...' : widget.orderEntity.code}',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _status(),
              const SizedBox(
                height: 50,
              ),
              _items(context),
              const SizedBox(
                height: 30,
              ),
              _shipping()
            ],
          ),
        ));
  }

  Widget _status() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: ThemeHelper.getCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Status',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: ThemeHelper.getTextPrimaryColor(context),
            ),
          ),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final status = widget.orderEntity.orderStatus[index];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: ThemeHelper.getStatusColor(context, status.done),
                            shape: BoxShape.circle,
                            boxShadow: status.done ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ] : null,
                          ),
                          child: status.done
                              ? const Icon(Icons.check, color: Colors.white, size: 20)
                              : Container(),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            status.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: ThemeHelper.getStatusTextColor(context, status.done),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Text(
                      status.createdDate.toDate().toString().split(' ')[0].length > 10 
                          ? '${status.createdDate.toDate().toString().split(' ')[0].substring(0, 10)}...'
                          : status.createdDate.toDate().toString().split(' ')[0],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: ThemeHelper.getStatusTextColor(context, status.done),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            reverse: true,
            itemCount: widget.orderEntity.orderStatus.length,
          ),
        ],
      ),
    );
  }

  Widget _items(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: ThemeHelper.getCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Items',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: ThemeHelper.getTextPrimaryColor(context),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _rebuyAllProducts,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.shopping_cart, size: 16),
                  label: Text(
                    _isLoading ? 'Adding...' : 'Rebuy All',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                ),
                    ),
                  ),
                  if (_canCancelOrder()) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton.icon(
                          onPressed: _isCancelling ? null : _cancelOrder,
                          icon: _isCancelling
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Icon(Icons.cancel, size: 16),
                          label: Text(
                            _isCancelling ? 'Cancelling...' : 'Cancel Order',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              AppNavigator.push(
                  context, OrderItemsPage(products: widget.orderEntity.products));
            },
            child: Container(
              width: double.infinity,
              height: 80,
              padding: const EdgeInsets.all(16),
              decoration: ThemeHelper.getContainerDecoration(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
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
                                '${widget.orderEntity.products.length > 999 ? '999+' : widget.orderEntity.products.length} Items',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: ThemeHelper.getTextPrimaryColor(context),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'View all products',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11,
                                  color: ThemeHelper.getTextSecondaryColor(context),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: ThemeHelper.getIconSecondaryColor(context),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shipping() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: ThemeHelper.getCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Shipping Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: ThemeHelper.getTextPrimaryColor(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeHelper.getSecondBackgroundColor(context),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: ThemeHelper.getBorderColor(context),
                width: 0.5,
              ),
            ),
            child: Text(
              widget.orderEntity.shippingAddress,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: ThemeHelper.getTextPrimaryColor(context),
                height: 1.4,
              ),
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}

class CancelOrderDialog extends StatefulWidget {
  @override
  State<CancelOrderDialog> createState() => _CancelOrderDialogState();
}

class _CancelOrderDialogState extends State<CancelOrderDialog> {
  final TextEditingController _reasonController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cancel Order'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Please provide a reason for cancelling this order:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Cancellation Reason',
                hintText: 'Enter the reason for cancellation...',
                border: OutlineInputBorder(),
                filled: true,
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a cancellation reason';
                }
                if (value.trim().length < 10) {
                  return 'Reason must be at least 10 characters';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(_reasonController.text.trim());
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Confirm Cancellation'),
        ),
      ],
    );
  }
}
