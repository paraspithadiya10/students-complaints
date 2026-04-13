import 'package:complaints/common/utils/enum_utils.dart';
import 'package:complaints/core/routing/app_routes.dart';
import 'package:complaints/core/theme/colors/app_colors.dart';
import 'package:complaints/features/home/widgets/stats_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StatsSectionWidget extends ConsumerWidget {
  const StatsSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Top row: Sheets and Events
        Row(
          children: [
            Expanded(
              child: StatsWidget(
                icon: Icons.computer,
                title: 'BCA',
                color: AppColors.primaryColor,
                onTap: () => context.pushNamed(
                  AppRoutes.studentList.name,
                  extra: StreamType.bca,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsWidget(
                icon: Icons.business,
                title: 'BBA',
                color: AppColors.secondaryColor,
                onTap: () => context.pushNamed(
                  AppRoutes.studentList.name,
                  extra: StreamType.bba,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Bottom row: Tasks and Links
        Row(
          children: [
            Expanded(
              child: StatsWidget(
                icon: Icons.book_outlined,
                title: 'B.Sc.',
                color: AppColors.accentColor,
                onTap: () => context.pushNamed(
                  AppRoutes.studentList.name,
                  extra: StreamType.bsc,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsWidget(
                icon: Icons.account_balance,
                title: 'B.Com',
                color: AppColors.brightMagentaColor,
                onTap: () => context.pushNamed(
                  AppRoutes.studentList.name,
                  extra: StreamType.bcom,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Documents and Polls
        Row(
          children: [
            Expanded(
              child: StatsWidget(
                icon: Icons.people_outline,
                title: 'BSW',
                color: AppColors.brightOrangeColor,
                onTap: () => context.pushNamed(
                  AppRoutes.studentList.name,
                  extra: StreamType.bsw,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsWidget(
                icon: Icons.account_balance,
                title: 'M.Com',
                color: AppColors.gradientStart,
                onTap: () => context.pushNamed(
                  AppRoutes.studentList.name,
                  extra: StreamType.mcom,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Documents and Polls
        Row(
          children: [
            Expanded(
              child: StatsWidget(
                icon: Icons.computer_outlined,
                title: 'M.Sc IT & CA',
                color: AppColors.gradientMiddle,
                onTap: () => context.pushNamed(
                  AppRoutes.studentList.name,
                  extra: StreamType.mscIt,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsWidget(
                icon: Icons.science_outlined,
                title: 'M.Sc(Chem)',
                color: AppColors.gradientEnd,
                onTap: () => context.pushNamed(
                  AppRoutes.studentList.name,
                  extra: StreamType.mscChem,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
