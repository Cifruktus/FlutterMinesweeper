import 'package:flutter/foundation.dart';

@immutable
class MinesweeperCell {
  final bool hasMine;
  final bool isOpened;
  final bool isMarked;
  final bool isPressed;
  final int bombsAround;

  const MinesweeperCell(
      {this.bombsAround = 0,
      this.isPressed = false,
      this.hasMine = false,
      this.isOpened = false,
      this.isMarked = false});

  MinesweeperCell copyWith({
    bool? hasMine,
    bool? isOpened,
    bool? isMarked,
    bool? isPressed,
    int? bombsAround,
  }) {
    return MinesweeperCell(
      hasMine: hasMine ?? this.hasMine,
      isMarked: isMarked ?? this.isMarked,
      isOpened: isOpened ?? this.isOpened,
      isPressed: isPressed ?? this.isPressed,
      bombsAround: bombsAround ?? this.bombsAround,
    );
  }
}
