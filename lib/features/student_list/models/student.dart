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
