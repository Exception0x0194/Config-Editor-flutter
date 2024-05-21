import 'package:flutter/material.dart';
import 'screens/config_editor_screen.dart';
import 'models/cascaded_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Create an initial config
    final initialConfig = CascadedConfig(
      type: 'config',
      comment: 'Initial config',
      inputFloat: 0.0,
      inputInt: 0,
      switches: true,
      strs: ['abc', 'def'],
      configs: [
        CascadedConfig(
          type: 'config',
          comment: 'Child config 1',
          inputFloat: 0.0,
          inputInt: 0,
          switches: true,
          strs: ['ghi', 'jkl'],
          configs: [],
        ),
        CascadedConfig(
          type: 'config',
          comment: 'Child config 2',
          inputFloat: 0.0,
          inputInt: 0,
          switches: true,
          strs: [],
          configs: [],
        )
      ],
    );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'Noto'),
      home: ConfigEditorScreen(initialConfig: initialConfig),
    );
  }
}
