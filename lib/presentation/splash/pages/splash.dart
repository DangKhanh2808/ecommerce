import 'package:ecommerce/core/configs/assets/app_vector.dart';
import 'package:ecommerce/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SlashPage extends StatelessWidget {
  const SlashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: SvgPicture.asset(AppVector.appLogo),
      ),
    );
  }
}
