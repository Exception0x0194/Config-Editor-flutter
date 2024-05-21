import 'dart:convert';

import 'package:flutter/services.dart';

class CascadedConfig {
  String type;
  String comment;
  double inputFloat;
  int inputInt;
  bool switches;
  List<String> strs;
  List<CascadedConfig> configs;

  CascadedConfig({
    this.type = 'config',
    this.comment = 'config',
    this.inputFloat = 0.0,
    this.inputInt = 0,
    this.switches = true,
    this.strs = const [],
    this.configs = const [],
  });

  factory CascadedConfig.fromJson(Map<String, dynamic> json) {
    return CascadedConfig(
      type: json['type'] as String,
      comment: json['comment'] as String,
      inputFloat: json['inputFloat'] as double,
      inputInt: json['inputInt'] as int,
      switches: json['switches'] as bool,
      strs: List<String>.from(json['strs']),
      configs: List<CascadedConfig>.from(
          json['configs']?.map((x) => CascadedConfig.fromJson(x)) ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'comment': comment,
        'inputFloat': inputFloat,
        'inputInt': inputInt,
        'switches': switches,
        'strs': strs,
        'configs': configs.map((c) => c.toJson()).toList(),
      };
}

void copyConfigToClipboard(CascadedConfig config) {
  final jsonStr = json.encode(config.toJson());
  Clipboard.setData(ClipboardData(text: jsonStr)).then((_) {});
}

Future<CascadedConfig?> getConfigFromClipboard() async {
  ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
  if (data != null && data.text != null) {
    try {
      final Map<String, dynamic> jsonConfig = json.decode(data.text!);
      return CascadedConfig.fromJson(jsonConfig);
    } catch (e) {
      print("Error parsing JSON from clipboard: $e");
      return null;
    }
  }
  return null;
}
