import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../core/theming/app_colors.dart';
import '../../../../../../core/helper/constants/text_strings.dart';
import '../../../../../../core/helper/spacing.dart';
import '../../../../logic/cubit/auth_cubit.dart';
import '../../../../logic/cubit/auth_state.dart';

class LoginFormSection extends StatefulWidget {
  const LoginFormSection({super.key});

  @override
  State<LoginFormSection> createState() => _LoginFormSectionState();
}

class _LoginFormSectionState extends State<LoginFormSection> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          THelperFunctions.showSnackBar(
            context: context,
            message: 'مرحباً بعودتك',
            type: SnackBarType.success,
          );

          // context.pushReplacementNamed(Routes.navigation);

          // THelperFunctions.navigateReplacementToScreen(
          //   context,
          //   MultiBlocProvider(
          //     providers: [
          //       // BlocProvider(
          //       //   create: (context) =>
          //       //       sl<NavigationMenuCubit>()..initializeScreensList(),
          //       // ),
          //       // BlocProvider(
          //       //   create: (context) =>
          //       //       sl<ShopCubit>()
          //       //         ..getSortedProducts(sortBy: 'rating', sortType: "desc"),
          //       // ),
          //     ],
          //     child: const NavigationMenu(),
          //   ),
          // );
        } else if (state is AuthError) {
          THelperFunctions.showSnackBar(
            context: context,
            message: state.message,
            type: SnackBarType.error,
          );
        }
        // else if (state is AuthEmailConfirmationRequired) {
        //   THelperFunctions.showSnackBar(
        //     context: context,
        //     message: 'يرجى تأكيد بريدك الإلكتروني: ${state.email}',
        //     type: SnackBarType.warning,
        //   );
        // }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: TTexts.email,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Iconsax.password_check),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Iconsax.eye_slash : Iconsax.eye,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    labelText: TTexts.password,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? true;
                            });
                          },
                        ),
                        const Text(TTexts.rememberMe),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        // THelperFunctions.navigateToScreen(
                        //   context,
                        //   const ForgetPasswordView(),
                        // );
                      },
                      child: const Text(TTexts.forgetPassword),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state is AuthLoading
                        ? null
                        : () {
                            THelperFunctions.hideKeyboard();
                            _handleLogin();
                          },
                    child: state is AuthLoading
                        ? const Text(TTexts.loading)
                        : const Text(TTexts.signIn),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      // context.pushNamed(Routes.signup);
                    },
                    child: const Text(TTexts.createAccount),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
