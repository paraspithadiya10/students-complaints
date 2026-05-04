import 'package:complaints/common/models/response_model.dart';
import 'package:complaints/features/complaint/models/complaint.dart';
import 'package:complaints/features/student_list/models/student.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentService {
  final supabase = Supabase.instance.client;

  Future<ResponseModel> getStudentList(
    String stream,
    String? searchText,
  ) async {
    try {
      final response = await supabase.rpc(
        'get_students_by_stream',
        params: {'p_stream': stream, 'p_search': searchText},
      );

      debugPrint('Students list : $response');

      final students = (response as List)
          .map((e) => Student.fromJson(e))
          .toList();

      return ResponseModel(data: students, type: ResponseType.success);
    } catch (e) {
      debugPrint("error student fetching : $e");
      return ResponseModel(data: null, type: ResponseType.exception);
    }
  }

  Future<ResponseModel> getComplaintList(int id) async {
    try {
      final response = await supabase.rpc(
        'get_student_complaints',
        params: {'p_spu_id': id},
      );

      debugPrint('complaints list : $response');

      final complaints = (response as List)
          .map((e) => Complaint.fromJson(e))
          .toList();

      return ResponseModel(data: complaints, type: ResponseType.success);
    } catch (e) {
      return ResponseModel(data: null, type: ResponseType.exception);
    }
  }
}
