import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gilang/controller/auth_controller.dart';
import 'package:gilang/controller/article_controller.dart';
import 'package:gilang/pages/article_detail_page.dart';
import 'package:gilang/pages/edit_post_page.dart';
import 'package:gilang/pages/new_post_page.dart';
import 'package:gilang/pages/login.dart';
// import 'package:gilang/pages/dashboard.dart'; // Sudah tidak dipakai langsung
import 'package:gilang/pages/register_page.dart';
import 'package:gilang/pages/all_post.dart';
import 'package:gilang/pages/my_articles_page.dart';
import 'package:gilang/pages/profile_page.dart';
import 'package:gilang/pages/change_password_page.dart';
import 'package:gilang/pages/edit_profile_page.dart';
import 'package:gilang/pages/main_page.dart'; // <-- IMPORT FILE BARU

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  Get.put(AuthController());
  Get.put(ArticleController());

  runApp(const MyApp());
}

// Ganti MyApp menjadi const
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tribun Media',
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => const LoginPage()),
        // PERUBAHAN: Arahkan /dashboard ke MainPage yang baru
        GetPage(name: '/dashboard', page: () => const MainPage()),
        GetPage(name: '/register', page: () => const RegisterPage()),
        GetPage(name: '/articles', page: () => AllPostPage()),
        GetPage(name: '/articles/new', page: () => const NewPostPage()),
        GetPage(
          name: '/articles/:id',
          page: () {
            final id = Get.parameters['id']!;
            return ArticleDetailPage(articleId: id);
          },
        ),
        GetPage(
          name: '/articles/edit/:id',
          page: () {
            final id = Get.parameters['id']!;
            return EditPostPage(articleId: id);
          },
        ),
        GetPage(name: '/my-articles', page: () => const MyArticlesPage()),
        GetPage(name: '/profile', page: () => ProfilePage()),
        GetPage(name: '/change-password', page: () => const ChangePasswordPage()),
        GetPage(name: '/edit-profile', page: () => const EditProfilePage()),
      ],
    );
  }
}