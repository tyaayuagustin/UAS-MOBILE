import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'migrate_users.dart';

/// Script standalone untuk menjalankan migrasi
/// Jalankan dengan: flutter run -t lib/utils/run_migration.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('\n╔════════════════════════════════════════╗');
  print('║   SIAKAD - User Migration Script      ║');
  print('╚════════════════════════════════════════╝\n');

  // Pilih salah satu metode di bawah ini:

  // METODE 1: Migrasi data yang ada (username → email)
  // Gunakan ini jika sudah ada data user dan ingin update field-nya
  await UserMigration.migrateUsernameToEmail();

  // METODE 2: Reset total - hapus semua user dan buat ulang
  // Gunakan ini untuk membersihkan data dan mulai fresh
  // await UserMigration.resetDummyUsers();

  print('✅ Migrasi selesai!\n');
  
  // Exit setelah migrasi selesai
  exit(0);
}
