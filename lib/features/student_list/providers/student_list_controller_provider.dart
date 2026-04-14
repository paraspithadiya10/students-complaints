import 'package:complaints/features/student_list/controllers/student_list_controller.dart';
import 'package:complaints/features/student_list/models/student_list_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final studentListControllerProvider =
    NotifierProvider<StudentListController, StudentListModel>(
      StudentListController.new,
    );
