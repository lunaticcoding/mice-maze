import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:miceandmaze/const.dart';
import 'package:miceandmaze/game/LocalFileStorage.dart';
import 'package:miceandmaze/views/GameOverView.dart';
import 'package:miceandmaze/views/GameView.dart';
import 'package:miceandmaze/views/HomeView.dart';


class MazeGame extends Game {
  Size screenSize;
  double tileSize;
  bool finishedLoading = false;

  TextPainter painter;
  TextStyle textStyle;
  Offset position;
  bool showInstructions = true;
  Rect rect;
  Paint paint;


  HomeView homeView;
  GameView gameView;
  GameOverView gameOverView;
  kViews activeView;

  int highscore;

  MazeGame(){
    initialize();
  }

  void initialize() async {
    highscore = int.parse(await readContent());

    resize(await Flame.util.initialDimensions());
    homeView = HomeView(game: this);
    gameView = GameView(game: this);
    gameOverView = GameOverView(game: this);
    activeView = kViews.homeView;

    // Should actually be in gamview class but here it is easier to throw out
    // and replace with a proper instructions screen if I ever decide to
    // continue this app.
    painter = TextPainter(
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );

    painter = TextPainter(
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );

    textStyle = TextStyle(
      color: Color(0xff654321),
      fontSize: 30,
    );

    painter.text = TextSpan(
      text: "play",
      style: textStyle,
    );

    painter.text = TextSpan(
      text: "swipe over the maze \nwalls to move them",
      style: textStyle,
    );

    painter.layout();

    position = Offset(
      (screenSize.width / 2) - (painter.width / 2),
      (screenSize.height * .4) - (painter.height / 2),
    );

    rect = Rect.fromLTWH((screenSize.width / 2) - (painter.width / 2) - tileSize/2,
        (screenSize.height * .4) - (painter.height / 2) - tileSize/2,
        painter.width + tileSize,
      painter.height + tileSize);
    paint = Paint();
    paint.color = Color(0xffe8c39e);

    finishedLoading = true;
  }

  @override
  void render(Canvas canvas) {
    if(!finishedLoading) return;
    switch(activeView){
      case kViews.homeView:
        homeView.render(canvas);
        break;
      case kViews.gameView:
        gameView.render(canvas);
        if(showInstructions) {
          canvas.drawRect(rect, paint);
          painter.paint(canvas, position);
        }
        break;
      case kViews.gameOverView:
        gameOverView.render(canvas);
        break;
      default:
        throw Exception("Invalid view");
    }
  }

  @override
  void update(double t) {
    if(!finishedLoading) return;
    switch(activeView){
      case kViews.homeView:
        homeView.update(t);
        break;
      case kViews.gameView:
        gameView.update(t);
        break;
      case kViews.gameOverView:
        gameOverView.update(t);
        break;
      default:
        throw Exception("Invalid view");
    }
  }

  void resize(Size size) {
    screenSize = size;
    super.resize(size);
    tileSize = screenSize.height/4;
  }

  void onTapDown(TapDownDetails d) {
    switch(activeView){
      case kViews.homeView:
        activeView = kViews.gameView;
        break;
      case kViews.gameOverView:
        gameView = GameView(game: this);
        activeView = kViews.gameView;
        break;
      case kViews.gameView:
        showInstructions = false;
        break;
      default:
    }
  }

  Offset oldP;
  int selectedIndex;
  bool isDragDone = true;
  double threshold = 20.0;

  void dragStart(DragStartDetails d) {
    switch(activeView){
      case kViews.gameView:
        for(int i = 0; i < gameView.mazeWalls.length; i++) {
          oldP = d.globalPosition;
          if(gameView.mazeWalls[i].wallRect.outerRect.inflate(2).contains(d.globalPosition)) {
            selectedIndex = i;
            isDragDone = false;
            break;
          }
        }
        break;
      default:
    }

  }

  void dragUpdate(DragUpdateDetails d) {
    switch(activeView){
      case kViews.gameView:
        if(!isDragDone) {
          Offset difference = d.globalPosition-oldP;
          if(gameView.mazeWalls[selectedIndex].orientation == kOrientation.vertical){
            if((difference.dx) > threshold && isMovePossible(Offset(tileSize/2, 0))) {
              gameView.mazeWalls[selectedIndex].shiftInplace(Offset(tileSize, 0));
              isDragDone = true;
              return;
            }
            if((difference.dx) < -threshold && isMovePossible(Offset(-tileSize/2, 0))) {
              gameView.mazeWalls[selectedIndex].shiftInplace(Offset(-tileSize, 0));
              isDragDone = true;
              return;
            }
          } else {
            if((difference.dy) > threshold && isMovePossible(Offset(0, tileSize/2))) {
              gameView.mazeWalls[selectedIndex].shiftInplace(Offset(0, tileSize));
              isDragDone = true;
              return;
            }
            if((difference.dy) < -threshold && isMovePossible(Offset(0, -tileSize/2))) {
              gameView.mazeWalls[selectedIndex].shiftInplace(Offset(0, -tileSize));
              isDragDone = true;
              return;
            }
          }
        }
        break;
      default:
    }
  }

  bool isMovePossible(Offset offset) {
    for(int i = 0; i < gameView.mazeWalls.length; i++) {
      if(i == selectedIndex) continue;
      if(gameView.mazeWalls[selectedIndex].wallRect
          .shift(offset).safeInnerRect
          .overlaps(gameView.mazeWalls[i].wallRect.safeInnerRect)) {
        return false;
      }
    }
    if(gameView.borderTop.wallRect.safeInnerRect
        .overlaps(gameView.mazeWalls[selectedIndex].wallRect.safeInnerRect
        .shift(offset))
        ||
        gameView.borderBottom.wallRect.safeInnerRect
            .overlaps(gameView.mazeWalls[selectedIndex].wallRect.safeInnerRect
            .shift(offset))
    ) {
      return false;
    }
    return !gameView.mazeWalls[selectedIndex]
        .shift(offset).outerRect
        .overlaps(gameView.player.mouseRect)
        &&
        !gameView.mazeWalls[selectedIndex]
            .shift(offset).outerRect
            .overlaps(gameView.rat.mouseRect);
  }



}