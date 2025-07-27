import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce/domain/auth/entity/user.dart';
import 'package:ecommerce/domain/auth/usecases/get_all_users.dart';
import 'package:ecommerce/domain/auth/usecases/update_user_address.dart';
import 'package:ecommerce/domain/auth/usecases/update_user_payment_method.dart';

part 'user_management_state.dart';

class UserManagementCubit extends Cubit<UserManagementState> {
  final GetAllUsersUseCase getAllUsersUseCase;
  final UpdateUserAddressUseCase updateUserAddressUseCase;
  final UpdateUserPaymentMethodUseCase updateUserPaymentMethodUseCase;

  UserManagementCubit({
    required this.getAllUsersUseCase,
    required this.updateUserAddressUseCase,
    required this.updateUserPaymentMethodUseCase,
  }) : super(UserManagementInitial());

  Future<void> fetchUsers() async {
    emit(UserManagementLoading());
    final result = await getAllUsersUseCase();
    result.fold(
      (error) => emit(UserManagementError(error)),
      (users) => emit(UserManagementLoaded(users)),
    );
  }

  Future<void> updateAddress(String userId, String newAddress) async {
    emit(UserManagementLoading());
    final result = await updateUserAddressUseCase(userId, newAddress);
    result.fold(
      (error) => emit(UserManagementError(error)),
      (_) => fetchUsers(),
    );
  }

  Future<void> updatePaymentMethod(String userId, String paymentMethod) async {
    emit(UserManagementLoading());
    final result = await updateUserPaymentMethodUseCase(userId, paymentMethod);
    result.fold(
      (error) => emit(UserManagementError(error)),
      (_) => fetchUsers(),
    );
  }
} 