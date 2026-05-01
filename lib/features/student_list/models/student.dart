import 'package:complaints/common/utils/enum_utils.dart';

class Student {
  final int spuId;
  final String enrollmentNo;
  final StreamType stream;
  final String name;
  final int mobileNo;
  final int permanentMobileNo;
  final int alternateMobileNo;
  final int admissionYear;
  final int highCount;
  final int mediumCount;
  final int lowCount;

  Student({
    required this.spuId,
    required this.enrollmentNo,
    required this.stream,
    required this.name,
    required this.mobileNo,
    required this.permanentMobileNo,
    required this.alternateMobileNo,
    required this.admissionYear,
    required this.highCount,
    required this.mediumCount,
    required this.lowCount,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      spuId: json['spu_id'],
      enrollmentNo: json['enrollment_no'],
      stream: StreamType.values.firstWhere(
        (e) => e.name.toLowerCase() == json['stream'].toString().toLowerCase(),
        orElse: () => StreamType.bca,
      ),
      name: json['student_name'],
      mobileNo: json['mobile_no'],
      permanentMobileNo: json['permanent_mobile_no'],
      alternateMobileNo: json['alternate_mobile_no'],
      admissionYear: json['admission_year'],
      highCount: json['high_count'],
      mediumCount: json['medium_count'],
      lowCount: json['low_count'],
    );
  }
}
