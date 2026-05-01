import 'package:complaints/common/utils/common_utils.dart';
import 'package:complaints/common/widgets/styled_content_container_widget.dart';
import 'package:complaints/common/widgets/toolkit/zoe_icon_button_widget.dart';
import 'package:complaints/common/widgets/toolkit/zoe_secondary_button.dart';
import 'package:complaints/core/routing/app_routes.dart';
import 'package:complaints/core/theme/colors/app_colors.dart';
import 'package:complaints/features/student_list/models/student.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StudentsInfoWidget extends ConsumerWidget {
  final Student student;
  final bool showButton;

  const StudentsInfoWidget({
    super.key,
    required this.student,
    this.showButton = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final color = AppColors.gradientEnd;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surface,
        border: Border.all(color: color.withValues(alpha: 0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              StyledContentContainer(
                size: 56,
                primaryColor: theme.colorScheme.primary,
                backgroundOpacity: 0.1,
                borderOpacity: 0.10,
                shadowOpacity: 0.06,
                child: Text(student.name[0], style: TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: .start,
                children: [
                  Text(student.name, style: theme.textTheme.headlineSmall),
                  Text(student.stream.toUpperCase()),
                ],
              ),
              const Spacer(),
              ZoeIconButtonWidget(icon: Icons.edit_outlined),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: .start,
            spacing: 5,
            children: [
              Text('SPU ID : ${student.spuId}'),
              Text('Enrollment No : ${student.enrollmentNo}'),
              Text('Admission Year : ${student.admissionYear}'),
              Text('Father Name : ${CommonUtils.getFatherName(student.name)}'),
              Text('Contact No : ${student.mobileNo}'),
              SizedBox(height: 10),
              if (showButton)
                ZoeSecondaryButton(
                  text: 'Create Complaint',
                  onPressed: () {
                    context.pushNamed(AppRoutes.complaint.name, extra: student);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
