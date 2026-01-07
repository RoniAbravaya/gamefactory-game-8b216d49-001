import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

/// Represents the player character in a platformer game.
class Player extends SpriteAnimationComponent with HasGameRef, Hitbox, Collidable {
  /// The speed at which the player moves.
  final double _speed = 200;

  /// The amount of health the player starts with.
  final int _maxHealth = 3;

  /// The current health of the player.
  int _currentHealth;

  /// Whether the player is currently invulnerable.
  bool _isInvulnerable = false;

  /// The duration of invulnerability after taking damage.
  final Duration _invulnerabilityDuration = Duration(seconds: 2);

  /// Animation states for the player.
  late final SpriteAnimation _runAnimation;
  late final SpriteAnimation _jumpAnimation;
  late final SpriteAnimation _idleAnimation;

  /// The current state of the player.
  String _currentState = 'idle';

  Player()
      : _currentHealth = _maxHealth,
        super(size: Vector2(50, 50)) {
    addHitbox(HitboxRectangle());
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _runAnimation = await _loadAnimation('run.png', 8);
    _jumpAnimation = await _loadAnimation('jump.png', 1);
    _idleAnimation = await _loadAnimation('idle.png', 4);
    animation = _idleAnimation;
  }

  /// Loads and returns a [SpriteAnimation] from an asset.
  Future<SpriteAnimation> _loadAnimation(String assetPath, int frameCount) async {
    final spriteSheet = await gameRef.images.load(assetPath);
    final spriteSize = Vector2.all(50);
    return SpriteAnimation.spriteList(
      SpriteSheet(image: spriteSheet, srcSize: spriteSize).sprites,
      stepTime: 0.1,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    _handleMovement(dt);
    _checkInvulnerability(dt);
  }

  /// Handles the player's movement based on the current state.
  void _handleMovement(double dt) {
    switch (_currentState) {
      case 'running':
        position.x += _speed * dt;
        animation = _runAnimation;
        break;
      case 'jumping':
        // Example jump logic; actual implementation would require physics
        position.y -= _speed * dt;
        animation = _jumpAnimation;
        break;
      case 'idle':
      default:
        animation = _idleAnimation;
    }
  }

  /// Checks and updates the player's invulnerability status.
  void _checkInvulnerability(double dt) {
    if (_isInvulnerable) {
      // Example logic to handle invulnerability duration
      Future.delayed(_invulnerabilityDuration, () {
        _isInvulnerable = false;
      });
    }
  }

  /// Makes the player take damage and become temporarily invulnerable.
  void takeDamage() {
    if (!_isInvulnerable) {
      _currentHealth--;
      _isInvulnerable = true;
      if (_currentHealth <= 0) {
        // Handle player death
      }
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
    if (other is Obstacle) {
      takeDamage();
    } else if (other is Collectible) {
      // Handle collectible pickup
    }
  }

  /// Sets the player's current state.
  void setState(String state) {
    _currentState = state;
  }
}

/// Represents an obstacle the player can collide with.
class Obstacle extends SpriteComponent with Collidable {
  Obstacle() {
    addHitbox(HitboxRectangle());
  }
}

/// Represents a collectible item the player can pick up.
class Collectible extends SpriteComponent with Collidable {
  Collectible() {
    addHitbox(HitboxRectangle());
  }
}