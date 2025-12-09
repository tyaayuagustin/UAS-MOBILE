# Setup Firebase untuk SIAKAD Sekolah

Aplikasi telah diubah untuk menggunakan **Firebase Cloud Firestore** sebagai database cloud menggantikan shared_preferences (local storage).

## 🔥 Langkah-langkah Setup Firebase

### 1. Buat Project Firebase

1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Klik **"Add project"** atau **"Tambah project"**
3. Beri nama project: `siakad-sekolah` (atau nama lain sesuai keinginan)
4. Ikuti wizard setup hingga selesai

### 2. Aktifkan Cloud Firestore

1. Di Firebase Console, pilih project yang baru dibuat
2. Klik menu **"Firestore Database"** di sidebar kiri
3. Klik **"Create database"**
4. Pilih mode:
   - **Test mode** (untuk development - data dapat diakses publik)
   - **Production mode** (untuk production - butuh security rules)
5. Pilih lokasi server (pilih yang terdekat, misal: `asia-southeast1`)
6. Klik **"Enable"**

### 3. Setup Security Rules (Penting untuk Production)

Di Firestore Console, tab **"Rules"**, ganti dengan:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection - hanya bisa dibaca
    match /users/{userId} {
      allow read: if true;
      allow write: if false; // Hanya admin yang bisa modify via console
    }
    
    // Sessions collection
    match /sessions/{sessionId} {
      allow read, write: if true;
    }
    
    // Students collection
    match /students/{studentId} {
      allow read: if true;
      allow write: if true; // Ubah sesuai kebutuhan
    }
    
    // Teachers collection
    match /teachers/{teacherId} {
      allow read: if true;
      allow write: if true;
    }
    
    // Schedules collection
    match /schedules/{scheduleId} {
      allow read: if true;
      allow write: if true;
    }
    
    // Announcements collection
    match /announcements/{announcementId} {
      allow read: if true;
      allow write: if true;
    }
    
    // Grades collection
    match /grades/{gradeId} {
      allow read: if true;
      allow write: if true;
    }
  }
}
```

### 4. Install FlutterFire CLI

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Pastikan sudah login ke Firebase
firebase login

# Configure FlutterFire untuk project ini
flutterfire configure
```

Pilih project `siakad-sekolah` yang sudah dibuat, dan pilih platform yang ingin digunakan (Android, iOS, Web, dll).

Ini akan otomatis generate file `firebase_options.dart` dengan konfigurasi yang benar.

### 5. Alternative: Manual Configuration

Jika tidak menggunakan FlutterFire CLI, setup manual untuk setiap platform:

#### **Android**

1. Di Firebase Console, klik icon Android
2. Daftarkan app dengan package name: `com.example.siakad_sekolah`
3. Download `google-services.json`
4. Copy ke folder: `android/app/google-services.json`
5. Edit `android/build.gradle`:
   ```gradle
   dependencies {
       classpath 'com.google.gms:google-services:4.4.0'
   }
   ```
6. Edit `android/app/build.gradle`:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```

#### **iOS**

1. Di Firebase Console, klik icon iOS
2. Daftarkan app dengan Bundle ID: `com.example.siakadSekolah`
3. Download `GoogleService-Info.plist`
4. Drag file ke Xcode project di folder `Runner`

#### **Web**

1. Di Firebase Console, klik icon Web
2. Copy konfigurasi Firebase
3. Update `lib/firebase_options.dart` dengan nilai yang benar

#### **Windows/macOS/Linux**

Gunakan konfigurasi Web untuk platform desktop.

### 6. Update `firebase_options.dart`

Setelah mendapatkan konfigurasi dari Firebase Console, update file `lib/firebase_options.dart` dengan nilai yang benar:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'AIzaSy...', // Ganti dengan API Key Anda
  appId: '1:123456789:web:abc123', // Ganti dengan App ID Anda
  messagingSenderId: '123456789', // Ganti dengan Sender ID Anda
  projectId: 'siakad-sekolah', // Sesuaikan dengan nama project
  authDomain: 'siakad-sekolah.firebaseapp.com',
  storageBucket: 'siakad-sekolah.appspot.com',
);
```

## 📦 Struktur Data di Firestore

Aplikasi akan otomatis membuat collections berikut:

### Collections:

1. **users** - Data user login
   - Fields: id, username, password, name, role

2. **sessions** - Session login user
   - Fields: userId, loginTime

3. **students** - Data siswa
   - Fields: id, nis, name, kelas, jurusan

4. **teachers** - Data guru
   - Fields: id, nip, name, mataPelajaran

5. **schedules** - Jadwal pelajaran
   - Fields: id, hari, jamMulai, jamSelesai, mataPelajaran, guruId, guruName, kelas

6. **announcements** - Pengumuman
   - Fields: id, title, content, createdAt, createdBy

7. **grades** - Nilai siswa
   - Fields: id, studentId, studentName, mataPelajaran, nilaiTugas, nilaiUTS, nilaiUAS, semester, tahunAjaran

## 🚀 Cara Menjalankan

```bash
# 1. Pastikan sudah setup Firebase
flutterfire configure

# 2. Install dependencies
flutter pub get

# 3. Run aplikasi
flutter run
```

## ✨ Keuntungan Menggunakan Firebase

### ✅ **Kelebihan:**
- ☁️ Data tersimpan di cloud, bisa diakses dari device mana saja
- 🔄 Real-time synchronization
- 🔐 Security rules untuk proteksi data
- 📱 Multi-platform support (Android, iOS, Web, Desktop)
- 💾 Backup otomatis
- 📊 Analytics & monitoring built-in
- 🚀 Scalable untuk banyak user
- 🆓 Free tier generous (50K reads/day, 20K writes/day)

### 🎯 **Fitur Baru dengan Firebase:**
- Data persistent di cloud
- Multi-user access (bisa login dari device berbeda)
- Data sync otomatis
- Bisa diakses via web, mobile, desktop
- Admin bisa monitor data via Firebase Console

## 🔒 Keamanan

Untuk production, pertimbangkan:

1. **Enable Firebase Authentication**
   - Ganti username/password dengan Firebase Auth
   - Support email/password, Google Sign-In, dll

2. **Security Rules**
   - Batasi write access berdasarkan role
   - Validasi data di server-side

3. **Environment Variables**
   - Jangan commit `google-services.json` ke git
   - Gunakan `.gitignore` untuk file config

## 📝 Akun Demo

Akun demo yang sama masih bisa digunakan:
- Admin: `admin` / `admin123`
- Guru: `guru` / `guru123`
- Siswa: `siswa` / `siswa123`

Data dummy akan otomatis dibuat saat pertama kali run aplikasi.

## 🛠️ Troubleshooting

### Error: "No Firebase App"
- Pastikan `Firebase.initializeApp()` dipanggil sebelum menggunakan Firestore
- Pastikan `firebase_options.dart` sudah dikonfigurasi dengan benar

### Error: "Permission Denied"
- Cek Security Rules di Firestore Console
- Untuk development, gunakan Test Mode

### Error: "Missing google-services.json"
- Download file dari Firebase Console
- Pastikan file di path yang benar

## 📚 Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Cloud Firestore Guide](https://firebase.google.com/docs/firestore)

---

**Migrasi dari Local Storage ke Firebase selesai!** 🎉

Aplikasi sekarang menggunakan Cloud Firestore untuk penyimpanan data yang lebih powerful dan scalable.
