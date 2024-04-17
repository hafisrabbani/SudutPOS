import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

import '../../view_model/setting/thermal_print_view_model.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    viewModel.getDevices();
                  },
                  child: const Text('Refresh Devices'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Atur padding
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await viewModel.toggleConnection();
                    setState(() {});
                  },
                  child: Text(viewModel.isConnected ? 'Disconnect' : 'Connect'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: viewModel.isConnected ? Colors.red : Colors.green, // Warna tombol connect/disconnect
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Atur padding
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Warna tombol print
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Atur padding
              ),
            ),
          ],
        ),
      ),
    );
  }
}
