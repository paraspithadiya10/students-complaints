import 'package:complaints/common/utils/common_utils.dart';
import 'package:complaints/common/utils/date_time_utils.dart';
import 'package:complaints/common/utils/enum_utils.dart';
import 'package:complaints/common/widgets/max_width_widget.dart';
import 'package:complaints/common/widgets/state_widgets/empty_state_widget.dart';
import 'package:complaints/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:complaints/features/complaint/providers/complaint_list_controller_provider.dart';
import 'package:complaints/features/student_detail/widgets/students_info_widget.dart';
import 'package:complaints/features/student_list/models/student.dart';
import 'package:complaints/features/student_list/providers/student_list_controller_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
          .getComplaintList(widget.student.spuId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(complaintListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: ZoeAppBar(
          onBackPressed: () {
            ref
                .read(studentListControllerProvider.notifier)
                .getStudentList(widget.student.stream.name);
            context.pop();
          },
        ),
      ),
      body: SafeArea(
        child: MaxWidthWidget(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    StudentsInfoWidget(student: widget.student),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              if (state.isLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state.complaints == null || state.complaints!.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: EmptyStateWidget(
                      icon: Icons.file_copy_outlined,
                      message: 'No Complaints Found !!',
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final data = state.complaints?[index];
                    final color = CommonUtils.getColor(
                      data?.severity ?? ComplaintSeverity.low,
                    );

                    final date = data?.complaintDate.toString();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: color.withValues(alpha: 0.50),
                          border: Border.all(
                            width: 2,
                            color: color.withValues(alpha: 0.50),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Complaint : ${data?.complaint}'),
                            Text('Reported By : ${data?.reportedBy}'),
                            Text(
                              'Reported At : ${DateTimeUtils.formatFromString(date!)}',
                            ),
                          ],
                        ),
                      ),
                    );
                  }, childCount: state.complaints?.length ?? 0),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
