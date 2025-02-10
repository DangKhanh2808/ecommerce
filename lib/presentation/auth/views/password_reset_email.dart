import 'package:ecommerce/common/helper/navigator/app_navigator.dart';
import 'package:ecommerce/common/widgets/button/basic_app_button.dart';
import 'package:ecommerce/core/configs/assets/app_vector.dart';
import 'package:ecommerce/presentation/auth/views/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PasswordResetEmailPage extends StatelessWidget {
  const PasswordResetEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _emailSending(context),
          const SizedBox(
            height: 30,
          ),
          _sendEmail(context),
          const SizedBox(
            height: 30,
          ),
          _returnToLoginButton(context),
        ],
      ),
    );
  }

  Widget _emailSending(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        AppVector.emailSending,
      ),
    );
  }

  Widget _sendEmail(BuildContext context) {
    return Text(
      'We have sent an email to your email address. Please check your email and follow the instructions to reset your password.',
      style: TextStyle(
        fontSize: 16,
      ),
    );
  }

  Widget _returnToLoginButton(BuildContext context) {
    return BasicAppButton(
      onPressed: () {
        AppNavigator.push(
          context,
          SigninPage(),
        );
      },
      width: 200,
      title: 'Return to Login',
    );
  }
}
