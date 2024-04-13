import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

import '../../view_model/setting/thermal_print_view_model.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late final SettingThermalPrint viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = SettingThermalPrint();
    viewModel.getDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<BluetoothDevice>(
              value: viewModel.selectedDevice,
              hint: const Text('Select Device'),
              items: viewModel.devices.map((device) {
                return DropdownMenuItem(
                  value: device,
                  child: Text(device.name!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  viewModel.selectDevice(value);
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    viewModel.getDevices(); // Refresh devices
                  },
                  child: const Text('Refresh Devices'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await viewModel.toggleConnection();
                    setState(() {}); // Update state after connection toggled
                  },
                  child: Text(viewModel.isConnected ? 'Disconnect' : 'Connect'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                viewModel.print('Hello World');
              },
              child: const Text('Print'),
            ),
          ],
        ),
      ),
    );
  }
}
