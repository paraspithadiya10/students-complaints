import 'package:complaints/features/student_list/models/student.dart';

class StudentListModel {
  bool? isLoading;
  List<Student>? students;
  List<Student>? filteredList;

  StudentListModel({this.isLoading, this.students, this.filteredList});

  StudentListModel copyWith({bool? isLoading, List<Student>? students}) {
    return StudentListModel(
      isLoading: isLoading ?? this.isLoading,
      students: students ?? this.students,
    );
  }
}
