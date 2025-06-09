abstract class SplashState {}

class DisplaySplashState extends SplashState {}

class AuthenticatedState extends SplashState {
  final String role;
  AuthenticatedState(this.role);
}

class UnAuthenticatedState extends SplashState {}
