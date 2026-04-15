class Student {
  final int id;
  final int spuId;
  final String stream;
  final String name;
  final String fatherName;
  final int mobileNo;
  final int highCount;
  final int mediumCount;
  final int lowCount;

  Student({
    required this.id,
    required this.spuId,
    required this.stream,
    required this.name,
    required this.fatherName,
    required this.mobileNo,
    required this.highCount,
    required this.mediumCount,
    required this.lowCount,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      spuId: json['spu_id'],
      stream: json['stream'],
      name: json['name'],
      fatherName: json['father_name'],
      mobileNo: json['mobile_no'],
      highCount: json['high_count'],
      mediumCount: json['medium_count'],
      lowCount: json['low_count'],
    );
  }

  Student copyWith({
    int? id,
    int? spuId,
    String? stream,
    String? name,
    String? fatherName,
    int? mobileNo,
    int? highCount,
    int? mediumCount,
    int? lowCount,
  }) {
    return Student(
      id: id ?? this.id,
      spuId: spuId ?? this.spuId,
      stream: stream ?? this.stream,
      name: name ?? this.name,
      fatherName: fatherName ?? this.fatherName,
      mobileNo: mobileNo ?? this.mobileNo,
      highCount: highCount ?? this.highCount,
      mediumCount: mediumCount ?? this.mediumCount,
      lowCount: lowCount ?? this.lowCount,
    );
  }
}
