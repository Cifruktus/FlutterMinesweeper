import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minesweeper/desktop/button.dart';
import 'package:minesweeper/desktop/desktop.dart';
import 'package:minesweeper/widgets/theme.dart';

class Window extends StatefulWidget {
  static _WindowState of(BuildContext context) =>
      context.findRootAncestorStateOfType<_WindowState>()!;

  final Widget child;
  final String title;
  final Widget? icon;
  final Key appKey;
  final bool centered;
  final Size expectedSize;

  const Window({
    Key? key,
    required this.child,
    required this.appKey,
    required this.title,
    this.icon,
    this.centered = true,
    this.expectedSize = const Size(50, 100),
  }) : super(key: key);

  @override
  _WindowState createState() => _WindowState();
}

class _WindowState extends State<Window> {
  static const defaultOffset = Offset(15,15);
  static const defaultRandomness = Offset(15,15);
  Offset position = Offset.zero;
  Size? desktopSize;

  bool focused = false;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();

    focusNode = FocusNode(
      skipTraversal: true,
      canRequestFocus: true,
    );

    focusNode.addListener(() {
      setState(() {
        focused = focusNode.hasFocus;
      });
    });

    var r = Random();
    position = Offset(r.nextDouble() * defaultRandomness.dx, r.nextDouble()* defaultRandomness.dy);
  }

  void ensureFocused() {
    if (focused) return;
    Desktop.of(context).requestFocus(widget.appKey);
    focusNode.requestFocus();
  }

  void move(Offset offset) {
    ensureFocused();
    setState(() {
      position = position.translate(offset.dx, offset.dy);
    });
  }

  void close<K>({K? data}) {
    Desktop.of(context).closeWindow(widget.appKey, data: data);
  }

  @override
  Widget build(BuildContext context) {
    var theme = CustomTheme.of(context);
    desktopSize ??= Desktop.of(context).desktopSize;

    var offset = widget.centered
        ? (Offset(desktopSize!.width, desktopSize!.height)) / 2 +
            position -
        (Offset(widget.expectedSize.width, widget.expectedSize.height) / 2)
        : defaultOffset + position;

    return Positioned(
        left: offset.dx,
        top: offset.dy,
        child: Focus(
          autofocus: true,
          focusNode: focusNode,
          child: GestureDetector(
            onTapDown: focused ? null : (_) => ensureFocused(),
            onSecondaryTapDown: focused ? null : (_) => ensureFocused(),
            child: Container(
                decoration: BoxDecoration(
                  color: theme.fillColor,
                  border: theme.elevatedBorder,
                ),
                child: IntrinsicWidth(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        onTapDown: (_) => ensureFocused(),
                        onSecondaryTapDown: (_) => ensureFocused(),
                        onPanUpdate: (details) => move(details.delta),
                        child: Container(
                          height: 25,
                          width: 100,
                          color: focused ? theme.windowTitleColor : Colors.grey,
                          padding: EdgeInsets.all(4),
                          child: Row(
                            children: [
                              if (widget.icon != null)
                                Container(
                                  padding: EdgeInsets.only(right: 4),
                                  height: 25,
                                  child: widget.icon,
                                ),
                              Expanded(
                                child: Text(
                                  widget.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              WinButton(
                                child: Image.asset(
                                  "assets/win/close.png",
                                  color: Colors.black87,
                                ),
                                onPressed: close,
                              )
                            ],
                          ),
                        ),
                      ),
                      IgnorePointer(
                        ignoring: !focused,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: widget.child,
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ));
  }
}
