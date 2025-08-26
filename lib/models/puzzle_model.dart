// 拼图游戏数据模型

import 'dart:math';
import 'dart:ui';

// 拼图游戏难度枚举
enum PuzzleDifficulty {
  easy,    // 简单 (3x3)
  medium,  // 中等 (4x4)
  hard,    // 困难 (5x5)
  expert,  // 专家 (6x6)
  custom   // 自定义
}

// 拼图块形状枚举
enum PuzzleTileShape {
  square,     // 方形
  irregular,  // 异形
  triangle    // 三角形
}

// 拼图块模型
class PuzzleTile {
  final int id;  // 拼图块ID（对应正确位置）
  final int value;  // 拼图块的当前值

  PuzzleTile({required this.id, required this.value});

  // 判断拼图块是否在正确位置
  bool isCorrect() => id == value;

  // 创建拼图块的副本
  PuzzleTile copyWith({int? id, int? value}) {
    return PuzzleTile(
      id: id ?? this.id,
      value: value ?? this.value,
    );
  }
}

// 拼图数据模型
class PuzzleModel {
  final String id;  // 拼图ID
  final String name;  // 拼图名称
  final String? imagePath;  // 拼图图片路径
  final PuzzleDifficulty difficulty;  // 难度
  final PuzzleTileShape tileShape;  // 拼图形状
  final int size;  // 网格大小 (3 表示 3x3)
  final List<List<PuzzleTile>> tiles;  // 拼图块二维数组
  final int moves;  // 移动次数
  final int secondsElapsed;  // 已用时间(秒)
  final bool isCompleted;  // 是否完成
  final List<List<List<PuzzleTile>>> history;  // 历史状态，用于撤销/重做
  final int historyIndex;  // 当前历史状态索引

  PuzzleModel({
    required this.id,
    required this.name,
    this.imagePath,
    required this.difficulty,
    this.tileShape = PuzzleTileShape.square,
    required this.size,
    required this.tiles,
    this.moves = 0,
    this.secondsElapsed = 0,
    this.isCompleted = false,
    this.history = const [],
    this.historyIndex = -1,
  });

  // 创建初始有序拼图
  factory PuzzleModel.ordered({
    required String id,
    required String name,
    String? imagePath,
    required PuzzleDifficulty difficulty,
    PuzzleTileShape tileShape = PuzzleTileShape.square,
    required int size,
  }) {
    // 创建有序的拼图块
    List<List<PuzzleTile>> tiles = [];
    for (int i = 0; i < size; i++) {
      List<PuzzleTile> row = [];
      for (int j = 0; j < size; j++) {
        final index = i * size + j;
        row.add(PuzzleTile(id: index, value: index));
      }
      tiles.add(row);
    }

    return PuzzleModel(
      id: id,
      name: name,
      imagePath: imagePath,
      difficulty: difficulty,
      tileShape: tileShape,
      size: size,
      tiles: tiles,
      history: [tiles],
      historyIndex: 0,
    );
  }

  // 创建随机打乱的拼图
  factory PuzzleModel.random({
    required String id,
    required String name,
    String? imagePath,
    required PuzzleDifficulty difficulty,
    PuzzleTileShape tileShape = PuzzleTileShape.square,
    required int size,
  }) {
    // 先创建有序拼图
    PuzzleModel orderedPuzzle = PuzzleModel.ordered(
      id: id,
      name: name,
      imagePath: imagePath,
      difficulty: difficulty,
      tileShape: tileShape,
      size: size,
    );

    // 随机移动多次拼图块来打乱（确保有解）
    final random = Random();
    PuzzleModel shuffledPuzzle = orderedPuzzle;

    // 移动200-500次，确保充分打乱
    int shuffleMoves = 200 + random.nextInt(300);
    for (int i = 0; i < shuffleMoves; i++) {
      // 获取空白块位置
      int emptyRow = -1, emptyCol = -1;
      for (int r = 0; r < size; r++) {
        for (int c = 0; c < size; c++) {
          if (shuffledPuzzle.tiles[r][c].value == size * size - 1) {
            emptyRow = r;
            emptyCol = c;
            break;
          }
        }
      }

      // 随机选择一个方向移动
      List<List<int>> directions = [
        [0, 1], [1, 0], [0, -1], [-1, 0]  // 右、下、左、上
      ];

      // 尝试随机方向
      bool moved = false;
      while (!moved && directions.isNotEmpty) {
        int dirIndex = random.nextInt(directions.length);
        int newRow = emptyRow + directions[dirIndex][0];
        int newCol = emptyCol + directions[dirIndex][1];

        // 检查是否在边界内
        if (newRow >= 0 && newRow < size && newCol >= 0 && newCol < size) {
          // 移动拼图块
          shuffledPuzzle = shuffledPuzzle.moveTile(newRow, newCol);
          moved = true;
        } else {
          // 移除无效方向
          directions.removeAt(dirIndex);
        }
      }
    }

    // 重置移动次数和历史记录
    return PuzzleModel(
      id: shuffledPuzzle.id,
      name: shuffledPuzzle.name,
      imagePath: shuffledPuzzle.imagePath,
      difficulty: shuffledPuzzle.difficulty,
      tileShape: shuffledPuzzle.tileShape,
      size: shuffledPuzzle.size,
      tiles: shuffledPuzzle.tiles,
      moves: 0,
      history: [shuffledPuzzle.tiles],
      historyIndex: 0,
    );
  }

  // 移动拼图块
  PuzzleModel moveTile(int row, int col) {
    // 找到空白块位置
    int emptyRow = -1, emptyCol = -1;
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        if (tiles[r][c].value == size * size - 1) {
          emptyRow = r;
          emptyCol = c;
          break;
        }
      }
    }

    // 检查是否可移动（必须相邻）
    bool canMove = (row == emptyRow && (col == emptyCol - 1 || col == emptyCol + 1)) ||
                  (col == emptyCol && (row == emptyRow - 1 || row == emptyRow + 1));

    if (!canMove) return this;

    // 创建新的拼图块数组
    List<List<PuzzleTile>> newTiles = List.generate(
      size,
      (i) => List.generate(
        size,
        (j) => tiles[i][j],
      ),
    );

    // 交换拼图块
    final temp = newTiles[row][col].value;
    newTiles[row][col] = PuzzleTile(
      id: newTiles[row][col].id,
      value: newTiles[emptyRow][emptyCol].value
    );
    newTiles[emptyRow][emptyCol] = PuzzleTile(
      id: newTiles[emptyRow][emptyCol].id,
      value: temp
    );

    // 创建新的历史记录
    List<List<List<PuzzleTile>>> newHistory = [];
    for (int i = 0; i <= historyIndex; i++) {
      newHistory.add(history[i]);
    }
    newHistory.add(newTiles);

    // 检查是否完成
    bool completed = true;
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        if (!newTiles[r][c].isCorrect()) {
          completed = false;
          break;
        }
      }
    }

    // 创建并返回新的拼图状态
    return PuzzleModel(
      id: id,
      name: name,
      imagePath: imagePath,
      difficulty: difficulty,
      tileShape: tileShape,
      size: size,
      tiles: newTiles,
      moves: moves + 1,
      secondsElapsed: secondsElapsed,
      isCompleted: completed,
      history: newHistory,
      historyIndex: historyIndex + 1,
    );
  }

  // 撤销移动
  PuzzleModel undo() {
    if (historyIndex <= 0) return this;

    return PuzzleModel(
      id: id,
      name: name,
      imagePath: imagePath,
      difficulty: difficulty,
      tileShape: tileShape,
      size: size,
      tiles: history[historyIndex - 1],
      moves: moves,
      secondsElapsed: secondsElapsed,
      isCompleted: false,
      history: history,
      historyIndex: historyIndex - 1,
    );
  }

  // 重做移动
  PuzzleModel redo() {
    if (historyIndex >= history.length - 1) return this;

    return PuzzleModel(
      id: id,
      name: name,
      imagePath: imagePath,
      difficulty: difficulty,
      tileShape: tileShape,
      size: size,
      tiles: history[historyIndex + 1],
      moves: moves,
      secondsElapsed: secondsElapsed,
      isCompleted: false,
      history: history,
      historyIndex: historyIndex + 1,
    );
  }

  // 增加计时
  PuzzleModel incrementTime() {
    return PuzzleModel(
      id: id,
      name: name,
      imagePath: imagePath,
      difficulty: difficulty,
      tileShape: tileShape,
      size: size,
      tiles: tiles,
      moves: moves,
      secondsElapsed: secondsElapsed + 1,
      isCompleted: isCompleted,
      history: history,
      historyIndex: historyIndex,
    );
  }

  // 转换难度到拼图大小
  static int difficultyToSize(PuzzleDifficulty difficulty) {
    switch (difficulty) {
      case PuzzleDifficulty.easy:
        return 3;
      case PuzzleDifficulty.medium:
        return 4;
      case PuzzleDifficulty.hard:
        return 5;
      case PuzzleDifficulty.expert:
        return 6;
      case PuzzleDifficulty.custom:
        return 4;  // 默认为4，实际应由用户指定
    }
  }
}

