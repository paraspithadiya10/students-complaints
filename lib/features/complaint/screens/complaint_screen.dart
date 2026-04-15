import 'package:complaints/common/widgets/max_width_widget.dart';
import 'package:complaints/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:complaints/common/widgets/toolkit/zoe_secondary_button.dart';
import 'package:complaints/features/complaint/utils/enum_utils.dart';
import 'package:complaints/features/student_detail/widgets/students_info_widget.dart';
import 'package:complaints/features/student_list/models/student.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ComplaintScreen extends StatefulWidget {
  final Student student;

  const ComplaintScreen({super.key, required this.student});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final reportedBy = TextEditingController();
  final complaint = TextEditingController();
  Severity? selectedSeverity;

  @override
  Widget build(BuildContext context) {
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
                controller: reportedBy,
                decoration: const InputDecoration(
                  hintText: "professor name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
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
                  final supabase = Supabase.instance.client;

                  try {
                    await supabase.rpc(
                      'add_complaint',
                      params: {
                        'p_student_id': widget.student.id,
                        'p_complaint': complaint.text,
                        'p_reported_by': reportedBy.text,
                        'p_severity': selectedSeverity?.name,
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
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          'Error: $e',
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
