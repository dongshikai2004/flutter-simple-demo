import 'package:flutter/material.dart';  // 导入Flutter的材料设计库
import 'dart:math';  // 导入数学库，用于拼图算法

// 应用程序入口点
void main() {
  runApp(const PuzzleApp());  // 运行拼图应用
}

// 应用的根部件
class PuzzleApp extends StatelessWidget {
  const PuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '拼图大师',  // 应用名称
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),  // 首页
    );
  }
}

// 首页部件，作为应用的主入口
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('拼图大师'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 应用标志和简介
              const Icon(Icons.extension, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                '拼图大师',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                '享受拼图游戏的乐趣，或创建你自己的拼图',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),

              // 拼图游戏入口按钮
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GameSelectionPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.gamepad),
                    SizedBox(width: 10),
                    Text('开始拼图', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 拼图编辑器入口按钮
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PuzzleEditorPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 10),
                    Text('拼图编辑器', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 游戏选择页面
class GameSelectionPage extends StatelessWidget {
  const GameSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 预定义的拼图类别
    final List<Map<String, dynamic>> puzzleCategories = [
      {'name': '自然风景', 'icon': Icons.landscape, 'color': Colors.green},
      {'name': '艺术画作', 'icon': Icons.palette, 'color': Colors.purple},
      {'name': '动物世界', 'icon': Icons.pets, 'color': Colors.orange},
      {'name': '建筑奇观', 'icon': Icons.architecture, 'color': Colors.blue},
      {'name': '我的收藏', 'icon': Icons.favorite, 'color': Colors.red},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('选择拼图'),
      ),
      body: Column(
        children: [
          // 难度选择器
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('难度选择', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _difficultyButton(context, '简单', '3×3', Colors.green),
                        _difficultyButton(context, '中等', '4×4', Colors.orange),
                        _difficultyButton(context, '困难', '5×5', Colors.red),
                        _difficultyButton(context, '专家', '6×6', Colors.purple),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 拼图类别列表
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: puzzleCategories.length,
              itemBuilder: (context, index) {
                final category = puzzleCategories[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: category['color'],
                      child: Icon(category['icon'], color: Colors.white),
                    ),
                    title: Text(category['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('包含多种精彩拼图'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PuzzleListPage(category: category['name']),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 难度选择按钮
  Widget _difficultyButton(BuildContext context, String label, String size, Color color) {
    return ElevatedButton(
      onPressed: () {
        // 此处可设置全局难度，后面实现
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(size, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

// 拼图列表页面
class PuzzleListPage extends StatelessWidget {
  final String category;

  const PuzzleListPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // 这里应该从数据库或API获取拼图列表，这里做演示
    final List<Map<String, dynamic>> puzzles = List.generate(
      12,
      (index) => {
        'id': 'puzzle_$index',
        'name': '$category 拼图 ${index + 1}',
        'difficulty': index % 4,
        'bestTime': index * 15 + 30,
        'completed': Random().nextBool(),
      }
    );

    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: puzzles.length,
        itemBuilder: (context, index) {
          final puzzle = puzzles[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PuzzleGamePage(
                    puzzleId: puzzle['id'],
                    puzzleName: puzzle['name'],
                  ),
                ),
              );
            },
            child: Card(
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 拼图预览图（实际应用中应加载真实图片）
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey.shade300,
                      child: Center(child: Icon(Icons.image, size: 50, color: Colors.grey.shade500)),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          puzzle['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              puzzle['completed'] ? Icons.check_circle : Icons.timer,
                              size: 16,
                              color: puzzle['completed'] ? Colors.green : Colors.orange
                            ),
                            const SizedBox(width: 4),
                            Text(
                              puzzle['completed'] ? '已完成' : '最佳: ${puzzle['bestTime']}秒',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// 拼图游戏页面
class PuzzleGamePage extends StatefulWidget {
  final String puzzleId;
  final String puzzleName;

  const PuzzleGamePage({
    super.key,
    required this.puzzleId,
    required this.puzzleName,
  });

  @override
  State<PuzzleGamePage> createState() => _PuzzleGamePageState();
}

class _PuzzleGamePageState extends State<PuzzleGamePage> {
  int _seconds = 0;
  int _moves = 0;
  bool _isPaused = false;
  bool _isGameCompleted = false;

  // 拼图区域的网格大小
  final int _gridSize = 4; // 4x4网格

  // 表示拼图板上的位置，null表示空位
  List<List<PuzzlePiece?>> _puzzleBoard = [];

  // 表示下方可选的拼图碎片
  List<PuzzlePiece> _availablePieces = [];

  @override
  void initState() {
    super.initState();
    _initializePuzzle();
    // 实际应用中应启动计时器
    // Timer.periodic(const Duration(seconds: 1), (timer) {
    //   if (!_isPaused && !_isGameCompleted) {
    //     setState(() {
    //       _seconds++;
    //     });
    //   }
    // });
  }

  // 初始化拼图
  void _initializePuzzle() {
    // 初始化拼图板(全部为空)
    _puzzleBoard = List.generate(
      _gridSize,
      (_) => List.generate(_gridSize, (_) => null)
    );

    // 生成拼图碎片
    _availablePieces = [];
    for (int i = 0; i < _gridSize * _gridSize; i++) {
      _availablePieces.add(
        PuzzlePiece(
          id: i,
          correctRow: i ~/ _gridSize,
          correctCol: i % _gridSize,
          // 实际应用中应加载真实图片
          color: Colors.primaries[i % Colors.primaries.length],
        )
      );
    }

    // 打乱顺序
    _availablePieces.shuffle();
  }

  // 处理拼图碎片放置
  void _placePiece(PuzzlePiece piece, int targetRow, int targetCol) {
    if (_puzzleBoard[targetRow][targetCol] == null) {
      setState(() {
        // 从可用碎片中移除
        _availablePieces.remove(piece);
        // 放置到拼图板上
        _puzzleBoard[targetRow][targetCol] = piece;
        _moves++;

        // 检查是否完成拼图
        _checkCompletion();
      });
    }
  }

  // 从拼图板上取回碎片
  void _retrievePiece(int row, int col) {
    if (_puzzleBoard[row][col] != null) {
      setState(() {
        // 取回碎片到可用列表
        _availablePieces.add(_puzzleBoard[row][col]!);
        // 清空拼图板上的位置
        _puzzleBoard[row][col] = null;
        _moves++;
      });
    }
  }

  // 检查是否完成拼图
  void _checkCompletion() {
    // 检查所有格子是否都已放置碎片
    bool allFilled = true;
    for (int i = 0; i < _gridSize; i++) {
      for (int j = 0; j < _gridSize; j++) {
        if (_puzzleBoard[i][j] == null) {
          allFilled = false;
          break;
        }
      }
    }

    // 检查所有碎片是否都在正确位置
    bool allCorrect = true;
    if (allFilled) {
      for (int i = 0; i < _gridSize; i++) {
        for (int j = 0; j < _gridSize; j++) {
          final piece = _puzzleBoard[i][j]!;
          if (piece.correctRow != i || piece.correctCol != j) {
            allCorrect = false;
            break;
          }
        }
      }
    } else {
      allCorrect = false;
    }

    if (allFilled && allCorrect) {
      setState(() {
        _isGameCompleted = true;
      });

      // 显示完成提示
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('恭喜!'),
          content: Text('你完成了拼图!\n用时: $_seconds 秒\n步数: $_moves 步'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('确定'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.puzzleName),
        actions: [
          IconButton(
            icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
            onPressed: () {
              setState(() {
                _isPaused = !_isPaused;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 游戏信息（时间和移动次数）
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _infoCard(Icons.timer, '时间', '$_seconds 秒'),
                _infoCard(Icons.swap_horiz, '移动', '$_moves 步'),
              ],
            ),
          ),

          // 上方的拼图板区域
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _gridSize,
                    ),
                    itemCount: _gridSize * _gridSize,
                    itemBuilder: (context, index) {
                      final row = index ~/ _gridSize;
                      final col = index % _gridSize;
                      final piece = _puzzleBoard[row][col];

                      return DragTarget<PuzzlePiece>(
                        onAccept: (draggedPiece) {
                          _placePiece(draggedPiece, row, col);
                        },
                        builder: (context, candidateData, rejectedData) {
                          return Container(
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: candidateData.isNotEmpty
                                    ? Colors.green
                                    : Colors.grey.shade300,
                                width: candidateData.isNotEmpty ? 2 : 1,
                              ),
                            ),
                            child: piece != null
                                ? GestureDetector(
                                    onTap: () => _retrievePiece(row, col),
                                    child: Container(
                                      color: piece.color,
                                      child: Center(
                                        child: Text(
                                          '${piece.id + 1}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : null,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // 下方的拼图碎片区域
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '可用拼图碎片:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _availablePieces.isEmpty
                        ? const Center(child: Text('没有可用的拼图碎片'))
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: _availablePieces.map((piece) {
                                return Draggable<PuzzlePiece>(
                                  data: piece,
                                  feedback: Container(
                                    width: 60,
                                    height: 60,
                                    color: piece.color.withOpacity(0.8),
                                    child: Center(
                                      child: Text(
                                        '${piece.id + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  childWhenDragging: Container(
                                    width: 60,
                                    height: 60,
                                    margin: const EdgeInsets.all(4),
                                    color: Colors.grey.shade300,
                                  ),
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    margin: const EdgeInsets.all(4),
                                    color: piece.color,
                                    child: Center(
                                      child: Text(
                                        '${piece.id + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),

          // 游戏控制按钮
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {
                      _initializePuzzle();
                      _moves = 0;
                      _seconds = 0;
                      _isGameCompleted = false;
                    });
                  },
                  tooltip: '重新开始',
                ),
                IconButton(
                  icon: const Icon(Icons.help_outline),
                  onPressed: () {
                    // 显示提示
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('游戏帮助'),
                        content: const Text('拖动下方的拼图碎片到上方对应的位置。\n点击上方已放置的碎片可以取回。'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('了解了'),
                          ),
                        ],
                      ),
                    );
                  },
                  tooltip: '帮助',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 信息卡片部件
  Widget _infoCard(IconData icon, String label, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(fontSize: 12)),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// 拼图碎片模型
class PuzzlePiece {
  final int id;  // 碎片ID
  final int correctRow;  // 正确的行位置
  final int correctCol;  // 正确的列位置
  final Color color;  // 碎片颜色(实际应用中应该是图片)

  PuzzlePiece({
    required this.id,
    required this.correctRow,
    required this.correctCol,
    required this.color,
  });
}

// 拼图编辑器页面
class PuzzleEditorPage extends StatefulWidget {
  const PuzzleEditorPage({super.key});

  @override
  State<PuzzleEditorPage> createState() => _PuzzleEditorPageState();
}

class _PuzzleEditorPageState extends State<PuzzleEditorPage> {
  int _gridSize = 3; // 默认3x3
  String _puzzleShape = '方形'; // 默认形状

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('拼图编辑器'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // 保存拼图设置
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('拼图已保存')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片选择区域
            Card(
              child: Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey.shade200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey.shade600),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // 选择图片（实际应用需要实现图片选择功能）
                        },
                        child: const Text('选择图片'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 设置区域
            const Text('拼图设置', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // 网格大小设置
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('拼图块数量'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('3×3'),
                        Expanded(
                          child: Slider(
                            value: _gridSize.toDouble(),
                            min: 2,
                            max: 6,
                            divisions: 4,
                            label: '${_gridSize}×${_gridSize}',
                            onChanged: (value) {
                              setState(() {
                                _gridSize = value.round();
                              });
                            },
                          ),
                        ),
                        const Text('6×6'),
                      ],
                    ),
                    Center(
                      child: Text(
                        '${_gridSize}×${_gridSize} (${_gridSize * _gridSize} 块)',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 拼图形状设置
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('拼图形状'),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _shapeOption('方形', Icons.crop_square),
                        _shapeOption('异形', Icons.extension),
                        _shapeOption('三角形', Icons.change_history),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 预览区域
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('预览', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    AspectRatio(
                      aspectRatio: 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.grey.shade200,
                        ),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: _gridSize,
                          ),
                          itemCount: _gridSize * _gridSize,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.all(2),
                              color: Colors.white,
                              child: Center(
                                child: Text('${index + 1}'),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 创建拼图按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 创建拼图
                  // 实际应用应该生成拼图并跳转到游戏页面
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('拼图已创建')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('创建拼图', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 形状选择选项
  Widget _shapeOption(String shape, IconData icon) {
    final isSelected = _puzzleShape == shape;

    return GestureDetector(
      onTap: () {
        setState(() {
          _puzzleShape = shape;
        });
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey.shade700,
              size: 30,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            shape,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
