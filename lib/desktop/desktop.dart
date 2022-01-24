import 'package:flutter/material.dart';
import 'package:minesweeper/desktop/icon.dart';
import 'package:minesweeper/minesweeper/view/page.dart';
import 'package:minesweeper/theme.dart';
import 'package:minesweeper/widgets/theme.dart';

class Desktop extends StatefulWidget {
  final Widget desktop;

  const Desktop({Key? key, required this.desktop}) : super(key: key);

  static MyInheritedData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MyInheritedData>() as MyInheritedData;

  @override
  _DesktopState createState() => _DesktopState();
}

class _DesktopState extends State<Desktop> {
  List<Widget> children = [];

  @override
  void initState() {
    super.initState();
    children.add(MinesweeperWindow(
      key: UniqueKey(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return CustomTheme(
      data: customThemeData,
      child: Scaffold(
        body: MyInheritedData(
          requestFocus: requestFocus,
          close: closeWindow,
          pushRoute: openWindow,
          child: Stack(
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
                        setState(() {
                          children.add(MinesweeperWindow(
                            key: UniqueKey(),
                          ));
                          // todo remove all dependencies outside desktop package
                        });
                      },
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
      ),
    );
  }

  void openWindow(Widget window) {
    setState(() {
      children.add(window);
    });
  }

  void requestFocus(Key window) {
    setState(() {
      var child = children.firstWhere((child) => child.key == window);
      children.remove(child);
      children.add(child); //now it's last on the stack
    });
  }

  void closeWindow(Key window) {
    setState(() {
      children.remove(children.firstWhere((child) => child.key == window));
    });
  }
}

class MyInheritedData extends InheritedWidget {
  final void Function(Widget window) pushRoute;
  final void Function(Key window) close;
  final void Function(Key window) requestFocus;

  const MyInheritedData({
    Key? key,
    required this.pushRoute,
    required Widget child,
    required this.close,
    required this.requestFocus,
  }) : super(key: key, child: child);

  static MyInheritedData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInheritedData>()!;
  }

  @override
  bool updateShouldNotify(MyInheritedData oldWidget) {
    return false;
  }
}
