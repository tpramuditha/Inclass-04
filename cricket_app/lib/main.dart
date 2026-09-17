import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MiniCricketApp());
}

class MiniCricketApp extends StatelessWidget {
  const MiniCricketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Cricket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1565C0),
        scaffoldBackgroundColor: const Color(0xFF1E88E5),
        useMaterial3: true,
      ),
      home: const MiniCricketScreen(),
    );
  }
}

class MiniCricketScreen extends StatefulWidget {
  const MiniCricketScreen({super.key});

  @override
  State<MiniCricketScreen> createState() => _MiniCricketScreenState();
}

class _MiniCricketScreenState extends State<MiniCricketScreen> {
  final Random _random = Random();
  final TextEditingController _ballsController = TextEditingController();

  // Game state
  bool _gameStarted = false;
  int _totalBalls = 0;
  int _ballsLeft = 0;
  int _runs = 0;

  void _startGame() {
    final int? entered = int.tryParse(_ballsController.text.trim());
    if (entered == null || entered <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number of balls')),
      );
      return;
    }
    setState(() {
      _totalBalls = entered;
      _ballsLeft = entered;
      _runs = 0;
      _gameStarted = true;
    });
  }

  void _bat() {
    if (_ballsLeft <= 0) return;
    final int runThisBall = _random.nextInt(7); // 0 to 6 inclusive
    setState(() {
      _ballsLeft -= 1;
      _runs += runThisBall;
    });
  }

  void _reset() {
    setState(() {
      _gameStarted = false;
      _totalBalls = 0;
      _ballsLeft = 0;
      _runs = 0;
      _ballsController.clear();
    });
  }

  @override
  void dispose() {
    _ballsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isOver = _gameStarted && _ballsLeft == 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        title: const Text('Mini Cricket'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              if (!_gameStarted) ...[
                // ---- Setup screen: enter number of balls ----
                const Text(
                  'Enter number of balls',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _ballsController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'e.g. 6',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _startGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Start'),
                ),
              ] else ...[
                // ---- Runs / Balls stat row ----
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatCard(
                      icon: Icons.sports_cricket,
                      iconColor: Colors.brown.shade300,
                      label: 'Runs',
                      value: _runs.toString(),
                    ),
                    _StatCard(
                      icon: Icons.circle,
                      iconColor: Colors.red,
                      label: 'Balls',
                      value: _ballsLeft.toString(),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                if (!isOver) ...[
                  // ---- Mid-game: show runs from last ball (optional info) ----
                  ElevatedButton(
                    onPressed: _bat,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D47A1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text('Bat', style: TextStyle(fontSize: 16)),
                  ),
                ] else ...[
                  // ---- Game over: final runs + Restart ----
                  Text(
                    '$_runs Runs',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _reset,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Restart',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 48, color: iconColor),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
