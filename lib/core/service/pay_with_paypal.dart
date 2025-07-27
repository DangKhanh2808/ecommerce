import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce/presentation/cart/views/payment_success.dart';
import 'package:ecommerce/common/helper/navigator/app_navigator.dart';
import 'package:ecommerce/presentation/cart/views/order_placed.dart';

class PayPalService {
  static const String _serverUrl = 'http://172.20.10.9:3000';
  
  // Lưu thông tin đơn hàng hiện tại
  static Map<String, dynamic>? currentOrderInfo;
  
  /// Tạo thanh toán PayPal
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
      ).timeout(const Duration(seconds: 60));

      print('📡 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      // Đóng loading
      _hideLoadingDialog(context);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true && data['id'] != null) {
          final orderId = data['id'];
          print('✅ Payment order created: $orderId');
          
          // Mở trang thanh toán PayPal
          await _openPayPalCheckout(orderId, context);
        } else {
          throw Exception('Invalid response: ${data['error'] ?? 'Unknown error'}');
        }
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['error'] ?? 'Server error';
        final details = errorData['details'] ?? '';
        
        print('❌ Server error: $errorMessage - $details');
        throw Exception('Payment creation failed: $errorMessage');
      }
    } catch (e) {
      // Đóng loading nếu có lỗi
      _hideLoadingDialog(context);
      
      print('❌ PayPal Service Error: $e');
      print('❌ Error type: ${e.runtimeType}');
      print('❌ Error details: ${e.toString()}');
      
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

  /// Mở trang thanh toán PayPal
  static Future<void> _openPayPalCheckout(String orderId, BuildContext context) async {
    try {
      final paypalUrl = Uri.parse('https://www.sandbox.paypal.com/checkoutnow?token=$orderId');
      
      print('🔗 Opening PayPal checkout: $paypalUrl');

      if (await canLaunchUrl(paypalUrl)) {
        // Thử nhiều cách mở URL
        try {
          // Cách 1: Mở trong browser mặc định
          await launchUrl(
            paypalUrl,
            mode: LaunchMode.externalApplication,
          );
          print('✅ PayPal checkout opened successfully');
        } catch (e) {
          print('❌ External application failed, trying in-app browser: $e');
          // Cách 2: Mở trong in-app browser
          await launchUrl(
            paypalUrl,
            mode: LaunchMode.inAppWebView,
          );
          print('✅ PayPal checkout opened in in-app browser');
        }
      } else {
        // Cách 3: Hiển thị URL để user copy
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
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
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
      
      final orderData = {
        'total': total,
        'products': products.map((product) => product.toMap()).toList(),
        'shippingAddress': shippingAddress,
        'paymentMethod': paymentMethod,
        'status': 'paid',
        'createdAt': FieldValue.serverTimestamp(),
        'orderId': 'ORDER-${DateTime.now().millisecondsSinceEpoch}',
        'code': 'OD-${DateTime.now().microsecondsSinceEpoch}',
        'userId': userId, // Add userId to order data
        'orderStatus': [
          {
            'title': 'Order Placed',
            'done': true,
            'createdDate': FieldValue.serverTimestamp(),
          },
          {
            'title': 'Processing',
            'done': true,
            'createdDate': FieldValue.serverTimestamp(),
          },
          {
            'title': 'Shipped',
            'done': false,
            'createdDate': FieldValue.serverTimestamp(),
          },
          {
            'title': 'Delivered',
            'done': false,
            'createdDate': FieldValue.serverTimestamp(),
          },
        ],
      };

      // Lưu vào Users/{userId}/Orders/{autoDocId}
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Orders')
          .add(orderData);

      print('✅ Order saved to Firebase successfully');
      print('📁 Path: Users/$userId/Orders/');
    } catch (e) {
      print('❌ Error saving order to Firebase: $e');
      throw Exception('Failed to save order: $e');
    }
  }

  /// Xử lý thanh toán thành công
  static Future<void> handlePaymentSuccess(BuildContext context) async {
    try {
      if (currentOrderInfo == null) {
        throw Exception('No order information available');
      }

      final total = currentOrderInfo!['total'] as double;
      final products = currentOrderInfo!['products'] as List<dynamic>;
      final shippingAddress = currentOrderInfo!['shippingAddress'] as String;

      // Lưu đơn hàng lên Firebase
      await saveOrderToFirebase(
        total: total,
        products: products,
        shippingAddress: shippingAddress,
        paymentMethod: 'PayPal',
      );

      // Chuyển đến trang thanh toán thành công
      AppNavigator.pushAndRemove(
        context,
        OrderPlacedPage(),
      );

      // Xóa thông tin đơn hàng hiện tại
      currentOrderInfo = null;
    } catch (e) {
      print('❌ Error handling payment success: $e');
              _showErrorSnackBar(context, 'Error saving order: $e');
    }
  }
} 