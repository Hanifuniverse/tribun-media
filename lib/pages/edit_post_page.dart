import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gilang/controller/article_controller.dart';

class EditPostPage extends StatefulWidget {
  final String articleId;

  const EditPostPage({super.key, required this.articleId});

  @override
  _EditPostPageState createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final _formKey = GlobalKey<FormState>();
  final ArticleController _articleController = Get.find<ArticleController>();

  String? selectedCategory;
  final List<String> categories = ['Technology', 'Nasional', 'Internasional'];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _hashtagsController = TextEditingController();
  final TextEditingController _readTimeController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  bool _isTrending = false;
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadArticleData();
  }

  Future<void> _loadArticleData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _articleController.fetchArticleById(widget.articleId);

      if (_articleController.selectedArticle.value != null) {
        final article = _articleController.selectedArticle.value!;

        _titleController.text = article.title;
        _contentController.text = article.content;
        _hashtagsController.text = article.tags.join(', ');
        _readTimeController.text = article.readTime;
        _imageUrlController.text = article.imageUrl;
        _isTrending = article.isTrending;
        selectedCategory = article.category;

        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load article: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _hashtagsController.dispose();
    _readTimeController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Edit Article',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : !_isInitialized
              ? const Center(child: Text('Artikel tidak ditemukan'))
              : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        'Article Title',
                        controller: _titleController,
                      ),
                      _buildTextField(
                        'Content',
                        controller: _contentController,
                        maxLines: 5,
                      ),
                      _buildTextField(
                        'Tags (comma separated)',
                        controller: _hashtagsController,
                        hint: 'tech,news,politics',
                      ),
                      _buildTextField(
                        'Read Time',
                        controller: _readTimeController,
                      ),
                      _buildTextField(
                        'Image URL',
                        controller: _imageUrlController,
                        hint: 'https://example.com/image.jpg',
                      ),
                      const SizedBox(height: 10),

                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        decoration: _inputDecoration('Category'),
                        items:
                            categories.map((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged:
                            (val) => setState(() => selectedCategory = val),
                        validator:
                            (value) =>
                                value == null ? 'Please choose category' : null,
                      ),

                      const SizedBox(height: 20),

                      // Trending Switch
                      SwitchListTile(
                        title: const Text('Is Trending'),
                        value: _isTrending,
                        onChanged: (value) {
                          setState(() {
                            _isTrending = value;
                          });
                        },
                        activeColor: Colors.blue,
                      ),

                      const SizedBox(height: 20),

                      // Preview Image
                      if (_imageUrlController.text.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Image Preview:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Image.network(
                                _imageUrlController.text,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 150,
                                    width: double.infinity,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Text('Invalid image URL'),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                      // Update Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _updateArticle,
                          icon: const Icon(Icons.save),
                          label:
                              _isLoading
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Text(
                                    'Update',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildTextField(
    String label, {
    int maxLines = 1,
    TextEditingController? controller,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: _inputDecoration(label, hint: hint),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  Future<void> _updateArticle() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedCategory == null) {
      setState(() {});
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Format data sesuai dengan API
      final articleData = {
        "title": _titleController.text,
        "category": selectedCategory!,
        "readTime": _readTimeController.text,
        "imageUrl":
            _imageUrlController.text.isEmpty
                ? 'https://source.unsplash.com/random/800x600/?news'
                : _imageUrlController.text,
        "isTrending": _isTrending,
        "tags":
            _hashtagsController.text.isEmpty
                ? ['news']
                : _hashtagsController.text
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList(),
        "content": _contentController.text,
      };

      // Log data sebelum mengirim
      print('Data artikel yang akan diupdate: $articleData');

      // Gunakan controller untuk update artikel
      await _articleController.updateArticle(widget.articleId, articleData);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
