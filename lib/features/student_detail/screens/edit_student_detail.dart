import 'package:complaints/common/utils/enum_utils.dart';
import 'package:complaints/common/widgets/max_width_widget.dart';
import 'package:complaints/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:complaints/common/widgets/toolkit/zoe_icon_button_widget.dart';
import 'package:complaints/common/widgets/toolkit/zoe_secondary_button.dart';
import 'package:complaints/core/routing/app_routes.dart';
import 'package:complaints/features/student_detail/widgets/student_avatar_widget.dart';
import 'package:complaints/features/student_list/models/student.dart';
import 'package:complaints/features/student_list/providers/student_list_controller_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditStudentDetail extends ConsumerStatefulWidget {
  final Student student;

  const EditStudentDetail({super.key, required this.student});

  @override
  ConsumerState<EditStudentDetail> createState() => _EditStudentDetailState();
}

class _EditStudentDetailState extends ConsumerState<EditStudentDetail> {
  final spuIdController = TextEditingController();
  final enrollmentNoController = TextEditingController();
  final nameController = TextEditingController();
  final mobileNoController = TextEditingController();
  final permanentMobileNoController = TextEditingController();
  final alternateMobileNoController = TextEditingController();
  final admissionYearController = TextEditingController();
  StreamType? selectedStream;

  @override
  void initState() {
    super.initState();
    spuIdController.text = widget.student.spuId.toString();
    enrollmentNoController.text = widget.student.enrollmentNo.toString();
    nameController.text = widget.student.name;
    mobileNoController.text = widget.student.mobileNo.toString();
    permanentMobileNoController.text = widget.student.permanentMobileNo
        .toString();
    alternateMobileNoController.text = widget.student.alternateMobileNo
        .toString();
    admissionYearController.text = widget.student.admissionYear.toString();
    selectedStream = widget.student.stream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: ZoeAppBar(title: 'Student Detail'),
        actions: [
          Padding(
            padding: EdgeInsetsGeometry.only(right: 10),
            child: ZoeIconButtonWidget(
              icon: Icons.save_outlined,
              onTap: () async {
                final supabase = Supabase.instance.client;

                try {
                  await supabase.rpc(
                    'update_student',
                    params: {
                      'p_spu_id': spuIdController.text,
                      'p_enrollment_no': enrollmentNoController.text,
                      'p_student_name': nameController.text,
                      'p_mobile_no': mobileNoController.text,
                      'p_permanent_mobile_no': permanentMobileNoController.text,
                      'p_alternate_mobile_no': alternateMobileNoController.text,
                      'p_stream': selectedStream?.name,
                      'p_admission_year': admissionYearController.text,
                    },
                  );

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(
                        'Details Updated Successfully',
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge!.copyWith(color: Colors.white),
                      ),
                    ),
                  );

                  ref
                      .read(studentListControllerProvider.notifier)
                      .getStudentList(widget.student.stream.name);

                  context.goNamed(AppRoutes.home.name);
                } catch (e) {
                  debugPrint('Error while updating students details : $e');

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        'Error while updating students details $e',
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge!.copyWith(color: Colors.white),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      body: MaxWidthWidget(
        isScrollable: true,
        padding: EdgeInsets.only(right: 16, top: 16, left: 16),
        child: Column(
          spacing: 20,
          children: [
            StudentAvatar(
              fileName: widget.student.spuId.toString(),
              radius: 50,
              initialImageUrl: widget.student.imageUrl ?? '',
              isEdit: true,
            ),
            TextFormField(
              controller: spuIdController,
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'Spu Id',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            TextFormField(
              controller: enrollmentNoController,
              decoration: const InputDecoration(
                labelText: 'Enrollment No',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            DropdownButtonFormField<StreamType>(
              initialValue: selectedStream,
              decoration: const InputDecoration(
                labelText: "Stream",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              items: StreamType.values.map((StreamType stream) {
                return DropdownMenuItem<StreamType>(
                  value: stream,
                  child: Text(stream.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (StreamType? newValue) {
                setState(() {
                  selectedStream = newValue;
                });
              },
            ),
            TextFormField(
              controller: mobileNoController,
              decoration: const InputDecoration(
                labelText: 'Mobile No',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            TextFormField(
              controller: permanentMobileNoController,
              decoration: const InputDecoration(
                labelText: 'Permanent Mobile No',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            TextFormField(
              controller: alternateMobileNoController,
              decoration: const InputDecoration(
                labelText: 'Alternate Mobile No',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            TextFormField(
              controller: admissionYearController,
              decoration: const InputDecoration(
                labelText: 'Admission Year',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
