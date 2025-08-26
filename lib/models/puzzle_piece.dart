import 'package:flutter/material.dart';

// 拼图碎片模型
class PuzzlePiece {
  final int id;  // 碎片ID
  final int correctRow;  // 正确的行位置
  final int correctCol;  // 正确的列位置
  final String? imagePath;  // 图片路径
  final Color color;  // 碎片颜色(当没有图片时使用)

  // 碎片当前的位置状态
  bool isPlaced = false;  // 是否已放置在拼图板上
  int? currentRow;  // 当前所在行
  int? currentCol;  // 当前所在列

  PuzzlePiece({
    required this.id,
    required this.correctRow,
    required this.correctCol,
    this.imagePath,
    this.color = Colors.blue,
    this.currentRow,
    this.currentCol,
  });

  // 判断碎片是否在正确位置
  bool isInCorrectPosition() {
    return isPlaced &&
           currentRow == correctRow &&
           currentCol == correctCol;
  }

  // 放置碎片
  void place(int row, int col) {
    isPlaced = true;
    currentRow = row;
    currentCol = col;
  }

  // 从拼图板上移除
  void remove() {
    isPlaced = false;
    currentRow = null;
    currentCol = null;
  }

  // 创建碎片的副本
  PuzzlePiece copyWith({
    int? id,
    int? correctRow,
    int? correctCol,
    String? imagePath,
    Color? color,
    bool? isPlaced,
    int? currentRow,
    int? currentCol,
  }) {
    final copy = PuzzlePiece(
      id: id ?? this.id,
      correctRow: correctRow ?? this.correctRow,
      correctCol: correctCol ?? this.correctCol,
      imagePath: imagePath ?? this.imagePath,
      color: color ?? this.color,
      currentRow: currentRow ?? this.currentRow,
      currentCol: currentCol ?? this.currentCol,
    );
    copy.isPlaced = isPlaced ?? this.isPlaced;
    return copy;
  }
}

