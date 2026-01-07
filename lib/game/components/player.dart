import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';

/// Represents the player character in the platformer game.
class Player extends SpriteAnimationComponent with HasGameRef, Hitbox, Collidable {
  double speed = 200.0;
  double jumpStrength = 300.0;
  bool isJumping = false;
  Vector2 gravity = Vector2(0, 500);
  Vector2 velocity = Vector2.zero();
  int health = 3;
  bool isInvulnerable = false;
  Duration invulnerabilityDuration = Duration(seconds: 2);

  Player({SpriteAnimation? animation, Vector2? position, Vector2? size})
      : super(animation: animation, position: position, size: size) {
    addHitbox(HitboxRectangle());
  }

  @override
  void update(double dt) {
    super.update(dt);
    velocity += gravity * dt;
    position += velocity * dt;

    // Check for landing
    if (isJumping && position.y >= gameRef.size.y - size.y) {
      isJumping = false;
      position.y = gameRef.size.y - size.y;
      velocity.y = 0;
    }

    // Screen boundaries
    position.clamp(Vector2.zero(), gameRef.size - size);
  }

  /// Makes the player jump if they are not already jumping.
  void jump() {
    if (!isJumping) {
      velocity.y = -jumpStrength;
      isJumping = true;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
    if (other is Obstacle && !isInvulnerable) {
      takeDamage();
    }
  }

  /// Reduces the player's health and triggers invulnerability.
  void takeDamage() {
    if (!isInvulnerable) {
      health -= 1;
      isInvulnerable = true;
      Future.delayed(invulnerabilityDuration, () {
        isInvulnerable = false;
      });
    }
  }
}

/// Represents obstacles that the player can collide with.
class Obstacle extends SpriteComponent with Hitbox, Collidable {
  Obstacle({Sprite? sprite, Vector2? position, Vector2? size})
      : super(sprite: sprite, position: position, size: size) {
    addHitbox(HitboxRectangle());
  }
}