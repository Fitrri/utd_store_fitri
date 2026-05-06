import 'package:flutter/services.dart';

class BatteryService {
  // Nama channel harus sama dengan yang ada di MainActivity.kt
  static const platform = MethodChannel('com.fitri.store/battery');

  Future<int?> getBatteryLevel() async {
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      return result;
    } on PlatformException catch (e) {
      print("Gagal mengambil baterai: ${e.message}");
      return null;
    }
  }

  Future<void> showNativeToast(String message) async {
    try {
      await platform.invokeMethod('showToast', {"message": message});
    } on PlatformException catch (e) {
      print("Gagal menampilkan toast: ${e.message}");
    }
  }
}