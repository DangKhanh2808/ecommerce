import '../../../domain/order/entities/address.dart';

class AddressModel extends Address {
  AddressModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.phone,
    required super.addressLine,
    required super.isDefault,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map) => AddressModel(
    id: map['id'],
    userId: map['userId'],
    name: map['name'],
    phone: map['phone'],
    addressLine: map['addressLine'],
    isDefault: map['isDefault'] ?? false,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'name': name,
    'phone': phone,
    'addressLine': addressLine,
    'isDefault': isDefault,
  };

  factory AddressModel.fromEntity(Address address) => AddressModel(
    id: address.id,
    userId: address.userId,
    name: address.name,
    phone: address.phone,
    addressLine: address.addressLine,
    isDefault: address.isDefault,
  );
} 