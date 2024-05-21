import 'package:flutter/material.dart';
import '../widgets/config_editor_widget.dart'; // Make sure to correctly import the ConfigEditorWidget
import '../models/cascaded_config.dart';

class ConfigEditorScreen extends StatelessWidget {
  final CascadedConfig config;

  const ConfigEditorScreen({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Config Editor'),
      ),
      body: SingleChildScrollView(
        child: ConfigEditorWidget(
          config: config,
          indentLevel: 0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          copyConfigToClipboard(config),
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Exported to clipboard')))
        },
        tooltip: 'Export to clipboard',
        child: const Icon(Icons.save),
      ),
    );
  }
}
