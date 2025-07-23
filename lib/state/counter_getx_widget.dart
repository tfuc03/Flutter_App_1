import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CounterController extends GetxController {
  var count = 0.obs;
  void increment() => count.value++;
}

class CounterGetXWidget extends StatelessWidget {
  CounterGetXWidget({super.key});
  final CounterController controller = Get.put(CounterController());
  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Text('GetX: '),
      Obx(
        () => Text(
          '${controller.count}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox(width: 8),
      ElevatedButton(
        onPressed: controller.increment,
        child: const Text('Tăng'),
      ),
    ],
  );
}
