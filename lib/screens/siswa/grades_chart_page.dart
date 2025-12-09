import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/grade.dart';
import '../../services/data_service.dart';
import '../../services/auth_service.dart';

class GradesChartPage extends StatefulWidget {
  const GradesChartPage({super.key});

  @override
  State<GradesChartPage> createState() => _GradesChartPageState();
}

class _GradesChartPageState extends State<GradesChartPage> {
  final _dataService = DataService();
  final _authService = AuthService();
  List<Grade> _grades = [];
  bool _isLoading = true;
  String _studentName = '';

  @override
  void initState() {
    super.initState();
    _loadGrades();
  }

  Future<void> _loadGrades() async {
    setState(() => _isLoading = true);
    
    final user = await _authService.getCurrentUser();
    _studentName = user?.name ?? 'Siswa';
    
    final allGrades = await _dataService.getGrades();
    
    setState(() {
      _grades = allGrades.where((g) => g.studentId == 'student_001').toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_grades.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Belum ada data nilai untuk ditampilkan',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadGrades,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Grafik Nilai $_studentName',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            
            // Bar Chart - Nilai per Mata Pelajaran
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nilai Akhir per Mata Pelajaran',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 300,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 100,
                          barTouchData: BarTouchData(
                            enabled: true,
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                String mapel = _grades[group.x.toInt()].mataPelajaran;
                                return BarTooltipItem(
                                  '$mapel\n${rod.toY.toStringAsFixed(1)}',
                                  const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value.toInt() >= _grades.length) return const Text('');
                                  final mapel = _grades[value.toInt()].mataPelajaran;
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      mapel.length > 8 ? '${mapel.substring(0, 8)}...' : mapel,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  );
                                },
                                reservedSize: 40,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(fontSize: 10),
                                  );
                                },
                              ),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 20,
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: _grades.asMap().entries.map((entry) {
                            return BarChartGroupData(
                              x: entry.key,
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value.nilaiAkhir,
                                  color: _getColorByGrade(entry.value.nilaiAkhir),
                                  width: 20,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Line Chart - Perbandingan Tugas, UTS, UAS
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Perbandingan Nilai Komponen',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 300,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            horizontalInterval: 20,
                            verticalInterval: 1,
                          ),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  if (value.toInt() >= _grades.length) return const Text('');
                                  final mapel = _grades[value.toInt()].mataPelajaran;
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      mapel.length > 6 ? '${mapel.substring(0, 6)}...' : mapel,
                                      style: const TextStyle(fontSize: 9),
                                    ),
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(fontSize: 10),
                                  );
                                },
                              ),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                          minX: 0,
                          maxX: (_grades.length - 1).toDouble(),
                          minY: 0,
                          maxY: 100,
                          lineBarsData: [
                            // Line for Tugas
                            LineChartBarData(
                              spots: _grades.asMap().entries.map((entry) {
                                return FlSpot(
                                  entry.key.toDouble(),
                                  entry.value.nilaiTugas.toDouble(),
                                );
                              }).toList(),
                              isCurved: true,
                              color: Colors.blue,
                              barWidth: 3,
                              dotData: const FlDotData(show: true),
                              belowBarData: BarAreaData(show: false),
                            ),
                            // Line for UTS
                            LineChartBarData(
                              spots: _grades.asMap().entries.map((entry) {
                                return FlSpot(
                                  entry.key.toDouble(),
                                  entry.value.nilaiUTS.toDouble(),
                                );
                              }).toList(),
                              isCurved: true,
                              color: Colors.orange,
                              barWidth: 3,
                              dotData: const FlDotData(show: true),
                              belowBarData: BarAreaData(show: false),
                            ),
                            // Line for UAS
                            LineChartBarData(
                              spots: _grades.asMap().entries.map((entry) {
                                return FlSpot(
                                  entry.key.toDouble(),
                                  entry.value.nilaiUAS.toDouble(),
                                );
                              }).toList(),
                              isCurved: true,
                              color: Colors.red,
                              barWidth: 3,
                              dotData: const FlDotData(show: true),
                              belowBarData: BarAreaData(show: false),
                            ),
                          ],
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots.map((spot) {
                                  String label = '';
                                  if (spot.barIndex == 0) label = 'Tugas';
                                  if (spot.barIndex == 1) label = 'UTS';
                                  if (spot.barIndex == 2) label = 'UAS';
                                  return LineTooltipItem(
                                    '$label: ${spot.y.toStringAsFixed(0)}',
                                    const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Legend
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLegend(Colors.blue, 'Tugas'),
                        const SizedBox(width: 16),
                        _buildLegend(Colors.orange, 'UTS'),
                        const SizedBox(width: 16),
                        _buildLegend(Colors.red, 'UAS'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Pie Chart - Distribusi Predikat
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Distribusi Predikat Nilai',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 250,
                      child: _buildPredikatPieChart(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildPredikatPieChart() {
    // Count predicates
    final predicateCounts = <String, int>{};
    for (var grade in _grades) {
      predicateCounts[grade.predikat] = (predicateCounts[grade.predikat] ?? 0) + 1;
    }

    if (predicateCounts.isEmpty) {
      return const Center(child: Text('Tidak ada data'));
    }

    final colors = {
      'A': Colors.green,
      'B': Colors.blue,
      'C': Colors.orange,
      'D': Colors.red,
      'E': Colors.red.shade900,
    };

    return Row(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sections: predicateCounts.entries.map((entry) {
                final percentage = (entry.value / _grades.length) * 100;
                return PieChartSectionData(
                  value: entry.value.toDouble(),
                  title: '${percentage.toStringAsFixed(1)}%',
                  color: colors[entry.key] ?? Colors.grey,
                  radius: 80,
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: predicateCounts.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: colors[entry.key],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('Predikat ${entry.key}: ${entry.value}'),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getColorByGrade(double grade) {
    if (grade >= 85) return Colors.green;
    if (grade >= 70) return Colors.blue;
    if (grade >= 60) return Colors.orange;
    if (grade >= 50) return Colors.red;
    return Colors.red.shade900;
  }
}
