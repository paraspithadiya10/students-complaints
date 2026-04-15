import 'package:complaints/common/models/response_model.dart';
import 'package:complaints/data/supabase/services/student_service.dart';
import 'package:complaints/features/complaint/models/complaint_list_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComplaintListController extends Notifier<ComplaintListModel> {
  @override
  ComplaintListModel build() => ComplaintListModel();

  // Student service
  final _studentService = StudentService();

  Future<void> getComplaintList(int id) async {
    setLoading(true);
    try {
      final response = await _studentService.getComplaintList(id);

      if (response.type != ResponseType.success) {
        setLoading(false);
        debugPrint('Failed to fetch complaints');
        return;
      }

      state = state.copyWith(complaints: response.data);
    } catch (e) {
      debugPrint('Failed to fetch complaints : ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }
}
