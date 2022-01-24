import 'package:flutter/widgets.dart';
import 'package:minesweeper/theme.dart';


class CustomTheme extends InheritedWidget {
  final CustomThemeData data;

  const CustomTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static CustomThemeData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CustomTheme>()!.data;
  }

  @override
  bool updateShouldNotify(CustomTheme oldWidget) {
    return true;
  }
}