import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class QuizPertemuan3 extends StatefulWidget {
  final String currentTitle;
  final String currentDesc;
  final Uint8List? currentImgBytes;

  const QuizPertemuan3({
    super.key,
    required this.currentTitle,
    required this.currentDesc,
    required this.currentImgBytes,
  });

  @override
  State<QuizPertemuan3> createState() => _QuizPertemuan3State();
}

class _QuizPertemuan3State extends State<QuizPertemuan3> {
  late TextEditingController titleController;
  late TextEditingController descController;
  Uint8List? _expImageBytes;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.currentTitle);
    descController = TextEditingController(text: widget.currentDesc);
    _expImageBytes = widget.currentImgBytes;
  }

  Future<void> _pickExpImage() async {
    final XFile? selected = await _picker.pickImage(source: ImageSource.gallery);
    if (selected != null) {
      var bytes = await selected.readAsBytes();
      setState(() {
        _expImageBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Pengalaman')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Nama Perusahaan/Organisasi', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: descController, maxLines: 3, decoration: const InputDecoration(labelText: 'Deskripsi Jobdesk', border: OutlineInputBorder())),
            const SizedBox(height: 15),

            GestureDetector(
              onTap: _pickExpImage,
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[100]
                ),
                child: _expImageBytes != null
                    ? Image.memory(_expImageBytes!, fit: BoxFit.cover)
                    : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                    Text('Klik untuk unggah foto bukti kegiatan')
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: const Color(0xFF1A237E),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context, {
                  'title': titleController.text,
                  'desc': descController.text,
                  'imageBytes': _expImageBytes,
                });
              },
              child: const Text('Simpan Pengalaman'),
            )
          ],
        ),
      ),
    );
  }
}