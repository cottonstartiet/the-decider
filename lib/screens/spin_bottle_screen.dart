import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/zen_theme.dart';

class SpinBottleScreen extends StatefulWidget {
  const SpinBottleScreen({super.key});

  @override
  State<SpinBottleScreen> createState() => _SpinBottleScreenState();
}

class _SpinBottleScreenState extends State<SpinBottleScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isSpinning = false;
  String? _result;
  final _random = Random();

  static const _directions = [
    'North',
    'North-East',
    'East',
    'South-East',
    'South',
    'South-West',
    'West',
    'North-West',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _isSpinning = false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _spin() {
    if (_isSpinning) return;

    // 4-8 full turns + random final angle
    final fullTurns = 4 + _random.nextInt(5);
    final finalAngle = _random.nextDouble() * 2 * pi;
    final totalRotation = fullTurns * 2 * pi + finalAngle;

    // Convert final angle to compass direction
    final degrees = (finalAngle * 180 / pi).round();
    final directionIndex = ((degrees + 22.5) ~/ 45) % 8;

    setState(() {
      _isSpinning = true;
      _result = '${_directions[directionIndex]}  ·  $degrees°';
    });

    _animation = Tween<double>(begin: 0, end: totalRotation).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SPIN THE BOTTLE')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final mainSize = min(constraints.maxWidth * 0.75, constraints.maxHeight * 0.45);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: (_result != null && !_isSpinning) ? 1.0 : 0.0,
                  child: Text(
                    _result ?? '',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      letterSpacing: 4,
                    ),
                  ),
                ),
                SizedBox(height: mainSize * 0.15),
                GestureDetector(
                  onTap: _spin,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _animation.value,
                        child: Container(
                          width: mainSize,
                          height: mainSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ZenTheme.sand,
                            border: Border.all(
                              color: ZenTheme.warmBeige,
                              width: mainSize * 3 / 180,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: ZenTheme.stone.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: _Bottle(size: mainSize),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: mainSize * 0.15),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _isSpinning ? 0.0 : 1.0,
                  child: Text(
                    'Tap to spin',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Bottle extends StatelessWidget {
  final double size;
  const _Bottle({required this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bottle neck — narrow top pointing upward
          Container(
            width: size * 8 / 180,
            height: size * 40 / 180,
            decoration: BoxDecoration(
              color: ZenTheme.deepSage,
              borderRadius: BorderRadius.circular(size * 4 / 180),
            ),
          ),
          SizedBox(height: size * 2 / 180),
          // Bottle body — wider base
          Container(
            width: size * 32 / 180,
            height: size * 50 / 180,
            decoration: BoxDecoration(
              color: ZenTheme.deepSage,
              borderRadius: BorderRadius.circular(size * 8 / 180),
            ),
          ),
        ],
      ),
    );
  }
}
