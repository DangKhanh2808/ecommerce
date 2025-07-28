class Address {
  final String id;
  final String userId;
  final String name;
  final String phone;
  final String addressLine;
  final bool isDefault;

  Address({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.addressLine,
    required this.isDefault,
  });

  Address copyWith({
    String? id,
    String? userId,
    String? name,
    String? phone,
    String? addressLine,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      addressLine: addressLine ?? this.addressLine,
      isDefault: isDefault ?? this.isDefault,
    );
  }
} 