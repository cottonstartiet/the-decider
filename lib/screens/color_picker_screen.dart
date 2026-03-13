import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/zen_theme.dart';

class ColorPickerScreen extends StatefulWidget {
  const ColorPickerScreen({super.key});

  @override
  State<ColorPickerScreen> createState() => _ColorPickerScreenState();
}

class _ColorPickerScreenState extends State<ColorPickerScreen>
    with SingleTickerProviderStateMixin {
  static const _colors = [
    _ColorOption('Red', Color(0xFFCF6B6B)),
    _ColorOption('Green', Color(0xFF6BAF6B)),
    _ColorOption('Yellow', Color(0xFFD4C36A)),
    _ColorOption('Blue', Color(0xFF6B8FCF)),
  ];

  late AnimationController _controller;
  late Animation<double> _animation;
  final _random = Random();
  int? _selectedIndex;
  bool _isSpinning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
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

  void _pick() {
    if (_isSpinning) return;

    setState(() {
      _isSpinning = true;
      _selectedIndex = _random.nextInt(_colors.length);
    });

    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('COLOR PICKER')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final mainSize = min(constraints.maxWidth * 0.75, constraints.maxHeight * 0.45);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: (_selectedIndex != null && !_isSpinning) ? 1.0 : 0.0,
                  child: Text(
                    _selectedIndex != null ? _colors[_selectedIndex!].name : '',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      letterSpacing: 4,
                    ),
                  ),
                ),
                SizedBox(height: mainSize * 0.15),
                GestureDetector(
                  onTap: _pick,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      final rotation = _animation.value * pi * 8;
                      return Transform.rotate(
                        angle: rotation,
                        child: _ColorWheel(
                          colors: _colors,
                          selectedIndex:
                              _isSpinning ? null : _selectedIndex,
                          size: mainSize,
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
                    'Tap the wheel',
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

class _ColorOption {
  final String name;
  final Color color;
  const _ColorOption(this.name, this.color);
}

class _ColorWheel extends StatelessWidget {
  final List<_ColorOption> colors;
  final int? selectedIndex;
  final double size;

  const _ColorWheel({required this.colors, this.selectedIndex, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring with shadow
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: ZenTheme.stone.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
          ),
          // Four quadrants
          for (int i = 0; i < colors.length; i++)
            Transform.rotate(
              angle: i * pi / 2,
              child: ClipPath(
                clipper: _QuadrantClipper(),
                child: Container(
                  width: size,
                  height: size,
                  color: selectedIndex == i
                      ? colors[i].color
                      : colors[i].color.withValues(alpha: 0.7),
                ),
              ),
            ),
          // Center dot
          Container(
            width: size * 32 / 180,
            height: size * 32 / 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ZenTheme.softWhite,
              border: Border.all(color: ZenTheme.warmBeige, width: size * 2 / 180),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuadrantClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    return Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(center.dx + radius, center.dy)
      ..arcToPoint(
        Offset(center.dx, center.dy - radius),
        radius: Radius.circular(radius),
        clockwise: false,
      )
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
