import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:miceandmaze/const.dart';
import 'dart:ui';
import 'package:miceandmaze/mazegame.dart';

import 'Mouse.dart';

class Player extends Mouse {

  Player(game, double x, double y) : super(game, x, y)  {
    aliveSprites = List<Sprite>();
    aliveSprites.add(Sprite('mouse_up_1.png'));
    aliveSprites.add(Sprite('mouse_up_2.png'));
    aliveSprites.add(Sprite('mouse_forward_1.png'));
    aliveSprites.add(Sprite('mouse_forward_2.png'));
    aliveSprites.add(Sprite('mouse_down_1.png'));
    aliveSprites.add(Sprite('mouse_down_2.png'));
    aliveSprites.add(Sprite('mouse_backward_1.png'));
    aliveSprites.add(Sprite('mouse_backward_2.png'));


    direction = kDirection.forward;
    mouseRect = Rect.fromLTWH(x, y+game.tileSize*(1/6), game.tileSize*(2/3), (2/3)*game.tileSize);
  }


}