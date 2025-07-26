import 'package:ecommerce/common/bloc/button/button_state_cubit.dart';
import 'package:ecommerce/common/helper/cart/cart.dart';
import 'package:ecommerce/common/helper/navigator/app_navigator.dart';
import 'package:ecommerce/common/widgets/button/basic_reative_button.dart';
import 'package:ecommerce/core/service/pay_with_paypal.dart';
import 'package:ecommerce/data/order/model/order_registration_req.dart';
import 'package:ecommerce/domain/order/entities/product_oredered.dart';
import 'package:ecommerce/domain/order/usecases/order_registration.dart';
import 'package:ecommerce/presentation/cart/views/order_placed.dart';
import 'package:ecommerce/presentation/cart/views/payment_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/bloc/button/button_state.dart';
import '../../../common/widgets/appbar/app_bar.dart';
import 'dart:async';
import 'package:app_links/app_links.dart';

class CheckOutPage extends StatefulWidget {
  final List<ProductOrderedEntity> products;
  const CheckOutPage({required this.products, super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  final TextEditingController _addressCon = TextEditingController();
  StreamSubscription? _linkSub;
  final _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    _linkSub = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null && uri.toString().contains('payment-success')) {
        PayPalService.handlePaymentSuccess(context);
      }
      // Nếu muốn xử lý payment-cancel thì thêm else if ở đây
    });
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    _addressCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: const Text('Checkout'),
        action: IconButton(
          icon: const Icon(Icons.refresh, color: Colors.deepPurple),
          onPressed: () {
            // Kiểm tra nếu có thông tin đơn hàng PayPal đã lưu
            if (PayPalService.currentOrderInfo != null) {
              PayPalService.handlePaymentSuccess(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Không có thông tin đơn hàng để xử lý'),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          },
          tooltip: 'Reload - Xử lý thanh toán PayPal',
        ),
      ),
      body: BlocProvider(
        create: (context) => ButtonStateCubit(),
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (context, state) {
            if (state is ButtonSuccessState) {
              AppNavigator.pushAndRemove(context, const OrderPlacedPage());
            }
            if (state is ButtonFailureState) {
              var snackbar = SnackBar(
                content: Text(state.errorMessage),
                behavior: SnackBarBehavior.floating,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Builder(builder: (parentContext) {
              return Column(
                children: [
                  _addressField(),
                  const SizedBox(height: 20),
                  // Nút thanh toán PayPal
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.payment, color: Colors.white),
                      label: const Text(
                        "Thanh toán bằng PayPal",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () => _payWithPaypal(parentContext),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0070BA), // PayPal blue
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Nút đặt hàng COD
                  BasicReactiveButton(
                    content: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${CartHelper.calculateCartSubtotal(widget.products)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Text(
                            'Thanh toán COD',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                    onPressed: () => _showCODConfirmationDialog(parentContext),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _addressField() {
    return TextField(
      controller: _addressCon,
      minLines: 2,
      maxLines: 4,
      decoration: const InputDecoration(
        hintText: 'Shipping Address',
        border: OutlineInputBorder(),
      ),
    );
  }

  void _payWithPaypal(BuildContext parentContext) async {
    final total = CartHelper.calculateCartSubtotal(widget.products);
    
    // Kiểm tra địa chỉ giao hàng
    if (_addressCon.text.trim().isEmpty) {
      ScaffoldMessenger.of(parentContext).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập địa chỉ giao hàng'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    // Lưu thông tin đơn hàng để sử dụng sau khi thanh toán thành công
    PayPalService.currentOrderInfo = {
      'total': total,
      'products': widget.products,
      'shippingAddress': _addressCon.text.trim(),
    };
    
    // Gọi service PayPal mới với retry logic
    await PayPalService.createPaymentWithRetry(total, parentContext);
  }

  /// Hiển thị dialog xác nhận thanh toán COD
  void _showCODConfirmationDialog(BuildContext parentContext) {
    final total = CartHelper.calculateCartSubtotal(widget.products);
    
    // Kiểm tra địa chỉ giao hàng
    if (_addressCon.text.trim().isEmpty) {
      ScaffoldMessenger.of(parentContext).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập địa chỉ giao hàng'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.payment,
                  color: Colors.orange,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Xác nhận đặt hàng',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bạn có chắc chắn muốn đặt hàng với phương thức thanh toán COD (Cash On Delivery)?',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng tiền: \$${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Số sản phẩm: ${widget.products.length}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Địa chỉ giao hàng:',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      _addressCon.text.trim(),
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Lưu ý: Bạn sẽ thanh toán khi nhận hàng.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(parentContext).pop(); // Đóng dialog
              },
              child: const Text(
                'Hủy',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(parentContext).pop(); // Đóng dialog
                _processCODOrder(parentContext);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Xác nhận',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Xử lý đặt hàng COD
  void _processCODOrder(BuildContext parentContext) async {
    try {
      print('🔄 Starting COD order process...');
      print('📊 Order details:');
      print('   - Total: \$${CartHelper.calculateCartSubtotal(widget.products)}');
      print('   - Products count: ${widget.products.length}');
      print('   - Shipping address: ${_addressCon.text.trim()}');

      // Lưu đơn hàng lên Firebase
      print('🔥 Saving order to Firebase...');
      await PayPalService.saveOrderToFirebase(
        total: CartHelper.calculateCartSubtotal(widget.products),
        products: widget.products,
        shippingAddress: _addressCon.text.trim(),
        paymentMethod: 'COD',
      );
      print('✅ Firebase save completed');

      if (!parentContext.mounted) {
        print('⚠️ Context not mounted, returning');
        return;
      }
      
      print('🔄 Navigating to OrderPlacedPage...');
      print('🔄 Current route: ${ModalRoute.of(parentContext)?.settings.name}');
      
      // Thử cách chuyển trang khác
      try {
        Navigator.of(parentContext).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const OrderPlacedPage(),
          ),
          (route) => false,
        );
        print('✅ Navigation to OrderPlacedPage completed');
      } catch (navError) {
        print('❌ Navigation error: $navError');
        // Fallback: thử cách khác
        Navigator.of(parentContext).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const OrderPlacedPage(),
          ),
        );
        print('✅ Fallback navigation completed');
      }

    } catch (e) {
      print('❌ Error in COD order process: $e');
      print('❌ Error type: ${e.runtimeType}');
      print('❌ Error stack trace: ${e.toString()}');
      
      if (!parentContext.mounted) {
        print('⚠️ Context not mounted in error handler, returning');
        return;
      }
      
      // Hiển thị lỗi
      ScaffoldMessenger.of(parentContext).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi đặt hàng: $e'),
          backgroundColor: Colors.red,
        ),
      );
      print('✅ Error snackbar shown');
    }
  }
}
