import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  bool isPlaform;
  CollisionBlock({Vector2? position, Vector2? size, this.isPlaform = false})
      : super(position: position, size: size) {
    debugMode = true;
  }
}
