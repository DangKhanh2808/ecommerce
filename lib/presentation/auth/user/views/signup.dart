import 'package:ecommerce/common/helper/navigator/app_navigator.dart';
import 'package:ecommerce/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce/common/widgets/button/basic_app_button.dart';
import 'package:ecommerce/data/auth/models/user_creation_req.dart';
import 'package:ecommerce/presentation/auth/user/views/gender_and_age_selection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/presentation/auth/user/views/signin.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final TextEditingController _firstNameCon = TextEditingController();
  final TextEditingController _lastNameCon = TextEditingController();
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: const BasicAppbar(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _siginText(theme),
                const SizedBox(height: 32),
                _firstNameField(theme),
                const SizedBox(height: 20),
                _lastNameField(theme),
                const SizedBox(height: 20),
                _emailField(theme),
                const SizedBox(height: 20),
                _passwordField(context, theme),
                const SizedBox(height: 24),
                _continueButton(context),
                const SizedBox(height: 32),
                Divider(height: 32, thickness: 1, color: isDark ? Colors.grey[700] : Colors.grey[300]),
                const SizedBox(height: 16),
                _createAccount(context, theme, isDark),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _siginText(ThemeData theme) {
    return Text(
      'Create Account',
      style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _firstNameField(ThemeData theme) {
    return TextField(
      controller: _firstNameCon,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: 'Firstname',
        hintStyle: theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor),
        filled: true,
        fillColor: theme.cardColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.primaryColor, width: 2),
        ),
        prefixIcon: Icon(Icons.person, color: theme.iconTheme.color),
      ),
    );
  }

  Widget _lastNameField(ThemeData theme) {
    return TextField(
      controller: _lastNameCon,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: 'Lastname',
        hintStyle: theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor),
        filled: true,
        fillColor: theme.cardColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.primaryColor, width: 2),
        ),
        prefixIcon: Icon(Icons.person_outline, color: theme.iconTheme.color),
      ),
    );
  }

  Widget _emailField(ThemeData theme) {
    return TextField(
      controller: _emailCon,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: 'Email Address',
        hintStyle: theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor),
        filled: true,
        fillColor: theme.cardColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.primaryColor, width: 2),
        ),
        prefixIcon: Icon(Icons.email, color: theme.iconTheme.color),
      ),
    );
  }

  Widget _passwordField(BuildContext context, ThemeData theme) {
    return TextField(
      controller: _passwordCon,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor),
        filled: true,
        fillColor: theme.cardColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.primaryColor, width: 2),
        ),
        prefixIcon: Icon(Icons.lock, color: theme.iconTheme.color),
      ),
      obscureText: true,
    );
  }

  Widget _continueButton(BuildContext context) {
    return BasicAppButton(
        onPressed: () {
          AppNavigator.push(
              context,
              GenderAndAgeSelectionPage(
                userCreationReq: UserCreationReq(
                    firstName: _firstNameCon.text,
                    email: _emailCon.text,
                    lastName: _lastNameCon.text,
                    password: _passwordCon.text),
              ));
        },
        title: 'Continue');
  }

  Widget _createAccount(BuildContext context, ThemeData theme, bool isDark) {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: "Do you have an account? ", style: theme.textTheme.bodyLarge?.copyWith(color: theme.textTheme.bodyLarge?.color)),
            TextSpan(
              text: 'Sign in',
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  AppNavigator.pushReplacement(context, SigninPage());
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
