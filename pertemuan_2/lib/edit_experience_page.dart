import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ============================================================
//  MODEL DATA PENGALAMAN
// ============================================================
class ExperienceData {
  final String judul;
  final String deskripsi;
  final Uint8List? gambarBytes;

  const ExperienceData({
    required this.judul,
    required this.deskripsi,
    this.gambarBytes,
  });
}

// ============================================================
//  HALAMAN UPLOAD / EDIT PENGALAMAN
// ============================================================
class EditExperiencePage extends StatefulWidget {
  const EditExperiencePage({
    super.key,
    this.existingData,
  });

  final ExperienceData? existingData;

  @override
  State<EditExperiencePage> createState() => _EditExperiencePageState();
}

class _EditExperiencePageState extends State<EditExperiencePage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _judulController;
  late TextEditingController _deskripsiController;

  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(
      text: widget.existingData?.judul ?? '',
    );
    _deskripsiController = TextEditingController(
      text: widget.existingData?.deskripsi ?? '',
    );
    _imageBytes = widget.existingData?.gambarBytes;
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
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

  void _simpan() {
    if (_formKey.currentState!.validate()) {
      final result = ExperienceData(
        judul: _judulController.text.trim(),
        deskripsi: _deskripsiController.text.trim(),
        gambarBytes: _imageBytes,
      );
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingData == null ? 'Upload Pengalaman' : 'Edit Pengalaman'),
        actions: [
          TextButton.icon(
            onPressed: _simpan,
            icon: const Icon(Icons.save, color: Colors.white),
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
              // === GAMBAR PENGALAMAN ===
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEEFF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                    image: _imageBytes != null
                        ? DecorationImage(
                      image: MemoryImage(_imageBytes!),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: _imageBytes == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_outlined,
                          size: 48, color: Colors.blue.shade300),
                      const SizedBox(height: 8),
                      Text(
                        'Ketuk untuk pilih gambar',
                        style: TextStyle(
                          color: Colors.blue.shade400,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'dari galeri perangkat kamu',
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 12),
                      ),
                    ],
                  )
                      : null,
                ),
              ),

              const SizedBox(height: 24),

              // === INFO PENGALAMAN ===
              const Text(
                'Informasi Pengalaman',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(
                  labelText: 'Judul *',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Judul tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _deskripsiController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  alignLabelWithHint: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 60),
                    child: Icon(Icons.description_outlined),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _simpan,
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    'Simpan Pengalaman',
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