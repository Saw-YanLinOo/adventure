import 'package:adventure/components/player.dart';

import 'collision_block.dart';

bool checkCollection(Player player, CollisionBlock block) {
  final hitbox = player.hitbox;

  final playerX = player.position.x + hitbox.offsetX;
  final playerY = player.position.y + hitbox.offsetY;
  final playerWidth = hitbox.width;
  final playerHeight = hitbox.height;

  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  final fixedX = player.scale.x < 0
      ? playerX - (hitbox.offsetX * 2) - playerWidth
      : playerX;
  final fixedY = block.isPlaform ? playerY + playerHeight : playerY;

  return (fixedY < blockY + blockHeight && // player top collision
      fixedY + playerHeight > blockY && // player bottom collision
      fixedX < blockX + blockWidth && // player left collision
      fixedX + playerWidth > blockX); // player right collision
}
