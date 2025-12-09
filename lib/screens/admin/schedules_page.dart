import 'package:flutter/material.dart';
import '../../models/schedule.dart';
import '../../models/teacher.dart';
import '../../services/data_service.dart';

class SchedulesPage extends StatefulWidget {
  const SchedulesPage({super.key});

  @override
  State<SchedulesPage> createState() => _SchedulesPageState();
}

class _SchedulesPageState extends State<SchedulesPage> {
  final _dataService = DataService();
  List<Schedule> _schedules = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    setState(() => _isLoading = true);
    final schedules = await _dataService.getSchedules();
    setState(() {
      _schedules = schedules;
      _isLoading = false;
    });
  }

  Future<void> _deleteSchedule(Schedule schedule) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus jadwal ini?'),
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
      await _dataService.deleteSchedule(schedule.id);
      _loadSchedules();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jadwal berhasil dihapus')),
        );
      }
    }
  }

  void _showScheduleForm([Schedule? schedule]) {
    showDialog(
      context: context,
      builder: (context) => ScheduleFormDialog(
        schedule: schedule,
        onSave: () {
          Navigator.pop(context);
          _loadSchedules();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final schedulesByDay = <String, List<Schedule>>{};
    for (var schedule in _schedules) {
      schedulesByDay.putIfAbsent(schedule.hari, () => []).add(schedule);
    }

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _schedules.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.schedule_outlined, size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada jadwal pelajaran',
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: schedulesByDay.keys.length,
                  itemBuilder: (context, index) {
                    final hari = schedulesByDay.keys.elementAt(index);
                    final daySchedules = schedulesByDay[hari]!;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ExpansionTile(
                        title: Text(
                          hari,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        leading: const Icon(Icons.calendar_today),
                        children: daySchedules.map((schedule) {
                          return ListTile(
                            title: Text(schedule.mataPelajaran),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${schedule.jamMulai} - ${schedule.jamSelesai}'),
                                Text('Guru: ${schedule.guruName}'),
                                Text('Kelas: ${schedule.kelas}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _showScheduleForm(schedule),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteSchedule(schedule),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showScheduleForm(),
        backgroundColor: Colors.orange.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class ScheduleFormDialog extends StatefulWidget {
  final Schedule? schedule;
  final VoidCallback onSave;

  const ScheduleFormDialog({
    super.key,
    this.schedule,
    required this.onSave,
  });

  @override
  State<ScheduleFormDialog> createState() => _ScheduleFormDialogState();
}

class _ScheduleFormDialogState extends State<ScheduleFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _mataPelajaranController = TextEditingController();
  final _kelasController = TextEditingController();
  String _selectedHari = 'Senin';
  TimeOfDay _jamMulai = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _jamSelesai = const TimeOfDay(hour: 8, minute: 30);
  Teacher? _selectedTeacher;
  List<Teacher> _teachers = [];
  final _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _loadTeachers();
    if (widget.schedule != null) {
      _mataPelajaranController.text = widget.schedule!.mataPelajaran;
      _kelasController.text = widget.schedule!.kelas;
      _selectedHari = widget.schedule!.hari;
      _jamMulai = _parseTime(widget.schedule!.jamMulai);
      _jamSelesai = _parseTime(widget.schedule!.jamSelesai);
    }
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _loadTeachers() async {
    final teachers = await _dataService.getTeachers();
    setState(() {
      _teachers = teachers;
      if (widget.schedule != null) {
        _selectedTeacher = teachers.firstWhere(
          (t) => t.id == widget.schedule!.guruId,
          orElse: () => teachers.first,
        );
      } else if (teachers.isNotEmpty) {
        _selectedTeacher = teachers.first;
      }
    });
  }

  @override
  void dispose() {
    _mataPelajaranController.dispose();
    _kelasController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _jamMulai : _jamSelesai,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _jamMulai = picked;
        } else {
          _jamSelesai = picked;
        }
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTeacher == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih guru terlebih dahulu')),
      );
      return;
    }

    final schedule = Schedule(
      id: widget.schedule?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      hari: _selectedHari,
      jamMulai: _formatTime(_jamMulai),
      jamSelesai: _formatTime(_jamSelesai),
      mataPelajaran: _mataPelajaranController.text,
      guruId: _selectedTeacher!.id,
      guruName: _selectedTeacher!.name,
      kelas: _kelasController.text,
    );

    if (widget.schedule == null) {
      await _dataService.addSchedule(schedule);
    } else {
      await _dataService.updateSchedule(schedule);
    }

    widget.onSave();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.schedule == null ? 'Tambah Jadwal' : 'Edit Jadwal'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedHari,
                decoration: const InputDecoration(
                  labelText: 'Hari',
                  border: OutlineInputBorder(),
                ),
                items: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu']
                    .map((hari) => DropdownMenuItem(value: hari, child: Text(hari)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedHari = value!),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context, true),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Jam Mulai',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(_formatTime(_jamMulai)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context, false),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Jam Selesai',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(_formatTime(_jamSelesai)),
                      ),
                    ),
                  ),
                ],
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
              DropdownButtonFormField<Teacher>(
                value: _selectedTeacher,
                decoration: const InputDecoration(
                  labelText: 'Guru Pengampu',
                  border: OutlineInputBorder(),
                ),
                items: _teachers
                    .map((teacher) => DropdownMenuItem(
                          value: teacher,
                          child: Text('${teacher.name} - ${teacher.mataPelajaran}'),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedTeacher = value),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kelasController,
                decoration: const InputDecoration(
                  labelText: 'Kelas',
                  border: OutlineInputBorder(),
                  hintText: 'Contoh: XII IPA',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kelas tidak boleh kosong';
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
