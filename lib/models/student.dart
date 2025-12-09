class Student {
  final String id;
  String nis;
  String name;
  String kelas;
  String jurusan;

  Student({
    required this.id,
    required this.nis,
    required this.name,
    required this.kelas,
    required this.jurusan,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nis': nis,
      'name': name,
      'kelas': kelas,
      'jurusan': jurusan,
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      nis: json['nis'],
      name: json['name'],
      kelas: json['kelas'],
      jurusan: json['jurusan'],
    );
  }

  Student copyWith({
    String? id,
    String? nis,
    String? name,
    String? kelas,
    String? jurusan,
  }) {
    return Student(
      id: id ?? this.id,
      nis: nis ?? this.nis,
      name: name ?? this.name,
      kelas: kelas ?? this.kelas,
      jurusan: jurusan ?? this.jurusan,
    );
  }
}
