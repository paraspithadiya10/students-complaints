import 'package:complaints/common/utils/enum_utils.dart';
import 'package:complaints/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:flutter/material.dart';

class StudentListScreen extends StatelessWidget {
  final StreamType streamType;

  const StudentListScreen({super.key, required this.streamType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: ZoeAppBar()),
      body: Center(child: Text('Stream : ${streamType.name}')),
    );
  }
}
