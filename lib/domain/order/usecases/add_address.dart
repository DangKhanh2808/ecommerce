import '../repository/address_repository.dart';
import '../entities/address.dart';

class AddAddressUseCase {
  final AddressRepository repository;
  AddAddressUseCase(this.repository);

  Future<void> call(Address address) => repository.addAddress(address);
} 