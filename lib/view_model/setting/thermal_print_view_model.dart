import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:intl/intl.dart';
import 'package:sudut_pos/utility/common.dart';

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

  Future<bool?> checkConnection() async {
    bool? isConnected = await printer!.isConnected;
    if (isConnected == true) {
      _isConnected = true;
    } else {
      _isConnected = false;
    }
    return await printer!.isConnected;
  }

  Future<void> print(String s) async {
    if (_isConnected) {
      printer!.printNewLine();
      printer!.printCustom('Sudut Cafe', 3, 1);
      printer!.printNewLine();
      printer!.printCustom('Jl. ITS Sukolilo Surabaya', 1, 1);
      printer!.printCustom('Telp. 085830556606', 1, 1);
      printer!.printNewLine();
      printer!.printNewLine();
      printer!.paperCut();
    } else {
      print('Please select and connect to a device.');
    }
  }

  Future<void> printReceipt(Map<String, dynamic> data) async {
    if (_isConnected) {
      printer!.printNewLine();
      printer!.printCustom('Sudut Cafe', 3, 1);
      printer!.printNewLine();
      printer!.printCustom('Jl. ITS Sukolilo Surabaya', 1, 1);
      printer!.printCustom('Telp. 085830556606', 1, 1);
      printer!.printNewLine();

      final transactionData = data['transaction'];
      final detailsData = data['details'];

      printer!.printLeftRight('ID Trx :',
          '${transactionData['id']}', 1);
      printer!
          .printLeftRight('Table Number : ',
          '${transactionData['tableNumber']}', 0);
      printer!
          .printCustom('Trx Time : ${DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.parse(transactionData['createdTime']))}', 0, 0);
      printer!.printNewLine();
      printer!.printCustom('Item : ', 1, 0);
      detailsData.forEach((detail) {
        printer!.printCustom('${detail['productName']}', 1, 0);
        printer!.printLeftRight('${detail['quantity']} pcs ',
            CommonUtils().cvIDRCurrency(detail['price']), 0);
        printer!.printNewLine();
      });
      printer!.printCustom('Sub Total : ${CommonUtils().cvIDRCurrency(calculateSubTotal(detailsData))}', 1, 0);
      printer!.printCustom('Discount : ${CommonUtils().buildDiscountText(transactionData['discType'], transactionData['discValue'])}', 1, 0);
      printer!.printCustom('Total : ${CommonUtils().cvIDRCurrency(transactionData['total'])}', 1, 0);
      printer!.printCustom('Nominal : ${CommonUtils().cvIDRCurrency(transactionData['nominalPayment'])}', 1, 0);
      printer!.printCustom('Change : ${CommonUtils().cvIDRCurrency(transactionData['change'])}', 1, 0);
      printer!.printNewLine();
      printer!.printNewLine();
      printer!.printCustom('Terima kasih', 1, 1);
      printer!.printCustom('Sudah belanja di Sudut Cafe', 1, 1);
      printer!.printCustom('powered by SudutPOS', 1, 1);
      printer!.paperCut();
    } else {
      print('Please select and connect to a device.');
    }
  }

  Future<void> printReceiptStaff(Map<String, dynamic> data) async {
    if (_isConnected) {
      final transactionData = data['transaction'];
      final detailsData = data['details'];
      printer!.printLeftRight('ID Trx :',
          '${transactionData['id']}', 1);
      printer!
          .printLeftRight('Table Number : ',
          '${transactionData['tableNumber']}', 0);
      printer!
          .printCustom('Trx Time : ${DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.parse(transactionData['createdTime']))}', 0, 0);
      printer!.printNewLine();
      printer!.printCustom('Item : ', 1, 0);
      detailsData.forEach((detail) {
        printer!.printCustom('${detail['productName']}', 1, 0);
        printer!.printLeftRight('${detail['quantity']} pcs ',
            CommonUtils().cvIDRCurrency(detail['price']), 0);
        printer!.printNewLine();
      });
      printer!.printNewLine();
      printer!.paperCut();
    } else {
      print('Please select and connect to a device.');
    }
  }

  double calculateSubTotal(List<dynamic> details) {
    double total = 0;
    for (var detail in details) {
      total += detail['price'] * detail['quantity'];
    }
    return total;
  }
}
