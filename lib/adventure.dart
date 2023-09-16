import 'dart:async';

import 'package:adventure/components/jump_button.dart';
import 'package:adventure/components/player.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:adventure/components/level.dart';
import 'package:flutter/material.dart';

class Adventure extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  final Player player = Player();
  late CameraComponent cam;
  late final JoystickComponent joystick;
  bool showControls = true;
  List<String> levelNames = ["level-02", "level-02"];
  int currentLevelIndex = 0;

  bool playSound = true;
  double soundVolume = 1.0;

  @override
  Color backgroundColor() {
    return const Color(0xFF211F30);
  }

  @override
  FutureOr<void> onLoad() async {
    // showControls = Platform.isAndroid || Platform.isIOS;
    await images.loadAllImages();
    _loadLevel();
    if (showControls) {
      addJoystick();
      add(JumpButton());
    }

    return super.onLoad();
  }

  void loadNextLevel() {
    removeWhere((component) => component is Level);

    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      currentLevelIndex = 0;
      _loadLevel();
    }
  }

  void _loadLevel() {
    Future.delayed(const Duration(seconds: 1), () {
      Level world = Level(
        levelName: levelNames[currentLevelIndex],
        player: player,
      );

      cam = CameraComponent.withFixedResolution(
          world: world, width: 640, height: 360);

      cam.viewfinder.anchor = Anchor.topLeft;
      addAll([cam, world]);
    });
  }

  @override
  void update(double dt) {
    if (showControls) {
      updateJobstick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      priority: 10,
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
    add(joystick);
  }

  void updateJobstick() {
    switch (joystick.direction) {
      case JoystickDirection.left ||
            JoystickDirection.upLeft ||
            JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right ||
            JoystickDirection.upRight ||
            JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }
}
