import 'package:ecommerce/common/helper/navigator/app_navigator.dart';
import 'package:ecommerce/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce/common/widgets/button/basic_app_button.dart';
import 'package:ecommerce/presentation/auth/views/enter_password.dart';
import 'package:ecommerce/presentation/auth/views/forgot_password.dart';
import 'package:ecommerce/presentation/auth/views/signin.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _signupText(context),
            const SizedBox(
              height: 20,
            ),
            _firstNameField(context),
            const SizedBox(
              height: 20,
            ),
            _lastNameField(context),
            const SizedBox(
              height: 20,
            ),
            _emailField(context),
            const SizedBox(
              height: 20,
            ),
            _passwordField(context),
            const SizedBox(
              height: 20,
            ),
            _continueButton(context),
            const SizedBox(
              height: 20,
            ),
            _forgotPassword(context),
          ],
        ),
      ),
    );
  }

  Widget _signupText(BuildContext context) {
    return Text(
      'Sign up',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _firstNameField(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'First Name',
      ),
    );
  }

  Widget _lastNameField(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Last Name',
      ),
    );
  }

  Widget _emailField(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Email Address',
      ),
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Password',
      ),
    );
  }

  Widget _continueButton(BuildContext context) {
    return BasicAppButton(
      onPressed: () {
        AppNavigator.push(
          context,
          EnterPasswordPage(),
        );
      },
      title: 'Continue',
    );
  }

  Widget _forgotPassword(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: "Do you have an account ? "),
          TextSpan(
            text: 'Sign In',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                AppNavigator.push(
                  context,
                  const SigninPage(),
                );
              },
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
