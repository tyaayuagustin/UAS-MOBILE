import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:universal_html/html.dart' as html;
import '../../models/grade.dart';
import '../../services/data_service.dart';
import '../../services/auth_service.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
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
    
    // Get current user to find student name
    final user = await _authService.getCurrentUser();
    _studentName = user?.name ?? 'Siswa';
    
    // For demo purposes, we'll show grades for the student with ID 'student_001'
    // In real app, you'd match by student ID from user data
    final allGrades = await _dataService.getGrades();
    
    setState(() {
      _grades = allGrades.where((g) => g.studentId == 'student_001').toList();
      _isLoading = false;
    });
  }

  Future<void> _exportToPDF() async {
    final pdf = pw.Document();

    // Calculate average
    final totalNilai = _grades.fold<double>(
      0,
      (sum, grade) => sum + grade.nilaiAkhir,
    );
    final rataRata = _grades.isEmpty ? 0.0 : totalNilai / _grades.length;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      'RAPOR SISWA',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'SIAKAD Sekolah',
                      style: const pw.TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 32),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Nama: $_studentName'),
                      pw.SizedBox(height: 4),
                      pw.Text('Semester: ${_grades.isNotEmpty ? _grades.first.semester : '-'}'),
                      pw.SizedBox(height: 4),
                      pw.Text('Tahun Ajaran: ${_grades.isNotEmpty ? _grades.first.tahunAjaran : '-'}'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 24),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'No',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Mata Pelajaran',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Tugas',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'UTS',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'UAS',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Nilai Akhir',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Predikat',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  ..._grades.asMap().entries.map((entry) {
                    final index = entry.key;
                    final grade = entry.value;
                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text((index + 1).toString()),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(grade.mataPelajaran),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(grade.nilaiTugas.toString()),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(grade.nilaiUTS.toString()),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(grade.nilaiUAS.toString()),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(grade.nilaiAkhir.toStringAsFixed(2)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(grade.predikat),
                        ),
                      ],
                    );
                  }),
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    'Rata-rata: ${rataRata.toStringAsFixed(2)}',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    try {
      final pdfBytes = await pdf.save();
      
      if (kIsWeb) {
        // Download untuk Web (Chrome, Edge, dll)
        final blob = html.Blob([pdfBytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.AnchorElement(href: url)
          ..setAttribute('download', 'Rapor_$_studentName.pdf')
          ..click();
        html.Url.revokeObjectUrl(url);
        
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ PDF berhasil didownload!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        // Save untuk Mobile/Desktop
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/rapor_${DateTime.now().millisecondsSinceEpoch}.pdf');
        
        await file.writeAsBytes(pdfBytes);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF berhasil disimpan di: ${file.path}'),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalNilai = _grades.fold<double>(
      0,
      (sum, grade) => sum + grade.nilaiAkhir,
    );
    final rataRata = _grades.isEmpty ? 0.0 : totalNilai / _grades.length;

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _grades.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.assessment_outlined, size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada data nilai',
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadGrades,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Informasi Siswa',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const Divider(),
                                const SizedBox(height: 8),
                                _buildInfoRow('Nama', _studentName),
                                _buildInfoRow('Semester', _grades.first.semester),
                                _buildInfoRow('Tahun Ajaran', _grades.first.tahunAjaran),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Daftar Nilai',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _exportToPDF,
                              icon: const Icon(Icons.picture_as_pdf),
                              label: const Text('Export PDF'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade700,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Card(
                          elevation: 3,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('Mata Pelajaran')),
                                DataColumn(label: Text('Tugas')),
                                DataColumn(label: Text('UTS')),
                                DataColumn(label: Text('UAS')),
                                DataColumn(label: Text('Nilai Akhir')),
                                DataColumn(label: Text('Predikat')),
                              ],
                              rows: _grades.map((grade) {
                                return DataRow(cells: [
                                  DataCell(Text(grade.mataPelajaran)),
                                  DataCell(Text(grade.nilaiTugas.toString())),
                                  DataCell(Text(grade.nilaiUTS.toString())),
                                  DataCell(Text(grade.nilaiUAS.toString())),
                                  DataCell(Text(grade.nilaiAkhir.toStringAsFixed(2))),
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getPredikatColor(grade.predikat),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        grade.predikat,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Card(
                          elevation: 3,
                          color: Colors.blue.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Rata-rata Nilai:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  rataRata.toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const Text(': '),
          Text(value),
        ],
      ),
    );
  }

  Color _getPredikatColor(String predikat) {
    switch (predikat) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.blue;
      case 'C':
        return Colors.orange;
      case 'D':
        return Colors.red;
      case 'E':
        return Colors.red.shade900;
      default:
        return Colors.grey;
    }
  }
}
