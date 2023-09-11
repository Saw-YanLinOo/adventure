import 'dart:async';

import 'package:adventure/adventure.dart';
import 'package:adventure/components/custom_hitbox.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Fruit extends SpriteAnimationComponent
    with HasGameRef<Adventure>, CollisionCallbacks {
  final String fruit;

  Fruit({
    this.fruit = "Apple",
    Vector2? position,
    Vector2? size,
  }) : super(position: position, size: size, removeOnFinish: true);

  final double stepTime = 0.05;
  final hitBox = CustomHitbox(
    offsetX: 10,
    offsetY: 10,
    width: 12,
    height: 12,
  );

  @override
  FutureOr<void> onLoad() {
    //debugMode = kDebugMode;
    priority = -1;

    add(RectangleHitbox(
      position: Vector2(hitBox.offsetX, hitBox.offsetY),
      size: Vector2(hitBox.width, hitBox.height),
      collisionType: CollisionType.passive,
    ));
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache("Items/Fruits/$fruit.png"),
      SpriteAnimationData.sequenced(
        amount: 17,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
    return super.onLoad();
  }

  void collidedWithPlayer() async {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache("Items/Fruits/Collected.png"),
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
        loop: false,
      ),
    );

    await animationTicker?.completed;

    removeFromParent();
  }
}
