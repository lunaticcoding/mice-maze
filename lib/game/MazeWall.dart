

import 'dart:ui';

import 'package:miceandmaze/const.dart';
import 'package:miceandmaze/mazegame.dart';

class MazeWall{
  final MazeGame game;
  kOrientation orientation;
  int length;
  Rect collisionBox;
  RRect wallRect;

  MazeWall(this.game, double left, double top, kOrientation orientation, int length) {
    wallRect = RRect.fromRectAndRadius(Rect.fromLTWH(
          left-5, top-5,
          orientation == kOrientation.vertical ? length * game.tileSize + 10 : 10,
          orientation == kOrientation.horizontal ? length * game.tileSize + 10 : 10,
      ), Radius.circular(20));
    this.orientation = orientation;
    this.length = length;
  }

  void shiftInplace(Offset offset) {
    wallRect = wallRect.shift(Offset(offset.dx, offset.dy));
  }

  RRect shift(Offset offset) {
    return wallRect.shift(offset);
  }

  void update(double t) {
    wallRect = wallRect.shift(Offset(-game.gameView.speed*t, 0));
  }

}