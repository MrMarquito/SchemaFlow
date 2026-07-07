import 'package:flutter/material.dart';

enum FieldType { int, varchar, boolean, datetime, text }

class Field {
  final String name;
  final FieldType type;
  final bool isPrimaryKey;

  Field({required this.name, required this.type, this.isPrimaryKey = false});
}

class TableNode {
  final String id;
  String name;
  Offset position;
  List<Field> fields;

  TableNode({
    required this.id,
    required this.name,
    required this.position,
    required this.fields,
  });
}

class Relationship {
  final String fromTableId;
  final String toTableId;

  Relationship({
    required this.fromTableId,
    required this.toTableId
  });
}
