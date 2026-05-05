import 'package:flutter/material.dart';

class CryptoPage extends StatelessWidget {
  const CryptoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fitri's Crypto Hub")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Area Bitcoin (Live harga akan dipasang di Commit 9)
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: const Column(
                children: [
                  Icon(Icons.currency_bitcoin, size: 80, color: Colors.orange),
                  SizedBox(height: 10),
                  Text("BTC/USD", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("\$ --,---", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.orange)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Tombol Isolate
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () {
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Fitur Isolate akan aktif di Commit 9")),
                  );
                },
                icon: const Icon(Icons.bolt),
                label: const Text("JALANKAN KALKULASI PAJAK (ISOLATE)"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Syarat: Harga di atas tidak boleh freeze saat tombol ditekan.",
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}