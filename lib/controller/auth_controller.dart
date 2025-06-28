import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_services.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final _token = Rx<String?>(null);
  final _user = Rxn<User>();
  String? get token => _token.value;
  User? get user => _user.value;

  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token.value = prefs.getString('jwt_token');
  }

  // Fungsi register sudah benar, meneruskan semua field yang dibutuhkan
  Future<void> register({
    required String email,
    required String password,
    required String name,
    String title = 'Content Creator',
    String avatar = 'https://i.imgur.com/7D72t25.png', // URL gambar yang stabil
  }) async {
    try {
      final response = await _apiService.register(
        email: email,
        password: password,
        name: name,
        title: title,
        avatar: avatar,
      );
      await _saveAuthData(response);
      Get.offAllNamed('/dashboard');
      Get.snackbar('Berhasil', 'Registrasi berhasil');
    } catch (e) {
      Get.snackbar('Error Registrasi', e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> login(String email, String password) async {
    try {
      // TAMBAHKAN LOG
      print('[AuthController] Memanggil ApiService untuk login...');
      
      final response = await _apiService.login(email, password);
      
      // TAMBAHKAN LOG
      print('[AuthController] Login API berhasil. Menyimpan data...');

      await _saveAuthData(response);
      
      // TAMBAHKAN LOG
      print('[AuthController] Data tersimpan, navigasi ke dashboard...');

      Get.offAllNamed('/dashboard');
      Get.snackbar('Berhasil', 'Login berhasil');
    } catch (e) {
      // TAMBAHKAN LOG
      print('[AuthController] Error tertangkap di controller: ${e.toString()}');
      Get.snackbar('Error Login', e.toString().replaceFirst('Exception: ', ''));
      // Re-throw error agar UI bisa menanganinya jika perlu
      rethrow;
    }
  }

  // PERBAIKAN KRUSIAL: Memperbaiki cara membaca respons dari API
  Future<void> _saveAuthData(Map<String, dynamic> response) async {
    // Sesuai dokumentasi, 'user' dan 'token' ada di dalam objek 'data'
    final data = response['data'] as Map<String, dynamic>;
    final tokenValue = data['token'] as String;
    final userValue = data['user'] as Map<String, dynamic>;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', tokenValue);
    
    _token.value = tokenValue;
    _user.value = User.fromJson(userValue);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    _token.value = null;
    _user.value = null;
    Get.offAllNamed('/login');
  }

  bool get isLoggedIn => token != null;
}