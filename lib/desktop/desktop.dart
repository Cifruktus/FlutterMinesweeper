import 'dart:async';

import 'package:flutter/material.dart';
import 'package:minesweeper/theme.dart';
import 'package:minesweeper/widgets/theme.dart';

class Desktop extends StatefulWidget {
  final Widget desktop;
  final List<Widget> icons;
  final Function(_DesktopState)? onInitState;

  const Desktop({Key? key, required this.desktop, this.icons = const [], this.onInitState}) : super(key: key);

  static _DesktopState of(BuildContext context) =>
      context.findRootAncestorStateOfType<_DesktopState>()!;

  @override
  _DesktopState createState() => _DesktopState();
}

class _DesktopState extends State<Desktop> {
  List<Widget> children = [];
  Map<Key, Completer> childrenCompleters = {};
  Size desktopSize = Size.zero;

  @override
  void initState() {
    super.initState();
    widget.onInitState?.call(this);
  }

  @override
  Widget build(BuildContext context) {
    return CustomTheme(
      data: customThemeData,
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            desktopSize = Size(constraints.maxWidth, constraints.maxHeight);
            return Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: Color(0xFF5595CE),
                    ),
                  ),
                  widget.desktop,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: widget.icons,
                    ),
                  ),
                  ...children
                ],
              );
          }
        ),
        ),
    );
  }

  Future<T?> openWindow<T>(Widget window) {
    assert(window.key != null, "Window have to have a key");
    setState(() {
      children.add(window);
      childrenCompleters[window.key!] = Completer<T?>();
    });
    return childrenCompleters[window.key!]!.future as Future<T?>;
  }

  void requestFocus(Key window) {
    setState(() {
      var child = children.firstWhere((child) => child.key == window);
      children.remove(child);
      children.add(child); //now it's last on the stack
    });
  }

  void closeWindow<T>(Key window, {T? data}) {
    setState(() {
      var child = children.firstWhere((child) => child.key == window);
      var completer = childrenCompleters[child.key!]!;
      children.remove(child);

      if (childrenCompleters[child.key!]!.future is Future<T?>) { // no support for dynamic here
        completer.complete(data);
      } else {
        completer.complete(null);
      }

      childrenCompleters.remove(child.key!);
    });
  }
}