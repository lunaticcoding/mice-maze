

import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:miceandmaze/game/gameObjects/GameObject.dart';
import 'package:miceandmaze/mazegame.dart';

class Trap extends GameObject {
  Sprite sprite;
  Trap(MazeGame game, double left, double top, double size):super(game: game) {
    sprite = Sprite("trap.png");
    rect = Rect.fromLTWH(left+(size/2), top+(size/2), size, size);
  }

  @override
  void render(Canvas c) {
    sprite.renderRect(c, rect);
  }

  @override
  void update(double t) {
    rect = rect.shift(Offset(-game.gameView.speed*t, 0));
  }

  @override
  void onCollisionPlayer() {
    game.gameView.gameOver();
  }
}