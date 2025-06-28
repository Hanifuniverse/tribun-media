import 'package:flutter/material.dart';
// import 'dashboard.dart'; // Ganti ini
import 'main_page.dart'; // Dengan ini

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _onBottomNavTapped(int index) {
    if (index == 0) {
      // PERBAIKAN: Arahkan ke MainPage() bukan DashboardPage()
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildArticleItem({
    required String title,
    required String category,
    required String summary,
    required String imageUrl,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Informasi di kiri
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(
                    summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Gambar di kanan
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: 100,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(String kategori) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (_, index) {
        return _buildArticleItem(
          category: kategori == "nasional" ? "Nasional" : "Internasional",
          title: kategori == "nasional"
              ? "Pemerintah Umumkan Kebijakan Baru"
              : "Negara X dan Y Jalin Kerja Sama",
          summary: kategori == "nasional"
              ? "Kebijakan baru ini bertujuan untuk memperkuat perekonomian nasional dan kesejahteraan rakyat."
              : "Kesepakatan kerja sama strategis ditandatangani dalam forum internasional di Jenewa.",
          imageUrl: "https://via.placeholder.com/100",
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Kategori Artikel'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Nasional'),
            Tab(text: 'Internasional'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTabContent('nasional'),
          _buildTabContent('internasional'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Kategori'),
        ],
      ),
    );
  }
}