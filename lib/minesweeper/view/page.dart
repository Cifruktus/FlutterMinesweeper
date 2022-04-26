import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper/desktop/button.dart';
import 'package:minesweeper/desktop/window.dart';
import 'package:minesweeper/minesweeper/cubit/minesweeper_game_cubit.dart';
import 'package:minesweeper/minesweeper/models/minefield_highlight.dart';
import 'package:minesweeper/minesweeper/models/minesweeper_settings.dart';
import 'package:minesweeper/minesweeper/view/game_board.dart';
import 'package:minesweeper/widgets/theme.dart';
import 'package:minesweeper/minesweeper/view/indicator.dart';

const defaultCellSize = 23.0;

class MinesweeperWindow extends StatelessWidget {
  final MinesweeperSettings initalSettings;
  const MinesweeperWindow({
    required Key key,
    this.initalSettings = MinesweeperSettings.easy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Window(
      expectedSize: Size(defaultCellSize * initalSettings.width, defaultCellSize * initalSettings.height),
      title: "Minesweeper",
      icon: Image.asset("assets/icons/mine_logo.png"),
      appKey: key!,
      child: BlocProvider(
        create: (context) => MinesweeperGameCubit(initalSettings),
        child: Minesweeper(),
      ),
    );
  }
}

class Minesweeper extends StatelessWidget {
  const Minesweeper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: CustomTheme.of(context).elevatedBorder,
          ),
          padding: EdgeInsets.all(4),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              decoration: BoxDecoration(
                border: CustomTheme.of(context).loweredBorder,
              ),
              margin: EdgeInsets.only(bottom: 4),
              padding: EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MinesCounterView(),
                  ResetButtonView(),
                  TimerView(),
                ],
              ),
            ),
            GameView(),
          ]),
        ),
      ],
    );
  }
}

class GameView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var state = context.select((MinesweeperGameCubit c) => c.state);

    return Container(
      decoration: BoxDecoration(
        border: CustomTheme.of(context).loweredBorder,
      ),
      child: GameBoard(
        field: state.field,
        //size: new Size(300, 300),
        cellSize: defaultCellSize,
        modifier: state.modifier,
        finished: state is MinesweeperGameFinished && !state.victory,
        onTap: (pos) => context.read<MinesweeperGameCubit>().openCell(pos),
        onTapDown: (pos) => context.read<MinesweeperGameCubit>().pressCell(pos),
        onSecondaryTap: (pos) => context.read<MinesweeperGameCubit>().markCell(pos),
        onTapUp: () => context.read<MinesweeperGameCubit>().unPressCell(),
      ),
    );
  }
}

class TimerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = CustomTheme.of(context);
    var time = context.select((MinesweeperGameCubit c) => c.state.time);

    return Container(
      decoration: BoxDecoration(border: theme.loweredBorder),
      child: SevenSegmentIndicator(
        height: 30,
        number: time,
      ),
    );
  }
}

class MinesCounterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = CustomTheme.of(context);
    var bombsLeft = context.select((MinesweeperGameCubit c) => c.countBombsLeft());

    return Container(
      decoration: BoxDecoration(border: theme.loweredBorder),
      child: SevenSegmentIndicator(
        height: 30,
        number: bombsLeft,
      ),
    );
  }
}

class ResetButtonView extends StatelessWidget {
  static const smile = "assets/minesweeper/emoji/smile.png";
  static const panic = "assets/minesweeper/emoji/panic.png";
  static const won = "assets/minesweeper/emoji/won.png";
  static const lost = "assets/minesweeper/emoji/lost.png";
  static const what = "assets/minesweeper/emoji/what.png";

  @override
  Widget build(BuildContext context) {
    var state = context.select((MinesweeperGameCubit c) => c.state);

    String emoji = smile;

    if (state is MinesweeperGameFinished) {
      emoji = state.victory ? won : lost;
    }

    if (state is MinesweeperGameGoing) {
      if (state.modifier is! MinefieldHighlightNone) {
        emoji = panic;
      }
    }

    return WinButton(
      onPressed: () => context.read<MinesweeperGameCubit>().resetGame(),
      child: Image.asset(
        emoji,
        height: 38,
      ),
    );
  }
}
