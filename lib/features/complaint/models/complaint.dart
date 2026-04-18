import 'package:complaints/common/utils/enum_utils.dart';
import 'package:complaints/common/utils/extension_utils.dart';

class Complaint {
  final int id;
  final int spuId;
  final String complaint;
  final String reportedBy;
  final DateTime complaintDate;
  final ComplaintSeverity severity;

  Complaint({
    required this.id,
    required this.spuId,
    required this.complaint,
    required this.reportedBy,
    required this.complaintDate,
    required this.severity,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['id'],
      spuId: json['spu_id'],
      complaint: json['complaint'],
      reportedBy: json['reported_by'],
      complaintDate: DateTime.parse(json['complaint_date']),
      severity: ComplaintSeverityExtension.fromJson(json['severity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'spu_id': spuId,
      'complaint': complaint,
      'reported_by': reportedBy,
      'complaint_date': complaintDate.toIso8601String(),
      'severity': severity.name,
    };
  }
}
