import 'dart:io';
import 'package:path/path.dart' as pp;
import 'package:pocketbase/pocketbase.dart';
import 'package:yaml/yaml.dart';

/// Entry point of the application
/// Authenticates with PocketBase and generates Dart models for collections.
Future<void> main() async {
  final config = loadConfiguration('./pocketbase.yaml');
  final pb = PocketBase(config['hosting']['domain']);

  await authenticate(
    pb,
    config['hosting']['email'],
    config['hosting']['password'],
  );

  final collections = await pb.collections.getFullList();

  createModelsDirectory('./lib/models');
  generateModels(collections);

  formatGeneratedModels('./lib/models');
}

/// Loads the PocketBase configuration from a YAML file.
YamlMap loadConfiguration(String path) {
  final file = File(pp.normalize(path));
  final yamlString = file.readAsStringSync();
  return loadYaml(yamlString);
}

/// Authenticates an admin user with PocketBase.
Future<void> authenticate(PocketBase pb, String email, String password) async {
  await pb.admins.authWithPassword(email, password);
}

/// Ensures that the models directory exists; creates it if not.
void createModelsDirectory(String path) {
  final directory = Directory(path);
  if (!directory.existsSync()) {
    directory.createSync();
  }
}

/// Generates Dart models for all collections.
void generateModels(List<CollectionModel> collections) {
  for (var collection in collections) {
    final modelContent = generateModelForCollection(collection);
    final filePath = 'lib/models/${collection.name}.dart';
    File(filePath).writeAsStringSync(modelContent);
  }
}

/// Formats the generated model files using Dart's formatter.
void formatGeneratedModels(String modelsPath) {
  Process.runSync('dart', ['format', modelsPath]);
}

/// Generates the Dart model code for a single collection.
String generateModelForCollection(CollectionModel collection) {
  final buffer = StringBuffer();

  // Add file documentation and imports
  buffer.writeln("// Model for Collection ${collection.name}");
  buffer.writeln("// ignore_for_file: constant_identifier_names");
  buffer.writeln();
  buffer.writeln("import 'package:pocketbase/pocketbase.dart';");
  buffer.writeln();

  // Add enums for 'select' fields
  for (var field in collection.schema) {
    if (field.type == 'select') {
      generateEnumForField(buffer, field);
    }
  }

  // Add class declaration
  buffer.writeln("class ${removeSnake(capName(collection.name))}Model {");
  generateClassFields(buffer, collection.schema);
  generateConstructor(collection.name, buffer, collection.schema);
  generateFactoryConstructor(buffer, collection);
  generateToMapMethod(buffer, collection.schema);
  buffer.writeln("}"); // Close class

  return buffer.toString();
}

/// Generates an enum for a 'select' field in the collection schema.
void generateEnumForField(StringBuffer buffer, SchemaField field) {
  buffer.writeln('enum ${capName(removeSnake(field.name))}Enum {');
  for (var option in field.options['values']) {
    buffer.writeln('${removeSnake(option)},');
  }
  buffer.writeln('}');

  buffer.writeln('final _${removeSnake(field.name)}EnumToMap = {');
  for (var option in field.options['values']) {
    buffer.writeln(
        '${capName(removeSnake(field.name))}Enum.${removeSnake(option)}: "$option",');
  }
  buffer.writeln('};');

  buffer.writeln('final _${removeSnake(field.name)}EnumFromMap = {');
  for (var option in field.options['values']) {
    buffer.writeln(
        '"$option": ${capName(removeSnake(field.name))}Enum.${removeSnake(option)},');
  }
  buffer.writeln('};');
}

/// Generates the fields and their corresponding constants for the class.
void generateClassFields(StringBuffer buffer, List<SchemaField> schema) {
  buffer.writeln(" \n // Fields");
  buffer.writeln("  final String id;");
  buffer.writeln("  static const String Id = 'id';");

  buffer.writeln("  \n final DateTime created;");
  buffer.writeln("  static const String Created = 'created';");

  buffer.writeln("  \n final DateTime updated;");
  buffer.writeln("  static const String Updated = 'updated';");

  for (var field in schema) {
    buffer.writeln("  \n final ${getType(field)} ${removeSnake(field.name)};");
    buffer.writeln(
        "  static const String ${removeSnake(capName(field.name))} = '${field.name}';");
  }
}

/// Generates the constructor for the class.
void generateConstructor(
    String colName, StringBuffer buffer, List<SchemaField> schema) {
  buffer.writeln("\n  const ${removeSnake(capName(colName))}Model({");
  buffer.writeln("    required this.id,");
  buffer.writeln("    required this.created,");
  buffer.writeln("    required this.updated,");

  for (var field in schema) {
    buffer.writeln(
        "    ${field.required ? 'required' : ''} this.${removeSnake(field.name)},");
  }

  buffer.writeln("  });");
}

/// Generates the factory constructor for creating an instance from a PocketBase model.
void generateFactoryConstructor(
    StringBuffer buffer, CollectionModel collection) {
  buffer.writeln(
      "\n  factory ${removeSnake(capName(collection.name))}Model.fromModel(RecordModel r) {");
  buffer.writeln("    return ${removeSnake(capName(collection.name))}Model(");
  buffer.writeln("      id: r.id,");
  buffer.writeln("      created: DateTime.parse(r.created),");
  buffer.writeln("      updated: DateTime.parse(r.updated),");

  for (var field in collection.schema) {
    if (field.type == 'select') {
      buffer.writeln(
          "      ${removeSnake(field.name)}: _${removeSnake(field.name)}EnumFromMap[r.data['${field.name}']]!,");
    } else {
      buffer.writeln(
          "      ${removeSnake(field.name)}: r.data['${field.name}'],");
    }
  }

  buffer.writeln("    );");
  buffer.writeln("  }");
}

/// Generates the `toMap` method for the class, converting it to a Map.
void generateToMapMethod(StringBuffer buffer, List<SchemaField> schema) {
  buffer.writeln("\n  Map<String, dynamic> toMap() {");
  buffer.writeln("    return {");

  for (var field in schema) {
    if (field.type == 'select') {
      buffer.writeln(
          "      '${field.name}': _${removeSnake(field.name)}EnumToMap[${removeSnake(field.name)}],");
    } else {
      buffer.writeln("      '${field.name}': ${removeSnake(field.name)},");
    }
  }

  buffer.writeln("    };");
  buffer.writeln("  }");
}

/// Capitalizes the first letter of a string.
String capName(String str) {
  if (str == 'date_time' || str == 'datetime' || str == 'dateTime') {
    return 'DateTimez';
  }
  return str[0].toUpperCase() + str.substring(1);
}

/// Converts a snake_case string to camelCase.
String removeSnake(String str) {
  final parts = str.split('_');
  return parts.fold(
      '',
      (previous, element) =>
          previous.isEmpty ? element : previous + capName(element));
}

/// Maps the schema field type to a Dart type.
String getType(SchemaField field) {
  switch (field.type) {
    case 'text':
      return field.required ? 'String' : 'String?';
    case 'number':
      return field.required ? 'num' : 'num?';
    case 'bool':
      return field.required ? 'bool' : 'bool?';
    case 'date':
      return field.required ? 'DateTime' : 'DateTime?';
    case 'select':
      return field.required
          ? '${capName(removeSnake(field.name))}Enum'
          : '${capName(removeSnake(field.name))}Enum?';
    default:
      return 'dynamic';
  }
}
