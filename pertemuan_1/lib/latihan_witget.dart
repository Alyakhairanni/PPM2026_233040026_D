import 'package:flutter/material.dart';

class LatihanWidget extends StatelessWidget {
  const LatihanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Latihan Icon')),
      body: const Center(
        child: Text(
          'Lihat ikon-ikon di bawah 👇',
          // mainAxisAlignment: MainAxisAlignment.center,
          // children: [
          //=== Text Widget
          // const Text(
          //   'Hello Flutter!',
          //   style: TextStyle(
          //     fontSize: 40,
          //     fontWeight: FontWeight.w900,
          //     color: Color(0xFF2196F3),
          //   ),
          // ),
          // const SizedBox(height: 8),
          // const Text(
          //   'Ini teks biasa dengan ukuran kecil',
          //   style: TextStyle(fontSize: 40, color: Colors.purple),
          // ),
          // const SizedBox(height: 16),

          //=== Blue Box
          // Container(
          //   width: 300,
          //   height: 100,
          //   padding: const EdgeInsets.all(20),
          //   decoration: BoxDecoration(
          //     color: Colors.blue,
          //     borderRadius: BorderRadius.circular(100),
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.blue.withValues(alpha: 0.3),
          //         blurRadius: 50,
          //         offset: const Offset(0, 10),
          //       ),
          //     ],
          //     border: Border.all(color: Colors.black, width: 4),
          //   ),
          //   child: const Center(
          //     child: Text(
          //       'Box',
          //       style: TextStyle(color: Colors.white, fontSize: 24),
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 16),

          // === Row dan Column ===
          // const Text('Baris di bawah ini menggunakan Row:'),
          // const SizedBox(height: 16),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     _Kotak(color: Colors.red),
          //     _Kotak(color: Colors.green),
          //     _Kotak(color: Colors.blue),
          //   ],
          // ),
          // const SizedBox(height: 16),
          // const Text('Column = vertikal ↕'),
          // const Text('Row = horizontal ↔'),

          //=== icon dan Buttom bar

          //],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: Colors.grey.shade100,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.home, size: 32, color: Colors.red),
            Icon(Icons.receipt_long, size: 24, color: Colors.green),
            Icon(Icons.leaderboard, size: 48, color: Colors.purple),
            Icon(Icons.settings, size: 64, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

// class _Kotak extends StatelessWidget {
//   final Color color;
//   const _Kotak({required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Container(width: 60, height: 60, color: color);
//   }
// }