import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:test6_platformer_01/player.dart';

/// Represents an obstacle in the platformer game.
class Obstacle extends PositionComponent with HasHitboxes, Collidable {
  final Sprite _sprite;
  final double _speed;
  final double _damage;

  Obstacle({
    required Vector2 position,
    required this._sprite,
    required this._speed,
    required this._damage,
  }) : super(position: position, size: _sprite.size) {
    addHitbox(HitboxRectangle());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= _speed * dt;

    if (position.x < -size.x) {
      position.x = game.size.x + size.x;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);

    if (other is Player) {
      other.takeDamage(_damage);
    }
  }

  @override
  void render(Canvas canvas) {
    _sprite.render(canvas, position: position, size: size);
  }
}