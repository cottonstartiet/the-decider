import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/zen_theme.dart';

class DoubleNothingScreen extends StatefulWidget {
  const DoubleNothingScreen({super.key});

  @override
  State<DoubleNothingScreen> createState() => _DoubleNothingScreenState();
}

class _DoubleNothingScreenState extends State<DoubleNothingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final _random = Random();
  bool _isAnimating = false;
  int _streak = 1;
  bool _lastWon = false;
  bool _hasLost = false;
  bool _hasResult = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _isAnimating = false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _attemptDouble() {
    if (_isAnimating || _hasLost) return;

    final won = _random.nextBool();
    setState(() {
      _isAnimating = true;
      _hasResult = true;
      _lastWon = won;
      if (won) {
        _streak *= 2;
      } else {
        _streak = 0;
        _hasLost = true;
      }
    });

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.reset();
    _controller.forward();
  }

  void _cashOut() {
    if (_isAnimating) return;
    setState(() {
      _hasResult = true;
      _hasLost = true;
    });
  }

  void _playAgain() {
    setState(() {
      _streak = 1;
      _hasLost = false;
      _lastWon = false;
      _hasResult = false;
    });
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DOUBLE OR NOTHING')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Streak display
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                double scale = 1.0;
                double translateX = 0.0;
                if (_isAnimating && _hasResult) {
                  if (_lastWon) {
                    // Pulse: scale up then back
                    scale = 1.0 + 0.3 * sin(_animation.value * pi);
                  } else {
                    // Shake: oscillate X
                    translateX = 12 * sin(_animation.value * pi * 6) *
                        (1.0 - _animation.value);
                  }
                }
                return Transform.translate(
                  offset: Offset(translateX, 0),
                  child: Transform.scale(
                    scale: scale,
                    child: Text(
                      'Streak: ${_streak}x',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                letterSpacing: 4,
                                color: _hasLost
                                    ? ZenTheme.stone
                                    : ZenTheme.deepSage,
                              ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 48),
            // Coin
            GestureDetector(
              onTap: _attemptDouble,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  final angle = _isAnimating
                      ? _animation.value * pi * 4
                      : 0.0;
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle),
                    child: _DoubleCoin(
                      hasResult: _hasResult && !_isAnimating,
                      won: _lastWon,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 48),
            // Buttons or instruction
            if (_hasLost && !_isAnimating)
              _ActionButton(
                label: 'Play Again',
                color: ZenTheme.deepSage,
                onTap: _playAgain,
              )
            else if (!_hasLost)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ActionButton(
                    label: 'Double',
                    color: ZenTheme.deepSage,
                    onTap: _isAnimating ? null : _attemptDouble,
                  ),
                  const SizedBox(width: 24),
                  _ActionButton(
                    label: 'Cash Out',
                    color: ZenTheme.stone,
                    onTap: _isAnimating ? null : _cashOut,
                  ),
                ],
              ),
            const SizedBox(height: 32),
            // Instruction text
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isAnimating ? 0.0 : 1.0,
              child: Text(
                'Double your luck or cash out',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoubleCoin extends StatelessWidget {
  final bool hasResult;
  final bool won;

  const _DoubleCoin({required this.hasResult, required this.won});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ZenTheme.accent, Color(0xFFD4B896)],
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
        child: Text(
          hasResult ? (won ? '✓' : '✗') : '?',
          style: TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.w200,
            color: hasResult
                ? (won ? ZenTheme.deepSage : const Color(0xFFCF6B6B))
                : ZenTheme.softWhite,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          color: onTap != null ? color : color.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: ZenTheme.softWhite,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
