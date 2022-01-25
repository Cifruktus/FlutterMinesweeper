import 'dart:async';

import 'package:flutter/material.dart';
import 'package:minesweeper/desktop/icon.dart';
import 'package:minesweeper/minesweeper/view/page.dart';
import 'package:minesweeper/theme.dart';
import 'package:minesweeper/widgets/theme.dart';

class Desktop extends StatefulWidget {
  final Widget desktop;

  const Desktop({Key? key, required this.desktop}) : super(key: key);

  static _DesktopState of(BuildContext context) =>
      context.findRootAncestorStateOfType<_DesktopState>()!;

  @override
  _DesktopState createState() => _DesktopState();
}

class _DesktopState extends State<Desktop> {
  List<Widget> children = [];
  Map<Key, Completer> childrenCompleters = {};

  @override
  void initState() {
    super.initState();
    openWindow(MinesweeperWindow(key: UniqueKey()));
  }

  @override
  Widget build(BuildContext context) {
    return CustomTheme(
      data: customThemeData,
      child: Scaffold(
        body: Stack(
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
                  children: [
                    WinDesktopIcon(
                      onPressed: () {
                        //todo add link to github
                      },
                      child: Image.asset(
                        "assets/icons/git_logo.png",
                        fit: BoxFit.contain,
                      ),
                      text: "Visit github page.exe",
                    ),
                    WinDesktopIcon(
                      onPressed: () {
                        openWindow(MinesweeperWindow(key: UniqueKey()));
                      }, // todo remove all dependencies outside desktop package
                      child: Image.asset(
                        "assets/icons/mine_logo.png",
                        fit: BoxFit.contain,
                      ),
                      text: "Mine-sweeper",
                    ),
                  ],
                ),
              ),
              ...children
            ],
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