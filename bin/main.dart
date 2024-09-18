import 'dart:io';
import 'package:path/path.dart' as pp;
import 'package:pocketbase/pocketbase.dart';
import 'package:yaml/yaml.dart';
import 'package:args/args.dart';

/// Entry point of the application
/// Authenticates with PocketBase and generates Dart models for collections.
Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption(
      'config',
      abbr: 'c',
      defaultsTo: './pocketbase.yaml',
      help: 'Configuration file path.',
    )
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Show help information.',
    );

  final argResults = parser.parse(arguments);

  if (argResults['help'] as bool) {
    printHelp(parser);
    exit(0);
  }

  final configPath = argResults['config'] as String;

  print('Loading configuration from $configPath');

  Config config;
  try {
    config = loadConfiguration(configPath);
  } catch (e) {
    print('Error loading configuration: $e');
    printHelp(parser);
    exit(1);
  }

  print('Authenticating with PocketBase');

  final pb = PocketBase(config.domain);

  try {
    await authenticate(
      pb,
      config.email,
      config.password,
    );
  } catch (e) {
    print('Authentication failed: $e');
    print('Please check your email and password in the configuration file.');
    exit(1);
  }

  print('Fetching collections from PocketBase');

  final collections = await pb.collections.getFullList();

  print('Creating models directory at ${config.outputDirectory}');

  createModelsDirectory(config.outputDirectory);

  print('Generating models');

  generateModels(collections, config.outputDirectory);

  print('Formatting generated models');

  formatGeneratedModels(config.outputDirectory);

  print('Done');
}

/// Class representing the configuration.
class Config {
  final String domain;
  final String email;
  final String password;
  final String outputDirectory;

  Config({
    required this.domain,
    required this.email,
    required this.password,
    required this.outputDirectory,
  });

  factory Config.fromYaml(YamlMap yaml) {
    final pbConfig = yaml['pocketbase'];
    if (pbConfig == null) {
      throw Exception('Missing "pocketbase" section in configuration.');
    }

    final hostingConfig = pbConfig['hosting'];
    if (hostingConfig == null) {
      throw Exception(
          'Missing "hosting" section under "pocketbase" in configuration.');
    }

    final domain = hostingConfig['domain'];
    final email = hostingConfig['email'];
    final password = hostingConfig['password'];

    if (domain == null || email == null || password == null) {
      throw Exception(
          'Missing "domain", "email", or "password" in hosting configuration.');
    }

    final outputDirectory = pbConfig['output_directory'] ?? './lib/models';

    return Config(
      domain: domain,
      email: email,
      password: password,
      outputDirectory: outputDirectory,
    );
  }
}

/// Loads the PocketBase configuration from a YAML file.
Config loadConfiguration(String path) {
  final file = File(pp.normalize(path));
  if (!file.existsSync()) {
    throw Exception('Configuration file not found at $path');
  }
  final yamlString = file.readAsStringSync();
  final yaml = loadYaml(yamlString);
  return Config.fromYaml(yaml);
}

/// Prints help information.
void printHelp(ArgParser parser) {
  print('Pocketbase Plus Model Generator\n');
  print('Generates Dart models from your PocketBase collections.\n');
  print('Usage:');
  print('  dart run pocketbase_plus:main [options]\n');
  print('Options:');
  print(parser.usage);
  print('''
Expected configuration file in YAML format with the following structure:

pocketbase:
  hosting:
    domain: 'https://your-pocketbase-domain.com'
    email: 'your-email@example.com'
    password: 'your-password'
  output_directory: './lib/models'  # Optional, default is './lib/models'

Example configuration file:

pocketbase:
  hosting:
    domain: 'https://pocketbase.example.com'
    email: 'admin@example.com'
    password: 'your-password'
  output_directory: './lib/models'
''');
}

/// Authenticates an admin user with PocketBase.
Future<void> authenticate(PocketBase pb, String email, String password) async {
  await pb.admins.authWithPassword(email, password);
}

/// Ensures that the models directory exists; creates it if not.
void createModelsDirectory(String path) {
  final directory = Directory(path);
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }
}

/// Generates Dart models for all collections.
void generateModels(List<CollectionModel> collections, String outputDirectory) {
  for (var collection in collections) {
    final modelContent = generateModelForCollection(collection);
    final filePath = pp.join(outputDirectory, '${collection.name}.dart');
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
  buffer.writeln('// This file is auto-generated. Do not modify manually.');
  buffer.writeln('// Model for collection ${collection.name}');
  buffer.writeln('// ignore_for_file: constant_identifier_names');
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
  // Start the enum definition with constructor
  buffer.writeln('enum ${capName(removeSnake(field.name))}Enum {');
  for (var option in field.options['values']) {
    buffer.writeln('${removeSnake(option)}("$option"),');
  }
  buffer.writeln(';\n');

  // Add a final String field and the constructor
  buffer.writeln('final String value;\n');
  buffer
      .writeln('const ${capName(removeSnake(field.name))}Enum(this.value);\n');

  // Add fromValue static method
  buffer.writeln(
      'static ${capName(removeSnake(field.name))}Enum fromValue(String value) {');
  buffer.writeln(
      '  return ${capName(removeSnake(field.name))}Enum.values.firstWhere(');
  buffer.writeln('    (enumValue) => enumValue.value == value,');
  buffer.writeln(
      '    orElse: () => throw ArgumentError("Invalid value: \$value"),');
  buffer.writeln('  );');
  buffer.writeln('}\n');

  buffer.writeln('}');
  buffer.writeln();
}

/// Generates the fields and their corresponding constants for the class.
void generateClassFields(StringBuffer buffer, List<SchemaField> schema) {
  buffer.writeln(" \n // Fields");
  buffer.writeln("  final String? id;");
  buffer.writeln("  static const String Id = 'id';");

  buffer.writeln("  \n final DateTime? created;");
  buffer.writeln("  static const String Created = 'created';");

  buffer.writeln("  \n final DateTime? updated;");
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
  buffer.writeln("    this.id,");
  buffer.writeln("    this.created,");
  buffer.writeln("    this.updated,");

  for (var field in schema) {
    buffer.writeln(
        "    ${field.required ? 'required' : ''} this.${removeSnake(field.name)},");
  }

  buffer.writeln("  });");

  // Add copyWith method after constructor
  buffer.writeln("\n  ${removeSnake(capName(colName))}Model copyWith({");
  buffer.writeln("    String? id,");
  buffer.writeln("    DateTime? created,");
  buffer.writeln("    DateTime? updated,");

  for (var field in schema) {
    var type = getType(field);
    if (field.required && type != "dynamic") {
      buffer.writeln("    ${getType(field)}? ${removeSnake(field.name)},");
    } else {
      buffer.writeln("    ${getType(field)}  ${removeSnake(field.name)},");
    }
  }

  buffer.writeln("  }) {");
  buffer.writeln("    return ${removeSnake(capName(colName))}Model(");
  buffer.writeln("      id: id ?? this.id,");
  buffer.writeln("      created: created ?? this.created,");
  buffer.writeln("      updated: updated ?? this.updated,");

  for (var field in schema) {
    buffer.writeln(
        "      ${removeSnake(field.name)}: ${removeSnake(field.name)} ?? this.${removeSnake(field.name)},");
  }

  buffer.writeln("    );");
  buffer.writeln("  }");
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
          "      ${removeSnake(field.name)}: ${capName(removeSnake(field.name))}Enum.fromValue(r.data['${field.name}']! as String),");
    } else if (field.type == 'date') {
      if (field.required) {
        buffer.writeln(
            "       ${removeSnake(field.name)}: DateTime.parse(r.data['${field.name}']! as String),");
      } else {
        buffer.writeln(
            "      ${removeSnake(field.name)}: r.data['${field.name}'] != null && r.data['${field.name}'] != '' ? DateTime.parse(r.data['${field.name}']) : null,");
      }
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
      buffer
          .writeln("      '${field.name}': ${removeSnake(field.name)}.value,");
    } else if (field.type == 'date') {
      if (field.required) {
        buffer.writeln(
            "      '${field.name}': ${removeSnake(field.name)}.toIso8601String(),");
      } else {
        buffer.writeln(
            "      '${field.name}': ${removeSnake(field.name)}?.toIso8601String(),");
      }
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
