import 'dart:async';
import 'dart:ui';

import 'package:adventure/adventure.dart';
import 'package:adventure/components/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

enum State {
  idle,
  run,
  hit,
}

class Chicken extends SpriteAnimationGroupComponent
    with HasGameRef<Adventure>, CollisionCallbacks {
  final double offNeg;
  final double offPos;

  Chicken({
    super.position,
    super.size,
    this.offNeg = 0,
    this.offPos = 0,
  });

  static const stepTime = 0.05;
  static const tileSize = 16;
  static const runSpeed = 18;
  static const _bounceHeight = 260.0;

  Vector2 velocity = Vector2.zero();

  bool gotStopped = false;

  late final Player player;
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _runAnimation;
  late final SpriteAnimation _hitAnimation;

  double rangeNeg = 0;
  double rangePos = 0;
  double moveDirection = -1;
  double targetDirection = -1;

  @override
  void update(double dt) {
    if (!gotStopped) {
      _updateState();
      _movement(dt);
    }
    super.update(dt);
  }

  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    player = game.player;

    add(RectangleHitbox(
      position: Vector2(4, 6),
      size: Vector2(24, 26),
    ));

    _loadAllAnimation();
    _calculateRange();
    return super.onLoad();
  }

  _loadAllAnimation() {
    _idleAnimation = _spriteAnimation("Idle", 12);
    _runAnimation = _spriteAnimation("Run", 14);
    _hitAnimation = _spriteAnimation("Hit", 5)..loop = false;

    animations = {
      State.idle: _idleAnimation,
      State.run: _runAnimation,
      State.hit: _hitAnimation,
    };
    current = State.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache("Enemies/Chicken/$state (32x34).png"),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2(32, 34),
      ),
    );
  }

  void _calculateRange() {
    rangeNeg = position.x - offNeg * tileSize;
    rangePos = position.x + offPos * tileSize;
  }

  void _movement(double dt) {
    velocity.x = 0;

    double playerOffset = (player.scale.x > 0) ? 0 : -player.width;
    double chickenOffset = (scale.x > 0) ? 0 : -width;
    if (playerInRange()) {
      // player in range

      targetDirection =
          (player.x + playerOffset < position.x + chickenOffset) ? -1 : 1;

      velocity.x = targetDirection * runSpeed;
    }

    moveDirection = lerpDouble(moveDirection, targetDirection, 0.1) ?? 1;
    position.x += velocity.x * dt;
  }

  bool playerInRange() {
    double playerOffset = (player.scale.x > 0) ? 0 : -player.width;
    return player.x + playerOffset >= rangeNeg &&
        player.x + playerOffset <= rangePos &&
        player.y + player.height > position.y &&
        player.y < position.y + height;
  }

  void _updateState() {
    current = (velocity.x != 0) ? State.run : State.idle;
    if ((moveDirection > 0 && scale.x > 0) ||
        (moveDirection < 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }
  }

  void collidedWithPlayer() async {
    if (player.velocity.y > 0 && player.y + player.height > position.y) {
      if (game.playSound) {
        FlameAudio.play("hit.wav", volume: game.soundVolume);
      }
      gotStopped = true;
      current = State.hit;
      player.velocity.y = -_bounceHeight;
      await animationTicker?.completed;
      removeFromParent();
    } else {
      player.collidedWithEnemy();
    }
  }
}
