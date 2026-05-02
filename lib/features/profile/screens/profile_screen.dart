import 'package:complaints/common/providers/profile_controller_provider.dart';
import 'package:complaints/common/utils/pref_keys.dart';
import 'package:complaints/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:complaints/common/widgets/toolkit/zoe_secondary_button.dart';
import 'package:complaints/core/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../widgets/profile_avatar_widget.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = ref.read(profileControllerProvider);
    debugPrint('${state.mobileNo}');
    usernameController.text = state.username ?? '';
    emailController.text = state.email ?? '';
    mobileController.text = state.mobileNo ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: ZoeAppBar(title: 'Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: .center,
          spacing: 20,
          children: [
            ProfileAvatar(radius: 60, initialImageUrl: null),
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(
                hintText: 'Username',
                prefixIcon: Icon(Icons.person_2_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            TextFormField(
              controller: emailController,
              enabled: false,
              decoration: const InputDecoration(
                hintText: 'E-mail',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            TextFormField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: 'Mobile no',
                prefixIcon: Icon(Icons.call),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            ZoeSecondaryButton(
              text: 'Save',
              onPressed: () async {
                final supabase = Supabase.instance.client;
                final user = supabase.auth.currentUser;

                if (user == null) return;

                try {
                  await supabase
                      .from('profiles')
                      .update({
                        'username': usernameController.text.trim(),
                        'email': emailController.text.trim(),
                        'mobile_no': mobileController.text.trim(),
                      })
                      .eq('id', user.id);

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully'),
                    ),
                  );

                  ref
                      .read(profileControllerProvider.notifier)
                      .getProfile(user.id);
                } catch (e) {
                  debugPrint('Update failed: $e');

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Update failed: $e')));
                }
              },
            ),
            SizedBox(height: 40),
            ZoeSecondaryButton(
              text: 'Log out',
              onPressed: () async {
                final pref = await SharedPreferences.getInstance();
                pref.setBool(isLoggedIn, false);
                await Supabase.instance.client.auth.signOut();

                if (!context.mounted) return;

                context.goNamed(AppRoutes.login.name);
              },
              primaryColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
