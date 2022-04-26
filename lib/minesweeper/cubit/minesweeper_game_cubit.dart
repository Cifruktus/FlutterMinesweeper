import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:minesweeper/minesweeper/models/minefield_highlight.dart';
import 'package:minesweeper/minesweeper/models/minesweeper_cell.dart';
import 'package:minesweeper/minesweeper/models/minesweeper_settings.dart';
import 'package:minesweeper/minesweeper/models/position.dart';
import 'package:minesweeper/minesweeper/ticker.dart';

part 'minesweeper_game_state.dart';

class MinesweeperGameCubit extends Cubit<MinesweeperGameState> {
  final Ticker _ticker;
  StreamSubscription<int>? _tickerSubscription;

  factory MinesweeperGameCubit(MinesweeperSettings settings) {
    var field = generateField(settings.width, settings.height);
    return MinesweeperGameCubit._(field, settings.bombs, Ticker());
  }

  MinesweeperGameCubit._(
    List<List<MinesweeperCell>> field,
    int bombs,
    this._ticker,
  ) : super(MinesweeperGameInitial(
          field: field,
          bombsCount: bombs,
        ));

  void openCell(IntPos pos) {
    var state = this.state;

    if (state.field[pos.x][pos.y].isMarked) return;

    if (state is MinesweeperGameInitial) {
      var board = copyField(state.field);

      fillWithMines(board, state.bombsCount);
      countNeighbours(board);

      emit(MinesweeperGameGoing(field: board, bombsCount: state.bombsCount));
      state = this.state;

      _tickerSubscription?.cancel();
      _tickerSubscription = _ticker.tick().listen(timerTick);

      // won't return, still need to open the cell
    }

    if (state is MinesweeperGameGoing) {
      var board = copyField(state.field);

      bool hitAMine = false;
      if (state.field[pos.x][pos.y].isOpened) {
        if (!isSafe(state.field, pos)) return;
        hitAMine = openSurrounding(board, pos);
      } else {
        hitAMine = openAllFreeCells(board, pos);
      }

      if (hitAMine) {
        emit(MinesweeperGameFinished(
          field: board,
          victory: false,
          bombsCount: state.bombsCount,
          time: state.time,
        ));
        _tickerSubscription?.cancel();
        return;
      }
      if (isWon(board)) {
        emit(MinesweeperGameFinished(
          field: board,
          victory: true,
          bombsCount: state.bombsCount,
          time: state.time,
        ));
        _tickerSubscription?.cancel();
        return;
      }
      emit(state.copyWith(
        field: board,
        modifier: MinefieldHighlightNone(),
        minesDistributed: true,
      ));
    }
  }

  void timerTick(int count) {
    var state = this.state;
    if (state is MinesweeperGameGoing) {
      emit(state.copyWith(time: count));
    }
  }

  int countBombsLeft() {
    return state.bombsCount - countMarked(state.field);
  }

  void resetGame() {
    var field = generateField(state.width, state.height);
    emit(MinesweeperGameInitial(field: field, bombsCount: state.bombsCount));
  }

  void setSettings(MinesweeperSettings settings) {
    var field = generateField(settings.width, settings.height);
    emit(MinesweeperGameInitial(field: field, bombsCount: settings.bombs));
  }

  void pressCell(IntPos pos) {
    var state = this.state;

    if (state is MinesweeperGameGoing) {
      if (state.field[pos.x][pos.y].isOpened) {
        emit(state.copyWith(modifier: MouseAreaPressed(pos)));
      } else if (!state.field[pos.x][pos.y].isMarked) {
        emit(state.copyWith(modifier: MousePressed(pos)));
      }
    }

    if (state is MinesweeperGameInitial) {
      emit(state.copyWith(modifier: MousePressed(pos)));
    }
  }

  void unPressCell() {
    var state = this.state;

    if (state is MinesweeperGameGoing) {
      emit(state.copyWith(modifier: MinefieldHighlightNone()));
    }

    if (state is MinesweeperGameInitial) {
      emit(state.copyWith(modifier: MinefieldHighlightNone()));
    }
  }

  markCell(IntPos pos) {
    var state = this.state;

    if (state is MinesweeperGameGoing) {
      var board = copyField(state.field);
      var cell = board[pos.x][pos.y];
      if (cell.isOpened) return;

      board[pos.x][pos.y] = cell.copyWith(isMarked: !cell.isMarked);

      emit(state.copyWith(field: board));
    }
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}

bool isSafe(List<List<MinesweeperCell>> field, IntPos pos) {
  var expectedBombs = 0;

  for (int nI = -1; nI <= 1; nI++) {
    for (int nJ = -1; nJ <= 1; nJ++) {
      if (pos.x + nI < 0 || pos.x + nI >= field.length) continue;
      if (pos.y + nJ < 0 || pos.y + nJ >= field[pos.x + nI].length) continue;
      if (field[pos.x + nI][pos.y + nJ].isMarked) expectedBombs++;
    }
  }

  return expectedBombs == field[pos.x][pos.y].bombsAround;
}

// true if we hit a mine
bool openSurrounding(List<List<MinesweeperCell>> field, IntPos pos) {
  bool hitAMine = false;

  for (int nI = -1; nI <= 1; nI++) {
    for (int nJ = -1; nJ <= 1; nJ++) {
      if (pos.x + nI < 0 || pos.x + nI >= field.length) continue;
      if (pos.y + nJ < 0 || pos.y + nJ >= field[pos.x + nI].length) continue;
      var cell = field[pos.x + nI][pos.y + nJ];

      if (!cell.isOpened && !cell.isMarked) {
        openAllFreeCells(field, IntPos(pos.x + nI, pos.y + nJ));
        hitAMine |= cell.hasMine;
      }
    }
  }

  return hitAMine;
}

// true if we hit a mine
bool openAllFreeCells(List<List<MinesweeperCell>> field, IntPos pos) {
  field[pos.x][pos.y] = field[pos.x][pos.y].copyWith(isOpened: true);

  if (field[pos.x][pos.y].hasMine) return true;
  if (field[pos.x][pos.y].bombsAround != 0) return false;

  for (int nI = -1; nI <= 1; nI++) {
    for (int nJ = -1; nJ <= 1; nJ++) {
      if (pos.x + nI < 0 || pos.x + nI >= field.length) continue;
      if (pos.y + nJ < 0 || pos.y + nJ >= field[pos.x + nI].length) continue;
      var cell = field[pos.x + nI][pos.y + nJ];
      if (!cell.isOpened && !cell.isMarked) {
        openAllFreeCells(field, IntPos(pos.x + nI, pos.y + nJ));
      }
    }
  }

  return false;
}

void fillWithMines(List<List<MinesweeperCell>> field, minesCount) {
  filling:
  for (int i = 0; i < field.length; i++) {
    for (int j = 0; j < field[i].length; j++) {
      field[i][j] = field[i][j].copyWith(hasMine: true);
      minesCount--;
      if (minesCount == 0) break filling;
    }
  }

  // shuffle ->
  var r = Random();

  for (int i = 0; i < field.length; i++) {
    for (int j = 0; j < field[i].length; j++) {
      var moveTo = IntPos(r.nextInt(field.length), r.nextInt(field[0].length));

      var tmp = field[i][j];
      field[i][j] = field[moveTo.x][moveTo.y];
      field[moveTo.x][moveTo.y] = tmp;
    }
  }
}

List<List<MinesweeperCell>> countNeighbours(List<List<MinesweeperCell>> field) {
  // what the for are you doing here?!
  for (int i = 0; i < field.length; i++) {
    for (int j = 0; j < field[i].length; j++) {
      var neighborCount = 0;
      for (int nI = -1; nI <= 1; nI++) {
        for (int nJ = -1; nJ <= 1; nJ++) {
          if (i + nI < 0 || i + nI >= field.length) continue;
          if (j + nJ < 0 || j + nJ >= field[i + nI].length) continue;
          if (field[i + nI][j + nJ].hasMine) neighborCount++;
        }
      }
      field[i][j] = field[i][j].copyWith(bombsAround: neighborCount);
    }
  }
  return field;
}

bool isWon(List<List<MinesweeperCell>> field) {
  for (int i = 0; i < field.length; i++) {
    for (int j = 0; j < field[i].length; j++) {
      var cell = field[i][j];
      if (!cell.hasMine && !cell.isOpened) return false;
    }
  }
  return true;
}

int countMarked(List<List<MinesweeperCell>> field) {
  int answer = 0;
  for (int i = 0; i < field.length; i++) {
    for (int j = 0; j < field[i].length; j++) {
      if (field[i][j].isMarked) answer++;
    }
  }
  return answer;
}

List<List<MinesweeperCell>> generateField(int w, int h) {
  return List.generate(w, (_) => List.filled(h, MinesweeperCell()));
}

List<List<MinesweeperCell>> copyField(List<List<MinesweeperCell>> ref) {
  return List.generate(ref.length, (i) => List.from(ref[i]));
}
