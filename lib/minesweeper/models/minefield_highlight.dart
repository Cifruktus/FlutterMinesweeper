import 'package:flutter/foundation.dart';
import 'package:minesweeper/minesweeper/models/minesweeper_cell.dart';
import 'package:minesweeper/minesweeper/models/position.dart';

@immutable
abstract class MinefieldHighlight {
  const MinefieldHighlight();

  MinesweeperCell check(int x, int y, MinesweeperCell cell);
}

class MinefieldHighlightNone extends MinefieldHighlight {
  const MinefieldHighlightNone();

  @override
  MinesweeperCell check(int x, int y, MinesweeperCell cell) {
    return cell;
  }
}

class MousePressed extends MinefieldHighlight {
  final IntPos pos;

  get x => pos.x;

  get y => pos.y;

  const MousePressed(this.pos);

  @override
  MinesweeperCell check(int x, int y, MinesweeperCell cell) {
    if (x == this.x && y == this.y) {
      return cell.copyWith(isPressed: true);
    }
    return cell;
  }
}

class MouseAreaPressed extends MinefieldHighlight {
  final IntPos pos;

  get x => pos.x;

  get y => pos.y;

  const MouseAreaPressed(this.pos);

  @override
  MinesweeperCell check(int x, int y, MinesweeperCell cell) {
    if (this.x - 1 <= x && this.x + 1 >= x && this.y - 1 <= y && this.y + 1 >= y) {
      return cell.copyWith(isPressed: true);
    }
    return cell;
  }
}
