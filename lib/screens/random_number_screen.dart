import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/zen_theme.dart';

class RandomNumberScreen extends StatefulWidget {
  const RandomNumberScreen({super.key});

  @override
  State<RandomNumberScreen> createState() => _RandomNumberScreenState();
}

class _RandomNumberScreenState extends State<RandomNumberScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final _random = Random();
  int? _result;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 0.9), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 40),
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

  void _generate() {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
      _result = _random.nextInt(10) + 1;
    });

    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RANDOM NUMBER')),
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
                    _result != null ? '$_result' : '',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      letterSpacing: 4,
                    ),
                  ),
                ),
                SizedBox(height: mainSize * 0.15),
                GestureDetector(
                  onTap: _generate,
                  child: AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          width: mainSize,
                          height: mainSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [ZenTheme.deepSage, ZenTheme.sage],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: ZenTheme.deepSage.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _isAnimating ? '?' : (_result?.toString() ?? '?'),
                              style: TextStyle(
                                fontSize: mainSize * 48 / 160,
                                fontWeight: FontWeight.w200,
                                color: ZenTheme.softWhite,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: mainSize * 0.15),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _isAnimating ? 0.0 : 1.0,
                  child: Text(
                    'Tap to pick 1–10',
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
