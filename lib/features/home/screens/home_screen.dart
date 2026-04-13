import 'package:complaints/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:complaints/features/home/widgets/stats_section_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: ZoeAppBar(showBackButton: false, title: 'Streams')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(spacing: 20, children: [StatsSectionWidget()]),
      ),
    );
  }
}
