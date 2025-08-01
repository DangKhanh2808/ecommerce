# Hướng dẫn Luồng Thanh Toán PayPal

## Tổng quan

Luồng thanh toán PayPal đã được cải thiện với các tính năng mới:

1. **Xác nhận đơn hàng** trước khi tạo thanh toán
2. **Link thanh toán thủ công** với hướng dẫn chi tiết
3. **Refresh màn hình** sau khi thanh toán thành công
4. **Chuyển đến trang đặt hàng thành công**

## Các thay đổi chính

### 1. PayPalService - Các method mới

#### `createPaymentWithConfirmation()`
- Method mới để tạo thanh toán với xác nhận đơn hàng
- Hiển thị dialog xác nhận chi tiết
- Tự động lưu thông tin đơn hàng

```dart
await PayPalService.createPaymentWithConfirmation(
  total: total,
  context: context,
  products: products,
  shippingAddress: address,
);
```

#### `handlePaymentSuccess()`
- Xử lý thanh toán thành công
- Lưu đơn hàng lên Firebase
- Refresh cart
- Chuyển đến trang thành công

#### `refreshCart()`
- Refresh màn hình cart sau khi thanh toán
- Sử dụng BlocProvider để cập nhật state

### 2. Dialog xác nhận đơn hàng

Dialog hiển thị:
- Tổng tiền
- Số lượng sản phẩm
- Địa chỉ giao hàng
- Danh sách sản phẩm (tối đa 3 sản phẩm)
- Thông báo hướng dẫn

### 3. Dialog thanh toán thủ công

Dialog bao gồm:
- Icon PayPal
- Tổng tiền
- Hướng dẫn thanh toán từng bước
- Link PayPal có thể copy
- Nút "Đã thanh toán" để hoàn tất

## Cách sử dụng

### Trong Checkout Page

```dart
void _processPayPalPayment() async {
  try {
    final subtotal = CartHelper.calculateCartSubtotal(widget.products);
    final shipping = CartHelper.calculateShippingCost(widget.products);
    final tax = 0.0;
    final total = subtotal + shipping + tax;
    
    // Sử dụng method mới với xác nhận đơn hàng
    await PayPalService.createPaymentWithConfirmation(
      total: total,
      context: context,
      products: widget.products,
      shippingAddress: _addressController.text.isNotEmpty 
          ? _addressController.text 
          : 'Default Address',
    );
  } catch (e) {
    // Xử lý lỗi
  }
}
```

### Test với Demo Page

Sử dụng `PayPalDemoPage` để test luồng thanh toán:

```dart
// Thêm vào navigation
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const PayPalDemoPage()),
);
```

## Luồng hoạt động

1. **Bấm nút PayPal** → Hiển thị dialog xác nhận đơn hàng
2. **Xác nhận đơn hàng** → Tạo thanh toán PayPal
3. **Tạo thanh toán thành công** → Hiển thị dialog thanh toán thủ công
4. **User thanh toán** → Mở browser hoặc copy link
5. **Nhấn "Đã thanh toán"** → Lưu đơn hàng lên Firebase
6. **Hoàn tất** → Refresh cart và chuyển đến trang thành công

## Các tính năng bảo mật

- **Validation** thông tin đơn hàng
- **Error handling** chi tiết
- **Loading states** cho UX tốt hơn
- **Timeout handling** cho network requests
- **Fallback** cho các trường hợp lỗi

## Troubleshooting

### Lỗi thường gặp

1. **Server connection failed**
   - Kiểm tra kết nối mạng
   - Kiểm tra server PayPal có hoạt động không

2. **Payment creation failed**
   - Kiểm tra thông tin đơn hàng
   - Kiểm tra server response

3. **Cart refresh failed**
   - Kiểm tra BlocProvider context
   - Kiểm tra CartProductsDisplayCubit

### Debug

Sử dụng console logs để debug:
- `🌐 PayPal Service` - Thông tin request
- `📡 Response` - Thông tin response
- `✅ Success` - Thành công
- `❌ Error` - Lỗi

## Cập nhật tương lai

- [ ] Tích hợp webhook để tự động xác nhận thanh toán
- [ ] Thêm nhiều phương thức thanh toán
- [ ] Cải thiện UI/UX
- [ ] Thêm analytics tracking
- [ ] Multi-language support 