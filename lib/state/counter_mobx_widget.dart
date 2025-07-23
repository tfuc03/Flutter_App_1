import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
part 'counter_mobx_widget.g.dart';

class CounterStore = _CounterStore with _$CounterStore;

abstract class _CounterStore with Store {
  @observable
  int count = 0;
  @action
  void increment() => count++;
}

final counterStore = CounterStore();

class CounterMobXWidget extends StatelessWidget {
  const CounterMobXWidget({super.key});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Text('MobX: '),
      Observer(
        builder:
            (_) => Text(
              '${counterStore.count}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
      ),
      const SizedBox(width: 8),
      ElevatedButton(
        onPressed: counterStore.increment,
        child: const Text('Tăng'),
      ),
    ],
  );
}
