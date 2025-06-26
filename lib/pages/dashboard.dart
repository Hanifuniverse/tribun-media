import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gilang/controller/article_controller.dart';
import 'package:gilang/models/artikel_model.dart';
import 'package:gilang/pages/profile_page.dart';

// dashboard.dart sekarang menjadi HomePage
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ArticleController _articleController = Get.find<ArticleController>();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Memuat artikel saat halaman pertama kali dibuka
    _articleController.fetchArticles(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "News",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Navigasi ke halaman profil
              Get.to(() => ProfilePage());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: RefreshIndicator(
          onRefresh: () => _articleController.fetchArticles(isRefresh: true),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBox(),
              const SizedBox(height: 20),
              Expanded(
                child: Obx(() {
                  if (_articleController.isLoading.value &&
                      _articleController.articles.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Filter untuk trending dan search
                  final trendingArticles = _articleController.articles
                      .where((a) => a.isTrending)
                      .toList();
                  final latestArticles = _articleController.articles
                      .where((article) => article.title
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()))
                      .toList();

                  return ListView(
                    children: [
                      _buildSectionTitle("Trending"),
                      const SizedBox(height: 12),
                      _buildTrendingList(trendingArticles),
                      const SizedBox(height: 24),
                      _buildSectionTitle("Latest News"),
                      const SizedBox(height: 12),
                      _buildLatestNewsList(latestArticles),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk Search Box
  Widget _buildSearchBox() {
    return TextField(
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
      ),
    );
  }

  // Widget untuk Judul Section (Trending, Latest News)
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Widget untuk daftar horizontal "Trending"
  Widget _buildTrendingList(List<Article> articles) {
    return SizedBox(
      height: 220,
      child: articles.isEmpty
          ? const Center(child: Text("No trending articles found."))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return _buildTrendingCard(articles[index]);
              },
            ),
    );
  }

  // Widget untuk kartu di bagian "Trending"
  Widget _buildTrendingCard(Article article) {
    return InkWell(
      onTap: () => Get.toNamed('/articles/${article.id}'),
      child: Container(
        width: 250,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                article.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              article.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk daftar vertikal "Latest News"
  Widget _buildLatestNewsList(List<Article> articles) {
    return articles.isEmpty
        ? const Center(child: Text("No articles found."))
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              return _buildLatestNewsCard(articles[index]);
            },
          );
  }

  // Widget untuk kartu di bagian "Latest News"
  Widget _buildLatestNewsCard(Article article) {
    return InkWell(
      onTap: () => Get.toNamed('/articles/${article.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${article.content.substring(0, (article.content.length > 70) ? 70 : article.content.length)}...',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                article.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}