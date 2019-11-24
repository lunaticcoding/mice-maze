

import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:miceandmaze/game/gameObjects/GameObject.dart';
import 'package:miceandmaze/mazegame.dart';

class BlueCheese extends GameObject {
  Sprite sprite;

  BlueCheese(MazeGame game, double left, double top, double size):super(
      game: game,
      rect: Rect.fromLTWH(left+(size/2), top+(size/2), size, size)
  ) {
    sprite = Sprite("blue_cheese.png");
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
    game.gameView.score += 5;
    rect = rect.shift(Offset(game.tileSize*20, 0));
  }
}