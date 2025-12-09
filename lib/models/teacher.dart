class Teacher {
  final String id;
  String nip;
  String name;
  String mataPelajaran;

  Teacher({
    required this.id,
    required this.nip,
    required this.name,
    required this.mataPelajaran,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nip': nip,
      'name': name,
      'mataPelajaran': mataPelajaran,
    };
  }

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      nip: json['nip'],
      name: json['name'],
      mataPelajaran: json['mataPelajaran'],
    );
  }

  Teacher copyWith({
    String? id,
    String? nip,
    String? name,
    String? mataPelajaran,
  }) {
    return Teacher(
      id: id ?? this.id,
      nip: nip ?? this.nip,
      name: name ?? this.name,
      mataPelajaran: mataPelajaran ?? this.mataPelajaran,
    );
  }
}
