import 'package:bloc/bloc.dart';
import 'package:minesweeper/minesweeper/models/minesweeper_settings.dart';

class MinesweeperSettingsCubit extends Cubit<MinesweeperSettings> {
  MinesweeperSettingsCubit() : super(MinesweeperSettings.easy);

  void setWidth(String width){
    var input = int.tryParse(width);
    if (input == null) return;
    emit(state.copyWith(width: input));
  }

  void setHeight(String height){
    var input = int.tryParse(height);
    if (input == null) return;
    emit(state.copyWith(height: input));
  }

  void setBombs(String bombs){
    var input = int.tryParse(bombs);
    if (input == null) return;
    emit(state.copyWith(bombs: input));
  }

  void setSettings(MinesweeperSettings settings){
    emit(settings);
  }
}
