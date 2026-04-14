import 'dart:async';

import 'package:complaints/common/utils/enum_utils.dart';
import 'package:complaints/common/widgets/max_width_widget.dart';
import 'package:complaints/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:complaints/common/widgets/toolkit/zoe_search_bar_widget.dart';
import 'package:complaints/features/student_list/providers/student_list_controller_provider.dart';
import 'package:complaints/features/student_list/widgets/student_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentListScreen extends ConsumerStatefulWidget {
  final StreamType streamType;

  const StudentListScreen({super.key, required this.streamType});

  @override
  ConsumerState<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends ConsumerState<StudentListScreen> {
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(studentListControllerProvider.notifier)
          .getStudentList(widget.streamType);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: ZoeAppBar()),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final state = ref.watch(studentListControllerProvider);

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
                      .getStudentList(widget.streamType, value);
                });
              },
            ),
            const SizedBox(height: 10),
            if (state.isLoading) ...[
              Center(child: CircularProgressIndicator()),
            ] else
              Expanded(
                child: ListView.builder(
                  itemCount: state.filteredList?.length,
                  itemBuilder: (context, index) {
                    final student = state.filteredList?[index];
                    return StudentItemWidget(student: student!);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
