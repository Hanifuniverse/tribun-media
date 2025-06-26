import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gilang/controller/auth_controller.dart';
import 'edit_profile_page.dart';
import 'change_password_page.dart';

class ProfilePage extends StatelessWidget {
  // Kita tidak lagi menggunakan data hardcoded, jadi baris ini dihapus.

  // Ambil instance AuthController yang sudah ada
  final AuthController _authController = Get.find<AuthController>();

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan Obx agar UI otomatis update jika ada perubahan data user
    return Obx(() {
      // Ambil data user dari controller.
      // Beri nilai default jika user null (misalnya saat proses logout)
      final user = _authController.user;
      final userName = user?.name ?? 'Nama Pengguna';
      final userEmail = user?.email ?? 'email@pengguna.com';
      final userTitle = user?.title ?? 'Jabatan';
      final userPhoto = user?.avatar ?? 'https://via.placeholder.com/150';

      return Scaffold(
        appBar: AppBar(
          title: const Text("Profil"),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: Column(
          children: [
            const SizedBox(height: 30),
            
            // Foto Profil dari data pengguna yang login
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(userPhoto),
                // Tambahkan fallback jika gambar gagal dimuat
                onBackgroundImageError: (_, __) {},
                child: userPhoto.isEmpty ? const Icon(Icons.person, size: 60) : null,
              ),
            ),
            
            const SizedBox(height: 20),

            // Nama dari data pengguna yang login
            Text(
              userName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Jabatan/Title dari data pengguna yang login
            Text(
              userTitle,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),

            // Email dari data pengguna yang login
            Text(
              userEmail,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            const Divider(),

            // Tombol Edit Profil
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text("Edit Profil"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              },
            ),

            // Tombol Ganti Password
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text("Ganti Password"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                );
              },
            ),
            
            const Divider(),

            const Spacer(),

            // Tombol Logout, memanggil fungsi logout dari controller
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Panggil fungsi logout yang sudah kita buat
                    _authController.logout();
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Keluar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    foregroundColor: Colors.red.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.red.shade100),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}