import 'package:complaints/common/utils/pref_keys.dart';
import 'package:complaints/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:complaints/common/widgets/toolkit/zoe_secondary_button.dart';
import 'package:complaints/core/routing/app_routes.dart';
import 'package:complaints/features/home/widgets/stats_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: ZoeAppBar(showBackButton: false, title: 'Streams')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          spacing: 20,
          children: [
            StatsSectionWidget(),
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
