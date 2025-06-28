import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:gilang/controller/article_controller.dart';
import 'package:gilang/models/artikel_model.dart';

class MyArticlesPage extends StatefulWidget {
  const MyArticlesPage({super.key});

  @override
  _MyArticlesPageState createState() => _MyArticlesPageState();
}

class _MyArticlesPageState extends State<MyArticlesPage> with SingleTickerProviderStateMixin {
  final ArticleController _controller = Get.find<ArticleController>();
  late TabController _tabController;
  final List<String> categories = ['Nasional', 'Internasional'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    _controller.fetchUserArticles(isRefresh: true);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artikel Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.fetchUserArticles(isRefresh: true),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: categories.map((category) => Tab(text: category)).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Get.toNamed('/articles/new'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: categories.map((category) {
          return Obx(() {
            final articles = _controller.userArticles
                .where((article) => article.category == category)
                .toList();

            if (_controller.isUserArticlesLoading.value && articles.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (articles.isEmpty) {
              return _buildNoArticlesWidget(category);
            }

            return _buildArticleList(articles);
          });
        }).toList(),
      ),
    );
  }

  Widget _buildNoArticlesWidget(String category) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.article, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Belum Ada Artikel $category',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap tombol + untuk membuat artikel baru',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _controller.fetchUserArticles(isRefresh: true),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleList(List<Article> articles) {
    return RefreshIndicator(
      onRefresh: () => _controller.fetchUserArticles(isRefresh: true),
      child: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return _buildArticleItem(articles[index]);
        },
      ),
    );
  }

  Widget _buildArticleItem(Article article) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    article.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${article.readTime} • ${DateFormat('dd MMM yyyy').format(article.createdAt)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editArticle(article),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteArticle(article.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _editArticle(Article article) {
    Get.toNamed('/articles/edit/${article.id}');
  }

  void _deleteArticle(String id) {
    Get.defaultDialog(
      title: 'Hapus Artikel',
      middleText: 'Apakah Anda yakin ingin menghapus artikel ini?',
      textConfirm: 'Hapus',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      onConfirm: () {
        _controller.deleteArticle(id);
        Get.back();
        _controller.fetchUserArticles(isRefresh: true);
      },
    );
  }
}