import 'package:flutter/material.dart';
import '../../models/grade.dart';
import '../../models/student.dart';
import '../../services/data_service.dart';

class GradesPage extends StatefulWidget {
  const GradesPage({super.key});

  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  final _dataService = DataService();
  List<Grade> _grades = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGrades();
  }

  Future<void> _loadGrades() async {
    setState(() => _isLoading = true);
    final grades = await _dataService.getGrades();
    setState(() {
      _grades = grades;
      _isLoading = false;
    });
  }

  Future<void> _deleteGrade(Grade grade) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus nilai ${grade.mataPelajaran} untuk ${grade.studentName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _dataService.deleteGrade(grade.id);
      _loadGrades();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nilai berhasil dihapus')),
        );
      }
    }
  }

  void _showGradeForm([Grade? grade]) {
    showDialog(
      context: context,
      builder: (context) => GradeFormDialog(
        grade: grade,
        onSave: () {
          Navigator.pop(context);
          _loadGrades();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _grades.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.grade_outlined, size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada data nilai',
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _grades.length,
                  itemBuilder: (context, index) {
                    final grade = _grades[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade700,
                          child: Text(
                            grade.studentName[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          grade.studentName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(grade.mataPelajaran),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Nilai Tugas:'),
                                    Text(
                                      grade.nilaiTugas.toString(),
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Nilai UTS:'),
                                    Text(
                                      grade.nilaiUTS.toString(),
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Nilai UAS:'),
                                    Text(
                                      grade.nilaiUAS.toString(),
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const Divider(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Nilai Akhir:',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${grade.nilaiAkhir.toStringAsFixed(2)} (${grade.predikat})',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      icon: const Icon(Icons.edit),
                                      label: const Text('Edit'),
                                      onPressed: () => _showGradeForm(grade),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton.icon(
                                      icon: const Icon(Icons.delete),
                                      label: const Text('Hapus'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                      ),
                                      onPressed: () => _deleteGrade(grade),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showGradeForm(),
        backgroundColor: Colors.blue.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class GradeFormDialog extends StatefulWidget {
  final Grade? grade;
  final VoidCallback onSave;

  const GradeFormDialog({
    super.key,
    this.grade,
    required this.onSave,
  });

  @override
  State<GradeFormDialog> createState() => _GradeFormDialogState();
}

class _GradeFormDialogState extends State<GradeFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _mataPelajaranController = TextEditingController();
  final _nilaiTugasController = TextEditingController();
  final _nilaiUTSController = TextEditingController();
  final _nilaiUASController = TextEditingController();
  Student? _selectedStudent;
  String _selectedSemester = 'Ganjil';
  String _selectedTahunAjaran = '2024/2025';
  List<Student> _students = [];
  final _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _loadStudents();
    if (widget.grade != null) {
      _mataPelajaranController.text = widget.grade!.mataPelajaran;
      _nilaiTugasController.text = widget.grade!.nilaiTugas.toString();
      _nilaiUTSController.text = widget.grade!.nilaiUTS.toString();
      _nilaiUASController.text = widget.grade!.nilaiUAS.toString();
      _selectedSemester = widget.grade!.semester;
      _selectedTahunAjaran = widget.grade!.tahunAjaran;
    }
  }

  Future<void> _loadStudents() async {
    final students = await _dataService.getStudents();
    setState(() {
      _students = students;
      if (widget.grade != null) {
        _selectedStudent = students.firstWhere(
          (s) => s.id == widget.grade!.studentId,
          orElse: () => students.first,
        );
      } else if (students.isNotEmpty) {
        _selectedStudent = students.first;
      }
    });
  }

  @override
  void dispose() {
    _mataPelajaranController.dispose();
    _nilaiTugasController.dispose();
    _nilaiUTSController.dispose();
    _nilaiUASController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedStudent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih siswa terlebih dahulu')),
      );
      return;
    }

    final grade = Grade(
      id: widget.grade?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      studentId: _selectedStudent!.id,
      studentName: _selectedStudent!.name,
      mataPelajaran: _mataPelajaranController.text,
      nilaiTugas: double.parse(_nilaiTugasController.text),
      nilaiUTS: double.parse(_nilaiUTSController.text),
      nilaiUAS: double.parse(_nilaiUASController.text),
      semester: _selectedSemester,
      tahunAjaran: _selectedTahunAjaran,
    );

    if (widget.grade == null) {
      await _dataService.addGrade(grade);
    } else {
      await _dataService.updateGrade(grade);
    }

    widget.onSave();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.grade == null ? 'Tambah Nilai' : 'Edit Nilai'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<Student>(
                value: _selectedStudent,
                decoration: const InputDecoration(
                  labelText: 'Siswa',
                  border: OutlineInputBorder(),
                ),
                items: _students
                    .map((student) => DropdownMenuItem(
                          value: student,
                          child: Text('${student.name} (${student.nis})'),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedStudent = value),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _mataPelajaranController,
                decoration: const InputDecoration(
                  labelText: 'Mata Pelajaran',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mata Pelajaran tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nilaiTugasController,
                decoration: const InputDecoration(
                  labelText: 'Nilai Tugas',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nilai Tugas tidak boleh kosong';
                  }
                  final nilai = double.tryParse(value);
                  if (nilai == null || nilai < 0 || nilai > 100) {
                    return 'Nilai harus antara 0-100';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nilaiUTSController,
                decoration: const InputDecoration(
                  labelText: 'Nilai UTS',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nilai UTS tidak boleh kosong';
                  }
                  final nilai = double.tryParse(value);
                  if (nilai == null || nilai < 0 || nilai > 100) {
                    return 'Nilai harus antara 0-100';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nilaiUASController,
                decoration: const InputDecoration(
                  labelText: 'Nilai UAS',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nilai UAS tidak boleh kosong';
                  }
                  final nilai = double.tryParse(value);
                  if (nilai == null || nilai < 0 || nilai > 100) {
                    return 'Nilai harus antara 0-100';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedSemester,
                      decoration: const InputDecoration(
                        labelText: 'Semester',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Ganjil', 'Genap']
                          .map((sem) => DropdownMenuItem(value: sem, child: Text(sem)))
                          .toList(),
                      onChanged: (value) => setState(() => _selectedSemester = value!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedTahunAjaran,
                      decoration: const InputDecoration(
                        labelText: 'Tahun Ajaran',
                        border: OutlineInputBorder(),
                      ),
                      items: ['2024/2025', '2025/2026', '2026/2027']
                          .map((ta) => DropdownMenuItem(value: ta, child: Text(ta)))
                          .toList(),
                      onChanged: (value) => setState(() => _selectedTahunAjaran = value!),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
