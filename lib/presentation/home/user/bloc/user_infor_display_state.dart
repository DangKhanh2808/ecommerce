import 'package:ecommerce/domain/auth/entity/user.dart';

abstract class UserInforDisplayState {}

class UserInforLoading extends UserInforDisplayState {}

class UserInforLoaded extends UserInforDisplayState {
  final UserEntity user;

  UserInforLoaded({required this.user});
}

class LoadUserInforFailure extends UserInforDisplayState {}
