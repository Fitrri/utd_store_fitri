import 'package:dio/dio.dart';
import '../domain/product_model.dart';

class ProductRepository {
  final Dio _dio;

  ProductRepository(this._dio) {
    // TAMBAHKAN INI: Interceptor Logger sesuai permintaan PDF
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('--- REQUEST KE: ${options.path} ---');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('--- RESPONSE BERHASIL ---');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('--- ERROR JARINGAN: ${e.message} ---');
        return handler.next(e);
      },
    ));
  }

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _dio.get('https://fakestoreapi.com/products');
      if (response.statusCode == 200) {
        List data = response.data;
        // Logika [Promo Ongkir] otomatis jalan karena NIM Genap (0)
        return data.map((json) => Product.fromJson(json)).toList();
      }
      throw Exception('Gagal ambil data');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}