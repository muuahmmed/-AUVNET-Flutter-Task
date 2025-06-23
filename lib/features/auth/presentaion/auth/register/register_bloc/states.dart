abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {}

class RegisterErrorState extends RegisterStates {
  final String message;
  RegisterErrorState(this.message);
}

class UserDataAddedLoginState extends RegisterStates {
  final String message;
  UserDataAddedLoginState(this.message);

  @override
  String toString() => message;
}

class UserDataLoadingLoginState extends RegisterStates {
  final String message;
  UserDataLoadingLoginState(this.message);

  @override
  String toString() => message;
}

class UserDataErrorLoginState extends RegisterStates {
  final String error;
  UserDataErrorLoginState(this.error);

  @override
  String toString() => error;
}
