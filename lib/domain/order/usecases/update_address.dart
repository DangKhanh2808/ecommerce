import '../repository/address_repository.dart';
import '../entities/address.dart';

class UpdateAddressUseCase {
  final AddressRepository repository;
  UpdateAddressUseCase(this.repository);

  Future<void> call(Address address) => repository.updateAddress(address);
} 