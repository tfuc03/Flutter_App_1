import 'package:flutter/material.dart';

class CounterInherited extends InheritedWidget {
  final int counter;
  final void Function() increment;
  const CounterInherited({
    super.key,
    required this.counter,
    required this.increment,
    required super.child,
  });
  static CounterInherited? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CounterInherited>();
  @override
  bool updateShouldNotify(CounterInherited oldWidget) =>
      counter != oldWidget.counter;
}

class CounterInheritedWidget extends StatefulWidget {
  const CounterInheritedWidget({super.key});
  @override
  State<CounterInheritedWidget> createState() => _CounterInheritedWidgetState();
}

class _CounterInheritedWidgetState extends State<CounterInheritedWidget> {
  int _counter = 0;
  void _increment() => setState(() => _counter++);
  @override
  Widget build(BuildContext context) => CounterInherited(
    counter: _counter,
    increment: _increment,
    child: Builder(
      builder:
          (context) => Row(
            children: [
              const Text('InheritedWidget: '),
              Text(
                '${CounterInherited.of(context)!.counter}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: CounterInherited.of(context)!.increment,
                child: const Text('Tăng'),
              ),
            ],
          ),
    ),
  );
}
