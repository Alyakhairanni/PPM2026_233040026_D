import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'catatan.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() {
    return message;
  }
}

class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  static const String _baseUrl =
      'https://besab-production.up.railway.app/api';

  static const String _apiKey =
      '8f38b5fbf0bc437285f2c62ed6e447eab56f78c8f95239a7';

  static const Duration _timeout = Duration(seconds: 10);

  Map<String, String> get _headers => {
    'X-API-Key': _apiKey,
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<List<Catatan>> getAll() async {
    final res = await _send(() => http.get(
      Uri.parse('$_baseUrl/catatan'),
      headers: _headers,
    ));

    final body = jsonDecode(res.body);

    return (body['data'] as List)
        .map((e) => Catatan.fromJson(e))
        .toList();
  }

  Future<Catatan> insert(Catatan c) async {
    final res = await _send(() => http.post(
      Uri.parse('$_baseUrl/catatan'),
      headers: _headers,
      body: jsonEncode(c.toJson()),
    ));

    final body = jsonDecode(res.body);

    return Catatan.fromJson(body['data']);
  }

  Future<void> delete(int id) async {
    await _send(() => http.delete(
      Uri.parse('$_baseUrl/catatan/$id'),
      headers: _headers,
    ));
  }

  Future<http.Response> _send(
      Future<http.Response> Function() request) async {
    try {
      final response = await request().timeout(_timeout);

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        return response;
      }

      throw ApiException(
        response.statusCode,
        'HTTP ${response.statusCode}',
      );
    } on SocketException {
      throw ApiException(0, 'Tidak ada koneksi internet');
    } on TimeoutException {
      throw ApiException(0, 'Request timeout');
    }
  }
}