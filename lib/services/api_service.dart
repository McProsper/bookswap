import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'dart:io';

class ApiService {
  static const String baseUrl =
      'https://bookswap-api-xleo.onrender.com';
      // 'http://10.0.2.2:5000';
      // 'http://192.168.42.112:5000';

  final cloudinary = CloudinaryPublic('dyi3jthr0', 'bookswap_unsigned', cache: false);

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Nouvelle méthode pour uploader une image vers Cloudinary
  Future<String?> uploadImage(File image) async {
    try {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(image.path, resourceType: CloudinaryResourceType.Image),
      );
      return response.secureUrl;
    } catch (e) {
      print('Erreur lors de l’upload sur Cloudinary: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveToken(data['token']);
      return data;
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Échec de la connexion');
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
    required String level,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'address': address,
        'level': level,
      }),
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await _saveToken(data['token']);
      return data;
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Échec de l’inscription');
    }
  }

  Future<List<dynamic>> searchBooks({
    String? query,
    String? level,
    String? condition,
  }) async {
    final uri = Uri.parse('$baseUrl/books/search').replace(
      queryParameters: {
        if (query != null && query.isNotEmpty) 'query': query,
        if (level != null && level != 'Tous') 'level': level,
        if (condition != null && condition != 'Tous') 'condition': condition,
      },
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Échec de la recherche');
    }
  }

  Future<void> addBook({
    required String title,
    required String author,
    required String systeme,
    required String level,
    required String condition,
    required String imageUrl,
  }) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/books/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': title,
        'author': author,
        'systeme': systeme,
        'level': level,
        'condition': condition,
        'imageUrl': imageUrl,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Échec de l’ajout du livre');
    }
  }

  Future<void> createRequest(String bookId) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/requests/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'bookId': bookId}),
    );
    if (response.statusCode != 201) {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Échec de la demande');
    }
  }

  Future<List<dynamic>> listSupplies({String? type}) async {
    final uri = Uri.parse('$baseUrl/supplies/list').replace(
      queryParameters: {
        if (type != null && type != 'Tous') 'type': type,
      },
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Échec de la récupération des fournitures');
    }
  }

  Future<void> contactSupplier(String itemId) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/supplies/contact'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'itemId': itemId}),
    );
    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Échec du contact');
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String phone,
    required String address,
    required String level,
  }) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/users/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'address': address,
        'level': level,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveToken(data['token']);
      return data;
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Échec de la mise à jour');
    }
  }

  Future<void> submitFeedback(String feedback) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/feedback/submit'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'feedback': feedback}),
    );
    if (response.statusCode != 201) {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Échec de l’envoi du commentaire');
    }
  }

  Future<void> saveFcmToken(String fcmToken) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/users/fcm-token'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'fcmToken': fcmToken}),
    );
    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Échec de la sauvegarde du token FCM');
    }
  }
}