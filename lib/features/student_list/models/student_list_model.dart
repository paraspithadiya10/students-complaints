import 'package:complaints/features/student_list/models/student.dart';

class StudentListModel {
  bool isLoading;
  List<Student>? students;
  List<Student>? filteredList;

  StudentListModel({this.isLoading = false, this.students, this.filteredList});

  StudentListModel copyWith({
    bool? isLoading,
    List<Student>? students,
    List<Student>? filteredList,
  }) {
    return StudentListModel(
      isLoading: isLoading ?? this.isLoading,
      students: students ?? this.students,
      filteredList: filteredList ?? this.filteredList,
    );
  }
}
