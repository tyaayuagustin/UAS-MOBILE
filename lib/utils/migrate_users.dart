import 'package:cloud_firestore/cloud_firestore.dart';

/// Script untuk migrasi data user dari username ke email
/// Jalankan sekali saja untuk update data yang sudah ada
class UserMigration {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Migrasi semua user: ubah field username menjadi email
  static Future<void> migrateUsernameToEmail() async {
    try {
      print('🔄 Memulai migrasi data user...');
      
      // Ambil semua dokumen user
      final usersSnapshot = await _firestore.collection('users').get();
      
      if (usersSnapshot.docs.isEmpty) {
        print('✅ Tidak ada data user yang perlu dimigrasi');
        return;
      }

      int migratedCount = 0;
      int skippedCount = 0;

      for (var doc in usersSnapshot.docs) {
        final data = doc.data();
        
        // Cek apakah sudah menggunakan email atau masih username
        if (data.containsKey('username') && !data.containsKey('email')) {
          String username = data['username'];
          String email = '$username@gmail.com';
          
          // Update dokumen: hapus username, tambah email
          await doc.reference.update({
            'email': email,
          });
          
          // Hapus field username (opsional, bisa dibiarkan untuk backup)
          await doc.reference.update({
            'username': FieldValue.delete(),
          });
          
          migratedCount++;
          print('✅ Migrasi: $username → $email');
        } else if (data.containsKey('email')) {
          skippedCount++;
          print('⏭️  Skip: ${data['email']} (sudah menggunakan email)');
        }
      }

      print('\n📊 Hasil Migrasi:');
      print('  - Berhasil dimigrasi: $migratedCount user');
      print('  - Dilewati (sudah email): $skippedCount user');
      print('  - Total: ${usersSnapshot.docs.length} user\n');
      
    } catch (e) {
      print('❌ Error saat migrasi: $e');
    }
  }

  /// Hapus semua user lama (gunakan dengan hati-hati!)
  static Future<void> clearAllUsers() async {
    try {
      print('🗑️  Menghapus semua data user...');
      
      final usersSnapshot = await _firestore.collection('users').get();
      
      for (var doc in usersSnapshot.docs) {
        await doc.reference.delete();
      }
      
      print('✅ Semua user berhasil dihapus (${usersSnapshot.docs.length} user)');
    } catch (e) {
      print('❌ Error saat menghapus: $e');
    }
  }

  /// Reset dan buat ulang dummy users dengan format email
  static Future<void> resetDummyUsers() async {
    try {
      print('🔄 Reset dummy users...');
      
      // Hapus user lama
      await clearAllUsers();
      
      // Buat user baru dengan format email
      final dummyUsers = [
        {
          'id': 'admin_001',
          'email': 'admin@gmail.com',
          'password': 'admin123',
          'name': 'Administrator',
          'role': 'UserRole.admin',
        },
        {
          'id': 'guru_001',
          'email': 'guru@gmail.com',
          'password': 'guru123',
          'name': 'Budi Santoso',
          'role': 'UserRole.guru',
        },
        {
          'id': 'siswa_001',
          'email': 'siswa@gmail.com',
          'password': 'siswa123',
          'name': 'Ahmad Fauzi',
          'role': 'UserRole.siswa',
        },
      ];

      for (var userData in dummyUsers) {
        await _firestore
            .collection('users')
            .doc(userData['id'] as String)
            .set(userData);
        print('✅ Created: ${userData['email']}');
      }
      
      print('\n✅ Reset selesai! 3 dummy user berhasil dibuat');
    } catch (e) {
      print('❌ Error saat reset: $e');
    }
  }
}
