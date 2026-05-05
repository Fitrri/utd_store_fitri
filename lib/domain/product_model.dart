import 'package:isar/isar.dart';

part 'product_model.g.dart';

@collection
class Product {
  Id isarId = Isar.autoIncrement;

  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  String? savedAt;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.savedAt,
  });

  // TAMBAHKAN KEMBALI METHOD INI (Penyebab error tadi)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      // Logika NIM Genap: Tambahkan [Promo Ongkir]
      title: "${json['title']} [Promo Ongkir]", 
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
    );
  }
}