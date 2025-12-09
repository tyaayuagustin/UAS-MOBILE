import 'package:flutter/material.dart';
import '../../models/schedule.dart';
import '../../services/data_service.dart';

class ScheduleViewPage extends StatefulWidget {
  const ScheduleViewPage({super.key});

  @override
  State<ScheduleViewPage> createState() => _ScheduleViewPageState();
}

class _ScheduleViewPageState extends State<ScheduleViewPage> {
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

  @override
  Widget build(BuildContext context) {
    final schedulesByDay = <String, List<Schedule>>{};
    for (var schedule in _schedules) {
      schedulesByDay.putIfAbsent(schedule.hari, () => []).add(schedule);
    }

    // Sort days
    final orderedDays = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    final sortedDays = schedulesByDay.keys.toList()
      ..sort((a, b) => orderedDays.indexOf(a).compareTo(orderedDays.indexOf(b)));

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
              : RefreshIndicator(
                  onRefresh: _loadSchedules,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: sortedDays.length,
                    itemBuilder: (context, index) {
                      final hari = sortedDays[index];
                      final daySchedules = schedulesByDay[hari]!;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 3,
                        child: Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            title: Text(
                              hari,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.orange.shade700,
                              child: const Icon(Icons.calendar_today, color: Colors.white, size: 20),
                            ),
                            children: daySchedules.map((schedule) {
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: Colors.grey.shade200),
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  title: Text(
                                    schedule.mataPelajaran,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.access_time, size: 16),
                                          const SizedBox(width: 4),
                                          Text('${schedule.jamMulai} - ${schedule.jamSelesai}'),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.person, size: 16),
                                          const SizedBox(width: 4),
                                          Text(schedule.guruName),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.class_, size: 16),
                                          const SizedBox(width: 4),
                                          Text(schedule.kelas),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
