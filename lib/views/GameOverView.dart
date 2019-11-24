import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:miceandmaze/mazegame.dart';

class GameOverView {
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

  GameOverView({this.game}) {
    background = Rect.fromLTWH(0, 0, game.screenSize.width, game.screenSize.height);
    backgroundPaint = Paint();
    backgroundPaint.color = Color(0xffe8c39e);

    buttonPaint = Paint();
    buttonPaint.color = Color(0xff654321);
    buttonPaint.style = PaintingStyle.stroke;
    buttonPaint.strokeWidth = 15.0;

    titleRect = Rect.fromLTWH(game.screenSize.width/4,
        game.screenSize.height/7,
        game.screenSize.width/2,
        game.screenSize.width/2*(116.0/901.0));

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
      text: "game over",
      style: textStyle,
    );

    painterHighscore.text = TextSpan(
      text: "${game.gameView.score}",
      style: textStyleHighscore,
    );

    painterHighscore.layout();
    painter.layout();

    positionHighscore = Offset(
      (game.screenSize.width / 2) - (painterHighscore.width / 2),
      (game.screenSize.height * .6) - (painterHighscore.height / 2),
    );

    position = Offset(
      (game.screenSize.width / 2) - (painter.width / 2),
      (game.screenSize.height * .3) - (painter.height / 2),
    );

  }

  void render(Canvas c) {
    c.drawRect(background, backgroundPaint);

    painter.paint(c, position);
    painterHighscore.paint(c, positionHighscore);

  }

  void update(double t) {
    painterHighscore.text = TextSpan(
      text: "${game.gameView.score}",
      style: textStyleHighscore,
    );

    painterHighscore.layout();

    positionHighscore = Offset(
      (game.screenSize.width / 2) - (painterHighscore.width / 2),
      (game.screenSize.height * .6) - (painterHighscore.height / 2),
    );
  }
}