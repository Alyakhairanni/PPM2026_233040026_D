import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ================= MODEL =================
class Catatan {
  final String id;
  final String judul;
  final String isi;
  final String kategori;
  final String email;
  final DateTime dibuatPada;

  Catatan({
    required this.id,
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.email,
    required this.dibuatPada,
  });

  // helper untuk edit/update data
  Catatan copyWith({
    String? judul,
    String? isi,
    String? kategori,
    String? email,
  }) {
    return Catatan(
      id: id,
      judul: judul ?? this.judul,
      isi: isi ?? this.isi,
      kategori: kategori ?? this.kategori,
      email: email ?? this.email,
      dibuatPada: dibuatPada,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catatan Mahasiswa',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/tambah') {
          final catatan = settings.arguments as Catatan?;

          return MaterialPageRoute(
            builder: (_) => TambahCatatanPage(catatan: catatan),
          );
        }

        if (settings.name == '/detail') {
          final catatan = settings.arguments as Catatan;

          return MaterialPageRoute(
            builder: (_) => DetailCatatanPage(catatan: catatan),
          );
        }

        return null;
      },
    );
  }
}

// ================= HOME PAGE =================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Catatan> _catatan = [
    Catatan(
      id: '1',
      judul: 'Belajar Flutter',
      isi: 'Mempelajari Stateful Widget dan Navigation.',
      kategori: 'Kuliah',
      email: 'alya@gmail.com',
      dibuatPada: DateTime.now(),
    ),
  ];

  // FILTER
  String _filterKategori = 'Semua';

  final List<String> _kategoriFilter = const [
    'Semua',
    'Kuliah',
    'Tugas',
    'Pribadi',
    'Lainnya',
  ];

  List<Catatan> get _catatanFiltered {
    if (_filterKategori == 'Semua') {
      return _catatan;
    }

    return _catatan
        .where((c) => c.kategori == _filterKategori)
        .toList();
  }

  // TAMBAH
  Future<void> _bukaTambahCatatan() async {
    final hasil = await Navigator.pushNamed(context, '/tambah');

    if (hasil is Catatan) {
      setState(() {
        _catatan.add(hasil);
      });
    }
  }

  // EDIT
  Future<void> _editCatatan(Catatan catatan) async {
    final hasil = await Navigator.pushNamed(
      context,
      '/tambah',
      arguments: catatan,
    );

    if (hasil is Catatan) {
      setState(() {
        final index = _catatan.indexWhere((c) => c.id == hasil.id);

        if (index != -1) {
          _catatan[index] = hasil;
        }
      });
    }
  }

  // HAPUS
  void _hapusCatatan(String id) {
    setState(() {
      _catatan.removeWhere((c) => c.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Catatan dihapus'),
      ),
    );
  }

  String _formatTanggal(DateTime dt) {
    return "${dt.day}/${dt.month}/${dt.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Mahasiswa'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: DropdownButton<String>(
              value: _filterKategori,
              underline: const SizedBox(),
              items: _kategoriFilter.map((kategori) {
                return DropdownMenuItem(
                  value: kategori,
                  child: Text(kategori),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _filterKategori = value!;
                });
              },
            ),
          ),
        ],
      ),
      body: _catatanFiltered.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _catatanFiltered.length,
        itemBuilder: (context, i) {
          final c = _catatanFiltered[i];

          return Card(
            child: ListTile(
              title: Text(
                c.judul,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "${c.kategori} • ${_formatTanggal(c.dibuatPada)}",
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () => _hapusCatatan(c.id),
              ),
              onTap: () async {
                final hasil = await Navigator.pushNamed(
                  context,
                  '/detail',
                  arguments: c,
                );

                if (hasil == 'edit') {
                  _editCatatan(c);
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _bukaTambahCatatan,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notes, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Belum ada catatan',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

// ================= TAMBAH / EDIT =================
class TambahCatatanPage extends StatefulWidget {
  final Catatan? catatan;

  const TambahCatatanPage({
    super.key,
    this.catatan,
  });

  @override
  State<TambahCatatanPage> createState() => _TambahCatatanPageState();
}

class _TambahCatatanPageState extends State<TambahCatatanPage> {
  final _formKey = GlobalKey<FormState>();

  final _judulCtrl = TextEditingController();
  final _isiCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  String _kategori = 'Kuliah';

  final _kategoriOpsi = const [
    'Kuliah',
    'Tugas',
    'Pribadi',
    'Lainnya',
  ];

  bool get isEdit => widget.catatan != null;

  @override
  void initState() {
    super.initState();

    // isi data lama saat edit
    if (isEdit) {
      final c = widget.catatan!;

      _judulCtrl.text = c.judul;
      _isiCtrl.text = c.isi;
      _emailCtrl.text = c.email;
      _kategori = c.kategori;
    }
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final data = Catatan(
      id: isEdit
          ? widget.catatan!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      judul: _judulCtrl.text.trim(),
      isi: _isiCtrl.text.trim(),
      kategori: _kategori,
      email: _emailCtrl.text.trim(),
      dibuatPada:
      isEdit ? widget.catatan!.dibuatPada : DateTime.now(),
    );

    Navigator.pop(context, data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Catatan' : 'Tambah Catatan',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // JUDUL
            TextFormField(
              controller: _judulCtrl,
              decoration: const InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Judul wajib diisi';
                }

                if (v.trim().length < 3) {
                  return 'Minimal 3 karakter';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            // EMAIL
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email Pengirim',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Email wajib diisi';
                }

                final emailRegex = RegExp(
                  r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$',
                );

                if (!emailRegex.hasMatch(v.trim())) {
                  return 'Format email tidak valid';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            // KATEGORI
            DropdownButtonFormField<String>(
              value: _kategori,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: _kategoriOpsi.map((k) {
                return DropdownMenuItem(
                  value: k,
                  child: Text(k),
                );
              }).toList(),
              onChanged: (v) {
                setState(() {
                  _kategori = v!;
                });
              },
            ),

            const SizedBox(height: 16),

            // ISI
            TextFormField(
              controller: _isiCtrl,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Isi',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.notes),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Isi wajib diisi';
                }

                return null;
              },
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 50,
              child: FilledButton.icon(
                onPressed: _simpan,
                icon: const Icon(Icons.save),
                label: Text(
                  isEdit
                      ? 'Update Catatan'
                      : 'Simpan Catatan',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= DETAIL =================
class DetailCatatanPage extends StatelessWidget {
  final Catatan catatan;

  const DetailCatatanPage({
    super.key,
    required this.catatan,
  });

  String _formatTanggal(DateTime dt) {
    return "${dt.day}/${dt.month}/${dt.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pop(context, 'edit');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              catatan.judul,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),

            const SizedBox(height: 12),

            Chip(
              label: Text(catatan.kategori),
            ),

            const SizedBox(height: 8),

            Text(
              "Email: ${catatan.email}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 8),

            Text(
              _formatTanggal(catatan.dibuatPada),
              style: const TextStyle(color: Colors.grey),
            ),

            const Divider(height: 32),

            Text(
              catatan.isi,
              style: const TextStyle(
                fontSize: 18,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}