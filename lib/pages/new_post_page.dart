// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gilang/controller/article_controller.dart';

// class NewPostPage extends StatefulWidget {
//   const NewPostPage({super.key});

//   @override
//   _NewPostPageState createState() => _NewPostPageState();
// }

// class _NewPostPageState extends State<NewPostPage> {
//   final _formKey = GlobalKey<FormState>();
//   final ArticleController _articleController = Get.find<ArticleController>();

//   String? selectedCategory;
//   final List<String> categories = ['Technology', 'Nasional', 'Internasional'];
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _contentController = TextEditingController();
//   final TextEditingController _hashtagsController = TextEditingController();
//   final TextEditingController _readTimeController = TextEditingController(
//     text: "5 menit",
//   );
//   // PERBAIKAN: Menghapus URL default yang sudah tidak valid.
//   final TextEditingController _imageUrlController = TextEditingController();
//   bool _isTrending = false;
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _contentController.dispose();
//     _hashtagsController.dispose();
//     _readTimeController.dispose();
//     _imageUrlController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           'Create Article',
//           style: TextStyle(color: Colors.black),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         foregroundColor: Colors.black,
//         leading: IconButton(
//           icon: const Icon(Icons.close),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               _buildTextField('Article Title', controller: _titleController),
//               _buildTextField(
//                 'Content',
//                 controller: _contentController,
//                 maxLines: 5,
//               ),
//               _buildTextField(
//                 'Tags (comma separated)',
//                 controller: _hashtagsController,
//                 hint: 'tech,news,politics',
//               ),
//               _buildTextField('Read Time', controller: _readTimeController),
              
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 14),
//                 child: TextFormField(
//                   controller: _imageUrlController,
//                   decoration: _inputDecoration('Image URL', hint: 'https://example.com/image.jpg'),
//                   keyboardType: TextInputType.url,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'URL gambar wajib diisi';
//                     }
//                     if (!value.startsWith('http')) {
//                       return 'Masukkan format URL yang valid';
//                     }
//                     return null;
//                   },
//                 ),
//               ),

//               const SizedBox(height: 10),

//               DropdownButtonFormField<String>(
//                 value: selectedCategory,
//                 decoration: _inputDecoration('Category'),
//                 items:
//                     categories.map((String value) {
//                       return DropdownMenuItem(value: value, child: Text(value));
//                     }).toList(),
//                 onChanged: (val) => setState(() => selectedCategory = val),
//                 validator:
//                     (value) => value == null ? 'Please choose category' : null,
//               ),

//               const SizedBox(height: 20),

//               SwitchListTile(
//                 title: const Text('Is Trending'),
//                 value: _isTrending,
//                 onChanged: (value) {
//                   setState(() {
//                     _isTrending = value;
//                   });
//                 },
//                 activeColor: Colors.blue,
//               ),

//               const SizedBox(height: 20),

//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   onPressed: _isLoading ? null : _submitArticle,
//                   icon: const Icon(Icons.send),
//                   label:
//                       _isLoading
//                           ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2,
//                             ),
//                           )
//                           : const Text(
//                             'Publish',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(
//     String label, {
//     int maxLines = 1,
//     TextEditingController? controller,
//     String? hint,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 14),
//       child: TextFormField(
//         controller: controller,
//         maxLines: maxLines,
//         decoration: _inputDecoration(label, hint: hint),
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter $label';
//           }
//           return null;
//         },
//       ),
//     );
//   }

//   InputDecoration _inputDecoration(String label, {String? hint}) {
//     return InputDecoration(
//       labelText: label,
//       hintText: hint,
//       labelStyle: const TextStyle(color: Colors.grey),
//       filled: true,
//       fillColor: Colors.grey[100],
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//       focusedBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: Colors.blue, width: 2),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//     );
//   }

//   Future<void> _submitArticle() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (selectedCategory == null) {
//       setState(() {});
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final articleData = {
//         "title": _titleController.text,
//         "category": selectedCategory!,
//         "readTime": _readTimeController.text,
//         "imageUrl": _imageUrlController.text,
//         "isTrending": _isTrending,
//         "tags":
//             _hashtagsController.text.isEmpty
//                 ? ['news']
//                 : _hashtagsController.text
//                     .split(',')
//                     .map((e) => e.trim())
//                     .where((e) => e.isNotEmpty)
//                     .toList(),
//         "content": _contentController.text,
//       };

//       await _articleController.createArticle(articleData);

//       if (mounted) {
//         // Kembali ke halaman sebelumnya setelah berhasil
//         Get.back();
//       }
//     } catch (e) {
//       if (mounted) {
//         Get.snackbar('Error', e.toString());
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gilang/controller/article_controller.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({super.key});

  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  final _formKey = GlobalKey<FormState>();
  final ArticleController _articleController = Get.find<ArticleController>();

  String? selectedCategory;
  final List<String> categories = ['Technology', 'Nasional', 'Internasional'];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _hashtagsController = TextEditingController();
  final TextEditingController _readTimeController =
      TextEditingController(text: '5 menit');
  final TextEditingController _imageUrlController = TextEditingController();

  bool _isTrending = false;
  bool _isLoading = false;

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
        title: const Text('Create Article', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField('Article Title', controller: _titleController),
              _buildTextField('Content',
                  controller: _contentController, maxLines: 5),
              _buildTextField('Tags (comma separated)',
                  controller: _hashtagsController, hint: 'tech,news,politics'),
              _buildTextField('Read Time', controller: _readTimeController),
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: TextFormField(
                  controller: _imageUrlController,
                  decoration: _inputDecoration('Image URL',
                      hint: 'https://example.com/image.jpg'),
                  keyboardType: TextInputType.url,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'URL gambar wajib diisi';
                    }
                    if (!value.startsWith('http')) {
                      return 'Masukkan format URL yang valid';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: _inputDecoration('Category'),
                items: categories
                    .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                    .toList(),
                onChanged: (val) => setState(() => selectedCategory = val),
                validator: (value) =>
                    value == null ? 'Please choose category' : null,
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text('Is Trending'),
                value: _isTrending,
                onChanged: (value) => setState(() => _isTrending = value),
                activeColor: Colors.blue,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submitArticle,
                  icon: const Icon(Icons.send),
                  label: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Publish',
                          style: TextStyle(fontWeight: FontWeight.bold)),
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

  // ---------- Helpers ---------- //

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
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Please enter $label' : null,
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

  // ---------- Submit Logic with Snackbar ---------- //

  Future<void> _submitArticle() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedCategory == null) {
      setState(() {}); // trigger validator
      return;
    }

    setState(() => _isLoading = true);

    try {
      final articleData = {
        'title': _titleController.text,
        'category': selectedCategory!,
        'readTime': _readTimeController.text,
        'imageUrl': _imageUrlController.text,
        'isTrending': _isTrending,
        'tags': _hashtagsController.text.isEmpty
            ? ['news']
            : _hashtagsController.text
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList(),
        'content': _contentController.text,
      };

      await _articleController.createArticle(articleData);

      if (mounted) {
        // Snackbar sukses
        Get.snackbar(
          'Sukses',
          'Artikel berhasil ditambahkan!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // Beri jeda singkat agar snackbar sempat terlihat
        await Future.delayed(const Duration(milliseconds: 800));

        Get.back(); // Kembali ke halaman sebelumnya
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar('Error', e.toString());
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
