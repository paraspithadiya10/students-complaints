import 'package:complaints/common/widgets/max_width_widget.dart';
import 'package:complaints/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:complaints/core/constants/image_constants.dart';
import 'package:complaints/core/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final supabase = Supabase.instance.client;

  Future<void> login(BuildContext context) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!context.mounted) return;

      if (response.user != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Login successful')));

        context.go(AppRoutes.home.route);
      }
    } on AuthApiException catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaxWidthWidget(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 30,
            children: [
              Image.asset(ImageConstants.appLogo, height: 100, width: 100),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(hintText: 'E-mail'),
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Password'),
              ),
              ZoePrimaryButton(text: 'Login', onPressed: () => login(context)),
            ],
          ),
        ),
      ),
    );
  }
}
