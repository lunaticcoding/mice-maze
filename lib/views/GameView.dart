import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:miceandmaze/const.dart';
import 'package:miceandmaze/game/LocalFileStorage.dart';
import 'package:miceandmaze/game/MazeWall.dart';
import 'package:miceandmaze/game/Mouse.dart';
import 'package:miceandmaze/game/Player.dart';
import 'package:miceandmaze/game/Rat.dart';
import 'package:miceandmaze/game/ScoreDisplay.dart';
import 'package:miceandmaze/game/gameObjects/GameObject.dart';
import 'package:miceandmaze/game/gameObjects/GameObjectFactory.dart';

import '../mazegame.dart';

class GameView extends Game {
  bool isGameOver;
  double speed;
  int score;

  ScoreDisplay scoreDisplay;
  Player player;
  Rat rat;

  Paint wallPaint;
  List<MazeWall> mazeWalls;
  List<GameObject> gameObjects;
  MazeWall borderTop;
  MazeWall borderBottom;

  Rect background;
  Paint backgroundPaint;

  MazeGame game;
  double traceLine;

  GameView({this.game}) {
    isGameOver = false;
    speed = 100;
    score = 0;

    traceLine = game.tileSize * 14;

    scoreDisplay = ScoreDisplay(game);

    background =
        Rect.fromLTWH(0, 0, game.screenSize.width, game.screenSize.height);
    backgroundPaint = Paint();
    backgroundPaint.color = Color(0xffe8c39e);

    player = Player(game, game.tileSize, game.tileSize * 2);
    rat = Rat(game, game.tileSize * 6, game.tileSize);
    borderTop = MazeWall(game, -game.tileSize, 0, kOrientation.vertical,
        (game.screenSize.width / game.tileSize).round() + 2);
    borderBottom = MazeWall(
        game,
        -game.tileSize,
        game.tileSize * 4,
        kOrientation.vertical,
        (game.screenSize.width / game.tileSize).round() + 2);

    mazeWalls = List<MazeWall>();
    fillMaze(0);
    fillMaze(14 * game.tileSize);

    gameObjects = List<GameObject>();
    gameObjects.add(GameObjectFactory.createGameObject(
        game: game,
        gameObjectId: kGameObjects.cheese,
        left: game.tileSize * 4,
        top: game.tileSize * 2,
        size: game.tileSize / 2));
    gameObjects.add(GameObjectFactory.createGameObject(
        game: game,
        gameObjectId: kGameObjects.blueCheese,
        left: game.tileSize * 6,
        top: game.tileSize * 2,
        size: game.tileSize / 2));
    gameObjects.add(GameObjectFactory.createGameObject(
        game: game,
        gameObjectId: kGameObjects.trap,
        left: game.tileSize * 2,
        top: game.tileSize * 1,
        size: game.tileSize / 2));

    wallPaint = Paint();
    wallPaint.color = Color(0xff654321);

    game.finishedLoading = true;
  }

  void fillMaze(double offset) {
    mazeWalls.add(MazeWall(game, offset, game.tileSize * 3,
        kOrientation.vertical, 2));
    mazeWalls.add(
        MazeWall(game, offset, 0, kOrientation.horizontal, 2));
    mazeWalls.add(MazeWall(game, game.tileSize + offset, game.tileSize,
        kOrientation.horizontal, 2));
    mazeWalls.add(MazeWall(game, game.tileSize + offset, game.tileSize * 2,
        kOrientation.vertical, 3));
    mazeWalls.add(MazeWall(game, game.tileSize * 2 + offset, game.tileSize,
        kOrientation.vertical, 2));
    mazeWalls.add(MazeWall(game, game.tileSize * 3 + offset, game.tileSize * 2,
        kOrientation.horizontal, 2));
    mazeWalls.add(MazeWall(
        game, game.tileSize * 4 + offset, 0, kOrientation.horizontal, 3));

    mazeWalls.add(MazeWall(game, game.tileSize * 4 + offset, game.tileSize * 3,
        kOrientation.vertical, 3));
    mazeWalls.add(MazeWall(
        game, game.tileSize * 5 + offset, 0, kOrientation.horizontal, 2));
    mazeWalls.add(MazeWall(game, game.tileSize * 5 + offset, game.tileSize * 2,
        kOrientation.vertical, 2));

    mazeWalls.add(MazeWall(game, game.tileSize * 6 + offset, game.tileSize,
        kOrientation.vertical, 2));
    mazeWalls.add(MazeWall(game, game.tileSize * 7 + offset, game.tileSize * 2,
        kOrientation.horizontal, 2));
    mazeWalls.add(MazeWall(game, game.tileSize * 8 + offset, game.tileSize,
        kOrientation.horizontal, 2));

    mazeWalls.add(MazeWall(game, game.tileSize * 8 + offset, game.tileSize * 3,
        kOrientation.vertical, 2));
    mazeWalls.add(MazeWall(
        game, game.tileSize * 9 + offset, 0, kOrientation.horizontal, 2));
    mazeWalls.add(MazeWall(game, game.tileSize * 9 + offset, game.tileSize,
        kOrientation.vertical, 2));

    mazeWalls.add(MazeWall(game, game.tileSize * 10 + offset, game.tileSize * 2,
        kOrientation.horizontal, 2));
    mazeWalls.add(MazeWall(game, game.tileSize * 10 + offset, game.tileSize * 2,
        kOrientation.vertical, 2));
    mazeWalls.add(MazeWall(
        game, game.tileSize * 12 + offset, 0, kOrientation.horizontal, 2));

    mazeWalls.add(MazeWall(game, game.tileSize * 11 + offset, game.tileSize * 3,
        kOrientation.vertical, 2));
    mazeWalls.add(MazeWall(game, game.tileSize * 13 + offset, game.tileSize,
        kOrientation.horizontal, 2));
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(background, backgroundPaint);

    mazeWalls
        .forEach((MazeWall wall) => canvas.drawRRect(wall.wallRect, wallPaint));
    gameObjects.forEach((gameObject) => gameObject.render(canvas));

    canvas.drawRRect(borderTop.wallRect, wallPaint);
    canvas.drawRRect(borderBottom.wallRect, wallPaint);

    game.gameView.player.render(canvas);
    game.gameView.rat.render(canvas);

    scoreDisplay.render(canvas);
  }

  @override
  void update(double t) {
    if (isGameOver) return;

    if (traceLine < 0) {
      traceLine += game.tileSize * 14;
      fillMaze(traceLine);
    }

    scoreDisplay.update(t);
    mouseCollisionDetection(t, player, false);
    mouseCollisionDetection(t, rat, true);

    if (player.mouseRect.left > game.screenSize.width / 4 &&
        player.direction == kDirection.forward) {
      mazeWalls.forEach((wall) => wall.update(t));
      gameObjects.forEach((gameObject) => gameObject.update(t));
      player.update(t, 0);
      rat.update(t, speed * 1.3);
      rat.mouseRect = rat.mouseRect.shift(Offset(-speed * t, 0));
      traceLine -= speed * t;
    } else {
      player.update(t, speed);
      rat.update(t, speed * 1.3);
    }

    for (int i = 0; i < mazeWalls.length; i++) {
      if (mazeWalls[i].wallRect.right < -game.tileSize) {
        mazeWalls.removeAt(i);
      }
    }

    gameObjects.forEach((gameObject) {
      if (gameObject.rect.right < 0) {
        gameObject.rect = gameObject.rect.shift(Offset(game.tileSize * 10, 0));
        gameObject.rect = Rect.fromLTWH(
            gameObject.rect.left,
            game.tileSize * (Random().nextInt(4) + (1 / 6)),
            gameObject.rect.width,
            gameObject.rect.height);
      }
      if (gameObject.rect.overlaps(player.mouseRect)) {
        gameObject.onCollisionPlayer();
      }
      if (gameObject.rect.overlaps(rat.mouseRect)) {
        gameObject.rect = gameObject.rect.shift(Offset(game.tileSize * 15, 0));
      }
    });

    if (rat.mouseRect.right < -game.tileSize) {
      rat = Rat(game, traceLine, Random().nextInt(4) * game.tileSize);
    }

    if (player.mouseRect.overlaps(rat.mouseRect)) {
      gameOver();
    }
  }

  void gameOver() {
    if (game.gameView.score > game.highscore) {
      writeContent(game.gameView.score.toString());
    }
    isGameOver = true;
    game.activeView = kViews.gameOverView;
  }

  mouseCollisionDetection(double t, Mouse mouse, bool isRat) {
    bool isLeftColl = false;
    bool isRightColl = false;

    Rect mouseTryLeft;
    Rect mouseTryRight;
    Rect mouseStraight;
    double offset = (game.tileSize * (1 / 3));
    double offsetStraight = (game.tileSize * (1 / 6));

    switch (mouse.direction) {
      case kDirection.forward:
        mouseTryLeft = mouse.mouseRect.shift(Offset(0, -offset));
        mouseTryRight = mouse.mouseRect.shift(Offset(0, offset));
        mouseStraight = mouse.mouseRect.shift(Offset(offsetStraight, 0));
        break;
      case kDirection.up:
        mouseTryLeft = mouse.mouseRect.shift(Offset(-offset, 0));
        mouseTryRight = mouse.mouseRect.shift(Offset(offset, 0));
        mouseStraight = mouse.mouseRect.shift(Offset(0, -offsetStraight));
        break;
      case kDirection.backward:
        mouseTryLeft = mouse.mouseRect.shift(Offset(0, offset));
        mouseTryRight = mouse.mouseRect.shift(Offset(0, -offset));
        mouseStraight = mouse.mouseRect.shift(Offset(-offsetStraight, 0));
        break;
      case kDirection.down:
        mouseTryLeft = mouse.mouseRect.shift(Offset(offset, 0));
        mouseTryRight = mouse.mouseRect.shift(Offset(-offset, 0));
        mouseStraight = mouse.mouseRect.shift(Offset(0, offsetStraight));
        break;
      default:
        throw Exception("Inavlid direction");
    }

    bool leavingScreenStraight = isLeavingScreen(mouseStraight, isRat);
    bool leavingScreenLeft = isLeavingScreen(mouseTryLeft, isRat);
    bool leavingScreenRight = isLeavingScreen(mouseTryRight, isRat);

    for (MazeWall wall in mazeWalls) {
      isLeftColl = isLeftColl || wall.wallRect.outerRect.overlaps(mouseTryLeft);
      isRightColl =
          isRightColl || wall.wallRect.outerRect.overlaps(mouseTryRight);
    }
    for (MazeWall wall in mazeWalls) {
      if (wall.wallRect.outerRect.overlaps(mouseStraight) ||
          leavingScreenStraight) {
        if (isLeftColl || leavingScreenLeft) {
          if (isRightColl || leavingScreenRight) {
            mouse.changeDirection(2);
            return;
          } else {
            mouse.mouseRect = mouseTryRight;
            mouse.changeDirection(1);
            return;
          }
        } else {
          mouse.mouseRect = mouseTryLeft;
          mouse.changeDirection(-1);
          return;
        }
      }
    }
  }

  bool isLeavingScreen(Rect gameObject, bool isRat) {
    if (isRat) {
      return !Rect.fromLTWH(
              -game.tileSize * 5, 0, game.tileSize * 30, game.screenSize.height)
          .inflate(-max(gameObject.width, gameObject.height))
          .overlaps(gameObject);
    }
    return !Rect.fromLTWH(0, 0, game.screenSize.width, game.screenSize.height)
        .inflate(-max(gameObject.width, gameObject.height))
        .overlaps(gameObject);
  }
}
