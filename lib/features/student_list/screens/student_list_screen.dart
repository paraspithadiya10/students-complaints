import 'package:complaints/common/utils/enum_utils.dart';
import 'package:complaints/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:complaints/features/student_list/providers/student_list_controller_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentListScreen extends ConsumerStatefulWidget {
  final StreamType streamType;

  const StudentListScreen({super.key, required this.streamType});

  @override
  ConsumerState<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends ConsumerState<StudentListScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(studentListControllerProvider.notifier).getStudentList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: ZoeAppBar()),
      body: Center(child: Text('Stream : ${widget.streamType.name}')),
    );
  }
}
