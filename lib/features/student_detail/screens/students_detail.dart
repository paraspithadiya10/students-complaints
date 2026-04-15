import 'package:complaints/common/widgets/max_width_widget.dart';
import 'package:complaints/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:complaints/features/complaint/providers/complaint_list_controller_provider.dart';
import 'package:complaints/features/student_detail/widgets/students_info_widget.dart';
import 'package:complaints/features/student_list/models/student.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentsDetailScreen extends ConsumerStatefulWidget {
  final Student student;

  const StudentsDetailScreen({super.key, required this.student});

  @override
  ConsumerState<StudentsDetailScreen> createState() =>
      _StudentsDetailScreenState();
}

class _StudentsDetailScreenState extends ConsumerState<StudentsDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(complaintListControllerProvider.notifier)
          .getComplaintList(widget.student.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(complaintListControllerProvider);

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: ZoeAppBar()),
      body: SafeArea(
        child: MaxWidthWidget(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              StudentsInfoWidget(student: widget.student),
              const SizedBox(height: 20),
              if (state.isLoading)
                Center(child: CircularProgressIndicator())
              else
                Text('data'),
            ],
          ),
        ),
      ),
    );
  }
}
