import 'dart:async';

mixin Validators {
  var usernameValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (username, sink) {
    if (username.isNotEmpty) {
      sink.add(username);
    } else {
      sink.addError("Username cannot be empty");
    }
  });

  var passwordValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    final passwordRegex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%?&])[A-Za-z\d@$!%?&]{8,}$');

    if (password.isEmpty) {
      sink.addError("Password cannot be empty");
    } else if (!passwordRegex.hasMatch(password)) {
      sink.addError(
          "Password must contain at least 8 characters, 1 number, 1 uppercase, 1 lowercase, and 1 special character");
    } else {
      sink.add(password);
    }
  });
}
