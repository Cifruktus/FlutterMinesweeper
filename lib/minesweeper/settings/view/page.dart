import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper/desktop/button.dart';
import 'package:minesweeper/desktop/window.dart';
import 'package:minesweeper/minesweeper/models/minesweeper_settings.dart';
import 'package:minesweeper/minesweeper/settings/cubit/minesweeper_settings_cubit.dart';

class MinesweeperSettingsView extends StatelessWidget {
  static Widget getWindow(BuildContext context){
    var key = UniqueKey();

    return Window(
      title: "Settings",
      key: key,
      appKey: key,
      child: BlocProvider(
        create: (context) => MinesweeperSettingsCubit(),
        child: MinesweeperSettingsView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WinButton(child: Text("easy"),onPressed: (){
          Window.of(context).close(data: MinesweeperSettings.easy);
        },),
        WinButton(child: Text("normal"),onPressed: (){
          Window.of(context).close(data: MinesweeperSettings.normal);
        },),
        WinButton(child: Text("hard"),onPressed: (){
          Window.of(context).close(data: MinesweeperSettings.hard);
        },),
      ],
    );
  }

}