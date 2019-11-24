

import 'package:miceandmaze/const.dart';
import 'package:miceandmaze/game/gameObjects/Cheese.dart';
import 'package:miceandmaze/game/gameObjects/Trap.dart';
import 'package:miceandmaze/mazegame.dart';

import 'BlueCheese.dart';
import 'GameObject.dart';

class GameObjectFactory{

  static GameObject createGameObject({kGameObjects gameObjectId, MazeGame game, double left, double top, double size}) {
    switch(gameObjectId) {
      case kGameObjects.cheese:
        return Cheese(game, left, top, size);
      case kGameObjects.blueCheese:
        return BlueCheese(game, left, top, size);
      case kGameObjects.trap:
        return Trap(game, left, top, size);
      case kGameObjects.cheese:
        return Cheese(game, left, top, size);
      case kGameObjects.cheese:
        return Cheese(game, left, top, size);
      case kGameObjects.cheese:
        return Cheese(game, left, top, size);
      default:
        throw Exception("Invalid class created in GameObjectFactory");
    }
  }
}