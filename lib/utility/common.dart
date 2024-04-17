import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class CommonUtils{
  String cvIDRCurrency(double price) {
    String formattedPrice = 'Rp ${price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    )}';
    return formattedPrice.replaceAll(RegExp(r'\.0+$'), '');
  }


  TextEditingValue formatThousand(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 3) {
      final int textLength = newValue.text.length;
      int commaCount = (textLength - 1) ~/ 3;
      int totalLength = textLength + commaCount;
      final StringBuffer newText = StringBuffer();
      int i = 0;
      int j = 0;
      while (i < totalLength) {
        if (j < textLength && (textLength - j) % 3 == 0) {
          newText.write(',');
          i++;
        } else {
          newText.write(newValue.text[j]);
          j++;
          i++;
        }
      }
      return TextEditingValue(
        text: newText.toString(),
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
    return newValue;
  }

  int generateTransactionId(){
    return 100000 + (DateTime.now().millisecondsSinceEpoch % 900000);
  }

  String dateTimeFormatter(DateTime dateTime, String format) {
    return DateFormat(format).format(dateTime);
  }

  String convertToDiscType(int type){
    return (type == 0) ? 'Percentage' : 'Nominal';
  }

  String buildDiscountText(int discType, double discValue) {
    if (discType == 0) {
      return '${discValue.toString()}%';
    } else {
      return CommonUtils().cvIDRCurrency(discValue);
    }
  }

}