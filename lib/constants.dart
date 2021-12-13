import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

Map<String, dynamic> appColors = {
  'darkMode' : true,
  'back' : HexColor("#221e31"),
  '1' : HexColor("#332e46"),
  '2' : HexColor("#454058"),
  'gradients' : [
    [HexColor('#F050AE'), HexColor('#9336FD')]
  ],
  'highlight': [HexColor("#0092ff"), HexColor("#f7bd64") ,HexColor("#ea5e93")],
};

class HiCardsTheme {

  static final iconColor = HexColor("1f1f1f");

  static final inputBackgroundColor = HexColor("#eeeff1");

}