import 'package:dio/dio.dart';
import '../domain/product_model.dart';

class ProductRepository {
  final Dio _dio;

  ProductRepository(this._dio) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) => handler.next(options),
      onResponse: (response, handler) => handler.next(response),
      onError: (DioException e, handler) => handler.next(e),
    ));
  }

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _dio.get('https://fakestoreapi.com/products');
      if (response.statusCode == 200) {
        List data = response.data;
        return data.map((json) {
          final productOriginal = Product.fromJson(json);
          
          // JURUS AMPUH: Hapus semua tulisan promo yang sudah ada, lalu pasang 1 saja
          String cleanTitle = productOriginal.title.replaceAll("[Promo Ongkir]", "").trim();

          return Product(
            id: productOriginal.id,
            title: "$cleanTitle [Promo Ongkir]", 
            price: productOriginal.price,
            description: productOriginal.description,
            category: productOriginal.category,
            image: productOriginal.image,
          );
        }).toList();
      }
      throw Exception('Gagal ambil data');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}