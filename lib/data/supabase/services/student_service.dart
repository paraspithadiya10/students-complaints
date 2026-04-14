import 'package:complaints/common/models/response_model.dart';
import 'package:complaints/features/student_list/models/student_list_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentService {
  final supabase = Supabase.instance.client;

  Future<ResponseModel> getStudentList() async {
    try {
      final response = await supabase.rpc(
        'get_students_by_stream',
        params: {'p_stream': 'BCA'},
      );

      debugPrint('Students list : $response');
      return ResponseModel(
        data: StudentListModel(students: []),
        type: ResponseType.success,
      );
    } catch (e) {
      return ResponseModel(
        data: StudentListModel(students: []),
        type: ResponseType.exception,
      );
    }
  }
}
