import 'package:flutter/material.dart';

const primaryColor = Color(0xFF29AAE2);
const primaryColorDark = Color.fromARGB(255, 8, 127, 255);
const background = Color(0xFFFFFFFF);
const textColorDark = Color(0xFF344D67);
const textColorLight = Color(0xFF6B728E);
const dividerColor = Color.fromARGB(255, 228, 223, 223);
const hintColor = Colors.grey;
const bottomNavbarActiveColor = Color.fromARGB(255, 8, 127, 255);
const bottomNavbarInactiveColor = Color.fromARGB(81, 8, 127, 255);
const userWalletRearColor = Color(0xff232B40);
const userWalletColorDark = Color(0xFF29AAE2);
const userWalletColorLight = Color.fromARGB(255, 170, 226, 251);
const aiWalletColorDark = Color(0xFF3451D4);
const aiWalletColorLight = Color.fromARGB(255, 149, 168, 255);
const rewardCardColor = Color(0xFF00337C);

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

Color getStatusColor(String status) {
  switch (status) {
    case 'approved':
    case 'complete':
    case 'open':
      return Colors.green;
    case 'pending':
    case 'partial':
      return Colors.orange;
    case 'rejected':
    case 'closed':
      return Colors.red;
    case 'transfered':
    case 'running':
      return Colors.blue;
    case 'invested':
      return Colors.purple;
    case 'withdrawn':
      return Colors.deepPurpleAccent;
    default:
      return textColorDark;
  }
}
