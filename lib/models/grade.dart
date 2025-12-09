class Grade {
  final String id;
  String studentId;
  String studentName;
  String mataPelajaran;
  double nilaiTugas;
  double nilaiUTS;
  double nilaiUAS;
  String semester;
  String tahunAjaran;

  Grade({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.mataPelajaran,
    required this.nilaiTugas,
    required this.nilaiUTS,
    required this.nilaiUAS,
    required this.semester,
    required this.tahunAjaran,
  });

  double get nilaiAkhir {
    return (nilaiTugas * 0.3) + (nilaiUTS * 0.3) + (nilaiUAS * 0.4);
  }

  String get predikat {
    final nilai = nilaiAkhir;
    if (nilai >= 90) return 'A';
    if (nilai >= 80) return 'B';
    if (nilai >= 70) return 'C';
    if (nilai >= 60) return 'D';
    return 'E';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'mataPelajaran': mataPelajaran,
      'nilaiTugas': nilaiTugas,
      'nilaiUTS': nilaiUTS,
      'nilaiUAS': nilaiUAS,
      'semester': semester,
      'tahunAjaran': tahunAjaran,
    };
  }

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      id: json['id'],
      studentId: json['studentId'],
      studentName: json['studentName'],
      mataPelajaran: json['mataPelajaran'],
      nilaiTugas: json['nilaiTugas'].toDouble(),
      nilaiUTS: json['nilaiUTS'].toDouble(),
      nilaiUAS: json['nilaiUAS'].toDouble(),
      semester: json['semester'],
      tahunAjaran: json['tahunAjaran'],
    );
  }

  Grade copyWith({
    String? id,
    String? studentId,
    String? studentName,
    String? mataPelajaran,
    double? nilaiTugas,
    double? nilaiUTS,
    double? nilaiUAS,
    String? semester,
    String? tahunAjaran,
  }) {
    return Grade(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      mataPelajaran: mataPelajaran ?? this.mataPelajaran,
      nilaiTugas: nilaiTugas ?? this.nilaiTugas,
      nilaiUTS: nilaiUTS ?? this.nilaiUTS,
      nilaiUAS: nilaiUAS ?? this.nilaiUAS,
      semester: semester ?? this.semester,
      tahunAjaran: tahunAjaran ?? this.tahunAjaran,
    );
  }
}
