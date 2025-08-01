# Hướng dẫn Troubleshooting Firebase

## Lỗi thường gặp khi lưu đơn hàng vào Firebase

### 1. Lỗi "User not authenticated"

**Nguyên nhân:**
- User chưa đăng nhập Firebase Auth
- Token authentication đã hết hạn
- Firebase Auth chưa được khởi tạo

**Cách khắc phục:**
```dart
// Kiểm tra user authentication
final user = FirebaseAuth.instance.currentUser;
if (user == null) {
  // Yêu cầu user đăng nhập lại
  // Hoặc redirect đến trang login
}
```

### 2. Lỗi "permission-denied"

**Nguyên nhân:**
- Firebase Security Rules không cho phép write
- User không có quyền ghi vào collection

**Cách khắc phục:**
Kiểm tra Firebase Security Rules:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /Users/{userId}/Orders/{orderId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 3. Lỗi "unavailable"

**Nguyên nhân:**
- Kết nối mạng không ổn định
- Firebase service không khả dụng
- Timeout connection

**Cách khắc phục:**
- Kiểm tra kết nối mạng
- Thử lại sau vài giây
- Kiểm tra Firebase Console status

### 4. Lỗi "invalid-argument"

**Nguyên nhân:**
- Dữ liệu không đúng format
- Field value không hợp lệ
- Product data bị lỗi
- **FieldValue.serverTimestamp() trong arrays** (Lỗi phổ biến)

**Cách khắc phục:**
- Kiểm tra format dữ liệu
- Validate data trước khi lưu
- Sử dụng try-catch để xử lý lỗi
- **Không sử dụng FieldValue.serverTimestamp() trong arrays**
- **Sử dụng DateTime.now().toIso8601String() thay thế**

### 5. Lỗi "Looking up a deactivated widget's ancestor is unsafe"

**Nguyên nhân:**
- Sử dụng `BuildContext` sau khi widget đã bị dispose
- Gọi `Navigator.of(context)` trên context không hợp lệ
- Async operation hoàn thành sau khi widget đã bị deactivate

**Cách khắc phục:**
```dart
// ❌ Không an toàn
if (Navigator.of(context).canPop()) {
  Navigator.of(context).pop();
}

// ✅ An toàn
if (context.mounted && Navigator.of(context).canPop()) {
  Navigator.of(context).pop();
}

// ✅ Hoặc sử dụng try-catch
try {
  if (context.mounted && Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }
} catch (e) {
  print('⚠️ Navigation error: $e');
}
```

## Cách Debug

### 1. Sử dụng Demo Page

Chạy `PayPalDemoPage` và test Firebase connection:

```dart
// Test Firebase connection
await PayPalService.testFirebaseConnection();
```

### 2. Console Logs

Theo dõi console logs để debug:

```
🔥 Testing Firebase connection...
👤 User ID: [user_id]
✅ Firebase write test successful: [doc_id]
✅ Test data cleaned up
```

### 3. Firebase Console

Kiểm tra Firebase Console:
- Authentication > Users
- Firestore Database > Data
- Functions > Logs

## Các bước kiểm tra

### Bước 1: Kiểm tra Authentication
```dart
final user = FirebaseAuth.instance.currentUser;
print('User: ${user?.uid}');
print('Email: ${user?.email}');
```

### Bước 2: Kiểm tra Network
```dart
// Test basic Firebase connection
try {
  await FirebaseFirestore.instance.collection('test').get();
  print('✅ Firebase connection OK');
} catch (e) {
  print('❌ Firebase connection failed: $e');
}
```

### Bước 3: Kiểm tra Data Format
```dart
// Validate order data
final orderData = {
  'total': 99.99, // Must be number
  'products': [], // Must be array
  'shippingAddress': 'Address', // Must be string
  'paymentMethod': 'PayPal', // Must be string
  'status': 'paid', // Must be string
  'createdAt': FieldValue.serverTimestamp(), // Must be timestamp (OK ở root level)
  'orderStatus': [
    {
      'title': 'Order Placed',
      'done': true,
      'createdDate': DateTime.now().toIso8601String(), // Use string, NOT FieldValue.serverTimestamp()
    }
  ]
};
```

## Cấu hình Firebase

### 1. Firebase Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow users to read/write their own orders
    match /Users/{userId}/Orders/{orderId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Allow users to read/write their own data
    match /Users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 2. Firebase Configuration
Kiểm tra `firebase_options.dart`:
```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'your-api-key',
  appId: 'your-app-id',
  messagingSenderId: 'your-sender-id',
  projectId: 'your-project-id',
  storageBucket: 'your-storage-bucket',
);
```

## Error Messages

| Error | Meaning | Solution |
|-------|---------|----------|
| `User not authenticated` | User chưa đăng nhập | Đăng nhập lại |
| `permission-denied` | Không có quyền | Kiểm tra Firebase Rules |
| `unavailable` | Service không khả dụng | Kiểm tra mạng/Firebase status |
| `invalid-argument` | Dữ liệu không hợp lệ | Validate data |
| `FieldValue.serverTimestamp() in arrays` | Không hỗ trợ timestamp trong arrays | Sử dụng DateTime.now().toIso8601String() |
| `Looking up a deactivated widget's ancestor` | Context đã bị dispose | Kiểm tra context.mounted trước khi sử dụng |
| `not-found` | Document không tồn tại | Kiểm tra path |
| `already-exists` | Document đã tồn tại | Sử dụng update thay vì create |

## Best Practices

1. **Always check authentication before write**
2. **Use try-catch for error handling**
3. **Validate data before saving**
4. **Use proper Firebase Rules**
5. **Monitor Firebase Console**
6. **Test with demo data first**
7. **Use proper data types**
8. **Handle network errors gracefully**

## Testing Checklist

- [ ] User đã đăng nhập
- [ ] Firebase connection OK
- [ ] Data format đúng
- [ ] Firebase Rules cho phép write
- [ ] Network connection ổn định
- [ ] No syntax errors
- [ ] Proper error handling
- [ ] Console logs clean 