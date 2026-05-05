import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:isar/isar.dart'; // Import Isar
import 'package:path_provider/path_provider.dart'; // Import Path Provider
import '../domain/product_model.dart'; // Import Model untuk Schema
import '../domain/splash_service.dart';
import '../data/product_repository.dart';
import '../presentation/cubit/product_cubit.dart';

final sl = GetIt.instance;

Future<void> inisialisasi() async {
  // 1. Inisialisasi ISAR (Database Lokal)
  // Mencari folder dokumen di HP agar database bisa disimpan permanen
  final dir = await getApplicationDocumentsDirectory();
  
  final isar = await Isar.open(
    [ProductSchema], // Schema dihasilkan otomatis dari build_runner
    directory: dir.path,
  );

  // Daftarkan Isar sebagai Singleton (biar satu database dipakai rame-rame)
  sl.registerSingleton<Isar>(isar);

  // 2. Register Dio (Networking)
  sl.registerLazySingleton(() => Dio());
  
  // 3. Register Service
  sl.registerLazySingleton(() => SplashService());
  
  // 4. Register Repository
  sl.registerLazySingleton(() => ProductRepository(sl()));
  
  // 5. Register Cubit (Presentation)
  sl.registerFactory(() => ProductCubit(sl()));
}