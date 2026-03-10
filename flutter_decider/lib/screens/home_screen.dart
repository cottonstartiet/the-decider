import 'package:flutter/material.dart';
import '../theme/zen_theme.dart';
import 'coin_flip_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = [
      _ToolItem(
        title: 'Heads or Tails',
        subtitle: 'Flip a coin',
        icon: Icons.monetization_on_outlined,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CoinFlipScreen()),
        ),
      ),
      _ToolItem(
        title: 'Coming Soon',
        subtitle: 'More tools ahead',
        icon: Icons.more_horiz,
        onTap: null,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              Text(
                'Decider',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Let go of the weight of choosing.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 40),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: tools.length,
                  itemBuilder: (context, index) => _ToolCard(tool: tools[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToolItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  const _ToolItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
}

class _ToolCard extends StatelessWidget {
  final _ToolItem tool;
  const _ToolCard({required this.tool});

  @override
  Widget build(BuildContext context) {
    final isDisabled = tool.onTap == null;
    return GestureDetector(
      onTap: tool.onTap,
      child: Card(
        child: Opacity(
          opacity: isDisabled ? 0.45 : 1.0,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  tool.icon,
                  size: 36,
                  color: isDisabled ? ZenTheme.stone : ZenTheme.deepSage,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tool.title,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: isDisabled ? ZenTheme.stone : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tool.subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
