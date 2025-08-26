import 'package:flutter/material.dart';
import '../models/puzzle_piece.dart';

class PuzzleBoard extends StatelessWidget {
  final List<List<PuzzlePiece?>> board;
  final int gridSize;
  final Function(int row, int col) onTileTap;
  final Function(PuzzlePiece piece, int row, int col) onTileDrop;

  const PuzzleBoard({
    super.key,
    required this.board,
    required this.gridSize,
    required this.onTileTap,
    required this.onTileDrop,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
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
            crossAxisCount: gridSize,
          ),
          itemCount: gridSize * gridSize,
          itemBuilder: (context, index) {
            final row = index ~/ gridSize;
            final col = index % gridSize;
            final piece = board[row][col];

            return DragTarget<PuzzlePiece>(
              onAccept: (draggedPiece) {
                onTileDrop(draggedPiece, row, col);
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
                          onTap: () => onTileTap(row, col),
                          child: _buildPieceWidget(piece),
                        )
                      : null,
                );
              },
            );
          },
        ),
      ),
    );
  }

  // 构建拼图碎片的视觉表示
  Widget _buildPieceWidget(PuzzlePiece piece) {
    // 如果有图片，应该显示图片部分
    if (piece.imagePath != null) {
      return Image.asset(
        piece.imagePath!,
        fit: BoxFit.cover,
      );
    }

    // 否则显示颜色块和ID
    return Container(
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
    );
  }
}

