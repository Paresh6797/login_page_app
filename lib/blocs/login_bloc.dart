import 'dart:async';
import 'package:rxdart/rxdart.dart';

import '../models/login_response.dart';
import '../repositories/login_repository.dart';
import '../validators/validators.dart';

class LoginBloc extends Object with Validators implements BaseBloc {
  final _usernameController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _loginResponseController = BehaviorSubject<LoginResponse>();

  // Stream to manage loading state
  final _loaderController = BehaviorSubject<bool>();

  // Visibility toggle for password (true = visible, false = hidden)
  final _passwordVisibilityController = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get passwordVisibilityStream =>
      _passwordVisibilityController.stream;

  Stream<LoginResponse> get loginResponseStream =>
      _loginResponseController.stream;

  Stream<bool> get loaderStream => _loaderController.stream;

  // Function to add value to the username and password controllers
  Function(String) get usernameChanged => _usernameController.sink.add;

  Function(String) get passwordChanged => _passwordController.sink.add;

  // Streams to get username and password with validation
  Stream<String> get username =>
      _usernameController.stream.transform(usernameValidator);

  Stream<String> get password =>
      _passwordController.stream.transform(passwordValidator);

  // Toggle password visibility
  void togglePasswordVisibility() {
    _passwordVisibilityController.add(!_passwordVisibilityController.value);
  }

  Stream<bool> get loginCheck => Rx.combineLatest2(
      username,
      password,
      (String username, String password) =>
          username.isNotEmpty && password.isNotEmpty);

// Perform login with username and password
  Future<void> doLogin() async {
    try {
      _loaderController.add(true);

      // Get the final username and password from the streams
      final String usernameValue = _usernameController.valueOrNull ?? "";
      final String passwordValue = _passwordController.valueOrNull ?? "";

      // Call the login API and get the response
      final loginResponse =
          await LoginRepository().doLoginAPI(usernameValue, passwordValue);
      _loaderController.add(false);
      _loginResponseController.add(loginResponse);
    } catch (error) {
      final loginResponse = LoginResponse(
          username: '',
          success: false,
          message:
              'Login failed. Please check your credentials or try again later.');
      _loaderController.add(false);
      _loginResponseController.add(loginResponse);
    }
  }

  @override
  void dispose() {
    _usernameController.close();
    _passwordController.close();
    _passwordVisibilityController.close();
    _loginResponseController.close();
  }
}

abstract class BaseBloc {
  void dispose();
}
