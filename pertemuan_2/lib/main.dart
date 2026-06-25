import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'widget_gallery.dart';
import 'edit_profile_page.dart';
import 'edit_experience_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
      _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      themeMode: _themeMode,
      home: ProfilePage(
        toggleTheme: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

// ============================================================
//  PROFILE PAGE
// ============================================================
class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  final VoidCallback toggleTheme;
  final bool isDarkMode;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileData _profileData = const ProfileData(
    nama: 'Raden Indra Prawirajaya',
    tentang:
    'Saya suka belajar hal baru, terutama yang berkaitan dengan teknologi dan pengembangan Game.',
    pendidikan: 'Universitas Pasundan — Semester 5\nIPK: 3.81',
    kontak: 'radenprawirajaya@gmail.com\n+62 8956-1955-1584',
    skills: ['Flutter', 'Dart', 'Firebase', 'Figma', 'Git'],
  );

  // List pengalaman
  final List<ExperienceData> _experiences = [];

  Future<void> _bukaEditProfil() async {
    final result = await Navigator.push<ProfileData>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(profileData: _profileData),
      ),
    );
    if (result != null) {
      setState(() {
        _profileData = result;
      });
    }
  }

  Future<void> _bukaUploadPengalaman() async {
    final result = await Navigator.push<ExperienceData>(
      context,
      MaterialPageRoute(
        builder: (_) => const EditExperiencePage(),
      ),
    );
    if (result != null) {
      setState(() {
        _experiences.add(result);
      });
    }
  }

  Future<void> _bukaEditPengalaman(int index) async {
    final result = await Navigator.push<ExperienceData>(
      context,
      MaterialPageRoute(
        builder: (_) => EditExperiencePage(existingData: _experiences[index]),
      ),
    );
    if (result != null) {
      setState(() {
        _experiences[index] = result;
      });
    }
  }

  void _hapusPengalaman(int index) {
    setState(() {
      _experiences.removeAt(index);
    });
  }

  ImageProvider _getFotoProvider() {
    if (_profileData.fotoBytes != null) {
      return MemoryImage(_profileData.fotoBytes!);
    }
    return const AssetImage('lib/assets/images/foto.jpg');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.collections),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WidgetGallery()),
              );
            },
          ),
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            const ListTile(leading: Icon(Icons.home), title: Text('Beranda')),
            const ListTile(leading: Icon(Icons.person), title: Text('Profil')),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profil'),
              onTap: () {
                Navigator.pop(context);
                _bukaEditProfil();
              },
            ),
            // === NAVIGASI EDIT PENGALAMAN ===
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('Upload Pengalaman'),
              onTap: () {
                Navigator.pop(context);
                _bukaUploadPengalaman();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Pengaturan'),
                    content: const Text('Menu pengaturan belum tersedia.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Tutup'),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.widgets),
              title: const Text('Widget Gallery'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WidgetGallery()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // === HEADER PROFIL ===
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _getFotoProvider(),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _profileData.nama,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Mahasiswa Teknik Informatika',
                    style:
                    TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(child: _StatBox(label: 'Post', value: '10')),
                Expanded(child: _StatBox(label: 'Teman', value: '1k')),
                Expanded(child: _StatBox(label: 'Like', value: '1.2K')),
              ],
            ),

            const SizedBox(height: 24),

            _SectionCard(
              icon: Icons.info_outline,
              title: 'Tentang Saya',
              content: _profileData.tentang,
            ),
            _SectionCard(
              icon: Icons.school,
              title: 'Pendidikan',
              content: _profileData.pendidikan,
            ),
            _SectionCard(
              icon: Icons.favorite,
              title: 'Hobi & Minat',
              content: 'Coding • Membaca • Menggambar • Game',
            ),
            _SectionCard(
              icon: Icons.email,
              title: 'Kontak',
              content: _profileData.kontak,
            ),

            // === SKILLS CARD ===
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Skills',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: _profileData.skills
                          .map((s) => Chip(label: Text(s)))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),

            // === PENGALAMAN CARD ===
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.cases_outlined,
                                color: Colors.blue, size: 22),
                            const SizedBox(width: 8),
                            const Text(
                              'Pengalaman',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            if (_experiences.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${_experiences.length}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ],
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline,
                              color: Colors.blue),
                          tooltip: 'Tambah Pengalaman',
                          onPressed: _bukaUploadPengalaman,
                        ),
                      ],
                    ),

                    if (_experiences.isEmpty) ...[
                      const SizedBox(height: 16),
                      Center(
                        child: Column(
                          children: [
                            Icon(Icons.work_outline,
                                size: 48, color: Colors.grey.shade400),
                            const SizedBox(height: 8),
                            Text(
                              'Belum ada pengalaman.\nTekan + untuk menambahkan.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ] else ...[
                      const Divider(),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _experiences.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final exp = _experiences[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: exp.gambarBytes != null
                                  ? Image.memory(
                                exp.gambarBytes!,
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                              )
                                  : Container(
                                width: 56,
                                height: 56,
                                color: Colors.blue.shade100,
                                child: const Icon(Icons.image,
                                    color: Colors.blue),
                              ),
                            ),
                            title: Text(
                              exp.judul,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              exp.deskripsi,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _bukaEditPengalaman(index);
                                } else if (value == 'hapus') {
                                  _hapusPengalaman(index);
                                }
                              },
                              itemBuilder: (_) => const [
                                PopupMenuItem(
                                    value: 'edit', child: Text('Edit')),
                                PopupMenuItem(
                                    value: 'hapus', child: Text('Hapus')),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _bukaEditProfil,
        icon: const Icon(Icons.edit),
        label: const Text('Edit Profil'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 3,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Beranda'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
          NavigationDestination(icon: Icon(Icons.message), label: 'Pesan'),
          NavigationDestination(icon: Icon(Icons.info), label: 'Tentang'),
        ],
      ),
    );
  }
}

// ============================================================
//  HELPER WIDGETS
// ============================================================
class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style:
            const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  const _SectionCard(
      {required this.icon, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.blue, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(content, style: const TextStyle(height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}