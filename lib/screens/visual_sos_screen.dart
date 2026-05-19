import 'dart:async';
import 'package:flutter/material.dart';

class VisualSosScreen extends StatefulWidget {
  const VisualSosScreen({super.key});

  @override
  State<VisualSosScreen> createState() => _VisualSosScreenState();
}

class _VisualSosScreenState extends State<VisualSosScreen> {
  bool _isRed = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Flash rapidly every 200ms
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        _isRed = !_isRed;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The screen flips between Bright Red and White
      backgroundColor: _isRed ? Colors.red : Colors.white,
      appBar: AppBar(
        title: const Text('Visual SOS', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black45,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 150,
              color: _isRed ? Colors.white : Colors.red,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              color: Colors.black54,
              child: const Text(
                'POINT SCREEN OUTWARDS',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
