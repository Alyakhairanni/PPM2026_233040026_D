class Catatan {
  final int? id;
  final String judul;
  final String isi;
  final String kategori;
  final DateTime dibuatPada;

  Catatan({
    this.id,
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.dibuatPada,
  });

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'judul': judul,
    'isi': isi,
    'kategori': kategori,
    'dibuat_pada': dibuatPada.toUtc().toIso8601String(),
  };

  factory Catatan.fromJson(Map<String, dynamic> m) {
    return Catatan(
      id: m['id'],
      judul: m['judul'],
      isi: m['isi'],
      kategori: m['kategori'],
      dibuatPada: DateTime.parse(m['dibuat_pada']),
    );
  }

  Catatan copyWith({
    String? judul,
    String? isi,
    String? kategori,
  }) {
    return Catatan(
      id: id,
      judul: judul ?? this.judul,
      isi: isi ?? this.isi,
      kategori: kategori ?? this.kategori,
      dibuatPada: dibuatPada,
    );
  }
}