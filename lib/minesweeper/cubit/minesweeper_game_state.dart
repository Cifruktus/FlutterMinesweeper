part of 'minesweeper_game_cubit.dart';

@immutable
abstract class MinesweeperGameState {
  final List<List<MinesweeperCell>> field;
  final MinefieldHighlight modifier;

  int get time;
  int get width => field.length;
  int get height => field[0].length;
  final int bombsCount;

  const MinesweeperGameState(this.field, this.bombsCount, this.modifier);
}

class MinesweeperGameInitial extends MinesweeperGameState {
  const MinesweeperGameInitial({
    required List<List<MinesweeperCell>> field,
    required int bombsCount,
    MinefieldHighlight modifier = const MinefieldHighlightNone(),
  }) : super(field, bombsCount, modifier);

  MinesweeperGameInitial copyWith({
    List<List<MinesweeperCell>>? field,
    MinefieldHighlight? modifier,
    bool? minesDistributed,
  }) {
    return MinesweeperGameInitial(
      field: field ?? this.field,
      modifier: modifier ?? this.modifier,
      bombsCount: bombsCount,
    );
  }

  @override
  int get time => 0;
}

class MinesweeperGameGoing extends MinesweeperGameState {
  @override
  final int time;

  const MinesweeperGameGoing({
    required List<List<MinesweeperCell>> field,
    required int bombsCount,
    MinefieldHighlight modifier = const MinefieldHighlightNone(),
    this.time = 0,
  }) : super(field, bombsCount, modifier);

  MinesweeperGameGoing copyWith({
    List<List<MinesweeperCell>>? field,
    MinefieldHighlight? modifier,
    bool? minesDistributed,
    int? time,
  }) {
    return MinesweeperGameGoing(
      field: field ?? this.field,
      modifier: modifier ?? this.modifier,
      bombsCount: bombsCount,
      time: time ?? this.time,
    );
  }
}

class MinesweeperGameFinished extends MinesweeperGameState {
  @override
  final int time;
  final bool victory;

  const MinesweeperGameFinished({
    required List<List<MinesweeperCell>> field,
    required this.victory,
    required int bombsCount,
    required this.time,
  }) : super(field, bombsCount, const MinefieldHighlightNone());
}
