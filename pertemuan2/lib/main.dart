import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'galery_widget.dart';
import 'quiz_pertemuan_3.dart'; // Digunakan untuk Halaman Upload Pengalaman

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz PPM Alya',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // DATA BAWAAN SESUAI REQUEST KAMU
  String name = 'Alya Khairani';
  String bio = 'Mahasiswa Teknik Informatika yang antusias belajar Mobile Development.';
  String pendidikan = 'Universitas Pasundan';
  String lokasi = 'Bandung, Jawa Barat';
  String email = 'alyakhairani0401@gmail.com';
  Uint8List? imgBytes;

  // State Data Pengalaman (Bonus)
  String expTitle = 'analys';
  String expDesc = 'Tambahkan melalui menu Upload Pengalaman di samping.';
  Uint8List? expImgBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Mahasiswa'),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      // DRAWER NAVIGASI UNTUK HALAMAN BONUS
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF1A237E)),
              accountName: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: Text(email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: imgBytes != null
                    ? MemoryImage(imgBytes!)
                    : const NetworkImage('https://picsum.photos/200') as ImageProvider,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil Utama'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.collections),
              title: const Text('Widget Gallery'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const GaleryWidget()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.work_history),
              title: const Text('Upload Pengalaman'),
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizPertemuan3(
                      currentTitle: expTitle,
                      currentDesc: expDesc,
                      currentImgBytes: expImgBytes,
                    ),
                  ),
                );
                if (result != null) {
                  setState(() {
                    expTitle = result['title'];
                    expDesc = result['desc'];
                    expImgBytes = result['imageBytes'];
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Halaman Pengaturan Berhasil Diakses!')),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[300],
              backgroundImage: imgBytes != null
                  ? MemoryImage(imgBytes!)
                  : const NetworkImage('https://picsum.photos/200') as ImageProvider,
            ),
            const SizedBox(height: 15),
            Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(bio, textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.grey[600], fontStyle: FontStyle.italic)),
            const Divider(height: 40),

            // Tampilan Informasi Utama (3 Section Terbuka)
            _infoCard(Icons.school, 'Pendidikan', pendidikan),
            _infoCard(Icons.location_on, 'Lokasi', lokasi),
            _infoCard(Icons.email, 'Email Kontak', email),

            const SizedBox(height: 20),

            // Preview Pengalaman Kerja/Organisasi Yang Diupdate
            Card(
              color: Colors.blue[50],
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: expImgBytes != null
                      ? Image.memory(expImgBytes!, width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.business, size: 40, color: Color(0xFF1A237E)),
                ),
                title: Text(expTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(expDesc),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(
                currentName: name,
                currentBio: bio,
                currentPendidikan: pendidikan,
                currentLokasi: lokasi,
                currentEmail: email,
                currentImgBytes: imgBytes,
              ),
            ),
          );

          if (result != null) {
            setState(() {
              name = result['name'];
              bio = result['bio'];
              pendidikan = result['pendidikan'];
              lokasi = result['lokasi'];
              email = result['email'];
              imgBytes = result['imageBytes'];
            });
          }
        },
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit),
        label: const Text('Edit Profil'),
      ),
    );
  }

  Widget _infoCard(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF1A237E)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16, color: Colors.black87)),
      ),
    );
  }
}