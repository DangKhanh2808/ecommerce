// profile_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/domain/auth/repository/auth.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository authRepository;

  ProfileCubit({required this.authRepository}) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());

    final result = await authRepository.getUser();

    result.fold(
      (error) => emit(ProfileError(error)),
      (user) => emit(ProfileLoaded(user)),
    );
  }
}
