class SplashService {
  Future<void> jalankanDelayAplikasi() async {
    // Sesuai aturan NIM akhiran 0, maka delay adalah 5 detik (5000 milidetik)
    // Logika diletakkan di sini untuk memenuhi standar Clean Architecture
    await Future.delayed(const Duration(seconds: 5));
  }
}