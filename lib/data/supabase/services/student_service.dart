import 'package:complaints/features/student_list/models/student_list_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentService {
  final supabase = Supabase.instance.client;

  Future<StudentListModel> getStudentList() async {
    try {
      final response = await supabase.rpc(
        'get_students_by_stream',
        params: {'p_stream': 'BCA'},
      );

      print(response);
      return StudentListModel(students: []);
    } catch (e) {
      return StudentListModel(students: []);
    }
  }
}
