import 'package:flame/components.dart';
import 'package:flame/audio.dart';
import 'package:test6_platformer_01/game_state.dart';

/// A collectible item that the player can pick up for points.
class Collectible extends SpriteComponent with HasGameRef<GameState> {
  /// The score value of this collectible.
  final int scoreValue;

  /// The audio clip to play when this collectible is collected.
  final AudioClip _collectSound;

  /// Whether this collectible should have an animation.
  final bool _hasAnimation;

  /// The animation component for this collectible, if applicable.
  late final AnimationComponent _animation;

  Collectible({
    required Sprite sprite,
    required this.scoreValue,
    required AudioClip collectSound,
    bool hasAnimation = false,
  })  : _collectSound = collectSound,
        _hasAnimation = hasAnimation,
        super(
          sprite: sprite,
          size: Vector2.all(32),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add collision detection
    addCollision();

    // Add animation if enabled
    if (_hasAnimation) {
      _animation = AnimationComponent(
        animation: Animation.sequenced(
          'collectible',
          4,
          textureSize: size,
          stepTime: 0.2,
        ),
        position: position,
        size: size,
      );
      add(_animation);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // Check if the player has collided with this collectible
    if (other is Player) {
      // Increase the player's score
      gameRef.gameState.score += scoreValue;

      // Play the collect sound
      _collectSound.play();

      // Remove the collectible from the game
      removeFromParent();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update the animation if it exists
    if (_hasAnimation) {
      _animation.update(dt);
    }
  }
}