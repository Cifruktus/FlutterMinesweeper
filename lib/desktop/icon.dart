import 'package:flutter/material.dart';

class WinDesktopIcon extends StatefulWidget {
  final Widget child;
  final String text;
  final void Function(BuildContext context) onPressed;

  const WinDesktopIcon({
    Key? key,
    required this.child,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  _WinDesktopIconState createState() => _WinDesktopIconState();
}

class _WinDesktopIconState extends State<WinDesktopIcon> {
  bool pressed = false;
  bool hovering = false;

  static const double iconSize = 70.0;

  @override
  Widget build(BuildContext context) {
    final idleDecoration = BoxDecoration(
      border: Border.all(
          width: 1,
          color: Colors.transparent
      ),
    );

    final hoverDecoration = BoxDecoration(
      border: Border.all(
          width: 1,
          color: Colors.white38
      ),
      color: Colors.white12,
    );

    return GestureDetector(
      onDoubleTap: () => widget.onPressed(context),
      onTapDown: (_) => setState(() => pressed = true),
      onTapUp: (_) => setState(() => pressed = false),
      onTapCancel: () => setState(() => pressed = false),
      onPanUpdate: (_){}, // to consume this gesture

      child: Padding(
        padding: EdgeInsets.all(4),
        child: MouseRegion(
          onEnter: (_) => setState(() => hovering = true),
          onExit: (_) => setState(() => hovering = false),
          cursor: SystemMouseCursors.click,
          child: Container(
            decoration: hovering ? hoverDecoration : idleDecoration,
            width: iconSize,
            //height: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                    constraints: BoxConstraints.tight(Size(iconSize,iconSize * 0.7)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                      child: widget.child,
                    )),
                Text(
                  widget.text,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    shadows: const [
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        color: Color(0xFF000000),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
