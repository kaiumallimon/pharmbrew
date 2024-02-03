import 'package:flutter/material.dart';
import 'package:pharmbrew/screens/views/_create_account1_ui.dart';

class CreateAccount1 extends StatelessWidget {
  const CreateAccount1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CreateAccount1Ui(),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}