import 'dart:async';

import 'package:adventure/components/collision_block.dart';
import 'package:adventure/components/player.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
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

    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>("Spawnpoint");
    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            {
              player.position = Vector2(spawnPoint.x, spawnPoint.y);
              add(player);
              break;
            }
        }
      }
    }

    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>("Collisions");
    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.x, collision.y),
              isPlaform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.x, collision.y),
            );
            collisionBlocks.add(block);
            add(block);
            break;
        }
      }
    }

    player.collisionBlocks = collisionBlocks;

    return super.onLoad();
  }
}
