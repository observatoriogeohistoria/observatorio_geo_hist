import 'package:flutter/services.dart';

class MonthYearInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.length > 6) text = text.substring(0, 6);

    String formatted = "";
    if (text.length >= 2) {
      String month = text.substring(0, 2);

      int? monthInt = int.tryParse(month);
      if (monthInt != null && (monthInt < 1 || monthInt > 12)) {
        return oldValue;
      }

      formatted = month;
      if (text.length > 2) {
        formatted += "/${text.substring(2)}";
      }
    } else {
      formatted = text;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
