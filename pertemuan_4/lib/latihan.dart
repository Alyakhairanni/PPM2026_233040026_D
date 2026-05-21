import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// === Langkah 2.2: Model Data ===
class Catatan {
  final String id;
  final String judul;
  final String isi;
  final String kategori;
  final DateTime dibuatPada;

  Catatan({
    required this.id,
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.dibuatPada,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
      ),
      // === Langkah 4.1 & 5.4: Navigation & Named Routes ===
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/tambah') {
          return MaterialPageRoute(
            builder: (_) => const TambahCatatanPage(),
          );
        } else if (settings.name == '/detail') {
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

// === Langkah 2.2: HomePage sebagai StatefulWidget ===
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // === STATE ===
  final List<Catatan> _catatan = [
    Catatan(
      id: '1',
      judul: 'Belajar Flutter',
      isi: 'Mempelajari Stateful Widget, Form, dan Navigation.',
      kategori: 'Kuliah',
      dibuatPada: DateTime.now(),
    ),
  ];

  // === Langkah 5.3: Navigasi & Tangkap Data Balik ===
  Future<void> _bukaTambahCatatan() async {
    final hasil = await Navigator.pushNamed(context, '/tambah');

    if (hasil is Catatan) {
      setState(() {
        _catatan.add(hasil);
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Catatan "${hasil.judul}" ditambahkan')),
      );
    }
  }

  // === Langkah 6.1: Fitur Hapus ===
  void _hapusCatatan(String id) {
    setState(() {
      _catatan.removeWhere((c) => c.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Catatan telah dihapus')),
    );
  }

  // === Langkah 6.1: Helper Format Tanggal ===
  String _formatTanggal(DateTime dt) {
    return "${dt.day}/${dt.month}/${dt.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catatan Mahasiswa')),
      body: _catatan.isEmpty
          ? _buildEmptyState() // Langkah 6.1: Empty State
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _catatan.length,
              itemBuilder: (context, i) {
                final c = _catatan[i];
                return Card(
                  child: ListTile(
                    title: Text(c.judul, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${c.kategori} • ${_formatTanggal(c.dibuatPada)}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _hapusCatatan(c.id),
                    ),
                    onTap: () {
                      // Langkah 5.3: Navigasi ke Detail dengan Arguments
                      Navigator.pushNamed(context, '/detail', arguments: c);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _bukaTambahCatatan,
        tooltip: 'Tambah Catatan',
        child: const Icon(Icons.add),
      ),
    );
  }

  // Widget helper untuk Empty State
  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notes, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Belum ada catatan.\nSilakan tambah catatan baru!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

// === Langkah 3: Form & Validasi (TambahCatatanPage) ===
class TambahCatatanPage extends StatefulWidget {
  const TambahCatatanPage({super.key});

  @override
  State<TambahCatatanPage> createState() => _TambahCatatanPageState();
}

class _TambahCatatanPageState extends State<TambahCatatanPage> {
  final _formKey = GlobalKey<FormState>(); // Langkah 3.1: GlobalKey
  final _judulCtrl = TextEditingController(); // Langkah 3.1: Controller
  final _isiCtrl = TextEditingController();

  String _kategori = 'Kuliah';
  final _kategoriOpsi = const ['Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  @override
  void dispose() {
    // Langkah 3.2: Bebaskan resource controller
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    super.dispose();
  }

  // === Langkah 5.2: Kirim Data Balik via Navigator.pop ===
  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final catatanBaru = Catatan(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      judul: _judulCtrl.text.trim(),
      isi: _isiCtrl.text.trim(),
      kategori: _kategori,
      dibuatPada: DateTime.now(),
    );

    Navigator.pop(context, catatanBaru);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Catatan')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Field Judul
            TextFormField(
              controller: _judulCtrl,
              decoration: const InputDecoration(
                labelText: 'Judul',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Judul wajib diisi';
                if (v.trim().length < 3) return 'Minimal 3 karakter';
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Field Kategori (Dropdown)
            DropdownButtonFormField<String>(
              value: _kategori,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: _kategoriOpsi
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) => setState(() => _kategori = v!),
            ),
            const SizedBox(height: 16),
            // Field Isi
            TextFormField(
              controller: _isiCtrl,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Isi',
                prefixIcon: Icon(Icons.notes),
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Isi wajib diisi' : null,
            ),
            const SizedBox(height: 24),
            // Tombol Simpan
            SizedBox(
              height: 50,
              child: FilledButton.icon(
                onPressed: _simpan,
                icon: const Icon(Icons.save),
                label: const Text('Simpan Catatan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// === Langkah 5.1: DetailCatatanPage (StatelessWidget) ===
class DetailCatatanPage extends StatelessWidget {
  final Catatan catatan;
  const DetailCatatanPage({super.key, required this.catatan});

  String _formatTanggal(DateTime dt) {
    return "${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Catatan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              catatan.judul,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Chip(
                  label: Text(catatan.kategori),
                  backgroundColor: Colors.indigo.withOpacity(0.1),
                  labelStyle: const TextStyle(color: Colors.indigo),
                ),
                const SizedBox(width: 12),
                Text(
                  _formatTanggal(catatan.dibuatPada),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const Divider(height: 48),
            Text(
              catatan.isi,
              style: const TextStyle(fontSize: 18, height: 1.6),
            ),
            const SizedBox(height: 48),
            Center(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali ke Daftar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
