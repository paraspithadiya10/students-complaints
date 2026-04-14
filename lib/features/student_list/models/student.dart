class Student {
  final int id;
  final int spuId;
  final String stream;
  final String name;
  final String fatherName;
  final int mobileNo;

  Student({
    required this.id,
    required this.spuId,
    required this.stream,
    required this.name,
    required this.fatherName,
    required this.mobileNo,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      spuId: json['spu_id'],
      stream: json['stream'],
      name: json['name'],
      fatherName: json['father_name'],
      mobileNo: json['mobile_no'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'spu_id': spuId,
      'stream': stream,
      'name': name,
      'father_name': fatherName,
      'mobile_no': mobileNo,
    };
  }

  Student copyWith({
    int? id,
    int? spuId,
    String? stream,
    String? name,
    String? fatherName,
    int? mobileNo,
  }) {
    return Student(
      id: id ?? this.id,
      spuId: spuId ?? this.spuId,
      stream: stream ?? this.stream,
      name: name ?? this.name,
      fatherName: fatherName ?? this.fatherName,
      mobileNo: mobileNo ?? this.mobileNo,
    );
  }
}
