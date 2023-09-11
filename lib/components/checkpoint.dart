import 'dart:async';

import 'package:adventure/adventure.dart';
import 'package:adventure/components/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Checkpoint extends SpriteAnimationComponent
    with HasGameRef<Adventure>, CollisionCallbacks {
  Checkpoint({Vector2? position, Vector2? size})
      : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;

    add(RectangleHitbox(position: Vector2(18, 56), size: Vector2(12, 8)));
    animation = SpriteAnimation.fromFrameData(
      game.images
          .fromCache("Items/Checkpoints/Checkpoint/Checkpoint (No Flag).png"),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 0.05,
        textureSize: Vector2.all(64),
      ),
    );

    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      _reachCheckpoint();
    }

    super.onCollisionStart(intersectionPoints, other);
  }

  void _reachCheckpoint() async {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(
          "Items/Checkpoints/Checkpoint/Checkpoint (Flag Out) (64x64).png"),
      SpriteAnimationData.sequenced(
        amount: 26,
        stepTime: 0.05,
        textureSize: Vector2.all(64),
        loop: false,
      ),
    );

    await animationTicker?.completed;

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(
          "Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle)(64x64).png"),
      SpriteAnimationData.sequenced(
        amount: 10,
        stepTime: 0.05,
        textureSize: Vector2.all(64),
        loop: false,
      ),
    );
  }
}
