import 'package:complaints/features/complaint/controllers/complaint_list_controller.dart';
import 'package:complaints/features/complaint/models/complaint_list_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final complaintListControllerProvider =
    NotifierProvider<ComplaintListController, ComplaintListModel>(
      ComplaintListController.new,
    );
