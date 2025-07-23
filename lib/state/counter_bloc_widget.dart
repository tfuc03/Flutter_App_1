import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);
  void increment() => emit(state + 1);
}

class CounterBlocWidget extends StatelessWidget {
  const CounterBlocWidget({super.key});
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => CounterCubit(),
    child: BlocBuilder<CounterCubit, int>(
      builder:
          (context, count) => Row(
            children: [
              const Text('Bloc/Cubit: '),
              Text(
                '$count',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => context.read<CounterCubit>().increment(),
                child: const Text('Tăng'),
              ),
            ],
          ),
    ),
  );
}
