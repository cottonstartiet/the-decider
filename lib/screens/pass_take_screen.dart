import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/zen_theme.dart';

class PassTakeScreen extends StatefulWidget {
  const PassTakeScreen({super.key});

  @override
  State<PassTakeScreen> createState() => _PassTakeScreenState();
}

class _PassTakeScreenState extends State<PassTakeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  final _random = Random();
  String? _result;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    _slideAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -40.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -40.0, end: 40.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 40.0, end: -20.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -20.0, end: 10.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: 0.0), weight: 20),
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

  void _decide() {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
      _result = _random.nextBool() ? 'Take' : 'Pass';
    });

    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final isPass = _result == 'Pass';
    final displayColor = _result == null
        ? ZenTheme.accent
        : isPass ? ZenTheme.stone : ZenTheme.deepSage;

    return Scaffold(
      appBar: AppBar(title: const Text('PASS OR TAKE')),
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
                    ),
                  ),
                ),
                SizedBox(height: mainSize * 0.15),
                GestureDetector(
                  onTap: _decide,
                  child: AnimatedBuilder(
                    animation: _slideAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_slideAnimation.value, 0),
                        child: Container(
                          width: mainSize,
                          height: mainSize,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(mainSize * 32 / 160),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                displayColor,
                                displayColor.withValues(alpha: 0.7),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: displayColor.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              _isAnimating
                                  ? Icons.swap_horiz
                                  : (isPass
                                      ? Icons.close_rounded
                                      : Icons.check_rounded),
                              size: mainSize * 56 / 160,
                              color: ZenTheme.softWhite,
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
                    'Tap to decide',
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
