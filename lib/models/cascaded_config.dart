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
  Clipboard.setData(ClipboardData(text: jsonStr)).then((_) {
  });
}
