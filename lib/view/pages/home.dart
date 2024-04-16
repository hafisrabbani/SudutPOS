import 'package:flutter/material.dart';
import 'package:sudut_pos/view_model/setting/thermal_print_view_model.dart';
class Testinggg extends StatefulWidget {
  const Testinggg({super.key});

  @override
  State<Testinggg> createState() => _TestingggState();
}

class _TestingggState extends State<Testinggg> {
  final viewModel = SettingThermalPrint();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            viewModel.checkConnection().then((value) {
              if (value!) {
                viewModel.print('Hello World');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select and connect to a device.'),
                  ),
                );
              }
            });
          },
          child: const Text('Print'),
        ),
      ),
    );
  }
}
