import 'package:flutter/material.dart';

import 'custom_icons.dart';

class Item {
  const Item(
      {required this.name,
      required this.uid,
      required this.borderColor,
      required this.detailsBorderColor,
      required this.backgroundColor,
      required this.optionsColor,
      required this.optionsBorderColor,
      required this.optionsDropDownColor,
      this.details,
      required this.options,
      required this.asset});
  final String name;
  final IconData asset;
  final String uid;
  final List<String>? details;
  final List<dynamic> options;
  final Color borderColor;
  final Color detailsBorderColor;
  final Color backgroundColor;
  final Color optionsColor;
  final Color optionsDropDownColor;
  final Color optionsBorderColor;
}

final upItem = Item(
    name: 'Up',
    uid: '1',
    backgroundColor: const Color(0xFF7DBF32),
    borderColor: const Color(0xFF6A9E31),
    asset: CustomIcons.up_big,
    details: ["Forward", "Backward"],
    options: List.generate(7, (index) => index + 1),
    detailsBorderColor: const Color(0xFF95D13F),
    optionsBorderColor: const Color(0xFFE4E757),
    optionsDropDownColor: const Color(0xFFB6BB17),
    optionsColor: const Color(0xFFCDDB00));

final backItem = Item(
    name: 'Back',
    uid: '1',
    backgroundColor: Color(0xFFFB7D9D),
    borderColor: Color(0xFFD66A8B),
    asset: CustomIcons.ccw,
    details: ["To the left", "To the right"],
    options: List.generate(7, (index) => index + 1),
    detailsBorderColor: const Color(0xFFFAA7C1),
    optionsBorderColor: const Color(0xFFF6D3DE),
    optionsDropDownColor: const Color(0xFFD48DA3),
    optionsColor: const Color(0xFFFFAFC8));

const lightItem = Item(
    name: 'Light',
    uid: '1',
    backgroundColor: Color(0xFF7272C0),
    borderColor: Color(0xFF6D70A6),
    asset: CustomIcons.lightbulb_1,
    options: ["red", "yellow", "blue", "green"],
    detailsBorderColor: const Color(0xFF8080D8),
    optionsBorderColor: const Color(0xFFDFD0F2),
    optionsDropDownColor: const Color(0xFFAA9DBC),
    optionsColor: const Color(0xFFBFAFD4));

const soundItem = Item(
    name: 'Sound',
    uid: '1',
    backgroundColor: Color(0xFF7272C0),
    borderColor: Color(0xFF6D70A6),
    asset: CustomIcons.volume,
    options: ["Hi", "Goodbye"],
    detailsBorderColor: const Color(0xFF8080D8),
    optionsBorderColor: const Color(0xFFDFD0F2),
    optionsDropDownColor: const Color(0xFFAA9DBC),
    optionsColor: const Color(0xFFBFAFD4));

final loopItem = Item(
    name: 'Loop',
    uid: '1',
    backgroundColor: Color(0xFFFFA400),
    borderColor: Color(0xFFDE8A10),
    asset: CustomIcons.loop,
    options: List.generate(7, (index) => index + 1),
    detailsBorderColor: const Color(0xFFFFB845),
    optionsBorderColor: const Color(0xFFFFE497),
    optionsDropDownColor: const Color(0xFFD8AE48),
    optionsColor: const Color(0xFFFFD34C));
final endLoopItem = Item(
    name: 'EndLoop',
    uid: '1',
    backgroundColor: Color(0xFFFFA400),
    borderColor: Color(0xFFDE8A10),
    asset: CustomIcons.loop,
    options: List.generate(7, (index) => index + 1),
    detailsBorderColor: const Color(0xFFFFB845),
    optionsBorderColor: const Color(0xFFFFE497),
    optionsDropDownColor: const Color(0xFFD8AE48),
    optionsColor: const Color(0xFFFFD34C));

final List<Item> menuItems = [upItem, backItem, lightItem, soundItem, loopItem];

Color getColor(String color) {
  if (color == "red") {
    return Colors.red;
  } else if (color == "yellow") {
    return Colors.yellow;
  } else if (color == "blue") {
    return Colors.blue;
  } else if (color == "green") {
    return Colors.blue;
  } else {
    return Colors.white;
  }
}
