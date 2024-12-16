class LoginResponse {
  final bool success;
  final String message;
  final String username;

  LoginResponse({required this.success, required this.message, required this.username});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'],
      message: json['message'],
      username: json['username'],
    );
  }
}
