import 'package:flutter/material.dart';
import 'package:ecommerce/core/service/pay_with_paypal.dart';
import 'package:ecommerce/domain/order/entities/product_oredered.dart';

/// Demo page để test luồng thanh toán PayPal
class PayPalDemoPage extends StatelessWidget {
  const PayPalDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PayPal Demo'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Test Luồng Thanh Toán PayPal',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            // Thông tin demo
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin Demo:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('• Tổng tiền: \$99.99'),
                    const Text('• Số sản phẩm: 3'),
                    const Text('• Địa chỉ: 123 Demo Street'),
                    const Text('• Phương thức: PayPal'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Nút test Firebase connection
            ElevatedButton.icon(
              onPressed: () => _testFirebaseConnection(context),
              icon: const Icon(Icons.cloud, color: Colors.white),
              label: const Text(
                'Test Firebase Connection',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            
            // Nút test navigation
            ElevatedButton.icon(
              onPressed: () => _testNavigation(context),
              icon: const Icon(Icons.navigation, color: Colors.white),
              label: const Text(
                'Test Navigation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            
            // Nút test thanh toán
            ElevatedButton.icon(
              onPressed: () => _testPayPalPayment(context),
              icon: const Icon(Icons.payment, color: Colors.white),
              label: const Text(
                'Test Thanh Toán PayPal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            
            // Hướng dẫn
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hướng dẫn Test:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('1. Nhấn "Test Thanh Toán PayPal"'),
                    const Text('2. Xem dialog xác nhận đơn hàng'),
                    const Text('3. Xác nhận để tiếp tục'),
                    const Text('4. Xem dialog thanh toán thủ công'),
                    const Text('5. Nhấn "Đã thanh toán" để hoàn tất'),
                    const Text('6. Kiểm tra chuyển đến trang thành công'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Test navigation
  void _testNavigation(BuildContext context) {
    try {
      print('🧪 Testing navigation to OrderPlacedPage...');
      
      // Test navigation trực tiếp
      PayPalService.navigateToOrderPlacedPage(context);
      
      print('✅ Navigation test completed');
    } catch (e) {
      print('❌ Navigation test error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Navigation test error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Test Firebase connection
  void _testFirebaseConnection(BuildContext context) async {
    try {
      // Hiển thị loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Testing Firebase connection...'),
            ],
          ),
        ),
      );

      // Test Firebase connection
      final success = await PayPalService.testFirebaseConnection();

      // Đóng loading
      Navigator.of(context).pop();

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Firebase connection successful!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Firebase connection failed. Check console for details.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Đóng loading nếu có lỗi
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      
      print('❌ Firebase test error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Firebase test error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Test luồng thanh toán PayPal
  void _testPayPalPayment(BuildContext context) async {
    try {
      // Tạo danh sách sản phẩm demo
      final demoProducts = [
        ProductOrderedEntity(
          productId: '1',
          productTitle: 'Sản phẩm Demo 1',
          productPrice: 29.99,
          productSize: 'M',
          productColor: 'Đỏ',
          productQuantity: 1,
          productImage: 'demo1.jpg',
          totalPrice: 29.99,
          createdDate: DateTime.now().toIso8601String(),
          id: 'demo1',
          code: 'DEMO1',
        ),
        ProductOrderedEntity(
          productId: '2',
          productTitle: 'Sản phẩm Demo 2',
          productPrice: 39.99,
          productSize: 'L',
          productColor: 'Xanh',
          productQuantity: 1,
          productImage: 'demo2.jpg',
          totalPrice: 39.99,
          createdDate: DateTime.now().toIso8601String(),
          id: 'demo2',
          code: 'DEMO2',
        ),
        ProductOrderedEntity(
          productId: '3',
          productTitle: 'Sản phẩm Demo 3',
          productPrice: 29.99,
          productSize: 'S',
          productColor: 'Vàng',
          productQuantity: 1,
          productImage: 'demo3.jpg',
          totalPrice: 29.99,
          createdDate: DateTime.now().toIso8601String(),
          id: 'demo3',
          code: 'DEMO3',
        ),
      ];

      // Gọi method thanh toán với xác nhận
      await PayPalService.createPaymentWithConfirmation(
        total: 99.99,
        context: context,
        products: demoProducts,
        shippingAddress: '123 Demo Street, Demo City, DC 12345',
      );

      print('✅ PayPal demo completed successfully');
    } catch (e) {
      print('❌ PayPal demo error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Demo error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
} 