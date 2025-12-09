# 🚀 Quick Start - SIAKAD Sekolah dengan Firebase

## Cara Tercepat Setup & Run Aplikasi

### Prerequisites
- Flutter SDK installed
- Dart SDK installed
- Firebase CLI installed
- Internet connection

### Setup Cepat (5 Menit)

#### 1. Setup Firebase Project
```bash
# Login ke Firebase
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Navigate ke project folder
cd "c:\Users\Tya Ayu Agustin\siakad_sekolah"

# Configure Firebase (pilih/buat project baru)
flutterfire configure
```

Ikuti wizard:
- Pilih atau buat project Firebase baru
- Nama project: `siakad-sekolah`
- Pilih platform: Android, iOS, Web, Windows (sesuai kebutuhan)
- File `firebase_options.dart` akan di-generate otomatis

#### 2. Enable Firestore di Firebase Console
1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Pilih project yang baru dibuat
3. Klik **Firestore Database** → **Create Database**
4. Pilih **Test Mode** (untuk development)
5. Pilih location: `asia-southeast1` atau terdekat
6. Klik **Enable**

#### 3. Install Dependencies & Run
```bash
# Install dependencies
flutter pub get

# Run aplikasi (pilih device)
flutter run

# Atau run di device tertentu:
flutter run -d windows
flutter run -d chrome
flutter run -d android
```

### 🎉 Selesai!

Aplikasi akan:
1. ✅ Initialize Firebase
2. ✅ Create collections dan dummy data otomatis
3. ✅ Siap digunakan dengan login demo

### 🔐 Login Demo

Gunakan akun berikut untuk login:

| Role | Username | Password |
|------|----------|----------|
| Admin | `admin` | `admin123` |
| Guru | `guru` | `guru123` |
| Siswa | `siswa` | `siswa123` |

### 📱 Test Aplikasi

**Admin:**
1. Login sebagai admin
2. Coba tambah siswa baru
3. Coba tambah jadwal
4. Coba buat pengumuman

**Guru:**
1. Login sebagai guru
2. Coba input nilai siswa
3. Lihat pengumuman

**Siswa:**
1. Login sebagai siswa
2. Lihat jadwal pelajaran
3. Lihat rapor/nilai
4. Export rapor ke PDF
5. Lihat pengumuman

### 🔥 Verifikasi Firebase

1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Pilih project Anda
3. Klik **Firestore Database**
4. Anda akan melihat collections baru:
   - `users`
   - `students`
   - `teachers`
   - `schedules`
   - `announcements`
   - `grades`
   - `sessions`

Data dummy sudah tersimpan di sana! 🎉

### ⚡ Tips Development

```bash
# Hot reload saat development
# Tekan 'r' di terminal atau Save file (hot reload otomatis)

# Hot restart
# Tekan 'R' di terminal

# Clear Firestore data dan restart
# 1. Hapus semua collections di Firebase Console
# 2. Hot restart aplikasi (data dummy akan dibuat ulang)
```

### 🐛 Troubleshooting

**Error: "No Firebase App"**
```bash
# Jalankan lagi flutterfire configure
flutterfire configure

# Lalu flutter pub get
flutter pub get
```

**Error: "Permission Denied"**
- Pastikan Firestore dalam **Test Mode**
- Atau update Security Rules sesuai `FIREBASE_SETUP.md`

**Data tidak muncul:**
- Cek koneksi internet
- Cek Firebase Console apakah data ada
- Restart aplikasi

### 📚 Next Steps

1. ✅ Aplikasi berjalan dengan Firebase
2. ⬜ Customize Security Rules untuk production
3. ⬜ Implement Firebase Authentication
4. ⬜ Deploy ke Play Store / App Store
5. ⬜ Add more features

### 💡 Development Tips

**Live Edit Data di Firebase Console:**
- Buka Firestore di console
- Edit data langsung
- Aplikasi akan sync otomatis

**Test Multi-User:**
- Buka aplikasi di 2 device/browser
- Login dengan user berbeda
- Edit data di satu device
- Lihat perubahan di device lain (real-time!)

---

**Selamat! Aplikasi SIAKAD Sekolah dengan Firebase sudah berjalan!** 🎊

Untuk panduan lengkap, lihat:
- `FIREBASE_SETUP.md` - Setup detail Firebase
- `README_APP.md` - Dokumentasi lengkap aplikasi
