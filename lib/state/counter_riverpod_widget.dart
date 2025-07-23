import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateProvider<int>((ref) => 0);

class CounterRiverpodWidget extends ConsumerWidget {
  const CounterRiverpodWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Row(
      children: [
        const Text('Riverpod: '),
        Text('$count', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => ref.read(counterProvider.notifier).state++,
          child: const Text('Tăng'),
        ),
      ],
    );
  }
}
