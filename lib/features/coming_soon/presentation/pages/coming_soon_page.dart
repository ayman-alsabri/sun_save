import 'package:flutter/material.dart';

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auto translate')),
      body: Center(
        child: Text(
          'Comming soon',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
