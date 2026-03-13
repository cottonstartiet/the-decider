import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/zen_theme.dart';

class DiceRollerScreen extends StatefulWidget {
  const DiceRollerScreen({super.key});

  @override
  State<DiceRollerScreen> createState() => _DiceRollerScreenState();
}

class _DiceRollerScreenState extends State<DiceRollerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isRolling = false;
  String? _result;
  int _dieValue = 1;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _isRolling = false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _rollDice() {
    if (_isRolling) return;

    final value = _random.nextInt(6) + 1;
    setState(() {
      _isRolling = true;
      _dieValue = value;
      _result = '$value';
    });

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DICE ROLLER')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final mainSize = min(constraints.maxWidth * 0.75, constraints.maxHeight * 0.45);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Result text
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: (_result != null && !_isRolling) ? 1.0 : 0.0,
                  child: Text(
                    _result != null ? 'You rolled a $_result' : '',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      letterSpacing: 4,
                    ),
                  ),
                ),
                SizedBox(height: mainSize * 0.15),
                // Die
                GestureDetector(
                  onTap: _rollDice,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      final t = _animation.value;
                      // Multiple full rotations on both axes
                      final rotX = t * 4 * pi;
                      final rotY = t * 3 * pi;
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateX(rotX)
                          ..rotateY(rotY),
                        child: _DieFace(value: _dieValue, size: mainSize),
                      );
                    },
                  ),
                ),
                SizedBox(height: mainSize * 0.15),
                // Instruction
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _isRolling ? 0.0 : 1.0,
                  child: Text(
                    'Tap to roll',
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

class _DieFace extends StatelessWidget {
  final int value;
  final double size;
  const _DieFace({required this.value, required this.size});

  static const _dieFaces = ['⚀', '⚁', '⚂', '⚃', '⚄', '⚅'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 16 / 160),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ZenTheme.deepSage, Color(0xFF4A6A4C)],
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
          _dieFaces[value - 1],
          style: TextStyle(
            fontSize: size * 72 / 160,
            color: ZenTheme.softWhite,
          ),
        ),
      ),
    );
  }
}
