// 拼图游戏服务

import 'dart:async';
import 'dart:math';
import '../models/puzzle_model.dart';

// 拼图游戏服务类，提供游戏相关的功能
class PuzzleGameService {
  // 内置的拼图类别
  static final List<Map<String, dynamic>> puzzleCategories = [
    {'id': 'nature', 'name': '自然风景', 'icon': 'landscape'},
    {'id': 'art', 'name': '艺术画作', 'icon': 'palette'},
    {'id': 'animals', 'name': '动物世界', 'icon': 'pets'},
    {'id': 'architecture', 'name': '建筑奇观', 'icon': 'architecture'},
    {'id': 'custom', 'name': '我的收藏', 'icon': 'favorite'},
  ];

  // 获取指定类别的拼图列表
  static Future<List<Map<String, dynamic>>> getPuzzlesByCategory(String categoryId) async {
    // 在实际应用中，这里应该从数据库或API加载数据

    // 生成一些示例数据
    final random = Random();
    List<Map<String, dynamic>> puzzles = [];

    for (int i = 1; i <= 12; i++) {
      puzzles.add({
        'id': '${categoryId}_$i',
        'name': '$categoryId 拼图 $i',
        'imagePath': 'assets/images/$categoryId/$i.jpg', // 实际应用中的图片路径
        'difficulty': random.nextInt(4),
        'bestTime': random.nextInt(300) + 30,
        'completed': random.nextBool(),
      });
    }

    return puzzles;
  }

  // 加载拼图游戏数据
  static Future<PuzzleModel> loadPuzzle(String puzzleId, PuzzleDifficulty difficulty) async {
    // 在实际应用中，这里应该从数据库或API加载拼图数据

    // 提取类别和ID
    final parts = puzzleId.split('_');
    final category = parts[0];
    final id = parts[1];

    // 根据难度确定拼图大小
    final size = PuzzleModel.difficultyToSize(difficulty);

    // 创建一个随机打乱的拼图
    return PuzzleModel.random(
      id: puzzleId,
      name: '$category 拼图 $id',
      imagePath: 'assets/images/$category/$id.jpg', // 实际应用中的图片路径
      difficulty: difficulty,
      size: size,
    );
  }

  // 保存游戏进度
  static Future<bool> saveGameProgress(PuzzleModel puzzle) async {
    // 在实际应用中，这里应该将游戏进度保存到本地存储
    return true;
  }

  // 加载保存的游戏进度
  static Future<PuzzleModel?> loadGameProgress(String puzzleId) async {
    // 在实际应用中，这里应该从本地存储加载游戏进度
    return null;
  }

  // 检查并更新最佳成绩
  static Future<bool> updateBestScore(String puzzleId, int seconds, int moves) async {
    // 在实际应用中，这里应该检查并更新最佳成绩
    return true;
  }

  // 获取排行榜数据
  static Future<List<Map<String, dynamic>>> getLeaderboard(String puzzleId) async {
    // 在实际应用中，这里应该加载排行榜数据

    // 生成一些示例数据
    final random = Random();
    List<Map<String, dynamic>> leaderboard = [];

    for (int i = 1; i <= 10; i++) {
      leaderboard.add({
        'rank': i,
        'name': '玩家${random.nextInt(1000)}',
        'time': random.nextInt(300) + 30,
        'moves': random.nextInt(100) + 20,
      });
    }

    // 按时间排序
    leaderboard.sort((a, b) => a['time'].compareTo(b['time']));

    return leaderboard;
  }

  // 检查拼图是否可解（确保拼图有解）
  static bool isPuzzleSolvable(List<List<PuzzleTile>> tiles) {
    final size = tiles.length;
    List<int> flatList = [];

    // 将二维数组转为一维
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        flatList.add(tiles[i][j].value);
      }
    }

    // 计算逆序数
    int inversions = 0;
    for (int i = 0; i < flatList.length; i++) {
      for (int j = i + 1; j < flatList.length; j++) {
        // 跳过空白块
        if (flatList[i] != size * size - 1 && flatList[j] != size * size - 1) {
          if (flatList[i] > flatList[j]) {
            inversions++;
          }
        }
      }
    }

    // 找到空白块的行数（从底部数）
    int emptyRow = -1;
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (tiles[i][j].value == size * size - 1) {
          emptyRow = size - i;
          break;
        }
      }
    }

    // 根据规则判断是否可解
    // 对于奇数大小的拼图，逆序数必须是偶数
    // 对于偶数大小的拼图，逆序数加上空白块所在行数（从底部数）如果是奇数则可解
    if (size % 2 == 1) {
      return inversions % 2 == 0;
    } else {
      return (inversions + emptyRow) % 2 == 1;
    }
  }
}

