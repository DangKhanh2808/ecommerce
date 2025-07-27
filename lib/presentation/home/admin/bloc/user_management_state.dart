part of 'user_management_cubit.dart';

abstract class UserManagementState {}

class UserManagementInitial extends UserManagementState {}
class UserManagementLoading extends UserManagementState {}
class UserManagementLoaded extends UserManagementState {
  final List<UserEntity> users;
  UserManagementLoaded(this.users);
}
class UserManagementError extends UserManagementState {
  final String message;
  UserManagementError(this.message);
} 