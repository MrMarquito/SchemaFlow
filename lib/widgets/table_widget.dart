import 'package:flutter/material.dart';
import '../models/schema_models.dart';

class TableWidget extends StatelessWidget {
  final TableNode table;
  final VoidCallback onTapLink;
  final Function(Offset) onDrag;

  const TableWidget({
    super.key,
    required this.table,
    required this.onTapLink,
    required this.onDrag,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: table.position.dx,
      top: table.position.dy,
      child: GestureDetector(
        onPanUpdate: (details) => onDrag(table.position + details.delta),
        child: Container(
          width: 220,
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF333333), width: 1.5),
            boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 4))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFF2D2D2D),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.table_chart, size: 16, color: Color(0xFF3794FF)),
                    const SizedBox(width: 8),
                    Text(table.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.link, size: 16, color: Colors.grey),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: onTapLink,
                      tooltip: 'Link Table',
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children:
                    table.fields.map((field) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Icon(
                            field.isPrimaryKey ? Icons.vpn_key : Icons.label_outline,
                            size: 12,
                            color: field.isPrimaryKey ? Colors.amber : Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(field.name, style: const TextStyle(color: Colors.white, fontSize: 13)),
                          const Spacer(),
                          Text(
                            field.type.name.toUpperCase(),
                            style: const TextStyle(color: Colors.grey, fontSize: 11, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                  )).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
