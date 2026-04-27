import 'package:complaints/common/providers/profile_controller_provider.dart';
import 'package:complaints/common/utils/pref_keys.dart';
import 'package:complaints/common/widgets/max_width_widget.dart';
import 'package:complaints/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:complaints/core/constants/image_constants.dart';
import 'package:complaints/core/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;
  final supabase = Supabase.instance.client;

  Future<void> login(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!context.mounted) return;

      if (response.user != null) {
        final currentUser = supabase.auth.currentUser;

        ref
            .read(profileControllerProvider.notifier)
            .getProfile(currentUser?.id ?? '');

        final pref = await SharedPreferences.getInstance();

        pref.setBool(isLoggedIn, true);

        await Future.delayed(const Duration(seconds: 3));

        if (!context.mounted) return;

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
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
                decoration: const InputDecoration(
                  hintText: 'E-mail',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              TextFormField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.password_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : ZoePrimaryButton(
                      text: 'Login',
                      onPressed: () => login(context),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
