import 'package:flutter/material.dart';
import '../../models/teacher.dart';
import '../../services/data_service.dart';

class TeachersPage extends StatefulWidget {
  const TeachersPage({super.key});

  @override
  State<TeachersPage> createState() => _TeachersPageState();
}

class _TeachersPageState extends State<TeachersPage> {
  final _dataService = DataService();
  List<Teacher> _teachers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTeachers();
  }

  Future<void> _loadTeachers() async {
    setState(() => _isLoading = true);
    final teachers = await _dataService.getTeachers();
    setState(() {
      _teachers = teachers;
      _isLoading = false;
    });
  }

  Future<void> _deleteTeacher(Teacher teacher) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus guru ${teacher.name}?'),
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
      await _dataService.deleteTeacher(teacher.id);
      _loadTeachers();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Guru berhasil dihapus')),
        );
      }
    }
  }

  void _showTeacherForm([Teacher? teacher]) {
    showDialog(
      context: context,
      builder: (context) => TeacherFormDialog(
        teacher: teacher,
        onSave: () {
          Navigator.pop(context);
          _loadTeachers();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _teachers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.school_outlined, size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada data guru',
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _teachers.length,
                  itemBuilder: (context, index) {
                    final teacher = _teachers[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green.shade700,
                          child: Text(
                            teacher.name[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          teacher.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('NIP: ${teacher.nip} | ${teacher.mataPelajaran}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showTeacherForm(teacher),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteTeacher(teacher),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTeacherForm(),
        backgroundColor: Colors.green.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class TeacherFormDialog extends StatefulWidget {
  final Teacher? teacher;
  final VoidCallback onSave;

  const TeacherFormDialog({
    super.key,
    this.teacher,
    required this.onSave,
  });

  @override
  State<TeacherFormDialog> createState() => _TeacherFormDialogState();
}

class _TeacherFormDialogState extends State<TeacherFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nipController = TextEditingController();
  final _nameController = TextEditingController();
  final _mataPelajaranController = TextEditingController();
  final _dataService = DataService();

  @override
  void initState() {
    super.initState();
    if (widget.teacher != null) {
      _nipController.text = widget.teacher!.nip;
      _nameController.text = widget.teacher!.name;
      _mataPelajaranController.text = widget.teacher!.mataPelajaran;
    }
  }

  @override
  void dispose() {
    _nipController.dispose();
    _nameController.dispose();
    _mataPelajaranController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final teacher = Teacher(
      id: widget.teacher?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      nip: _nipController.text,
      name: _nameController.text,
      mataPelajaran: _mataPelajaranController.text,
    );

    if (widget.teacher == null) {
      await _dataService.addTeacher(teacher);
    } else {
      await _dataService.updateTeacher(teacher);
    }

    widget.onSave();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.teacher == null ? 'Tambah Guru' : 'Edit Guru'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nipController,
                decoration: const InputDecoration(
                  labelText: 'NIP',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'NIP tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
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
