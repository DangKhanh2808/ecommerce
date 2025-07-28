import '../repository/address_repository.dart';

class DeleteAddressUseCase {
  final AddressRepository repository;
  DeleteAddressUseCase(this.repository);

  Future<void> call(String addressId, String userId) => repository.deleteAddress(addressId, userId);
} 