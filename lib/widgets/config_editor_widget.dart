import 'package:flutter/material.dart';
import '../models/cascaded_config.dart';

class ConfigEditorWidget extends StatefulWidget {
  final CascadedConfig config;
  final indentLevel;

  const ConfigEditorWidget(
      {super.key, required this.config, required this.indentLevel});

  @override
  _ConfigEditorWidgetState createState() => _ConfigEditorWidgetState();
}

class _ConfigEditorWidgetState extends State<ConfigEditorWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: widget.indentLevel * 20.0),
      child: ExpansionTile(
        title: Text(widget.config.comment),
        children: [
          Padding(
              padding: EdgeInsets.only(left: widget.indentLevel * 20.0 + 20),
              child: Column(children: [
                _buildCommentInput(),
                _buildTypeSelector(),
                _buildInputFloat(),
                _buildInputInt(),
                _buildSwitch(),
                _buildStrsExpansion(),
                _buildConfigsExpansion(),
              ]))
        ],
      ),
    );
  }

  Widget _buildTypeSelector() {
    return ListTile(
      title: const Text('Type'),
      trailing: DropdownButton<String>(
        value: widget.config.type,
        onChanged: (String? newValue) {
          setState(() {
            widget.config.type = newValue!;
          });
        },
        items: <String>['config', 'str']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCommentInput() {
    return ListTile(
      title: Text('Comment: ${widget.config.comment}'),
      onTap: () {
        _editComment();
      },
    );
  }

  Widget _buildInputFloat() {
    return ListTile(
      title:
          Text('Input Float: ${widget.config.inputFloat.toStringAsFixed(2)}'),
      onTap: () {
        _editInputFloat();
      },
    );
  }

  Widget _buildInputInt() {
    return ListTile(
      title: Text('Input Integer: ${widget.config.inputInt}'),
      onTap: () {
        _editInputInt();
      },
    );
  }

  void _editComment() {
    TextEditingController controller =
        TextEditingController(text: widget.config.comment);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Comment'),
          content: TextField(
            controller: controller,
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  widget.config.comment = controller.text;
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _editInputFloat() {
    TextEditingController controller =
        TextEditingController(text: widget.config.inputFloat.toString());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Input Float'),
          content: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  widget.config.inputFloat = double.tryParse(controller.text) ??
                      widget.config.inputFloat;
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _editInputInt() {
    TextEditingController controller =
        TextEditingController(text: widget.config.inputInt.toString());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Input Integer'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  widget.config.inputInt =
                      int.tryParse(controller.text) ?? widget.config.inputInt;
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSwitch() {
    return ListTile(
      title: const Text('Switch'),
      trailing: Switch(
        value: widget.config.switches,
        onChanged: (bool val) {
          setState(() {
            widget.config.switches = val;
          });
        },
      ),
    );
  }

  Widget _buildStrsExpansion() {
    return widget.config.type == 'str'
        ? ExpansionTile(title: const Text('String'), children: [
            ListTile(
              subtitle: Text((widget.config.strs.join('\n'))),
              onTap: () {
                _editStrList();
              },
            )
          ])
        : const SizedBox.shrink();
  }

  void _editStrList() {
    TextEditingController controller =
        TextEditingController(text: widget.config.strs.join('\n'));
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Strings'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.multiline,
            maxLines: null, // Set to null to allow for unlimited lines.
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  widget.config.strs = controller.text
                      .split('\n')
                      .where((str) => str.isNotEmpty)
                      .toList();
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildConfigsExpansion() {
    return widget.config.type == 'config'
        ? ExpansionTile(
            title: const Text('Configs'),
            children: [
              ...widget.config.configs
                  .map((config) => ConfigEditorWidget(
                        config: config,
                        indentLevel: widget.indentLevel + 1,
                      ))
                  ,
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: const Icon(Icons.add),
                      title: const Text('Add New Config'),
                      onTap: () => _addNewConfig(),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      leading: const Icon(Icons.remove),
                      title: const Text('Remove Last Config'),
                      onTap: () => _removeLastConfig(),
                    ),
                  ),
                ],
              )
            ],
          )
        : const SizedBox.shrink();
  }

  void _addNewConfig() {
    setState(() {
      widget.config.configs.add(CascadedConfig(
        type: 'config',
        comment: 'New config',
        inputFloat: 0.0,
        inputInt: 0,
        switches: false,
        strs: [],
        configs: [],
      ));
    });
  }

  void _removeLastConfig() {
    if (widget.config.configs.isNotEmpty) {
      setState(() {
        widget.config.configs.removeLast();
      });
    }
  }
}
