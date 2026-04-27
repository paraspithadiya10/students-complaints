import 'package:complaints/common/providers/profile_controller_provider.dart';
import 'package:complaints/common/widgets/max_width_widget.dart';
import 'package:complaints/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:complaints/common/widgets/toolkit/zoe_secondary_button.dart';
import 'package:complaints/features/complaint/providers/complaint_list_controller_provider.dart';
import 'package:complaints/features/complaint/utils/enum_utils.dart';
import 'package:complaints/features/student_detail/widgets/students_info_widget.dart';
import 'package:complaints/features/student_list/models/student.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ComplaintScreen extends ConsumerStatefulWidget {
  final Student student;

  const ComplaintScreen({super.key, required this.student});

  @override
  ConsumerState<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends ConsumerState<ComplaintScreen> {
  final complaint = TextEditingController();
  Severity? selectedSeverity;

  @override
  Widget build(BuildContext context) {
    final profile = ref.read(profileControllerProvider);
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: ZoeAppBar()),
      body: SafeArea(
        child: MaxWidthWidget(
          isScrollable: true,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 20,
            children: [
              StudentsInfoWidget(student: widget.student, showButton: false),

              TextFormField(
                controller: complaint,
                minLines: 5,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Complaint",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
              DropdownButtonFormField<Severity>(
                initialValue: selectedSeverity,
                decoration: const InputDecoration(
                  labelText: "Severity",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
                items: Severity.values.map((Severity severity) {
                  return DropdownMenuItem<Severity>(
                    value: severity,
                    child: Text(
                      severity.name[0].toUpperCase() +
                          severity.name.substring(1),
                    ),
                  );
                }).toList(),
                onChanged: (Severity? newValue) {
                  setState(() {
                    selectedSeverity = newValue;
                  });
                },
              ),
              const SizedBox(height: 10),
              ZoeSecondaryButton(
                text: 'Submit',
                onPressed: () async {
                  final complaintText = complaint.text.trim();

                  if (complaintText.isEmpty || selectedSeverity == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          'Please fill all fields',
                          style: Theme.of(
                            context,
                          ).textTheme.labelLarge!.copyWith(color: Colors.white),
                        ),
                      ),
                    );
                    return;
                  }

                  final supabase = Supabase.instance.client;

                  try {
                    await supabase.rpc(
                      'add_complaint',
                      params: {
                        'p_spu_id': widget.student.spuId,
                        'p_complaint': complaintText,
                        'p_reported_by': profile.username,
                        'p_severity': selectedSeverity!.name,
                      },
                    );

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.green,
                        content: Text(
                          'Complaint submitted',
                          style: Theme.of(
                            context,
                          ).textTheme.labelLarge!.copyWith(color: Colors.white),
                        ),
                      ),
                    );

                    ref
                        .read(complaintListControllerProvider.notifier)
                        .getComplaintList(widget.student.spuId);

                    context.pop();
                  } catch (e) {
                    debugPrint('Error while creating complaints : $e');

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          'Error while submitting complaint: $e',
                          style: Theme.of(
                            context,
                          ).textTheme.labelLarge!.copyWith(color: Colors.white),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
