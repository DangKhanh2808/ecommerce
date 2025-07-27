import 'package:ecommerce/common/helper/cart/cart.dart';
import 'package:ecommerce/common/helper/navigator/app_navigator.dart';
import 'package:ecommerce/domain/order/entities/product_oredered.dart';
import 'package:ecommerce/presentation/cart/views/cart.dart';
import 'package:ecommerce/presentation/cart/views/order_placed.dart';
import 'package:ecommerce/presentation/cart/views/payment_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/common/bloc/button/button_state.dart';
import 'package:ecommerce/common/bloc/button/button_state_cubit.dart';
import 'package:ecommerce/data/order/model/order_registration_req.dart';
import 'package:ecommerce/domain/order/usecases/order_registration.dart';
import 'package:ecommerce/service_locator.dart';
import 'dart:async';
import 'package:ecommerce/core/service/pay_with_paypal.dart';

class CheckOutPage extends StatefulWidget {
  final List<ProductOrderedEntity> products;
  const CheckOutPage({required this.products, super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  final TextEditingController _addressController = TextEditingController();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  double? _pendingOrderTotal;
  ButtonStateCubit? _buttonStateCubit;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        _buttonStateCubit = ButtonStateCubit();
        return _buttonStateCubit!;
      },
      child: BlocListener<ButtonStateCubit, ButtonState>(
        listener: (context, state) {
          print('🔄 ButtonState changed: ${state.runtimeType}');
          
          if (state is ButtonLoadingState) {
            print('⏳ ButtonLoadingState received, showing loading...');
            // Hiển thị loading dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const AlertDialog(
                  content: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 16),
                      Text('Processing order...'),
                    ],
                  ),
                );
              },
            );
          }
          
          if (state is ButtonSuccessState) {
            print('✅ ButtonSuccessState received, navigating to OrderPlacedPage');
            // Đóng loading dialog nếu có
            Navigator.of(context).pop();
            // Hiển thị thông báo thành công
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Order placed successfully!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
            // Chuyển đến trang thành công
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const OrderPlacedPage()),
              (route) => false,
            );
          }
          
          if (state is ButtonFailureState) {
            print('❌ ButtonFailureState received: ${state.errorMessage}');
            // Đóng loading dialog nếu có
            Navigator.of(context).pop();
            var snackbar = SnackBar(
                              content: Text('Error: ${state.errorMessage}'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          }
        },
        child: Builder(
          builder: (context) {
            // Xử lý pending order
            if (_pendingOrderTotal != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _placeOrderWithCubit(_pendingOrderTotal!);
                setState(() {
                  _pendingOrderTotal = null;
                });
              });
            }
            
            return Scaffold(
              appBar: AppBar(
                title: const Text('Checkout'),
                actions: [
                  IconButton(
                    onPressed: () {
                      AppNavigator.push(context, const CartPage());
                    },
                    icon: const Icon(Icons.refresh, color: Colors.deepPurple),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Payment Methods Section
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Payment Methods',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _processPayPalPayment();
                                },
                                icon: const Icon(Icons.payment, color: Colors.white),
                                label: const Text(
                                  'Pay with PayPal',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _processCardPayment(context);
                                },
                                icon: const Icon(Icons.credit_card, color: Colors.white),
                                label: const Text(
                                  'Pay with Card',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0070BA), // PayPal blue
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Order Summary Section
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Order Summary',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Products list
                            ...widget.products.map((product) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      product.productImage,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 50,
                                          height: 50,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.image, color: Colors.grey),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.productTitle,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          'Size: ${product.productSize} | Color: ${product.productColor}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          'Qty: ${product.productQuantity}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '\$${product.totalPrice}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )).toList(),
                            const Divider(),
                            // Total
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '\$${CartHelper.calculateCartSubtotal(widget.products)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Shipping Address Section
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Shipping Address',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _addressController,
                              decoration: const InputDecoration(
                                hintText: 'Enter your shipping address',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Order Info Section
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Order Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Total: \$${CartHelper.calculateCartSubtotal(widget.products)}',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Items: ${widget.products.length}',
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Shipping: Free',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Estimated delivery: 3-5 business days',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'By placing this order, you agree to our terms and conditions.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Place Order Button (COD)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final total = CartHelper.calculateCartSubtotal(widget.products);
                          _placeOrderWithCubit(total);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Place Order (COD)',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _processPayPalPayment() async {
    print('💳 Processing PayPal payment...');
    
    try {
      final total = CartHelper.calculateCartSubtotal(widget.products);
      
      // Lưu thông tin đơn hàng hiện tại
      PayPalService.currentOrderInfo = {
        'total': total,
        'products': widget.products,
        'shippingAddress': _addressController.text.isNotEmpty 
            ? _addressController.text 
            : 'Default Address',
      };
      
      // Tạo thanh toán PayPal
      await PayPalService.createPayment(total, context);
      print('✅ PayPal payment created successfully');
      
      // Sau khi tạo thanh toán PayPal, đặt hàng
      if (mounted) {
        setState(() {
          _pendingOrderTotal = total;
        });
      }
      
    } catch (e) {
      print('❌ PayPal payment error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
                            content: Text('Error creating PayPal payment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _processCardPayment(BuildContext context) {
    final total = CartHelper.calculateCartSubtotal(widget.products);
    print('Processing card payment...');
    print('   - Total: \$${CartHelper.calculateCartSubtotal(widget.products)}');
    print('   - Products count: ${widget.products.length}');
    
    // Simulate card payment processing
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _pendingOrderTotal = total;
        });
      }
    });
  }

  void _placeOrderWithCubit(double total) {
    print('🚀 Placing order with stored cubit...');
    print('   - Total: \$${CartHelper.calculateCartSubtotal(widget.products)}');
    print('   - Products count: ${widget.products.length}');
    
    // Hiển thị dialog xác nhận
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
                      title: const Text('Confirm Order'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total: \$${total.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              Text('Number of products: ${widget.products.length}'),
              const SizedBox(height: 8),
              Text('Shipping address: ${_addressController.text.isNotEmpty ? _addressController.text : 'Default Address'}'),
              const SizedBox(height: 16),
              const Text('Are you sure you want to place this order?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
                _confirmAndPlaceOrder(total);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmAndPlaceOrder(double total) {
    print('✅ User confirmed order, proceeding with placement...');
    
    // Tạo OrderRegistrationReq với orderId tự động
    final orderReq = OrderRegistrationReq(
      products: widget.products,
      createdDate: DateTime.now().toIso8601String(),
      shippingAddress: _addressController.text.isNotEmpty 
          ? _addressController.text 
          : 'Default Address',
      itemCount: widget.products.length,
      totalPrice: total,
    );
    
    print('📦 OrderRequest created: ${orderReq.toMap()}');
    
    // Sử dụng stored ButtonStateCubit instance
    if (_buttonStateCubit != null) {
      print('🔍 ButtonStateCubit found: ${_buttonStateCubit.runtimeType}');
      
      _buttonStateCubit!.execute(
        usecase: sl<OrderRegistrationUseCase>(),
        params: orderReq,
      );
      print('✅ Order registration executed with stored cubit');
    } else {
      print('❌ ButtonStateCubit is null');
    }
  }
}
