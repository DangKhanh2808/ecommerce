import '../../../domain/order/entities/address.dart';
import '../../../domain/order/repository/address_repository.dart';
import '../model/address_model.dart';
import '../source/address_firebase_service.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressFirebaseService service;
  AddressRepositoryImpl(this.service);

  @override
  Future<List<Address>> getAddresses(String userId) async {
    return await service.getAddresses(userId);
  }

  @override
  Future<void> addAddress(Address address) async {
    await service.addAddress(AddressModel.fromEntity(address));
  }

  @override
  Future<void> updateAddress(Address address) async {
    await service.updateAddress(AddressModel.fromEntity(address));
  }

  @override
  Future<void> deleteAddress(String addressId, String userId) async {
    await service.deleteAddress(addressId, userId);
  }
} 