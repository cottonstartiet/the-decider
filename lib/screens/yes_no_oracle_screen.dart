import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/zen_theme.dart';

class YesNoOracleScreen extends StatefulWidget {
  const YesNoOracleScreen({super.key});

  @override
  State<YesNoOracleScreen> createState() => _YesNoOracleScreenState();
}

class _YesNoOracleScreenState extends State<YesNoOracleScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isAnimating = false;
  String? _result;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 0.9), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.1), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 25),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

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

  void _consult() {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
      _result = _random.nextBool() ? 'Yes' : 'No';
    });

    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YES OR NO')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final mainSize = min(constraints.maxWidth * 0.75, constraints.maxHeight * 0.45);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: (_result != null && !_isAnimating) ? 1.0 : 0.0,
                  child: Text(
                    _result ?? '',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      letterSpacing: 4,
                      shadows: [
                        Shadow(
                          color: ZenTheme.deepSage.withValues(alpha: 0.3),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: mainSize * 0.15),
                GestureDetector(
                  onTap: _consult,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _animation.value,
                        child: _Orb(size: mainSize),
                      );
                    },
                  ),
                ),
                SizedBox(height: mainSize * 0.15),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _isAnimating ? 0.0 : 1.0,
                  child: Text(
                    'Consult the oracle',
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

class _Orb extends StatelessWidget {
  final double size;
  const _Orb({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          center: Alignment.center,
          radius: 0.6,
          colors: [ZenTheme.deepSage, ZenTheme.sage],
        ),
        boxShadow: [
          // Outer glow
          BoxShadow(
            color: ZenTheme.sage.withValues(alpha: 0.3),
            blurRadius: size * 30 / 160,
            spreadRadius: size * 4 / 160,
          ),
          // Depth shadow
          BoxShadow(
            color: ZenTheme.deepSage.withValues(alpha: 0.3),
            blurRadius: size * 20 / 160,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: size * 80 / 160,
          height: size * 80 / 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                ZenTheme.softWhite.withValues(alpha: 0.15),
                ZenTheme.softWhite.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
