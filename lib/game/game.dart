import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:test6_platformer_01/components/player.dart';
import 'package:test6_platformer_01/components/obstacle.dart';
import 'package:test6_platformer_01/components/collectible.dart';
import 'package:test6_platformer_01/services/analytics.dart';
import 'package:test6_platformer_01/services/ads.dart';
import 'package:test6_platformer_01/services/storage.dart';

class Test6Platformer01Game extends FlameGame with TapDetector {
  /// The current game state
  GameState _gameState = GameState.playing;

  /// The current level being played
  int _currentLevel = 1;

  /// The player's score
  int _score = 0;

  /// The player component
  late Player _player;

  /// The list of obstacles in the current level
  late List<Obstacle> _obstacles;

  /// The list of collectibles in the current level
  late List<Collectible> _collectibles;

  /// The analytics service
  final AnalyticsService _analyticsService = AnalyticsService();

  /// The ads service
  final AdsService _adsService = AdsService();

  /// The storage service
  final StorageService _storageService = StorageService();

  /// Loads the current level
  void _loadLevel() {
    // Load the level data from storage or other source
    // Create the player, obstacles, and collectibles
    _player = Player();
    _obstacles = [
      Obstacle(position: Vector2(100, 300)),
      Obstacle(position: Vector2(300, 200)),
    ];
    _collectibles = [
      Collectible(position: Vector2(200, 400)),
    ];

    // Add the components to the game
    add(_player);
    _obstacles.forEach(add);
    _collectibles.forEach(add);
  }

  @override
  Future<void> onLoad() async {
    // Load the first level
    _loadLevel();

    // Register the tap detector
    onTapUp = _handleTap;
  }

  void _handleTap(TapUpInfo info) {
    // Handle the tap input, e.g., make the player jump
    if (_gameState == GameState.playing) {
      _player.jump();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update the game state based on player actions and level progress
    switch (_gameState) {
      case GameState.playing:
        // Update player, obstacles, and collectibles
        _player.update(dt);
        _obstacles.forEach((obstacle) => obstacle.update(dt));
        _collectibles.forEach((collectible) => collectible.update(dt));

        // Check for collisions and level completion
        if (_player.isColliding(_obstacles)) {
          _gameOver();
        } else if (_player.isColliding(_collectibles)) {
          _collectItem();
        } else if (_player.reachedEndOfLevel()) {
          _levelComplete();
        }
        break;
      case GameState.paused:
        // Pause the game
        break;
      case GameState.gameOver:
        // Handle game over state
        break;
      case GameState.levelComplete:
        // Handle level complete state
        break;
    }
  }

  void _gameOver() {
    // Handle game over logic
    _gameState = GameState.gameOver;
    _analyticsService.logGameOver();
    // Show game over UI, reset level, etc.
  }

  void _collectItem() {
    // Handle item collection logic
    _score += 100;
    _analyticsService.logItemCollected();
    // Remove the collected item from the game
  }

  void _levelComplete() {
    // Handle level complete logic
    _gameState = GameState.levelComplete;
    _analyticsService.logLevelComplete(_currentLevel);
    // Show level complete UI, save progress, load next level, etc.
  }
}

/// The possible game states
enum GameState {
  playing,
  paused,
  gameOver,
  levelComplete,
}