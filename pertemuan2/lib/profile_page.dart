import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  final String currentName;
  final String currentBio;
  final String currentPendidikan;
  final String currentLokasi;
  final String currentEmail;
  final Uint8List? currentImgBytes;

  const ProfilePage({
    super.key,
    required this.currentName,
    required this.currentBio,
    required this.currentPendidikan,
    required this.currentLokasi,
    required this.currentEmail,
    required this.currentImgBytes,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController nameController;
  late TextEditingController bioController;
  late TextEditingController pendidikanController;
  late TextEditingController lokasiController;
  late TextEditingController emailController;

  Uint8List? _webImageBytes;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentName);
    bioController = TextEditingController(text: widget.currentBio);
    pendidikanController =
        TextEditingController(text: widget.currentPendidikan);
    lokasiController = TextEditingController(text: widget.currentLokasi);
    emailController = TextEditingController(text: widget.currentEmail);
    _webImageBytes = widget.currentImgBytes;
  }

  // Fungsi pick image yang aman untuk Google Chrome (Web)
  Future<void> _pickImage() async {
    final XFile? selectedImage = await _picker.pickImage(
        source: ImageSource.gallery);
    if (selectedImage != null) {
      var f = await selectedImage.readAsBytes();
      setState(() {
        _webImageBytes = f;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Form Pembaruan Profil',
              style: TextStyle(fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E)),
            ),
            const SizedBox(height: 20),

            // Pilih Foto Profil (Support Web/Chrome)
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.grey[300],
                backgroundImage: _webImageBytes != null
                    ? MemoryImage(_webImageBytes!)
                    : const NetworkImage(
                    'https://picsum.photos/200') as ImageProvider,
                child: _webImageBytes == null
                    ? const Icon(
                    Icons.camera_alt, size: 30, color: Colors.white)
                    : null,
              ),
            ),
            TextButton(
                onPressed: _pickImage, child: const Text('Ubah Foto Profil')),

            const SizedBox(height: 20),
            TextField(controller: nameController,
                decoration: const InputDecoration(
                    labelText: 'Nama Lengkap', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: bioController,
                decoration: const InputDecoration(
                    labelText: 'Tentang / Bio', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: pendidikanController,
                decoration: const InputDecoration(
                    labelText: 'Pendidikan', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: lokasiController,
                decoration: const InputDecoration(
                    labelText: 'Lokasi', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: emailController,
                decoration: const InputDecoration(
                    labelText: 'Email', border: OutlineInputBorder())),

            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: const Color(0xFF1A237E),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context, {
                  'name': nameController.text,
                  'bio': bioController.text,
                  'pendidikan': pendidikanController.text,
                  'lokasi': lokasiController.text,
                  'email': emailController.text,
                  'imageBytes': _webImageBytes,
                });
              },
              child: const Text('Simpan Perubahan'),
            )
          ],
        ),
      ),
    );
  }
}