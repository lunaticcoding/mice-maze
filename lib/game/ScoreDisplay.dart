import 'dart:ui';
import 'package:flutter/painting.dart';

import '../mazegame.dart';

class ScoreDisplay {
  final MazeGame game;
  TextPainter painter;
  TextStyle textStyle;
  Offset position;

  ScoreDisplay(this.game) {
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textStyle = TextStyle(
      color: Color(0xff654321),
      fontSize: 60,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 7,
          color: Color(0xffe8c39e),
          offset: Offset(3, 3),
        ),
      ],
    );

    position = Offset.zero;
  }

  void render(Canvas c) {
    painter.paint(c, position);
  }

  void update(double t) {
    if ((painter.text ?? '') != game.gameView.score.toString()) {
      painter.text = TextSpan(
        text: game.gameView.score.toString(),
        style: textStyle,
      );

      painter.layout();

      position = Offset(
        (game.screenSize.width) - (painter.width / 2) - (game.tileSize/2),
        game.tileSize/2 - (painter.height / 2),
      );
    }
  }
}