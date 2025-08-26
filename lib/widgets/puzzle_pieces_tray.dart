import 'package:flutter/material.dart';
import '../models/puzzle_piece.dart';

class PuzzlePiecesTray extends StatelessWidget {
  final List<PuzzlePiece> availablePieces;

  const PuzzlePiecesTray({
    super.key,
    required this.availablePieces,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: availablePieces.isEmpty
                ? const Center(child: Text('没有可用的拼图碎片'))
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: availablePieces.map((piece) {
                        return _buildDraggablePiece(piece);
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // 构建可拖动的拼图碎片
  Widget _buildDraggablePiece(PuzzlePiece piece) {
    return Draggable<PuzzlePiece>(
      data: piece,
      feedback: _buildPieceWidget(piece, 60, isBeingDragged: true),
      childWhenDragging: Container(
        width: 60,
        height: 60,
        margin: const EdgeInsets.all(4),
        color: Colors.grey.shade300,
      ),
      child: _buildPieceWidget(piece, 60),
    );
  }

  // 构建拼图碎片的视觉表示
  Widget _buildPieceWidget(PuzzlePiece piece, double size, {bool isBeingDragged = false}) {
    // 如果有图片，应该显示图片部分
    if (piece.imagePath != null) {
      return Container(
        width: size,
        height: size,
        margin: const EdgeInsets.all(4),
        child: Image.asset(
          piece.imagePath!,
          fit: BoxFit.cover,
          opacity: isBeingDragged ? const AlwaysStoppedAnimation(0.8) : null,
        ),
      );
    }

    // 否则显示颜色块和ID
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.all(4),
      color: isBeingDragged ? piece.color.withOpacity(0.8) : piece.color,
      child: Center(
        child: Text(
          '${piece.id + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

