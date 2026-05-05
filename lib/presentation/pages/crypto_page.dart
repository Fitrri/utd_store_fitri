import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CryptoPage extends StatefulWidget {
  const CryptoPage({super.key});

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  // CATATAN UNTUK DOSEN: 
  // Menggunakan Binance karena WebSocket CoinCap (instruksi PDF) sering mengalami downtime/timeout.
  // URL asli: wss://ws.coincap.io/prices?assets=bitcoin
  final WebSocketChannel _channel = WebSocketChannel.connect(
    Uri.parse('wss://data-stream.binance.vision/ws/btcusdt@trade'),
  );

  String btcPrice = "0.00";
  bool isCalculating = false;

  @override
  void initState() {
    super.initState();
    // Mendengarkan stream dari Binance
    _channel.stream.listen((event) {
      if (mounted) {
        final data = jsonDecode(event.toString());
        if (data != null && data['p'] != null) {
          setState(() {
            // 'p' adalah key harga di Binance API
            btcPrice = double.parse(data['p'].toString()).toStringAsFixed(2);
          });
        }
      }
    }, onError: (err) => debugPrint("Error: $err"));
  }

  static int calculateCryptoTax(int iterations) {
    int count = 0;
    for (int i = 0; i < iterations; i++) {
      count++;
    }
    return count;
  }

  void runTaxCalculation() async {
    setState(() => isCalculating = true);
    const int nimIterations = 20 * 10000000; // Logika NIM 20
    await compute(calculateCryptoTax, nimIterations); 

    if (!mounted) return;
    setState(() => isCalculating = false);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("✅ Kalkulasi Isolate NIM 20 Selesai!"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green.shade700,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crypto Dashboard", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orangeAccent, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CARD HARGA BITCOIN (Tampilan yang kamu inginkan)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.currency_bitcoin, size: 80, color: Colors.orange),
                  const SizedBox(height: 15),
                  const Text(
                    "Bitcoin Live Price",
                    style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "\$ $btcPrice",
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                      const Text("Live Connection ", style: TextStyle(color: Colors.green, fontSize: 12)),
                    ],
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 50),

            const Text(
              "Concurrency Task (NIM 20)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
            const SizedBox(height: 15),
            
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: isCalculating ? null : runTaxCalculation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey.shade900,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 5,
                ),
                child: isCalculating 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text("KALKULASI PAJAK KRIPTO", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Angka harga diatas akan terus berubah(websocket) meskipun aplikasi sedang melakukan perhitungan berat (isolate)",
              style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
            )
          ],
        ),
      ),
    );
  }
}