import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:isar/isar.dart'; 
import 'package:path_provider/path_provider.dart'; 
import '../domain/product_model.dart'; 
import '../domain/splash_service.dart';
import '../data/product_repository.dart';
import '../presentation/cubit/product_cubit.dart';

final sl = GetIt.instance;

Future<void> inisialisasi() async {
  // 1. Inisialisasi ISAR (Database Lokal)
  final dir = await getApplicationDocumentsDirectory();
  
  final isar = await Isar.open(
    [ProductSchema], 
    directory: dir.path,
  );

  sl.registerSingleton<Isar>(isar);

  // 2. Register Dio (Networking) dengan INTERCEPTOR (Poin 2 PDF ETS)
  sl.registerLazySingleton(() {
    final dio = Dio();
    
    // Ini adalah bagian Interceptor yang WAJIB kamu jelaskan di video
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Fungsi: Mencatat log setiap kali aplikasi meminta data ke internet
        print("--- NETWORK LOG (REQUEST) ---");
        print("URL: ${options.uri}");
        print("Method: ${options.method}");
        return handler.next(options); 
      },
      onResponse: (response, handler) {
        // Fungsi: Mencatat log ketika data berhasil diterima
        print("--- NETWORK LOG (RESPONSE) ---");
        print("Status: ${response.statusCode}");
        print("Data: Berhasil diterima");
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        // Fungsi: Mencatat log jika terjadi error (misal internet mati)
        print("--- NETWORK LOG (ERROR) ---");
        print("Pesan Error: ${e.message}");
        return handler.next(e);
      },
    ));
    
    return dio;
  });
  
  // 3. Register Service
  sl.registerLazySingleton(() => SplashService());
  
  // 4. Register Repository
  sl.registerLazySingleton(() => ProductRepository(sl()));
  
  // 5. Register Cubit (Presentation)
  sl.registerFactory(() => ProductCubit(sl()));
}