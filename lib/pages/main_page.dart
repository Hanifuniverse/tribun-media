import 'package:flutter/material.dart';
import 'package:gilang/pages/all_post.dart';
import 'package:gilang/pages/dashboard.dart'; // Ini akan menjadi halaman Home baru
import 'package:gilang/pages/my_articles_page.dart';
import 'package:gilang/pages/new_post_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // Daftar halaman yang akan ditampilkan sesuai dengan item navigasi
  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(), // dashboard.dart yang sudah dirombak
    NewPostPage(),
    AllPostPage(),
    const MyArticlesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan IndexedStack agar state setiap halaman tetap terjaga
      // saat berpindah tab
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            activeIcon: Icon(Icons.add_box),
            label: 'New Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            activeIcon: Icon(Icons.article),
            label: 'All Posts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin_outlined),
            activeIcon: Icon(Icons.person_pin),
            label: 'My Articles',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // Penting: untuk memastikan semua item terlihat dan memiliki style yang sama
        type: BottomNavigationBarType.fixed, 
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}