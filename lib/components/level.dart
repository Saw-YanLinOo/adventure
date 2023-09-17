import 'dart:async';

import 'package:adventure/adventure.dart';
import 'package:adventure/components/background_tile.dart';
import 'package:adventure/components/checkpoint.dart';
import 'package:adventure/components/chicken.dart';
import 'package:adventure/components/collision_block.dart';
import 'package:adventure/components/fruit.dart';
import 'package:adventure/components/player.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World with HasGameRef<Adventure> {
  final String levelName;
  final Player player;
  List<CollisionBlock> collisionBlocks = [];
  Level({
    required this.levelName,
    required this.player,
  });

  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load("$levelName.tmx", Vector2.all(16));

    add(level);

    _scrollingBackground();
    _spawningObject();
    _addCollisions();

    return super.onLoad();
  }

  void _scrollingBackground() {
    final backgroundLayer = level.tileMap.getLayer("Background");

    if (backgroundLayer != null) {
      final backgroundColor =
          backgroundLayer.properties.getValue("BackgroundColor");

      final backgroundTile = BackgroundTile(
        color: backgroundColor ?? "Gray",
        position: Vector2(0, 0),
      );

      add(backgroundTile);
    }
  }

  void _spawningObject() {
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>("Spawnpoints");
    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;
          case "Fruit":
            final fruit = Fruit(
              fruit: spawnPoint.name,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );

            add(fruit);
            break;
          case "Checkpoint":
            final checkpoint = Checkpoint(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );

            add(checkpoint);
          case "Chicken":
            final offNeg = spawnPoint.properties.getValue("offNeg");
            final offPos = spawnPoint.properties.getValue("offPos");
            final chicken = Chicken(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              offNeg: offNeg,
              offPos: offPos,
            );
            add(chicken);
          default:
        }
      }
    }
  }

  void _addCollisions() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>("Collisions");
    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlaform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block);
            break;
        }
      }
    }

    player.collisionBlocks = collisionBlocks;
  }
}
