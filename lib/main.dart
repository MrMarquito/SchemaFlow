import 'package:flutter/material.dart';
import 'models/schema_models.dart';
import 'widgets/connection_painter.dart';
import 'widgets/table_widget.dart';

void main() => runApp(const SchemaFlowApp());

class SchemaFlowApp extends StatelessWidget {
  const SchemaFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SchemaFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const MainCanvasScreen(),
    );
  }
}

class MainCanvasScreen extends StatefulWidget {
  const MainCanvasScreen({super.key});

  @override
  State<MainCanvasScreen> createState() => _MainCanvasScreenState();
}

class _MainCanvasScreenState extends State<MainCanvasScreen> {
  final List<TableNode> _tables = [];
  final List<Relationship> _relationships = [];
  String? _linkingTableId;
  String _generatedSQl = "-- Create structural items to see output here";

  @override
  void initState() {
    super.initState();
    _tables.addAll([
      TableNode(
        id: 'u1',
        name: 'users',
        position: const Offset(80, 150),
        fields: [
          Field(name: 'id', type: FieldType.int, isPrimaryKey: true),
          Field(name: 'username', type: FieldType.varchar),
          Field(name: 'created_at', type: FieldType.datetime),
        ],
      ),
      TableNode(
        id: 'o1',
        name: 'orders',
        position: const Offset(420, 280),
        fields: [
          Field(name: 'id', type: FieldType.int, isPrimaryKey: true),
          Field(name: 'userd_id', type: FieldType.int),
          Field(name: 'total_price', type: FieldType.int),
        ],
      ),
    ]);
    _compileSQL();
  }

  void _addNewTable() {
    setState(() {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      _tables.add(
        TableNode(
          id: id,
          name: 'new_table_$id'.substring(0, 14),
          position: const Offset(200, 200),
          fields: [
            Field(name: 'id', type: FieldType.int, isPrimaryKey: true),
            Field(name: 'content', type: FieldType.text),
          ],
        ),
      );
    });
    _compileSQL();
  }

  void _handleLinking(String tableId) {
    if (_linkingTableId == null) {
      setState(() => _linkingTableId = tableId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select target table to complete relationship links'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      if (_linkingTableId != tableId) {
        setState(() {
          _relationships.add(
            Relationship(fromTableId: _linkingTableId!, toTableId: tableId),
          );
          _linkingTableId = null;
        });
        _compileSQL();
      } else {
        setState(() => _linkingTableId = null);
      }
    }
  }

  void _compileSQL() {
    StringBuffer buffer = StringBuffer();
    buffer.writeln("-- Generated via SchemaFlow Architecture Enginge\n");

    for (var table in _tables) {
      buffer.writeln("CREATE TABLE ${table.name} (");

      for (int i = 0; i < table.fields.length; i++) {
        final f = table.fields[i];
        String typeStr = f.type == FieldType.varchar
            ? "VARCHAR(255)"
            : f.type.name.toUpperCase();
        String pkStr = f.isPrimaryKey ? "PRIMARY KEY" : "";
        String comma = (i == table.fields.length - 1) ? "" : ",";
        buffer.writeln(" ${f.name} $typeStr$pkStr$comma");
      }
      buffer.writeln(");\n");
    }
    setState(() => _generatedSQl = buffer.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'SchemaFlow // Data Designer Engine',
          style: TextStyle(fontFamily: 'monospace', fontSize: 16),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: _addNewTable,
              icon: const Icon(Icons.add_box),
              label: const Text('Spawn Table'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0E639C),
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: const Color(0xFF141414),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: ConnectionPainter(
                        tables: _tables,
                        relationships: _relationships,
                      ),
                    ),
                  ),
                  ..._tables.map(
                    (table) => TableWidget(
                      table: table,
                      onTapLink: () => _handleLinking(table.id),
                      onDrag: (newPos) => setState(() {
                        table.position = newPos;
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E1E),
                border: Border(left: BorderSide(color: Color(0xFF2D2D2D), width: 2)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.code, color: Colors.greenAccent, size: 18),
                      SizedBox(width: 8),
                      Text("LIVE SQL DDL EXPORT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const Divider(color: Color(0xFF333333), height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        _generatedSQl,
                        style: const TextStyle(fontFamily: 'monospace', color: Color(0xFFD4D4D4), fontSize: 13, height: 1.4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
