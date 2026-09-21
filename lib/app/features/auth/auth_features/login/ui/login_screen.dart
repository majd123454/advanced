import 'package:flutter/material.dart';
import 'package:swb_advance/app/features/auth/auth_features/login/ui/widgets/login_form_section.dart';
import 'package:swb_advance/app/features/auth/auth_features/login/ui/widgets/login_header_section.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [LoginHeaderSection(), LoginFormSection()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
