import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../domain/splash_service.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> inisialisasi() async {
  // Mendaftarkan SplashService ke dalam GetIt
  sl.registerLazySingleton(() => SplashService());
  
  // Mendaftarkan Dio untuk kebutuhan API nanti
  sl.registerLazySingleton(() => Dio());
}