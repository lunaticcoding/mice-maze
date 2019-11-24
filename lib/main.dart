import 'package:flame/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flutter/services.dart';
import 'package:miceandmaze/mazegame.dart';

var game;

main() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  Util flameUtil = Util();
  await flameUtil.setOrientation(DeviceOrientation.landscapeLeft);
  await flameUtil.fullScreen();

  Flame.images.loadAll(<String>[
    'mouse_forward_1.png',
    'mouse_forward_2.png',
    'mouse_backward_1.png',
    'mouse_backward_2.png',
    'mouse_up_1.png',
    'mouse_up_2.png',
    'mouse_down_1.png',
    'mouse_down_2.png',
  ]);

  game = MazeGame();
  runApp(game.widget);

  PanGestureRecognizer dragger = PanGestureRecognizer();
  dragger.onStart = game.dragStart;
  dragger.onUpdate = game.dragUpdate;
  flameUtil.addGestureRecognizer(dragger);
  TapGestureRecognizer tapper = TapGestureRecognizer();
  tapper.onTapDown = game.onTapDown;
  flameUtil.addGestureRecognizer(tapper);

}


