import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:miceandmaze/game/LocalFileStorage.dart';
import 'package:miceandmaze/mazegame.dart';

class HomeView {
  final MazeGame game;
  Rect titleRect;
  Sprite titleSprite;
  Rect background;
  Paint backgroundPaint;

  Paint buttonPaint;

  TextPainter painter;
  TextPainter painterHighscore;
  TextStyle textStyle;
  TextStyle textStyleHighscore;
  Offset position;
  Offset positionHighscore;


  HomeView({this.game}) {
    background =
        Rect.fromLTWH(0, 0, game.screenSize.width, game.screenSize.height);
    backgroundPaint = Paint();
    backgroundPaint.color = Color(0xffe8c39e);

    buttonPaint = Paint();
    buttonPaint.color = Color(0xff654321);
    buttonPaint.style = PaintingStyle.stroke;
    buttonPaint.strokeWidth = 15.0;

    titleSprite = Sprite('titleScreen.png');
    titleRect = Rect.fromLTWH(
        game.screenSize.width / 4,
        game.screenSize.height / 7,
        game.screenSize.width / 2,
        game.screenSize.width / 2 * (116.0 / 901.0));

    painter = TextPainter(
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );

    painterHighscore = TextPainter(
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );

    textStyle = TextStyle(
      color: Color(0xff654321),
      fontSize: 70,
    );

    textStyleHighscore = TextStyle(
      fontSize: 70,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = Color(0xff654321),
    );

    painter.text = TextSpan(
      text: "play",
      style: textStyle,
    );

    painterHighscore.text = TextSpan(
      text: "${game.highscore}",
      style: textStyleHighscore,
    );

    painterHighscore.layout();
    painter.layout();

    positionHighscore = Offset(
      (game.screenSize.width / 2) - (painterHighscore.width / 2),
      (game.screenSize.height * .49) - (painterHighscore.height / 2),
    );

    position = Offset(
      (game.screenSize.width / 2) - (painter.width / 2),
      (game.screenSize.height * .75) - (painter.height / 2),
    );
  }

  void render(Canvas c) {
    c.drawRect(background, backgroundPaint);

    titleSprite.renderRect(c, titleRect);

    painter.paint(c, position);
    painterHighscore.paint(c, positionHighscore);
  }

  void update(double t) {}
}
