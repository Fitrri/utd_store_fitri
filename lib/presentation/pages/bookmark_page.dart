import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../../core/injection.dart';
import '../../domain/product_model.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil instance Isar yang sudah didaftarkan di injection.dart
    final isar = sl<Isar>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fitri's Bookmarks"),
        backgroundColor: Colors.redAccent,
      ),
      // StreamBuilder supaya kalau dihapus, tampilan langsung refresh otomatis
      body: StreamBuilder<List<Product>>(
        stream: isar.products.where().watch(fireImmediately: true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(
              child: Text("Belum ada produk favorit."),
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: Image.network(item.image, width: 50),
                title: Text(item.title),
                subtitle: Text("Disimpan jam: ${item.savedAt ?? '-'}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    // Logika hapus dari Isar
                    await isar.writeTxn(() => isar.products.delete(item.isarId));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Dihapus dari bookmark"))
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}