abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {}

class LoginErrorState extends LoginStates {
  final String message;
  LoginErrorState(this.message);

  @override
  String toString() => message;
}

class LogoutSuccessState extends LoginStates {}

class ForgotPasswordLoadingState extends LoginStates {}

class ForgotPasswordSuccessState extends LoginStates {
  final String email;
  ForgotPasswordSuccessState(this.email);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForgotPasswordSuccessState &&
          runtimeType == other.runtimeType &&
          email == other.email;

  @override
  int get hashCode => email.hashCode;
}

class ForgotPasswordErrorState extends LoginStates {
  final String error;
  ForgotPasswordErrorState(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForgotPasswordErrorState &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => error.hashCode;
}
