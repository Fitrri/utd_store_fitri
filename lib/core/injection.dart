import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../domain/splash_service.dart';
import '../data/product_repository.dart';
import '../presentation/cubit/product_cubit.dart'; // 1. PASTIKAN ADA IMPORT INI

final sl = GetIt.instance;

Future<void> inisialisasi() async {
  // Register Dio
  sl.registerLazySingleton(() => Dio());
  
  // Register Service
  sl.registerLazySingleton(() => SplashService());
  
  // Register Repository
  sl.registerLazySingleton(() => ProductRepository(sl()));
  
  // 2. TAMBAHKAN BARIS INI (Ini yang bikin layar merah tadi)
  sl.registerFactory(() => ProductCubit(sl()));
}