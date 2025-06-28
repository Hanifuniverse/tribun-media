import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gilang/models/artikel_model.dart';

class ApiService {
  // Base URL sudah benar sesuai dokumentasi
  static const String _baseUrl = 'https://rest-api-berita.vercel.app/api/v1';

  // Fungsi ini sudah benar, menyiapkan header termasuk token jika ada
  Map<String, String> _getHeaders({String? token}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // --- FUNGSI OTENTIKASI ---

  // Perbaikan: Body disesuaikan dengan 5 field yang diwajibkan dokumentasi
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required String title,
    required String avatar,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: _getHeaders(),
      body: json.encode({
        'email': email,
        'password': password,
        'name': name,
        'title': title,
        'avatar': avatar,
      }),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    // TAMBAHKAN LOG
    final url = Uri.parse('$_baseUrl/auth/login');
    print('[ApiService] Melakukan POST request ke: $url');
    
    final response = await http.post(
      url,
      headers: _getHeaders(),
      body: json.encode({
        'email': email,
        'password': password,
      }),
    ).timeout( // TAMBAHKAN TIMEOUT
      const Duration(seconds: 15), // Waktu tunggu 15 detik
      onTimeout: () {
        // TAMBAHKAN LOG & ERROR HANDLING UNTUK TIMEOUT
        print('[ApiService] Request timeout.');
        throw http.ClientException('Request timed out. Please check your connection.');
      },
    );
    
    // TAMBAHKAN LOG
    print('[ApiService] Respons diterima. Status code: ${response.statusCode}');
    print('[ApiService] Respons body: ${response.body}');
    
    return _handleResponse(response);
  }

  // --- FUNGSI CRUD ARTIKEL ---

  Future<NewsResponse> getArticles({int page = 1, int limit = 10, String? category}) async {
    String url = '$_baseUrl/news?page=$page&limit=$limit';
    if (category != null) {
      url += '&category=$category';
    }
    final response = await http.get(Uri.parse(url), headers: _getHeaders());
    if (response.statusCode == 200) {
      return newsResponseFromJson(response.body);
    } else {
      throw Exception(_handleError(response));
    }
  }

  Future<Article> getArticleById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/news/$id'), headers: _getHeaders());
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return Article.fromJson(jsonResponse['data']);
    } else {
      throw Exception(_handleError(response));
    }
  }

  Future<Map<String, dynamic>> createArticle(Map<String, dynamic> articleData, String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/news'),
      headers: _getHeaders(token: token),
      body: json.encode(articleData),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateArticle(String id, Map<String, dynamic> articleData, String token) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/news/$id'),
      headers: _getHeaders(token: token),
      body: json.encode(articleData),
    );
    return _handleResponse(response);
  }

  Future<void> deleteArticle(String id, String token) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/news/$id'),
      headers: _getHeaders(token: token),
    );
    // Delete biasanya mengembalikan 200 OK atau 204 No Content, tidak selalu ada body
    if (response.statusCode != 200 && response.statusCode != 204) {
       throw Exception(_handleError(response));
    }
  }
  
  Future<NewsResponse> getUserArticles({int page = 1, int limit = 10, required String token}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/news/user/me?page=$page&limit=$limit'),
      headers: _getHeaders(token: token),
    );
     if (response.statusCode == 200) {
      return newsResponseFromJson(response.body);
    } else {
      throw Exception(_handleError(response));
    }
  }

  // --- FUNGSI PENANGANAN RESPONS & ERROR ---

  // Fungsi ini untuk memproses respons yang berhasil atau melempar error
  Map<String, dynamic> _handleResponse(http.Response response) {
    // Kode 201 berarti "Created", ini adalah sukses untuk POST
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception(_handleError(response));
    }
  }
  
  // Perbaikan: Fungsi terpisah untuk mengurai pesan error sesuai dokumentasi
  String _handleError(http.Response response) {
    final responseData = json.decode(response.body);
    // Mengambil pesan error dari field 'error' jika ada, jika tidak, dari 'message'
    return responseData['error'] ?? responseData['message'] ?? 'Terjadi kesalahan tidak diketahui';
  }
}