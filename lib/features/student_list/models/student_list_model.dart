import 'package:complaints/features/student_list/models/student.dart';

class StudentListModel {
  bool isLoading;
  List<Student>? students;

  StudentListModel({this.isLoading = false, this.students});

  StudentListModel copyWith({bool? isLoading, List<Student>? students}) {
    return StudentListModel(
      isLoading: isLoading ?? this.isLoading,
      students: students ?? this.students,
    );
  }
}
