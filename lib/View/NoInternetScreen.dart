import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.wifi_off, size: 50, color: Colors.red),
            SizedBox(height: 20),
            Text("No Internet Connection", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
