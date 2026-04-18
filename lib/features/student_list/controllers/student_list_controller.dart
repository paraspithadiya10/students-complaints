import 'package:complaints/common/models/response_model.dart';
import 'package:complaints/common/utils/enum_utils.dart';
import 'package:complaints/data/supabase/services/student_service.dart';
import 'package:complaints/features/student_list/models/student_list_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentListController extends Notifier<StudentListModel> {
  @override
  StudentListModel build() => StudentListModel();

  // Student service
  final _studentService = StudentService();

  Future<void> getStudentList(String stream, [String? search]) async {
    setLoading(true);
    try {
      final response = await _studentService.getStudentList(stream, search);

      if (response.type != ResponseType.success) {
        setLoading(false);
        debugPrint('Failed to fetch student list');
        return;
      }

      state = state.copyWith(students: response.data);
    } catch (e) {
      debugPrint('Failed to fetch student list : ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }
}
