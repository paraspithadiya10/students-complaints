import 'package:complaints/features/complaint/models/complaint.dart';

class ComplaintListModel {
  bool isLoading;
  List<Complaint>? complaints;

  ComplaintListModel({this.isLoading = false, this.complaints});

  ComplaintListModel copyWith({bool? isLoading, List<Complaint>? complaints}) {
    return ComplaintListModel(
      isLoading: isLoading ?? this.isLoading,
      complaints: complaints ?? this.complaints,
    );
  }
}
