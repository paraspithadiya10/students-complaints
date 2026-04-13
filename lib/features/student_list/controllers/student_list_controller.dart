import 'package:complaints/features/student_list/models/student_list_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentListController extends Notifier<StudentListModel> {
  @override
  StudentListModel build() => StudentListModel();

  void setLoading(bool value) {
    state.isLoading = value;
  }
}
