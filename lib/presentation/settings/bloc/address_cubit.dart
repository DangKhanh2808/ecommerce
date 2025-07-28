import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/order/entities/address.dart';
import '../../../domain/order/usecases/get_addresses.dart';
import '../../../domain/order/usecases/add_address.dart';
import '../../../domain/order/usecases/update_address.dart';
import '../../../domain/order/usecases/delete_address.dart';

abstract class AddressState {}
class AddressInitial extends AddressState {}
class AddressLoading extends AddressState {}
class AddressLoaded extends AddressState {
  final List<Address> addresses;
  AddressLoaded(this.addresses);
}
class AddressError extends AddressState {
  final String message;
  AddressError(this.message);
}

class AddressCubit extends Cubit<AddressState> {
  final GetAddressesUseCase getAddresses;
  final AddAddressUseCase addAddress;
  final UpdateAddressUseCase updateAddress;
  final DeleteAddressUseCase deleteAddress;

  AddressCubit({
    required this.getAddresses,
    required this.addAddress,
    required this.updateAddress,
    required this.deleteAddress,
  }) : super(AddressInitial());

  Future<void> loadAddresses(String userId) async {
    emit(AddressLoading());
    try {
      final addresses = await getAddresses(userId);
      emit(AddressLoaded(addresses));
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> addNewAddress(Address address, String userId) async {
    try {
      await addAddress(address);
      await loadAddresses(userId);
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> updateExistingAddress(Address address, String userId) async {
    try {
      await updateAddress(address);
      await loadAddresses(userId);
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> deleteExistingAddress(String addressId, String userId) async {
    try {
      await deleteAddress(addressId, userId);
      await loadAddresses(userId);
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }
} 