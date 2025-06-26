import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gilang/controller/article_controller.dart';
import 'package:gilang/models/artikel_model.dart';

class AllPostPage extends StatelessWidget {
  // PERBAIKAN: Gunakan Get.find() untuk mengambil controller yang sudah ada,
  // jangan Get.put() yang akan membuat instance baru.
  final ArticleController _controller = Get.find<ArticleController>();

  AllPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Articles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.fetchArticles(isRefresh: true),
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.isLoading.value && _controller.articles.isEmpty) {
          return _buildLoadingWidget();
        }

        if (_controller.articles.isEmpty) {
          return _buildNoArticlesWidget();
        }

        return _buildArticleList();
      }),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildNoArticlesWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.article, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No Articles Available',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check back later',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _controller.fetchArticles(isRefresh: true),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleList() {
    return RefreshIndicator(
      onRefresh: () => _controller.fetchArticles(isRefresh: true),
      child: ListView.builder(
        itemCount: _controller.articles.length + (_controller.hasMore.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _controller.articles.length) {
            if (!_controller.isLoading.value) {
              _controller.fetchArticles();
            }
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
          return _buildArticleItem(_controller.articles[index]);
        },
      ),
    );
  }

  Widget _buildArticleItem(Article article) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => _viewArticle(article.id),
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
                          'By ${article.author.name}',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        Text(
                          '${article.category} • ${article.readTime}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _viewArticle(String id) {
    Get.toNamed('/articles/$id');
  }
}