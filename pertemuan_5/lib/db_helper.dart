import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'main.dart' show Catatan;

class DbHelper {
  DbHelper._();
  static final DbHelper instance = DbHelper._();

  static const String _key = 'catatan_list';
  SharedPreferences? _prefs;
  List<Catatan> _data = [];
  int _nextId = 1;

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _loadFromStorage();
    } catch (e) {
      print('Error initializing SharedPreferences: $e');
    }
  }

  void _loadFromStorage() {
    try {
      final jsonString = _prefs?.getString(_key);
      if (jsonString != null && jsonString.isNotEmpty) {
        final list = jsonDecode(jsonString) as List;
        _data = [for (final item in list) Catatan.fromMap(Map<String, Object?>.from(item as Map))];
        _nextId = _data.isEmpty ? 1 : (_data.map((c) => c.id!).reduce((a, b) => a > b ? a : b) + 1);
      }
    } catch (e) {
      print('Error loading from storage: $e');
      _data = [];
      _nextId = 1;
    }
  }

  Future<void> _saveToStorage() async {
    try {
      if (_prefs == null) return;
      final jsonString = jsonEncode([for (final c in _data) c.toMap()]);
      await _prefs!.setString(_key, jsonString);
    } catch (e) {
      print('Error saving to storage: $e');
    }
  }

  Future<int> insert(Catatan c) async {
    final newCatatan = Catatan(
      id: _nextId,
      judul: c.judul,
      isi: c.isi,
      kategori: c.kategori,
      dibuatPada: c.dibuatPada,
    );
    _data.add(newCatatan);
    _nextId++;
    await _saveToStorage();
    return newCatatan.id!;
  }

  Future<List<Catatan>> getAll() async {
    return _data.toList()..sort((a, b) => b.dibuatPada.compareTo(a.dibuatPada));
  }

  Future<int> update(Catatan c) async {
    final index = _data.indexWhere((e) => e.id == c.id);
    if (index == -1) return 0;
    _data[index] = c;
    await _saveToStorage();
    return 1;
  }

  Future<int> delete(int id) async {
    final initialLength = _data.length;
    _data.removeWhere((e) => e.id == id);
    await _saveToStorage();
    return _data.length < initialLength ? 1 : 0;
  }
}