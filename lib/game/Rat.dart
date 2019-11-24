import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:miceandmaze/const.dart';
import 'dart:ui';

import 'Mouse.dart';

class Rat extends Mouse {

  Rat(game, double x, double y) : super(game, x, y)  {
    aliveSprites = List<Sprite>();
    aliveSprites.add(Sprite('rat_up_1.png'));
    aliveSprites.add(Sprite('rat_up_2.png'));
    aliveSprites.add(Sprite('rat_forward_1.png'));
    aliveSprites.add(Sprite('rat_forward_2.png'));
    aliveSprites.add(Sprite('rat_down_1.png'));
    aliveSprites.add(Sprite('rat_down_2.png'));
    aliveSprites.add(Sprite('rat_backward_1.png'));
    aliveSprites.add(Sprite('rat_backward_2.png'));


    direction = kDirection.forward;
    mouseRect = Rect.fromLTWH(x, y+game.tileSize*(1/6), game.tileSize*(2/3), (2/3)*game.tileSize);
  }


}