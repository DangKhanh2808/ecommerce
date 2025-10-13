import 'package:ecommerce/common/helper/navigator/app_navigator.dart';
import 'package:ecommerce/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce/common/widgets/button/basic_app_button.dart';
import 'package:ecommerce/data/auth/models/user_signin.dart';
import 'package:ecommerce/presentation/auth/user/views/enter_password.dart';
import 'package:ecommerce/presentation/auth/user/views/signup.dart'; // <-- cần import này
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController _emailCon = TextEditingController();
  String? _errorEmail;

  @override
  void dispose() {
    _emailCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: const BasicAppbar(hideBack: true),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _signinText(context, theme),
                const SizedBox(height: 32),
                _emailField(context, theme),
                const SizedBox(height: 24),
                _continueButton(context),
                const SizedBox(height: 32),
                Divider(
                  height: 32,
                  thickness: 1,
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                ),
                const SizedBox(height: 16),
                _createAccount(
                    context, theme, isDark), // <-- gọi method đã được thêm
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _signinText(BuildContext context, ThemeData theme) {
    return Text(
      'Sign in',
      style:
          theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _emailField(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _emailCon,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: 'Email Address',
            hintStyle:
                theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor),
            filled: true,
            fillColor: theme.cardColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.primaryColor, width: 2),
            ),
            prefixIcon: Icon(Icons.email, color: theme.iconTheme.color),
          ),
        ),
        if (_errorEmail != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 8),
            child: Text(
              _errorEmail!,
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
      ],
    );
  }

  Widget _continueButton(BuildContext context) {
    return BasicAppButton(
      onPressed: () {
        final email = _emailCon.text.trim();

        setState(() {
          if (email.isEmpty) {
            _errorEmail = 'Vui lòng nhập email';
          } else if (!email.contains('@')) {
            _errorEmail = 'Email phải chứa ký tự @';
          } else {
            _errorEmail = null;
            AppNavigator.push(
              context,
              EnterPasswordPage(
                signinReq: UserSigninReq(email: email),
              ),
            );
          }
        });
      },
      title: 'Continue',
    );
  }

  // <-- Định nghĩa _createAccount được thêm vào đây
  Widget _createAccount(BuildContext context, ThemeData theme, bool isDark) {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Don't have an account? ",
              style: theme.textTheme.bodyLarge
                  ?.copyWith(color: theme.textTheme.bodyLarge?.color),
            ),
            TextSpan(
              text: 'Sign up',
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  AppNavigator.push(
                    context,
                    SignupPage(),
                  );
                },
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
