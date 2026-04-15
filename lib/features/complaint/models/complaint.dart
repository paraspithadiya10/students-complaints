class Complaint {
  final int id;
  final int studentId;
  final String complaint;
  final String reportedBy;
  final DateTime complaintDate;
  final String severity;

  Complaint({
    required this.id,
    required this.studentId,
    required this.complaint,
    required this.reportedBy,
    required this.complaintDate,
    required this.severity,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['id'],
      studentId: json['student_id'],
      complaint: json['complaint'],
      reportedBy: json['reported_by'],
      complaintDate: DateTime.parse(json['complaint_date']),
      severity: json['severity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'complaint': complaint,
      'reported_by': reportedBy,
      'complaint_date': complaintDate.toIso8601String(),
      'severity': severity,
    };
  }
}
