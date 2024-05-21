import 'package:flutter/material.dart';
import '../widgets/config_editor_widget.dart';
import '../models/cascaded_config.dart';

class ConfigEditorScreen extends StatefulWidget {
  final CascadedConfig initialConfig;

  const ConfigEditorScreen({super.key, required this.initialConfig});

  @override
  ConfigEditorScreenState createState() => ConfigEditorScreenState();
}

class ConfigEditorScreenState extends State<ConfigEditorScreen> {
  late CascadedConfig config; // Now managed within the State

  @override
  void initState() {
    super.initState();
    config = widget
        .initialConfig; // Initialize config from the widget's initial config
  }

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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                copyConfigToClipboard(config);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Exported to clipboard')));
              },
              tooltip: 'Export to clipboard',
              child: const Icon(Icons.save),
            ),
            const SizedBox(height: 20),
            FloatingActionButton(
              onPressed: () async {
                CascadedConfig? newConfig = await getConfigFromClipboard();
                if (newConfig != null) {
                  setState(() {
                    config = newConfig;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Imported from clipboard')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Import failed')));
                }
              },
              tooltip: 'Import from clipboard',
              child: const Icon(Icons.download),
            ),
          ],
        ),
      ),
    );
  }
}
