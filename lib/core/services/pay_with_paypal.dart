import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerce/presentation/cart/views/order_placed.dart';
import 'package:ecommerce/presentation/cart/bloc/cart_products_display_cubit.dart';
import 'package:ecommerce/domain/order/entities/product_oredered.dart';

class PayPalService {
  static const String _serverUrl = 'http://192.168.36.155:3000';
  
  // Lưu thông tin đơn hàng hiện tại
  static Map<String, dynamic>? currentOrderInfo;
  
  /// Tạo thanh toán PayPal (method cũ để tương thích)
  static Future<void> createPayment(double total, BuildContext context) async {
    try {
      // Hiển thị loading
      _showLoadingDialog(context);

      print('🌐 PayPal Service - Creating payment for: \$${total}');
      print('🌐 Server URL: $_serverUrl');
      
      final url = Uri.parse('$_serverUrl/create-payment');
      final requestBody = jsonEncode({'total': total.toStringAsFixed(2)});

      print('📡 Request URL: $url');
      print('📦 Request Body: $requestBody');
      print('📡 Sending request...');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: requestBody,
      ).timeout(const Duration(seconds: 15));

      print('📡 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      // Đóng loading
      _hideLoadingDialog(context);

      final data = jsonDecode(response.body);
      if (data['success'] == true && data['id'] != null) {
        final orderId = data['id'];
        print('✅ Payment order created: $orderId');
        
        // Hiển thị dialog với link thanh toán thủ công
        final paypalUrl = 'https://www.sandbox.paypal.com/checkoutnow?token=$orderId';
        _showManualPaymentDialog(context, paypalUrl, total);
        
        // Vẫn thử mở browser như cũ
        await _openPayPalCheckout(orderId, context, showDialogAfter: false);
      } else {
        throw Exception('Invalid response: ${data['error'] ?? 'Unknown error'}');
      }
    } catch (e) {
      // Đóng loading nếu có lỗi
      _hideLoadingDialog(context);
      print('❌ PayPal Service Error: $e');
      String errorMessage = 'PayPal payment error';
      if (e.toString().contains('SocketException')) {
        errorMessage = 'Cannot connect to PayPal server. Please check your network connection.';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'PayPal server connection timeout. Please try again.';
      } else if (e.toString().contains('Connection refused')) {
        errorMessage = 'PayPal server not responding. Please try again later.';
      } else {
        errorMessage = 'Payment error: ${e.toString()}';
      }
      _showErrorSnackBar(context, errorMessage);
    }
  }

  /// Tạo thanh toán PayPal với xác nhận đơn hàng
  static Future<void> createPaymentWithConfirmation({
    required double total,
    required BuildContext context,
    required List<dynamic> products,
    required String shippingAddress,
  }) async {
    try {
      // Lưu thông tin đơn hàng hiện tại
      currentOrderInfo = {
        'total': total,
        'products': products,
        'shippingAddress': shippingAddress,
      };

      // Hiển thị dialog xác nhận đơn hàng
      bool confirmed = await _showOrderConfirmationDialog(context, total, products, shippingAddress);
      
      if (!confirmed) {
        print('❌ User cancelled order confirmation');
        return;
      }

      // Gọi method createPayment cũ
      await createPayment(total, context);
    } catch (e) {
      print('❌ PayPal Service Error: $e');
      String errorMessage = 'PayPal payment error';
      if (e.toString().contains('SocketException')) {
        errorMessage = 'Cannot connect to PayPal server. Please check your network connection.';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'PayPal server connection timeout. Please try again.';
      } else if (e.toString().contains('Connection refused')) {
        errorMessage = 'PayPal server not responding. Please try again later.';
      } else {
        errorMessage = 'Payment error: ${e.toString()}';
      }
      _showErrorSnackBar(context, errorMessage);
    }
  }

  /// Hiển thị dialog xác nhận đơn hàng
  static Future<bool> _showOrderConfirmationDialog(
    BuildContext context, 
    double total, 
    List<dynamic> products, 
    String shippingAddress
  ) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Xác nhận đơn hàng',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Vui lòng kiểm tra thông tin đơn hàng:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                
                // Tổng tiền
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tổng tiền:', style: TextStyle(fontWeight: FontWeight.w500)),
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Số lượng sản phẩm
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Số sản phẩm:', style: TextStyle(fontWeight: FontWeight.w500)),
                    Text('${products.length} sản phẩm'),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Địa chỉ giao hàng
                const Text('Địa chỉ giao hàng:', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    shippingAddress,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Danh sách sản phẩm
                const Text('Danh sách sản phẩm:', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                ...products.take(3).map((product) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          product.productTitle ?? product.toString(),
                          style: const TextStyle(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )),
                if (products.length > 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '... và ${products.length - 3} sản phẩm khác',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: const Text(
                    'Sau khi xác nhận, bạn sẽ được chuyển đến trang thanh toán PayPal.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Xác nhận & Thanh toán'),
            ),
          ],
        );
      },
    ) ?? false;
  }

  /// Hiển thị dialog thanh toán thủ công
  static void _showManualPaymentDialog(BuildContext context, String paypalUrl, double total) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          'Thanh toán PayPal',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.payment,
              color: Colors.orange,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Tổng tiền: \$${total.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Để thanh toán, vui lòng:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text('1. Sao chép link bên dưới'),
            const Text('2. Mở trình duyệt web'),
            const Text('3. Dán link và hoàn tất thanh toán'),
            const Text('4. Quay lại app sau khi thanh toán xong'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey.shade50,
              ),
              child: SelectableText(
                paypalUrl,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: const Text(
                'Sau khi thanh toán thành công, hãy nhấn "Đã thanh toán" để hoàn tất đơn hàng.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: paypalUrl));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Link PayPal đã được sao chép'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Sao chép link'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              // Xử lý thanh toán thành công
              await handlePaymentSuccess(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Đã thanh toán'),
          ),
        ],
      ),
    );
  }

  /// Mở trang thanh toán PayPal
  static Future<void> _openPayPalCheckout(String orderId, BuildContext context, {bool showDialogAfter = true}) async {
    try {
      final paypalUrl = Uri.parse('https://www.sandbox.paypal.com/checkoutnow?token=$orderId');
      print('🔗 Opening PayPal checkout: $paypalUrl');
      if (await canLaunchUrl(paypalUrl)) {
        try {
          await launchUrl(
            paypalUrl,
            mode: LaunchMode.externalApplication,
          );
          print('✅ PayPal checkout opened successfully');
        } catch (e) {
          print('❌ External application failed, trying in-app browser: $e');
          await launchUrl(
            paypalUrl,
            mode: LaunchMode.inAppWebView,
          );
          print('✅ PayPal checkout opened in in-app browser');
        }
        // Luôn hiển thị dialog nếu được yêu cầu
        if (showDialogAfter) {
          _showPayPalUrlDialog(context, paypalUrl.toString());
        }
      } else {
        _showPayPalUrlDialog(context, paypalUrl.toString());
      }
    } catch (e) {
      print('❌ Error opening PayPal checkout: $e');
      _showPayPalUrlDialog(context, 'https://www.sandbox.paypal.com/checkoutnow?token=$orderId');
    }
  }

  /// Hiển thị dialog với URL PayPal để user copy
  static void _showPayPalUrlDialog(BuildContext context, String paypalUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Open PayPal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Cannot automatically open PayPal. Please:'),
            const SizedBox(height: 10),
            const Text('1. Copy the link below'),
            const Text('2. Open your browser'),
            const Text('3. Paste the link and pay'),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: SelectableText(
                paypalUrl,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: paypalUrl));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PayPal link copied to clipboard')),
              );
            },
            child: const Text('Copy Link'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Hiển thị dialog loading
  static void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('Creating payment...'),
          ],
        ),
      ),
    );
  }

  /// Ẩn dialog loading
  static void _hideLoadingDialog(BuildContext context) {
    try {
      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('⚠️ Error hiding loading dialog: $e');
    }
  }

  /// Hiển thị thông báo lỗi
  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Close',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Kiểm tra kết nối server
  static Future<bool> checkServerConnection() async {
    try {
      final url = Uri.parse('$_serverUrl/');
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Server connection check failed: $e');
      return false;
    }
  }

  /// Tạo thanh toán với retry logic
  static Future<void> createPaymentWithRetry(double total, BuildContext context, {int maxRetries = 3}) async {
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        print('🔄 Attempt $attempt/$maxRetries - Creating payment for: \$${total}');
        await createPayment(total, context);
        return; // Thành công, thoát khỏi retry
      } catch (e) {
        print('❌ Attempt $attempt failed: $e');
        if (attempt == maxRetries) {
          // Lần cuối cùng thất bại
          _showErrorSnackBar(context, 'Cannot connect to server after $maxRetries attempts. Please check your network connection.');
          rethrow;
        }
        // Chờ một chút trước khi thử lại
        await Future.delayed(Duration(seconds: attempt * 2));
      }
    }
  }

  /// Lưu đơn hàng lên Firebase
  static Future<void> saveOrderToFirebase({
    required double total,
    required List<dynamic> products,
    required String shippingAddress,
    required String paymentMethod,
  }) async {
    try {
      print('🔥 Saving order to Firebase...');
      
      // Lấy userId từ Firebase Auth
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      
      final userId = user.uid;
      print('👤 User ID: $userId');
      
      // Xử lý products để tránh lỗi toMap()
      List<Map<String, dynamic>> processedProducts = [];
      for (var product in products) {
        try {
          if (product is ProductOrderedEntity) {
            processedProducts.add(product.toMap());
          } else if (product is Map<String, dynamic>) {
            processedProducts.add(Map<String, dynamic>.from(product));
          } else {
            // Fallback: tạo map từ các thuộc tính cơ bản
            processedProducts.add({
              'productId': product.productId ?? 'unknown',
              'productTitle': product.productTitle ?? 'Unknown Product',
              'productPrice': product.productPrice ?? 0.0,
              'productQuantity': product.productQuantity ?? 1,
              'productColor': product.productColor ?? 'Unknown',
              'productSize': product.productSize ?? 'Unknown',
              'productImage': product.productImage ?? '',
              'totalPrice': product.totalPrice ?? 0.0,
              'createdDate': product.createdDate ?? DateTime.now().toIso8601String(),
              'id': product.id ?? 'unknown',
              'code': product.code ?? 'UNKNOWN',
            });
          }
        } catch (e) {
          print('⚠️ Error processing product: $e');
          // Thêm product mặc định nếu có lỗi
          processedProducts.add({
            'productId': 'error_product',
            'productTitle': 'Product (Error)',
            'productPrice': 0.0,
            'productQuantity': 1,
            'productColor': 'Unknown',
            'productSize': 'Unknown',
            'productImage': '',
            'totalPrice': 0.0,
            'createdDate': DateTime.now().toIso8601String(),
            'id': 'error_${DateTime.now().millisecondsSinceEpoch}',
            'code': 'ERROR',
          });
        }
      }
      
      print('📦 Processed ${processedProducts.length} products');
      
      final orderData = {
        'total': total,
        'products': processedProducts,
        'shippingAddress': shippingAddress,
        'paymentMethod': paymentMethod,
        'status': 'paid',
        'createdAt': FieldValue.serverTimestamp(),
        'orderId': 'ORDER-${DateTime.now().millisecondsSinceEpoch}',
        'code': 'OD-${DateTime.now().microsecondsSinceEpoch}',
        'userId': userId,
        'orderStatus': [
          {
            'title': 'Order Placed',
            'done': true,
            'createdDate': DateTime.now().toIso8601String(),
          },
          {
            'title': 'Processing',
            'done': true,
            'createdDate': DateTime.now().toIso8601String(),
          },
          {
            'title': 'Shipped',
            'done': false,
            'createdDate': DateTime.now().toIso8601String(),
          },
          {
            'title': 'Delivered',
            'done': false,
            'createdDate': DateTime.now().toIso8601String(),
          },
        ],
      };

      print('📋 Order data prepared: ${orderData.keys.toList()}');

      // Lưu vào Users/{userId}/Orders/{autoDocId}
      final docRef = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Orders')
          .add(orderData);

      print('✅ Order saved to Firebase successfully');
      print('📁 Path: Users/$userId/Orders/${docRef.id}');
      print('📄 Document ID: ${docRef.id}');
      
    } catch (e) {
      print('❌ Error saving order to Firebase: $e');
      print('❌ Error type: ${e.runtimeType}');
      print('❌ Error details: $e');
      
      // Thêm thông tin debug chi tiết hơn
      if (e.toString().contains('permission-denied')) {
        throw Exception('Không có quyền lưu đơn hàng. Vui lòng kiểm tra quyền Firebase.');
      } else if (e.toString().contains('unavailable')) {
        throw Exception('Firebase không khả dụng. Vui lòng kiểm tra kết nối mạng.');
      } else if (e.toString().contains('invalid-argument')) {
        throw Exception('Dữ liệu đơn hàng không hợp lệ. Vui lòng thử lại.');
      } else {
        throw Exception('Lỗi khi lưu đơn hàng: $e');
      }
    }
  }

  /// Xử lý thanh toán thành công
  static Future<void> handlePaymentSuccess(BuildContext context) async {
    try {
      if (currentOrderInfo == null) {
        throw Exception('Không có thông tin đơn hàng');
      }

      final total = currentOrderInfo!['total'] as double;
      final products = currentOrderInfo!['products'] as List<dynamic>;
      final shippingAddress = currentOrderInfo!['shippingAddress'] as String;

      print('💳 Processing payment success...');
      print('💰 Total: \$${total}');
      print('📦 Products count: ${products.length}');
      print('📍 Address: $shippingAddress');

      // Hiển thị loading
      _showLoadingDialog(context);

      // Lưu đơn hàng lên Firebase
      await saveOrderToFirebase(
        total: total,
        products: products,
        shippingAddress: shippingAddress,
        paymentMethod: 'PayPal',
      );

      // Đóng loading
      _hideLoadingDialog(context);

      // Xóa thông tin đơn hàng hiện tại
      currentOrderInfo = null;

      // Hiển thị thông báo thành công
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thanh toán thành công! Đơn hàng đã được đặt.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }

      // Refresh cart trước khi chuyển trang
      if (context.mounted) {
        try {
          refreshCart(context);
        } catch (e) {
          print('⚠️ Cart refresh failed: $e');
          // Không dừng luồng nếu refresh cart thất bại
        }

        // Chuyển đến trang thanh toán thành công
        navigateToOrderPlacedPage(context);
      }

    } catch (e) {
      // Đóng loading nếu có lỗi
      if (context.mounted) {
        _hideLoadingDialog(context);
        print('❌ Error handling payment success: $e');
        print('❌ Error type: ${e.runtimeType}');
        
        String errorMessage = 'Lỗi khi lưu đơn hàng';
        
        if (e.toString().contains('User not authenticated')) {
          errorMessage = 'Vui lòng đăng nhập lại để tiếp tục';
        } else if (e.toString().contains('permission-denied')) {
          errorMessage = 'Không có quyền lưu đơn hàng';
        } else if (e.toString().contains('unavailable')) {
          errorMessage = 'Kết nối mạng không ổn định, vui lòng thử lại';
        } else if (e.toString().contains('invalid-argument')) {
          errorMessage = 'Dữ liệu đơn hàng không hợp lệ';
        } else {
          errorMessage = 'Lỗi: ${e.toString()}';
        }
        
        _showErrorSnackBar(context, errorMessage);
      }
    }
  }

  /// Refresh cart sau khi thanh toán thành công
  static void refreshCart(BuildContext context) {
    // Tìm và refresh CartProductsDisplayCubit nếu có
    try {
      if (context.mounted) {
        final cartCubit = BlocProvider.of<CartProductsDisplayCubit>(context, listen: false);
        if (cartCubit != null) {
          cartCubit.displayCartProduct();
          print('✅ Cart refreshed successfully');
        }
      }
    } catch (e) {
      print('⚠️ Could not refresh cart: $e');
    }
  }

  /// Chuyển đến trang thanh toán thành công
  static void navigateToOrderPlacedPage(BuildContext context) {
    print('🔄 Navigating to OrderPlacedPage...');
    
    // Thử nhiều cách navigation khác nhau
    try {
      // Cách 1: pushAndRemoveUntil với (route) => false
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const OrderPlacedPage()),
        (route) => false,
      );
      print('✅ Navigation successful - Method 1');
    } catch (e) {
      print('⚠️ Navigation method 1 failed: $e');
      
      try {
        // Cách 2: pushAndRemoveUntil với (route) => route.isFirst
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const OrderPlacedPage()),
            (route) => route.isFirst,
          );
          print('✅ Navigation successful - Method 2');
        }
      } catch (e) {
        print('⚠️ Navigation method 2 failed: $e');
        
        try {
          // Cách 3: pushReplacement
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const OrderPlacedPage()),
            );
            print('✅ Navigation successful - Method 3');
          }
        } catch (e) {
          print('⚠️ Navigation method 3 failed: $e');
          
          // Cách 4: push đơn giản
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OrderPlacedPage()),
            );
            print('✅ Navigation successful - Method 4');
          }
        }
      }
    }
  }

  /// Test Firebase connection
  static Future<bool> testFirebaseConnection() async {
    try {
      print('🔥 Testing Firebase connection...');
      
      // Kiểm tra authentication
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('❌ User not authenticated');
        return false;
      }
      
      print('✅ User authenticated: ${user.uid}');
      
      // Test write to Firebase
      final testData = {
        'test': true,
        'timestamp': DateTime.now().toIso8601String(),
        'message': 'Firebase connection test',
      };
      
      final docRef = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('Test')
          .add(testData);
      
      print('✅ Firebase write test successful: ${docRef.id}');
      
      // Clean up test data
      await docRef.delete();
      print('✅ Test data cleaned up');
      
      return true;
    } catch (e) {
      print('❌ Firebase connection test failed: $e');
      return false;
    }
  }
} 