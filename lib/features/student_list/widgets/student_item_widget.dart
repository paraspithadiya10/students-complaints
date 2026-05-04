import 'package:complaints/common/widgets/glassy_container_widget.dart';
import 'package:complaints/common/widgets/styled_content_container_widget.dart';
import 'package:complaints/core/routing/app_routes.dart';
import 'package:complaints/core/theme/colors/app_colors.dart';
import 'package:complaints/features/student_detail/widgets/student_avatar_widget.dart';
import 'package:complaints/features/student_list/models/student.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StudentItemWidget extends ConsumerWidget {
  final Student student;
  final bool isCompact;

  const StudentItemWidget({
    super.key,
    required this.student,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final child = isCompact
        ? _buildCompactDesign(context, theme, student)
        : _buildExpandedDesign(context, theme, student);

    return GestureDetector(
      onTap: () {
        context.pushNamed(AppRoutes.studentDetail.name, extra: student);
      },
      child: child,
    );
  }

  Widget _buildCompactDesign(
    BuildContext context,
    ThemeData theme,
    Student student,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildEmojiContainer(student.name[0], AppColors.gradientEnd, theme),
          const SizedBox(width: 16),
          Expanded(child: _buildContentSection(student, theme)),
          const SizedBox(width: 12),
          Icon(
            Icons.chevron_right_rounded,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedDesign(
    BuildContext context,
    ThemeData theme,
    Student student,
  ) {
    return GlassyContainer(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          if (student.imageUrl?.isNotEmpty ?? false) ...[
            StudentAvatar(
              fileName: student.spuId.toString(),
              radius: 30,
              initialImageUrl: student.imageUrl ?? '',
            ),
          ] else ...[
            _buildEmojiContainer(student.name[0], AppColors.gradientEnd, theme),
          ],
          const SizedBox(width: 16),
          Expanded(child: _buildContentSection(student, theme)),
          const SizedBox(width: 12),
          Icon(
            Icons.chevron_right_rounded,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiContainer(String emoji, Color? color, ThemeData theme) {
    return StyledContentContainer(
      size: isCompact ? 34 : 56,
      primaryColor: color ?? theme.colorScheme.primary,
      backgroundOpacity: 0.1,
      borderOpacity: 0.10,
      shadowOpacity: 0.06,
      child: Text(emoji, style: TextStyle(fontSize: isCompact ? 18 : 24)),
    );
  }

  Widget _buildContentSection(Student student, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          student.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (!isCompact) ...[
          const SizedBox(height: 4),
          Text(
            student.spuId.toString(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          _buildComplaintCount(theme),
        ],
      ],
    );
  }

  Widget _buildComplaintCount(ThemeData theme) {
    return Row(
      spacing: 5,
      children: [
        if (student.highCount > 0) ...[
          Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          Text(
            student.highCount.toString(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(width: 5),
        ],
        if (student.mediumCount > 0) ...[
          Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          Text(
            student.mediumCount.toString(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(width: 5),
        ],
        if (student.lowCount > 0) ...[
          Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          Text(
            student.lowCount.toString(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
