import 'package:flutter/material.dart';
import '../../../home/widgets/categories.dart';
import '../../../home/widgets/header.dart';
import '../../../home/widgets/search_field.dart';

class AdminMenu extends StatelessWidget {
  const AdminMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Header(),
        SizedBox(height: 20),
        SearchField(),
        SizedBox(height: 20),
        Categories(),
        SizedBox(height: 20),
      ],
    );
  }
}
