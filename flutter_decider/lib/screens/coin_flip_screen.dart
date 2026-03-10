import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/zen_theme.dart';

class CoinFlipScreen extends StatefulWidget {
  const CoinFlipScreen({super.key});

  @override
  State<CoinFlipScreen> createState() => _CoinFlipScreenState();
}

class _CoinFlipScreenState extends State<CoinFlipScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFlipping = false;
  String? _result;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _isFlipping = false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCoin() {
    if (_isFlipping) return;

    final isHeads = _random.nextBool();
    setState(() {
      _isFlipping = true;
      _result = isHeads ? 'Heads' : 'Tails';
    });

    // Total rotations: full spins + final half if tails
    final totalTurns = 6 + (isHeads ? 0 : 1);
    _animation = Tween<double>(begin: 0, end: totalTurns * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HEADS OR TAILS')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Result text
            AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: (_result != null && !_isFlipping) ? 1.0 : 0.0,
              child: Text(
                _result ?? '',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  letterSpacing: 4,
                ),
              ),
            ),
            const SizedBox(height: 48),
            // Coin
            GestureDetector(
              onTap: _flipCoin,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  final angle = _animation.value;
                  // Determine which face to show based on rotation angle
                  final showBack = (angle / pi).floor() % 2 == 1;
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001) // perspective
                      ..rotateX(angle),
                    child: _CoinFace(showBack: showBack),
                  );
                },
              ),
            ),
            const SizedBox(height: 48),
            // Instruction
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isFlipping ? 0.0 : 1.0,
              child: Text(
                'Tap the coin',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoinFace extends StatelessWidget {
  final bool showBack;
  const _CoinFace({required this.showBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: showBack
              ? [ZenTheme.stone, const Color(0xFF7A7268)]
              : [ZenTheme.accent, const Color(0xFFD4B896)],
        ),
        boxShadow: [
          BoxShadow(
            color: ZenTheme.stone.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Transform(
          alignment: Alignment.center,
          transform: showBack ? (Matrix4.identity()..rotateX(pi)) : Matrix4.identity(),
          child: Text(
            showBack ? 'T' : 'H',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w200,
              color: ZenTheme.softWhite,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}
