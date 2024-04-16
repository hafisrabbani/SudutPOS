import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class SettingThermalPrint {
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter? printer = BlueThermalPrinter.instance;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  Future<void> getDevices() async {
    List<BluetoothDevice> bondedDevices = await printer!.getBondedDevices();
    devices = bondedDevices;
  }

  void selectDevice(BluetoothDevice? device) {
    selectedDevice = device;
  }

  Future<void> toggleConnection() async {
    if (selectedDevice != null) {
      if (_isConnected) {
        await printer!.disconnect();
        _isConnected = false;
      } else {
        bool connected = await printer!.connect(selectedDevice!);
        if (connected) {
          _isConnected = true;
        }
      }
    }
  }

  Future<bool?> checkConnection() async{
    bool? isConnected = await printer!.isConnected;
    if(isConnected == true){
      _isConnected = true;
    } else {
      _isConnected = false;
    }
    return await printer!.isConnected;
  }

  Future<void> print(String s) async {
    if (_isConnected) {
      printer!.printNewLine();
      printer!.printCustom('Hello World', 3, 1);
      printer!.printNewLine();
      printer!.print3Column('Sudut Pos', '1', 'Rp. 100.000', 1);
      printer!.paperCut();
    } else {
      print('Please select and connect to a device.');
    }
  }
}