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

  bool _canCancelOrder() {
    final statuses = widget.orderEntity.orderStatus;

    final isCancelled =
        statuses.any((s) => s.title == 'Cancelled' && s.done == true);
    final isDelivered =
        statuses.any((s) => s.title == 'Delivered' && s.done == true);
    final isShipped =
        statuses.any((s) => s.title == 'Shipped' && s.done == true);

    return !isCancelled && !isDelivered && !isShipped;
  }

  Future<void> _rebuyAllProducts() async {
    setState(() => _isLoading = true);

    try {
      int success = 0;

      for (var product in widget.orderEntity.products) {
        final res = await sl<RebuyProductUseCase>().call(params: product);

        res.fold(
          (error) {},
          (ok) => success++,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$success products added to cart!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong!'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  Future<void> _cancelOrder() async {
    final reason = await showDialog<String>(
      context: context,
      builder: (_) => CancelOrderDialog(),
    );

    if (reason == null || reason.trim().isEmpty) return;

    setState(() => _isCancelling = true);

    final result = await sl<CancelOrderUseCase>().call(params: {
      "orderCode": widget.orderEntity.code,
      "cancelReason": reason
    });

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      },
      (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order cancelled!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).pop(true);
      },
    );

    setState(() => _isCancelling = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          'Order #${widget.orderEntity.code.substring(0, 10)}',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _status(),
            const SizedBox(height: 30),
            _items(context),
            const SizedBox(height: 30),
            _shipping(),
          ],
        ),
      ),
    );
  }

  Widget _status() {
    final statuses = widget.orderEntity.orderStatus;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: ThemeHelper.getCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Order Status",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ThemeHelper.getTextPrimaryColor(context))),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: statuses.length,
            reverse: true,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (_, i) {
              final s = statuses[i];

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        color: s.done ? Colors.green : Colors.grey.shade400,
                        shape: BoxShape.circle,
                      ),
                      child: s.done
                          ? const Icon(Icons.check, color: Colors.white, size: 18)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      s.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ThemeHelper.getTextPrimaryColor(context),
                      ),
                    ),
                  ]),
                  Text(
                    "${s.createdDate.year}-${s.createdDate.month}-${s.createdDate.day}",
                    style: TextStyle(
                      fontSize: 14,
                      color: ThemeHelper.getTextSecondaryColor(context),
                    ),
                  ),
                ],
              );
            },
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
          Text(
            "Order Items",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ThemeHelper.getTextPrimaryColor(context),
            ),
          ),
          const SizedBox(height: 12),

          // ----- ACTION BUTTONS -----
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _rebuyAllProducts,
                  icon: _isLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child:
                              CircularProgressIndicator(color: Colors.white))
                      : const Icon(Icons.shopping_cart),
                  label: Text(_isLoading ? "Adding..." : "Rebuy All"),
                ),
              ),
              if (_canCancelOrder()) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: _isCancelling ? null : _cancelOrder,
                    icon: _isCancelling
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                                color: Colors.white))
                        : const Icon(Icons.cancel),
                    label: Text(_isCancelling ? "Cancelling..." : "Cancel"),
                  ),
                ),
              ]
            ],
          ),

          const SizedBox(height: 20),

          GestureDetector(
            onTap: () {
              AppNavigator.push(
                context,
                OrderItemsPage(products: widget.orderEntity.products),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: ThemeHelper.getContainerDecoration(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${widget.orderEntity.products.length} items",
                      style: TextStyle(
                          color: ThemeHelper.getTextPrimaryColor(context),
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  Icon(Icons.arrow_forward_ios_rounded,
                      color: ThemeHelper.getIconSecondaryColor(context)),
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
              const Icon(Icons.location_on_outlined),
              const SizedBox(width: 8),
              Text("Shipping Details",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ThemeHelper.getTextPrimaryColor(context))),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.orderEntity.shippingAddress,
            style: TextStyle(
              fontSize: 16,
              color: ThemeHelper.getTextPrimaryColor(context),
            ),
          )
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
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Cancel Order"),
      content: TextField(
        controller: _controller,
        maxLines: 3,
        decoration: const InputDecoration(
          labelText: "Reason",
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close")),
        ElevatedButton(
          onPressed: () =>
              Navigator.pop(context, _controller.text.trim()),
          child: const Text("Confirm"),
        ),
      ],
    );
  }
}
