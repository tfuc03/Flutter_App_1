import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

int counterReducer(int state, dynamic action) {
  if (action == 'INCREMENT') return state + 1;
  return state;
}

class CounterReduxWidget extends StatelessWidget {
  final Store<int> store = Store<int>(counterReducer, initialState: 0);
  CounterReduxWidget({super.key});
  @override
  Widget build(BuildContext context) => StoreProvider<int>(
    store: store,
    child: Row(
      children: [
        const Text('Redux: '),
        StoreConnector<int, int>(
          converter: (store) => store.state,
          builder:
              (context, count) => Text(
                '$count',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => store.dispatch('INCREMENT'),
          child: const Text('Tăng'),
        ),
      ],
    ),
  );
}
