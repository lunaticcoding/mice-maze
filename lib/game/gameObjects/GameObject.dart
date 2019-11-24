

import 'dart:ui';

import 'package:miceandmaze/mazegame.dart';

abstract class GameObject {
  MazeGame game;
  Rect rect;
  GameObject({this.game, this.rect});

  void render(Canvas c);

  void update(double t);

  void onCollisionPlayer();

}