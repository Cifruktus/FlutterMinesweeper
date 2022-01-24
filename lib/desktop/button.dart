import 'package:flutter/material.dart';
import 'package:minesweeper/widgets/theme.dart';

class WinButton extends StatefulWidget {
  final Widget child;
  final void Function() onPressed;

  const WinButton({Key? key, required this.child, required this.onPressed}) : super(key: key);

  @override
  _WinButtonState createState() => _WinButtonState();
}

class _WinButtonState extends State<WinButton> {
  bool pressed = false;

  static const pressedPadding = EdgeInsets.fromLTRB(1, 1, 0, 0);
  static const unpressedPadding = EdgeInsets.fromLTRB(0.5, 0.5, 0.5, 0.5);

  @override
  Widget build(BuildContext context) {
    var theme = CustomTheme.of(context);
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) => setState(() => pressed = true),
      onTapUp: (_) => setState(() => pressed = false),
      onTapCancel: () => setState(() => pressed = false),
      onPanUpdate: (_) {},
      // to consume this gesture

      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: pressed ? pressedPadding : unpressedPadding,
          decoration: BoxDecoration(
            color: theme.fillColor,
            border: pressed ? theme.loweredBorder : theme.elevatedBorder,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class WinTextButton extends StatefulWidget {
  final Widget child;
  final void Function() onPressed;

  const WinTextButton({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  @override
  _WinTextButtonState createState() => _WinTextButtonState();
}

class _WinTextButtonState extends State<WinTextButton> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    var theme = CustomTheme.of(context);
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) => setState(() => pressed = true),
      onTapUp: (_) => setState(() => pressed = false),
      onTapCancel: () => setState(() => pressed = false),
      onPanUpdate: (_) {},
      // to consume this gesture

      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          decoration: BoxDecoration(
            color: pressed ? theme.windowTitleColor : null,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
