// To parse this JSON data, do
//
//     final collection = collectionFromJson(jsonString);

import 'dart:convert';

Collection collectionFromJson(String str) =>
    Collection.fromJson(json.decode(str));

String collectionToJson(Collection data) => json.encode(data.toJson());

class Collection {
  final String id;
  final String name;
  final String type;
  final bool system;
  final List<Schema> schema;
  final List<dynamic> indexes;
  final String listRule;
  final String viewRule;
  final String createRule;
  final String updateRule;
  final String deleteRule;
  final CollectionOptions options;

  Collection({
    required this.id,
    required this.name,
    required this.type,
    required this.system,
    required this.schema,
    required this.indexes,
    required this.listRule,
    required this.viewRule,
    required this.createRule,
    required this.updateRule,
    required this.deleteRule,
    required this.options,
  });

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        system: json["system"],
        schema:
            List<Schema>.from(json["schema"].map((x) => Schema.fromJson(x))),
        indexes: List<dynamic>.from(json["indexes"].map((x) => x)),
        listRule: json["listRule"],
        viewRule: json["viewRule"],
        createRule: json["createRule"],
        updateRule: json["updateRule"],
        deleteRule: json["deleteRule"],
        options: CollectionOptions.fromJson(json["options"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "system": system,
        "schema": List<dynamic>.from(schema.map((x) => x.toJson())),
        "indexes": List<dynamic>.from(indexes.map((x) => x)),
        "listRule": listRule,
        "viewRule": viewRule,
        "createRule": createRule,
        "updateRule": updateRule,
        "deleteRule": deleteRule,
        "options": options.toJson(),
      };
}

class CollectionOptions {
  final bool allowEmailAuth;
  final bool allowOAuth2Auth;
  final bool allowUsernameAuth;
  final dynamic exceptEmailDomains;
  final dynamic manageRule;
  final int minPasswordLength;
  final dynamic onlyEmailDomains;
  final bool onlyVerified;
  final bool requireEmail;

  CollectionOptions({
    required this.allowEmailAuth,
    required this.allowOAuth2Auth,
    required this.allowUsernameAuth,
    required this.exceptEmailDomains,
    required this.manageRule,
    required this.minPasswordLength,
    required this.onlyEmailDomains,
    required this.onlyVerified,
    required this.requireEmail,
  });

  factory CollectionOptions.fromJson(Map<String, dynamic> json) =>
      CollectionOptions(
        allowEmailAuth: json["allowEmailAuth"],
        allowOAuth2Auth: json["allowOAuth2Auth"],
        allowUsernameAuth: json["allowUsernameAuth"],
        exceptEmailDomains: json["exceptEmailDomains"],
        manageRule: json["manageRule"],
        minPasswordLength: json["minPasswordLength"],
        onlyEmailDomains: json["onlyEmailDomains"],
        onlyVerified: json["onlyVerified"],
        requireEmail: json["requireEmail"],
      );

  Map<String, dynamic> toJson() => {
        "allowEmailAuth": allowEmailAuth,
        "allowOAuth2Auth": allowOAuth2Auth,
        "allowUsernameAuth": allowUsernameAuth,
        "exceptEmailDomains": exceptEmailDomains,
        "manageRule": manageRule,
        "minPasswordLength": minPasswordLength,
        "onlyEmailDomains": onlyEmailDomains,
        "onlyVerified": onlyVerified,
        "requireEmail": requireEmail,
      };
}

class Schema {
  final bool system;
  final String id;
  final String name;
  final String type;
  final bool required;
  final bool presentable;
  final bool unique;
  final SchemaOptions options;

  Schema({
    required this.system,
    required this.id,
    required this.name,
    required this.type,
    required this.required,
    required this.presentable,
    required this.unique,
    required this.options,
  });

  factory Schema.fromJson(Map<String, dynamic> json) => Schema(
        system: json["system"],
        id: json["id"],
        name: json["name"],
        type: json["type"],
        required: json["required"],
        presentable: json["presentable"],
        unique: json["unique"],
        options: SchemaOptions.fromJson(json["options"]),
      );

  Map<String, dynamic> toJson() => {
        "system": system,
        "id": id,
        "name": name,
        "type": type,
        "required": required,
        "presentable": presentable,
        "unique": unique,
        "options": options.toJson(),
      };
}

class SchemaOptions {
  final String? min;
  final dynamic max;
  final String? pattern;
  final List<String>? mimeTypes;
  final dynamic thumbs;
  final int? maxSelect;
  final int? maxSize;
  final bool? protected;
  final bool? convertUrls;
  final bool? noDecimal;
  final List<dynamic>? exceptDomains;
  final List<dynamic>? onlyDomains;
  final List<String>? values;
  final String? collectionId;
  final bool? cascadeDelete;
  final dynamic minSelect;
  final dynamic displayFields;

  SchemaOptions({
    this.min,
    this.max,
    this.pattern,
    this.mimeTypes,
    this.thumbs,
    this.maxSelect,
    this.maxSize,
    this.protected,
    this.convertUrls,
    this.noDecimal,
    this.exceptDomains,
    this.onlyDomains,
    this.values,
    this.collectionId,
    this.cascadeDelete,
    this.minSelect,
    this.displayFields,
  });

  factory SchemaOptions.fromJson(Map<String, dynamic> json) => SchemaOptions(
        min: json["min"],
        max: json["max"],
        pattern: json["pattern"],
        mimeTypes: json["mimeTypes"] == null
            ? []
            : List<String>.from(json["mimeTypes"]!.map((x) => x)),
        thumbs: json["thumbs"],
        maxSelect: json["maxSelect"],
        maxSize: json["maxSize"],
        protected: json["protected"],
        convertUrls: json["convertUrls"],
        noDecimal: json["noDecimal"],
        exceptDomains: json["exceptDomains"] == null
            ? []
            : List<dynamic>.from(json["exceptDomains"]!.map((x) => x)),
        onlyDomains: json["onlyDomains"] == null
            ? []
            : List<dynamic>.from(json["onlyDomains"]!.map((x) => x)),
        values: json["values"] == null
            ? []
            : List<String>.from(json["values"]!.map((x) => x)),
        collectionId: json["collectionId"],
        cascadeDelete: json["cascadeDelete"],
        minSelect: json["minSelect"],
        displayFields: json["displayFields"],
      );

  Map<String, dynamic> toJson() => {
        "min": min,
        "max": max,
        "pattern": pattern,
        "mimeTypes": mimeTypes == null
            ? []
            : List<dynamic>.from(mimeTypes!.map((x) => x)),
        "thumbs": thumbs,
        "maxSelect": maxSelect,
        "maxSize": maxSize,
        "protected": protected,
        "convertUrls": convertUrls,
        "noDecimal": noDecimal,
        "exceptDomains": exceptDomains == null
            ? []
            : List<dynamic>.from(exceptDomains!.map((x) => x)),
        "onlyDomains": onlyDomains == null
            ? []
            : List<dynamic>.from(onlyDomains!.map((x) => x)),
        "values":
            values == null ? [] : List<dynamic>.from(values!.map((x) => x)),
        "collectionId": collectionId,
        "cascadeDelete": cascadeDelete,
        "minSelect": minSelect,
        "displayFields": displayFields,
      };
}
