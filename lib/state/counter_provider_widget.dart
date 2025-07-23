import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CounterModel with ChangeNotifier {
  int _count = 0;
  int get count => _count;
  void increment() {
    _count++;
    notifyListeners();
  }
}

class CounterProviderWidget extends StatelessWidget {
  const CounterProviderWidget({super.key});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Text('Provider: '),
      Consumer<CounterModel>(
        builder:
            (context, counter, child) => Text(
              '${counter.count}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
      ),
      const SizedBox(width: 8),
      Consumer<CounterModel>(
        builder:
            (context, counter, child) => ElevatedButton(
              onPressed: counter.increment,
              child: const Text('Tăng'),
            ),
      ),
    ],
  );
}
