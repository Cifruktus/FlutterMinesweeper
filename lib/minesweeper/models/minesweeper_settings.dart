import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
class MinesweeperSettings extends Equatable {
  static const easy = MinesweeperSettings(width: 9, height: 9, bombs: 10);
  static const normal = MinesweeperSettings(width: 16, height: 16, bombs: 40);
  static const hard = MinesweeperSettings(width: 30, height: 16, bombs: 99);

  final int width;
  final int height;
  final int bombs;

  @override
  List<Object?> get props => [width, height, bombs];

  const MinesweeperSettings({required this.width, required this.height, required this.bombs});

  MinesweeperSettings copyWith({
    int? width,
    int? height,
    int? bombs,
  }) {
    return MinesweeperSettings(
      width: width ?? this.width,
      height: height ?? this.height,
      bombs: bombs ?? this.bombs,
    );
  }
}
