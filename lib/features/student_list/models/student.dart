class Student {
  final int spuId;
  final String stream;
  final String name;
  final int mobileNo;
  final int highCount;
  final int mediumCount;
  final int lowCount;

  Student({
    required this.spuId,
    required this.stream,
    required this.name,
    required this.mobileNo,
    required this.highCount,
    required this.mediumCount,
    required this.lowCount,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      spuId: json['spu_id'],
      stream: json['stream'],
      name: json['student_name'],
      mobileNo: json['mobile_no'],
      highCount: json['high_count'],
      mediumCount: json['medium_count'],
      lowCount: json['low_count'],
    );
  }
}
