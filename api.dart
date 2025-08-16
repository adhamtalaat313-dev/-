import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = 'http://10.0.2.2:4000/api'; // Android emulator -> host

Future<String?> _token() async {
  final sp = await SharedPreferences.getInstance();
  return sp.getString('token');
}

Future<http.Response> _authPost(String path, Map body) async {
  final t = await _token();
  return http.post(Uri.parse('$baseUrl$path'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ${t ?? ''}'},
      body: jsonEncode(body));
}

Future<http.Response> _authGet(String path) async {
  final t = await _token();
  return http.get(Uri.parse('$baseUrl$path'),
      headers: {'Authorization': 'Bearer ${t ?? ''}'});
}

Future<Map?> login(String email, String password) async {
  final r = await http.post(Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}));
  if (r.statusCode == 200) return jsonDecode(r.body);
  return null;
}

Future<List> searchListings({String q = ''}) async {
  final r = await http.get(Uri.parse('$baseUrl/listings?q=$q'));
  if (r.statusCode == 200) return jsonDecode(r.body);
  return [];
}

Future<Map?> createListing(Map body) async {
  final r = await _authPost('/listings', body);
  if (r.statusCode == 200) return jsonDecode(r.body);
  return null;
}
