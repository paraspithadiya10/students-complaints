import 'dart:async';
import 'package:complaints/common/models/profile_model.dart';
import 'package:complaints/common/providers/profile_controller_provider.dart';
import 'package:complaints/common/widgets/max_width_widget.dart';
import 'package:complaints/common/widgets/state_widgets/empty_state_widget.dart';
import 'package:complaints/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:complaints/common/widgets/toolkit/zoe_icon_button_widget.dart';
import 'package:complaints/common/widgets/toolkit/zoe_search_bar_widget.dart';
import 'package:complaints/core/routing/app_routes.dart';
import 'package:complaints/features/student_list/providers/student_list_controller_provider.dart';
import 'package:complaints/features/student_list/widgets/student_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final profileState = ref.read(profileControllerProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(studentListControllerProvider.notifier)
          .getStudentList(profileState.stream!.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.read(profileControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: ZoeAppBar(showBackButton: false, title: 'Students'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ZoeIconButtonWidget(
              icon: Icons.person_2_outlined,
              onTap: () {
                context.pushNamed(AppRoutes.profile.name);
              },
            ),
          ),
        ],
      ),
      body: _buildBody(context, profileState),
    );
  }

  Widget _buildBody(BuildContext context, Profile profileState) {
    final state = ref.watch(studentListControllerProvider);

    final students = state.students ?? [];

    return SafeArea(
      child: MaxWidthWidget(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            ZoeSearchBarWidget(
              controller: searchController,
              onChanged: (value) {
                _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  ref
                      .read(studentListControllerProvider.notifier)
                      .getStudentList(profileState.stream!.name, value);
                });
              },
            ),
            const SizedBox(height: 10),
            if (state.isLoading) ...[
              Spacer(),
              Center(child: CircularProgressIndicator()),
              Spacer(),
            ] else if ((state.students ?? []).isEmpty) ...[
              Spacer(),
              EmptyStateWidget(
                icon: Icons.school_outlined,
                message: 'No Students Found !!',
              ),
              Spacer(),
            ] else
              Expanded(
                child: ListView.builder(
                  itemCount: state.students?.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return StudentItemWidget(student: student);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
