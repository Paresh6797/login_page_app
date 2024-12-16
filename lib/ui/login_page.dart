import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../blocs/banner_bloc.dart';
import '../blocs/login_bloc.dart';
import '../models/banner_content.dart';
import '../models/login_response.dart';
import '../widget/CustomLoading.dart';
import 'welcome.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final LoginBloc _loginBloc = LoginBloc();
  final BannerBloc _bannerBloc = BannerBloc();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Bloc Pattern"),
          centerTitle: true,
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder<bool>(
              stream: _loginBloc.loaderStream,
              builder: (context, snapshot) {
                return CustomLoading(
                    inAsyncCall: snapshot.data ?? false,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: buildBody(),
                    ));
              }),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Banner content
        StreamBuilder<BannerContent>(
          stream: _bannerBloc.fetchBannerContent(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString(),
                  style: const TextStyle(color: Colors.red));
            } else if (snapshot.hasData) {
              return Text(
                snapshot.data!.content,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              );
            }
            return Container();
          },
        ),
        const SizedBox(height: 50),

        // Username input
        StreamBuilder<String>(
          stream: _loginBloc.username,
          builder: (context, snapshot) {
            return TextField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]'))
              ],
              onChanged: _loginBloc.usernameChanged,
              decoration: InputDecoration(
                labelText: 'Username',
                hintText: "Enter username",
                hintStyle: const TextStyle(color: Colors.black54),
                errorText: snapshot.hasError ? snapshot.error.toString() : null,
                border: const OutlineInputBorder(),
              ),
            );
          },
        ),

        const SizedBox(height: 20),

        // Password input
        StreamBuilder<String>(
          stream: _loginBloc.password,
          builder: (context, snapshot) {
            return StreamBuilder<bool>(
                stream: _loginBloc.passwordVisibilityStream,
                builder: (context, visibilitySnapshot) {
                  final isPasswordVisible = visibilitySnapshot.data ?? false;

                  return TextField(
                    obscureText: !isPasswordVisible,
                    onChanged: _loginBloc.passwordChanged,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: "Enter password",
                      hintStyle: const TextStyle(color: Colors.black54),
                      errorText: snapshot.hasError
                          ? snapshot.error.toString().replaceAllMapped(
                              RegExp(r'(.{50})'),
                              (match) => '${match.group(0)}\n')
                          : null,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          _loginBloc.togglePasswordVisibility();
                        },
                      ),
                    ),
                  );
                });
          },
        ),

        const SizedBox(height: 60),

        // Login button
        StreamBuilder<bool>(
          stream: _loginBloc.loginCheck,
          builder: (context, snapshot) {
            return ElevatedButton(
              onPressed: snapshot.hasData
                  ? () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      _loginBloc.doLogin();
                    }
                  : null,
              child: const Text('Login'),
            );
          },
        ),

        const SizedBox(height: 20),

        // Show login response
        StreamBuilder<LoginResponse>(
          stream: _loginBloc.loginResponseStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final loginResponse = snapshot.data!;
              if (loginResponse.success) {
                Future.delayed(Duration.zero, () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          WelcomePage(username: loginResponse.username ?? ''),
                    ),
                  );
                });
              } else {
                return Text(
                  loginResponse.message ?? 'Login Failed',
                  style: const TextStyle(color: Colors.red),
                );
              }
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
