import 'package:flutter_bloc/flutter_bloc.dart';

// State
abstract class HomeLoadingState {}

class HomeLoading extends HomeLoadingState {}

class HomeLoaded extends HomeLoadingState {}

class HomeError extends HomeLoadingState {
  final String message;
  HomeError(this.message);
}

// Cubit
class HomeLoadingCubit extends Cubit<HomeLoadingState> {
  HomeLoadingCubit() : super(HomeLoading());

  void setLoading() {
    emit(HomeLoading());
  }

  void setLoaded() {
    emit(HomeLoaded());
  }

  void setError(String message) {
    emit(HomeError(message));
  }
} 