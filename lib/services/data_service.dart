import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student.dart';
import '../models/teacher.dart';
import '../models/schedule.dart';
import '../models/announcement.dart';
import '../models/grade.dart';

class DataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Initialize with dummy data
  Future<void> initializeData() async {
    try {
      // Initialize students if not exists
      final studentsSnapshot = await _firestore.collection('students').limit(1).get();
      if (studentsSnapshot.docs.isEmpty) {
        final dummyStudents = [
          Student(
            id: 'student_001',
            nis: '20230001',
            name: 'Ahmad Fauzi',
            kelas: 'XII',
            jurusan: 'IPA',
          ),
          Student(
            id: 'student_002',
            nis: '20230002',
            name: 'Siti Nurhaliza',
            kelas: 'XII',
            jurusan: 'IPS',
          ),
          Student(
            id: 'student_003',
            nis: '20230003',
            name: 'Budi Santoso',
            kelas: 'XI',
            jurusan: 'IPA',
          ),
        ];
        for (var student in dummyStudents) {
          await _firestore.collection('students').doc(student.id).set(student.toJson());
        }
      }

      // Initialize teachers if not exists
      final teachersSnapshot = await _firestore.collection('teachers').limit(1).get();
      if (teachersSnapshot.docs.isEmpty) {
        final dummyTeachers = [
          Teacher(
            id: 'teacher_001',
            nip: '197501012000031001',
            name: 'Budi Santoso',
            mataPelajaran: 'Matematika',
          ),
          Teacher(
            id: 'teacher_002',
            nip: '198002152005011002',
            name: 'Sri Wahyuni',
            mataPelajaran: 'Bahasa Indonesia',
          ),
          Teacher(
            id: 'teacher_003',
            nip: '198505202010012001',
            name: 'Agus Priyanto',
            mataPelajaran: 'Fisika',
          ),
        ];
        for (var teacher in dummyTeachers) {
          await _firestore.collection('teachers').doc(teacher.id).set(teacher.toJson());
        }
      }

      // Initialize schedules if not exists
      final schedulesSnapshot = await _firestore.collection('schedules').limit(1).get();
      if (schedulesSnapshot.docs.isEmpty) {
        final dummySchedules = [
          Schedule(
            id: 'schedule_001',
            hari: 'Senin',
            jamMulai: '07:00',
            jamSelesai: '08:30',
            mataPelajaran: 'Matematika',
            guruId: 'teacher_001',
            guruName: 'Budi Santoso',
            kelas: 'XII IPA',
          ),
          Schedule(
            id: 'schedule_002',
            hari: 'Senin',
            jamMulai: '08:30',
            jamSelesai: '10:00',
            mataPelajaran: 'Bahasa Indonesia',
            guruId: 'teacher_002',
            guruName: 'Sri Wahyuni',
            kelas: 'XII IPA',
          ),
          Schedule(
            id: 'schedule_003',
            hari: 'Selasa',
            jamMulai: '07:00',
            jamSelesai: '08:30',
            mataPelajaran: 'Fisika',
            guruId: 'teacher_003',
            guruName: 'Agus Priyanto',
            kelas: 'XII IPA',
          ),
        ];
        for (var schedule in dummySchedules) {
          await _firestore.collection('schedules').doc(schedule.id).set(schedule.toJson());
        }
      }

      // Initialize announcements if not exists
      final announcementsSnapshot = await _firestore.collection('announcements').limit(1).get();
      if (announcementsSnapshot.docs.isEmpty) {
        final dummyAnnouncements = [
          Announcement(
            id: 'announcement_001',
            title: 'Libur Semester',
            content: 'Libur semester akan dimulai tanggal 20 Desember 2025',
            createdAt: DateTime.now(),
            createdBy: 'Administrator',
          ),
          Announcement(
            id: 'announcement_002',
            title: 'Ujian Akhir Semester',
            content: 'Ujian Akhir Semester akan dilaksanakan tanggal 10-15 Desember 2025',
            createdAt: DateTime.now(),
            createdBy: 'Administrator',
          ),
        ];
        for (var announcement in dummyAnnouncements) {
          await _firestore.collection('announcements').doc(announcement.id).set(announcement.toJson());
        }
      }

      // Initialize grades if not exists
      final gradesSnapshot = await _firestore.collection('grades').limit(1).get();
      if (gradesSnapshot.docs.isEmpty) {
        final dummyGrades = [
          Grade(
            id: 'grade_001',
            studentId: 'student_001',
            studentName: 'Ahmad Fauzi',
            mataPelajaran: 'Matematika',
            nilaiTugas: 85,
            nilaiUTS: 80,
            nilaiUAS: 90,
            semester: 'Ganjil',
            tahunAjaran: '2024/2025',
          ),
          Grade(
            id: 'grade_002',
            studentId: 'student_001',
            studentName: 'Ahmad Fauzi',
            mataPelajaran: 'Bahasa Indonesia',
            nilaiTugas: 88,
            nilaiUTS: 85,
            nilaiUAS: 87,
            semester: 'Ganjil',
            tahunAjaran: '2024/2025',
          ),
          Grade(
            id: 'grade_003',
            studentId: 'student_001',
            studentName: 'Ahmad Fauzi',
            mataPelajaran: 'Fisika',
            nilaiTugas: 82,
            nilaiUTS: 78,
            nilaiUAS: 85,
            semester: 'Ganjil',
            tahunAjaran: '2024/2025',
          ),
        ];
        for (var grade in dummyGrades) {
          await _firestore.collection('grades').doc(grade.id).set(grade.toJson());
        }
      }
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  // Students CRUD
  Future<List<Student>> getStudents() async {
    try {
      final snapshot = await _firestore.collection('students').get();
      return snapshot.docs.map((doc) => Student.fromJson(doc.data())).toList();
    } catch (e) {
      print('Error getting students: $e');
      return [];
    }
  }

  Future<void> addStudent(Student student) async {
    try {
      await _firestore.collection('students').doc(student.id).set(student.toJson());
    } catch (e) {
      print('Error adding student: $e');
    }
  }

  Future<void> updateStudent(Student student) async {
    try {
      await _firestore.collection('students').doc(student.id).update(student.toJson());
    } catch (e) {
      print('Error updating student: $e');
    }
  }

  Future<void> deleteStudent(String id) async {
    try {
      await _firestore.collection('students').doc(id).delete();
    } catch (e) {
      print('Error deleting student: $e');
    }
  }

  // Teachers CRUD
  Future<List<Teacher>> getTeachers() async {
    try {
      final snapshot = await _firestore.collection('teachers').get();
      return snapshot.docs.map((doc) => Teacher.fromJson(doc.data())).toList();
    } catch (e) {
      print('Error getting teachers: $e');
      return [];
    }
  }

  Future<void> addTeacher(Teacher teacher) async {
    try {
      await _firestore.collection('teachers').doc(teacher.id).set(teacher.toJson());
    } catch (e) {
      print('Error adding teacher: $e');
    }
  }

  Future<void> updateTeacher(Teacher teacher) async {
    try {
      await _firestore.collection('teachers').doc(teacher.id).update(teacher.toJson());
    } catch (e) {
      print('Error updating teacher: $e');
    }
  }

  Future<void> deleteTeacher(String id) async {
    try {
      await _firestore.collection('teachers').doc(id).delete();
    } catch (e) {
      print('Error deleting teacher: $e');
    }
  }

  // Schedules CRUD
  Future<List<Schedule>> getSchedules() async {
    try {
      final snapshot = await _firestore.collection('schedules').get();
      return snapshot.docs.map((doc) => Schedule.fromJson(doc.data())).toList();
    } catch (e) {
      print('Error getting schedules: $e');
      return [];
    }
  }

  Future<void> addSchedule(Schedule schedule) async {
    try {
      await _firestore.collection('schedules').doc(schedule.id).set(schedule.toJson());
    } catch (e) {
      print('Error adding schedule: $e');
    }
  }

  Future<void> updateSchedule(Schedule schedule) async {
    try {
      await _firestore.collection('schedules').doc(schedule.id).update(schedule.toJson());
    } catch (e) {
      print('Error updating schedule: $e');
    }
  }

  Future<void> deleteSchedule(String id) async {
    try {
      await _firestore.collection('schedules').doc(id).delete();
    } catch (e) {
      print('Error deleting schedule: $e');
    }
  }

  // Announcements CRUD
  Future<List<Announcement>> getAnnouncements() async {
    try {
      final snapshot = await _firestore
          .collection('announcements')
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((doc) => Announcement.fromJson(doc.data())).toList();
    } catch (e) {
      print('Error getting announcements: $e');
      return [];
    }
  }

  Future<void> addAnnouncement(Announcement announcement) async {
    try {
      await _firestore.collection('announcements').doc(announcement.id).set(announcement.toJson());
    } catch (e) {
      print('Error adding announcement: $e');
    }
  }

  Future<void> updateAnnouncement(Announcement announcement) async {
    try {
      await _firestore.collection('announcements').doc(announcement.id).update(announcement.toJson());
    } catch (e) {
      print('Error updating announcement: $e');
    }
  }

  Future<void> deleteAnnouncement(String id) async {
    try {
      await _firestore.collection('announcements').doc(id).delete();
    } catch (e) {
      print('Error deleting announcement: $e');
    }
  }

  // Grades CRUD
  Future<List<Grade>> getGrades() async {
    try {
      final snapshot = await _firestore.collection('grades').get();
      return snapshot.docs.map((doc) => Grade.fromJson(doc.data())).toList();
    } catch (e) {
      print('Error getting grades: $e');
      return [];
    }
  }

  Future<List<Grade>> getGradesByStudent(String studentId) async {
    try {
      final snapshot = await _firestore
          .collection('grades')
          .where('studentId', isEqualTo: studentId)
          .get();
      return snapshot.docs.map((doc) => Grade.fromJson(doc.data())).toList();
    } catch (e) {
      print('Error getting grades by student: $e');
      return [];
    }
  }

  Future<void> addGrade(Grade grade) async {
    try {
      await _firestore.collection('grades').doc(grade.id).set(grade.toJson());
    } catch (e) {
      print('Error adding grade: $e');
    }
  }

  Future<void> updateGrade(Grade grade) async {
    try {
      await _firestore.collection('grades').doc(grade.id).update(grade.toJson());
    } catch (e) {
      print('Error updating grade: $e');
    }
  }

  Future<void> deleteGrade(String id) async {
    try {
      await _firestore.collection('grades').doc(id).delete();
    } catch (e) {
      print('Error deleting grade: $e');
    }
  }
}
