# SIAKAD Sekolah - Sistem Informasi Akademik

Aplikasi Flutter untuk manajemen akademik sekolah dengan sistem multi-role (Admin, Guru, dan Siswa).

## 🎯 Fitur Utama

### 1. **Login & Role-Based Access**
- 3 Role pengguna: Admin, Guru, Siswa
- Autentikasi dengan dummy data (local storage)
- Setiap role memiliki hak akses berbeda

**Akun Demo:**
- Admin: `admin` / `admin123`
- Guru: `guru` / `guru123`
- Siswa: `siswa` / `siswa123`

### 2. **Admin Dashboard**
Admin memiliki akses penuh untuk:
- ✅ **CRUD Data Siswa**: NIS, Nama, Kelas, Jurusan
- ✅ **CRUD Data Guru**: NIP, Nama, Mata Pelajaran
- ✅ **CRUD Jadwal Pelajaran**: Hari, Jam, Mata Pelajaran, Guru Pengampu
- ✅ **CRUD Pengumuman**: Judul, Isi, Tanggal

### 3. **Guru Dashboard**
Guru dapat:
- ✅ **Input Nilai Siswa**: Nilai Tugas, UTS, UAS per mata pelajaran
- ✅ **Lihat Pengumuman**: Melihat semua pengumuman dari admin
- ✅ Perhitungan otomatis nilai akhir dan predikat

### 4. **Siswa Dashboard**
Siswa dapat:
- ✅ **Lihat Jadwal Pelajaran**: Jadwal lengkap per hari
- ✅ **Lihat Nilai/Rapor**: Nilai per mata pelajaran dengan detail
- ✅ **Export Rapor ke PDF**: Download rapor dalam format PDF
- ✅ **Lihat Pengumuman**: Semua pengumuman dari sekolah

## 📱 Teknologi yang Digunakan

- **Flutter**: Framework UI cross-platform
- **Firebase Cloud Firestore**: Database cloud real-time
- **Firebase Auth**: Authentication (ready for future implementation)
- **pdf**: Generate rapor dalam format PDF
- **path_provider**: Akses direktori file sistem
- **intl**: Format tanggal dan waktu

## 🔥 Firebase Integration

Aplikasi menggunakan **Firebase Cloud Firestore** sebagai database:
- ☁️ Data tersimpan di cloud
- 🔄 Real-time synchronization
- 🔐 Security rules
- 📱 Multi-platform support
- 💾 Automatic backup

**Setup Firebase:** Lihat file `FIREBASE_SETUP.md` untuk panduan lengkap.

## 🚀 Cara Menjalankan

### Setup Firebase (Wajib!)

1. **Setup Firebase Project**
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase
   flutterfire configure
   ```
   
   Atau ikuti panduan lengkap di `FIREBASE_SETUP.md`

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Jalankan Aplikasi**
   ```bash
   flutter run
   ```

4. **Build untuk Production**
   - Android: `flutter build apk`
   - iOS: `flutter build ios`
   - Web: `flutter build web`
   - Windows: `flutter build windows`

## 📂 Struktur Project

```
lib/
├── main.dart                      # Entry point aplikasi
├── models/                        # Data models
│   ├── user.dart                  # Model User & Role
│   ├── student.dart               # Model Siswa
│   ├── teacher.dart               # Model Guru
│   ├── schedule.dart              # Model Jadwal
│   ├── announcement.dart          # Model Pengumuman
│   └── grade.dart                 # Model Nilai
├── services/                      # Business logic
│   ├── auth_service.dart          # Service autentikasi
│   └── data_service.dart          # Service CRUD data
└── screens/                       # UI Screens
    ├── login_screen.dart          # Halaman login
    ├── admin/                     # Screens untuk Admin
    │   ├── admin_dashboard.dart
    │   ├── students_page.dart
    │   ├── teachers_page.dart
    │   ├── schedules_page.dart
    │   └── announcements_page.dart
    ├── guru/                      # Screens untuk Guru
    │   ├── guru_dashboard.dart
    │   └── grades_page.dart
    ├── siswa/                     # Screens untuk Siswa
    │   ├── siswa_dashboard.dart
    │   ├── schedule_view_page.dart
    │   └── report_page.dart
    └── shared/                    # Shared components
        └── announcements_view_page.dart
```

## 🎨 Fitur Detail

### Manajemen Data Siswa (Admin)
- Tambah siswa baru dengan NIS unik
- Edit data siswa (Nama, Kelas, Jurusan)
- Hapus data siswa dengan konfirmasi
- Pilihan kelas: X, XI, XII
- Pilihan jurusan: IPA, IPS, Bahasa

### Manajemen Data Guru (Admin)
- Tambah guru dengan NIP
- Edit informasi guru
- Hapus data guru
- Assign mata pelajaran

### Manajemen Jadwal (Admin)
- Buat jadwal per hari (Senin - Sabtu)
- Set waktu mulai dan selesai
- Assign guru pengampu
- Tentukan kelas untuk setiap jadwal

### Input Nilai (Guru)
- Input nilai per komponen (Tugas 30%, UTS 30%, UAS 40%)
- Perhitungan otomatis nilai akhir
- Predikat otomatis (A, B, C, D, E)
- Edit dan hapus nilai

### Rapor Siswa
- Tampilan tabel nilai lengkap
- Perhitungan rata-rata otomatis
- Export ke PDF dengan format rapor resmi
- Download langsung ke device

### Pengumuman
- Admin dapat membuat pengumuman baru
- Semua user dapat melihat pengumuman
- Tampilan dengan tanggal dan pembuat pengumuman

## 🔐 Keamanan

- Autentikasi role-based
- Validasi input di semua form
- Konfirmasi sebelum delete data
- Session management dengan shared_preferences

## 📊 Data Storage

Aplikasi menggunakan **Firebase Cloud Firestore** untuk penyimpanan data:

### Collections di Firestore:
- `users` - User credentials dan role
- `sessions` - Session management
- `students` - Data siswa
- `teachers` - Data guru  
- `schedules` - Jadwal pelajaran
- `announcements` - Pengumuman sekolah
- `grades` - Nilai siswa

### Keuntungan Firebase:
- ✅ Data tersimpan di cloud, accessible dari mana saja
- ✅ Real-time sync antar devices
- ✅ Backup otomatis
- ✅ Scalable untuk banyak user
- ✅ Security rules untuk proteksi data
- ✅ Free tier: 50K reads/day, 20K writes/day

## 🎯 Target Platform

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 📝 Catatan Pengembangan

- Data dummy sudah diinisialisasi otomatis saat pertama kali run
- Setup Firebase required - lihat `FIREBASE_SETUP.md`
- Untuk production, implementasikan Firebase Authentication
- PDF disimpan di direktori Documents aplikasi
- Firebase Console dapat digunakan untuk manage data secara langsung
- Security rules perlu dikonfigurasi untuk production

## 🤝 Kontribusi

Untuk pengembangan lebih lanjut:
1. Firebase Authentication integration (replace dummy login)
2. Real-time notification dengan FCM
3. Role-based security rules di Firestore
4. Absensi siswa dengan QR code
5. Pembayaran SPP integration
6. Jadwal ujian dan reminder
7. E-learning integration
8. Parent portal untuk orang tua siswa
9. Export data ke Excel/CSV
10. Dashboard analytics untuk kepala sekolah

## 📄 Lisensi

Private project untuk keperluan akademik sekolah.

---

**Dibuat dengan ❤️ menggunakan Flutter**
