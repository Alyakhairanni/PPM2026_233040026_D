import 'package:flutter/material.dart';
import 'api_client.dart';
import 'catatan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catatan REST API',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Catatan>> futureCatatan;

  @override
  void initState() {
    super.initState();
    futureCatatan = ApiClient.instance.getAll();
  }

  void refreshData() {
    setState(() {
      futureCatatan = ApiClient.instance.getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Catatan"),
      ),
      body: FutureBuilder<List<Catatan>>(
        future: futureCatatan,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final data = snapshot.data ?? [];

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final c = data[index];

              return ListTile(
                title: Text(c.judul),
                subtitle: Text(c.kategori),
              );
            },
          );
        },
      ),
    );
  }
}