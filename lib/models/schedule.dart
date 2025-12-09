class Schedule {
  final String id;
  String hari;
  String jamMulai;
  String jamSelesai;
  String mataPelajaran;
  String guruId;
  String guruName;
  String kelas;

  Schedule({
    required this.id,
    required this.hari,
    required this.jamMulai,
    required this.jamSelesai,
    required this.mataPelajaran,
    required this.guruId,
    required this.guruName,
    required this.kelas,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hari': hari,
      'jamMulai': jamMulai,
      'jamSelesai': jamSelesai,
      'mataPelajaran': mataPelajaran,
      'guruId': guruId,
      'guruName': guruName,
      'kelas': kelas,
    };
  }

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      hari: json['hari'],
      jamMulai: json['jamMulai'],
      jamSelesai: json['jamSelesai'],
      mataPelajaran: json['mataPelajaran'],
      guruId: json['guruId'],
      guruName: json['guruName'],
      kelas: json['kelas'],
    );
  }

  Schedule copyWith({
    String? id,
    String? hari,
    String? jamMulai,
    String? jamSelesai,
    String? mataPelajaran,
    String? guruId,
    String? guruName,
    String? kelas,
  }) {
    return Schedule(
      id: id ?? this.id,
      hari: hari ?? this.hari,
      jamMulai: jamMulai ?? this.jamMulai,
      jamSelesai: jamSelesai ?? this.jamSelesai,
      mataPelajaran: mataPelajaran ?? this.mataPelajaran,
      guruId: guruId ?? this.guruId,
      guruName: guruName ?? this.guruName,
      kelas: kelas ?? this.kelas,
    );
  }
}
