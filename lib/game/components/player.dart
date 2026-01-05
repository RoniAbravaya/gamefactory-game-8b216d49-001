import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';

/// The player character in the platformer game.
class Player extends SpriteAnimationComponent with HasGameRef, Collidable {
  /// The player's current horizontal velocity.
  double velocityX = 0;

  /// The player's current vertical velocity.
  double velocityY = 0;

  /// The player's maximum horizontal speed.
  double maxHorizontalSpeed = 200;

  /// The player's jump force.
  double jumpForce = -500;

  /// The player's current health.
  int health = 3;

  /// The player's current score.
  int score = 0;

  /// The player's sprite animation for the idle state.
  late SpriteAnimation idleAnimation;

  /// The player's sprite animation for the moving state.
  late SpriteAnimation movingAnimation;

  /// The player's sprite animation for the jumping state.
  late SpriteAnimation jumpingAnimation;

  /// Initializes the player component.
  Player({
    required Vector2 position,
    required Vector2 size,
  }) : super(
          position: position,
          size: size,
        ) {
    // Load and create the player's sprite animations
    idleAnimation = SpriteAnimation.load(
      'player_idle.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.2,
        textureSize: Vector2.all(32),
      ),
    );

    movingAnimation = SpriteAnimation.load(
      'player_moving.png',
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: 0.1,
        textureSize: Vector2.all(32),
      ),
    );

    jumpingAnimation = SpriteAnimation.load(
      'player_jumping.png',
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: 0.5,
        textureSize: Vector2.all(32),
      ),
    );
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Set the initial animation to the idle state
    animation = idleAnimation;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update the player's position based on the current velocities
    position.x += velocityX * dt;
    position.y += velocityY * dt;

    // Apply gravity
    velocityY += 1500 * dt;

    // Update the player's animation based on the current state
    if (velocityX.abs() > 0.1) {
      animation = movingAnimation;
    } else {
      animation = idleAnimation;
    }

    if (velocityY < 0) {
      animation = jumpingAnimation;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);

    // Handle collisions with other game objects
    if (other is Obstacle) {
      // Reduce the player's health or handle the collision in another way
      health--;
    }
  }

  /// Handles the player's jump input.
  void jump() {
    // Apply the jump force to the player's vertical velocity
    velocityY = jumpForce;
  }

  /// Handles the player's horizontal movement input.
  void move(double direction) {
    // Update the player's horizontal velocity based on the input direction
    velocityX = direction * maxHorizontalSpeed;
  }

  /// Increases the player's score by the given amount.
  void addScore(int amount) {
    score += amount;
  }
}