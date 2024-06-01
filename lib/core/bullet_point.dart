import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BulletFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    final lines = text.split('\n');

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].trim().isNotEmpty && !lines[i].startsWith('• ')) {
        lines[i] = '• ' + lines[i].trim();
      }
    }

    final modifiedText = lines.join('\n');
    final newTextLength = modifiedText.length;
    final cursorPosition = newValue.selection.baseOffset +
        (newTextLength - oldValue.text.length);

    return newValue.copyWith(
      text: modifiedText,
      selection: TextSelection.fromPosition(
        TextPosition(offset: cursorPosition),
      ),
    );
  }
}
