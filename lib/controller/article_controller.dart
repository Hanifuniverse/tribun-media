import 'package:get/get.dart';
import 'package:gilang/models/artikel_model.dart';
import 'package:gilang/services/api_services.dart';
import 'package:gilang/controller/auth_controller.dart';

class ArticleController extends GetxController {
  final ApiService _apiService = ApiService();
  final AuthController _authController = Get.find<AuthController>();

  // For all articles
  var articles = <Article>[].obs;
  var isLoading = true.obs;
  var page = 1;
  var hasMore = true.obs;

  // For article detail
  final selectedArticle = Rx<Article?>(null);
  var isDetailLoading = true.obs;

  // For user articles
  var userArticles = <Article>[].obs;
  var isUserArticlesLoading = true.obs;
  var userArticlesPage = 1;
  var hasMoreUserArticles = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchArticles();
  }

  Future<void> fetchArticles({bool isRefresh = false, String? category}) async {
    try {
      if (isRefresh) {
        page = 1;
        articles.clear();
        hasMore.value = true;
      }

      if (!hasMore.value) return;

      isLoading.value = true;
      
      final response = await _apiService.getArticles(
        page: page,
        category: category,
      );

      articles.addAll(response.data.articles);
      hasMore.value = response.data.pagination.hasMore;
      page++;
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat artikel: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchArticleById(String id) async {
    isDetailLoading.value = true;
    selectedArticle.value = null;
    try {
      final article = await _apiService.getArticleById(id);
      selectedArticle.value = article;
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat detail artikel: ${e.toString()}');
    } finally {
      isDetailLoading.value = false;
    }
  }

  Future<void> createArticle(Map<String, dynamic> articleData) async {
    try {
      if (!_authController.isLoggedIn) {
        throw Exception('Anda harus login untuk membuat artikel');
      }

      if (!articleData.containsKey('title') || 
          !articleData.containsKey('category') || 
          !articleData.containsKey('content')) {
        throw Exception('Judul, kategori, dan konten wajib diisi');
      }

      // Set default values if not provided
      articleData['readTime'] ??= '5 menit';
      articleData['imageUrl'] ??= 'https://source.unsplash.com/random/800x600/?news';
      articleData['isTrending'] ??= false;
      articleData['tags'] ??= ['news'];

      await _apiService.createArticle(articleData, _authController.token!);
      fetchArticles(isRefresh: true);
      fetchUserArticles(isRefresh: true);
      Get.back();
      Get.snackbar('Berhasil', 'Artikel berhasil dibuat');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> updateArticle(String id, Map<String, dynamic> articleData) async {
    try {
      if (!_authController.isLoggedIn) {
        throw Exception('Anda harus login untuk memperbarui artikel');
      }

      await _apiService.updateArticle(id, articleData, _authController.token!);
      fetchArticles(isRefresh: true);
      fetchUserArticles(isRefresh: true);
      Get.back();
      Get.snackbar('Berhasil', 'Artikel berhasil diperbarui');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> deleteArticle(String id) async {
    try {
      if (!_authController.isLoggedIn) {
        throw Exception('Anda harus login untuk menghapus artikel');
      }

      await _apiService.deleteArticle(id, _authController.token!);
      articles.removeWhere((article) => article.id == id);
      userArticles.removeWhere((article) => article.id == id);
      Get.snackbar('Berhasil', 'Artikel berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> fetchUserArticles({bool isRefresh = false}) async {
    try {
      if (!_authController.isLoggedIn) return;

      if (isRefresh) {
        userArticlesPage = 1;
        userArticles.clear();
        hasMoreUserArticles.value = true;
      }

      if (!hasMoreUserArticles.value) return;

      isUserArticlesLoading.value = true;

      final response = await _apiService.getUserArticles(
        page: userArticlesPage,
        token: _authController.token!,
      );

      userArticles.addAll(response.data.articles);
      hasMoreUserArticles.value = response.data.pagination.hasMore;
      userArticlesPage++;
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat artikel pengguna: ${e.toString()}');
    } finally {
      isUserArticlesLoading.value = false;
    }
  }
}