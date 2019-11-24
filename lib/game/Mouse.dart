import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:miceandmaze/const.dart';
import 'dart:ui';
import 'package:miceandmaze/mazegame.dart';

class Mouse {
  final MazeGame game;

  List<Sprite> aliveSprites;
  double aliveSpriteIndex = 0;

  Rect mouseRect;
  kDirection direction;

  Mouse(this.game, double x, double y);

  void render(Canvas c) {
    aliveSprites[direction.index*2 + aliveSpriteIndex.toInt()].renderRect(c, mouseRect.inflate(2));
  }


  void update(double t, double speed) {
    aliveSpriteIndex += 5*t;
    aliveSpriteIndex = aliveSpriteIndex >= 2 ? 0 : aliveSpriteIndex;
    switch(direction){
      case kDirection.forward:
        mouseRect = mouseRect.shift(Offset(speed*t, 0));
        break;
      case kDirection.backward:
        mouseRect = mouseRect.shift(Offset(-speed*t, 0));
        break;
      case kDirection.up:
        mouseRect = mouseRect.shift(Offset(0, -speed*t));
        break;
      case kDirection.down:
        mouseRect = mouseRect.shift(Offset(0, speed*t));
        break;
      default:
        throw Exception('value in player not valid');
    }
  }

  void changeDirection(int rotate) {
    direction = kDirection.values[(direction.index + rotate) % 4];
  }
}