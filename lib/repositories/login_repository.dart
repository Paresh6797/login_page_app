import 'dart:async';
import '../models/banner_content.dart';
import '../models/login_response.dart';

class LoginRepository {

  // For fetching banner content
  Future<BannerContent> fetchContentAPI() async {
    await Future.delayed(const Duration(seconds: 2));
    return BannerContent(content: "Welcome to the Login Page!");
  }

  // For login API call
  Future<LoginResponse> doLoginAPI(String username, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    // For login validation
    if (username == "Paresh" && password == "Password@123") {
      return LoginResponse(success: true, message: "Login Successful", username: username);
    } else {
      return LoginResponse(success: false, message: "Invalid username or password", username: "");
    }
  }
}
