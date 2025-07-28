import '../repository/address_repository.dart';
import '../entities/address.dart';

class GetAddressesUseCase {
  final AddressRepository repository;
  GetAddressesUseCase(this.repository);

  Future<List<Address>> call(String userId) => repository.getAddresses(userId);
} 