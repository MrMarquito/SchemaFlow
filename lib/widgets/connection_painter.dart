import 'package:flutter/material.dart';
import '../models/schema_models.dart';

class ConnectionPainter extends CustomPainter {
  final List<TableNode> tables;
  final List<Relationship> relationships;

  ConnectionPainter({required this.tables, required this.relationships});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xDEED66FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..isAntiAlias = true;

    for (var rel in relationships) {
      // Find corresponding tables in state
      final fromTable = tables.firstWhere((t) => t.id == rel.fromTableId);
      final toTable = tables.firstWhere((t) => t.id == rel.toTableId);

      // Establish approx anchors
      final startPoint = fromTable.position + const Offset(110, 60);
      final endPoint = toTable.position + const Offset(110, 60);

      final path = Path();
      path.moveTo(startPoint.dx, startPoint.dy);

      // Calculate smooth cube
      final controlPoint1 = Offset(
        startPoint.dx + (endPoint.dx - startPoint.dx) / 2,
        startPoint.dy,
      );
      final controlPoint2 = Offset(
        startPoint.dx + (endPoint.dx - startPoint.dx) / 2,
        endPoint.dy,
      );

      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        endPoint.dx,
        endPoint.dy,
      );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ConnectionPainter oldDelegate) => true;
}
