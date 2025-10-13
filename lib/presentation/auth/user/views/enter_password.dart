import 'package:ecommerce/common/bloc/button/button_state_cubit.dart';
import 'package:ecommerce/common/helper/navigator/app_navigator.dart';
import 'package:ecommerce/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce/common/widgets/button/basic_reative_button.dart';
import 'package:ecommerce/data/auth/models/user_signin.dart';
import 'package:ecommerce/domain/auth/usecases/signin.dart';
import 'package:ecommerce/presentation/auth/user/views/forgot_password.dart';
import 'package:ecommerce/presentation/home/user/pages/home.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/bloc/button/button_state.dart';
import 'package:ecommerce/service_locator.dart';

class EnterPasswordPage extends StatefulWidget {
  final UserSigninReq signinReq;
  const EnterPasswordPage({
    required this.signinReq,
    super.key,
  });

  @override
  State<EnterPasswordPage> createState() => _EnterPasswordPageState();
}

class _EnterPasswordPageState extends State<EnterPasswordPage> {
  late final TextEditingController _passwordCon;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _passwordCon = TextEditingController();
  }

  @override
  void dispose() {
    _passwordCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: BlocProvider(
          create: (context) => ButtonStateCubit(),
          child: BlocListener<ButtonStateCubit, ButtonState>(
            listener: (context, state) {
              if (state is ButtonFailureState) {
                var snackbar = SnackBar(
                  content: Text(state.errorMessage),
                  behavior: SnackBarBehavior.floating,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }

              if (state is ButtonSuccessState) {
                AppNavigator.pushAndRemove(context, const HomePage());
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _siginText(context),
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
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _siginText(BuildContext context) {
    return const Text(
      'Sign in',
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      controller: _passwordCon,
      obscureText: _obscurePassword,
      obscuringCharacter: '•',
      enableSuggestions: false,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.visiblePassword,
      autofillHints: const [AutofillHints.password],
      decoration: InputDecoration(
        hintText: 'Enter Password',
        suffixIcon: IconButton(
          icon:
              Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
    );
  }

  Widget _continueButton(BuildContext context) {
    return Builder(builder: (context) {
      return BasicReactiveButton(
          onPressed: () {
            widget.signinReq.password = _passwordCon.text;

            if (widget.signinReq.email == null ||
                widget.signinReq.email!.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Email cannot be empty'),
                ),
              );
              return;
            }

            context.read<ButtonStateCubit>().execute(
                usecase: sl<SigninUseCase>(), params: widget.signinReq);
          },
          title: 'Continue');
    });
  }

  Widget _forgotPassword(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        const TextSpan(text: "Forgot password? "),
        TextSpan(
            text: 'Reset',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                AppNavigator.push(context, ForgotPasswordPage());
              },
            style: const TextStyle(fontWeight: FontWeight.bold))
      ]),
    );
  }
}
