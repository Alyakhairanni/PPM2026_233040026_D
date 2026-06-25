import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    super.key,
    required this.profileData,
  });

  final ProfileData profileData;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _namaController;
  late TextEditingController _tentangController;
  late TextEditingController _pendidikanController;
  late TextEditingController _kontakController;
  late TextEditingController _skillsController;

  Uint8List? _imageBytes; // pakai bytes, support Web & Android

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.profileData.nama);
    _tentangController = TextEditingController(text: widget.profileData.tentang);
    _pendidikanController = TextEditingController(text: widget.profileData.pendidikan);
    _kontakController = TextEditingController(text: widget.profileData.kontak);
    _skillsController = TextEditingController(
      text: widget.profileData.skills.join(', '),
    );
    _imageBytes = widget.profileData.fotoBytes;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _tentangController.dispose();
    _pendidikanController.dispose();
    _kontakController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _imageBytes = bytes;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  void _simpanPerubahan() {
    if (_formKey.currentState!.validate()) {
      final List<String> skillsList = _skillsController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      final updated = ProfileData(
        nama: _namaController.text.trim(),
        tentang: _tentangController.text.trim(),
        pendidikan: _pendidikanController.text.trim(),
        kontak: _kontakController.text.trim(),
        skills: skillsList,
        fotoBytes: _imageBytes,
      );

      Navigator.pop(context, updated);
    }
  }

  ImageProvider _getImageProvider() {
    if (_imageBytes != null) {
      return MemoryImage(_imageBytes!);
    }
    return const AssetImage('lib/assets/images/foto.jpg');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        actions: [
          TextButton.icon(
            onPressed: _simpanPerubahan,
            icon: const Icon(Icons.check, color: Colors.white),
            label: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === FOTO PROFIL ===
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Foto Profil',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: _getImageProvider(),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.photo_library, size: 16),
                      label: const Text('Ganti Foto dari Galeri'),
                    ),
                  ],
                ),
              ),

              const Divider(height: 32),

              // === INFORMASI PROFIL ===
              const Text(
                'Informasi Profil',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap *',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _tentangController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Bio / Tentang',
                  alignLabelWithHint: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Icon(Icons.info_outline),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _pendidikanController,
                decoration: const InputDecoration(
                  labelText: 'Pendidikan',
                  prefixIcon: Icon(Icons.school_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _kontakController,
                decoration: const InputDecoration(
                  labelText: 'Kontak (Email / No. HP)',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _skillsController,
                decoration: const InputDecoration(
                  labelText: 'Skills (pisahkan dengan koma)',
                  prefixIcon: Icon(Icons.star_outline),
                  border: OutlineInputBorder(),
                  hintText: 'Flutter, Dart, Firebase',
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _simpanPerubahan,
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    'Simpan Perubahan',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5C6BC0),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// Model data profil — pakai Uint8List supaya support Web & Android
class ProfileData {
  final String nama;
  final String tentang;
  final String pendidikan;
  final String kontak;
  final List<String> skills;
  final Uint8List? fotoBytes;

  const ProfileData({
    required this.nama,
    required this.tentang,
    required this.pendidikan,
    required this.kontak,
    required this.skills,
    this.fotoBytes,
  });
}