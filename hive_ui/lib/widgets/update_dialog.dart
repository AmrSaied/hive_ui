import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:hive_ui/widgets/update_dialog_type_picker.dart';
import 'package:intl/intl.dart';

class UpdateDialog extends StatefulWidget {
  final Map<String, dynamic> objectAsJson;
  final String fieldName;
  final DateFormat? dateFormat;
  const UpdateDialog({
    Key? key,
    required this.objectAsJson,
    required this.fieldName,
    this.dateFormat,
  }) : super(key: key);

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  Map<String, dynamic> get jsonObject => widget.objectAsJson;
  UpdateDialogType fieldType = UpdateDialogType.string;
  late TextEditingController _controller;
  late bool booleanFieldValue;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onTypeChanged(UpdateDialogType? type) {
    if (type == UpdateDialogType.bool) {
      booleanFieldValue = false;
    }
    setState(() => fieldType = type!);
  }

  Future<void> onFormFieldTapped() async {
    if (fieldType == UpdateDialogType.datePicker) {
      final currentDate = jsonObject[widget.fieldName];
      late DateTime initialDate;

      if (currentDate != null && currentDate.isNotEmpty) {
        initialDate = DateTime.parse(currentDate.replaceAll("/", "-"));
      } else {
        initialDate = DateTime.now();
      }
      final datePicked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(
          const Duration(days: 30 * 4),
        ),
      );
      if (datePicked != null) {
        _controller.text =
            widget.dateFormat?.format(datePicked) ?? datePicked.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuerySize = MediaQuery.of(context).size;
    return Dialog(
      child: SizedBox(
        width: mediaQuerySize.width * 0.5,
        height: mediaQuerySize.height * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                ListTile(
                  title: Text(widget.fieldName),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Divider(),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        children: [
                          TextFormField(
                            readOnly: true,
                            enabled: false,
                            textAlign: TextAlign.center,
                            initialValue:
                                jsonObject[widget.fieldName].toString(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          if (fieldType != UpdateDialogType.bool)
                            TextField(
                              readOnly:
                                  fieldType == UpdateDialogType.datePicker,
                              onTap: () async => await onFormFieldTapped(),
                              controller: _controller,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: 'New Value',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            )
                          else
                            DropdownButtonFormField<bool>(
                              items: [true, false]
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e.toString()),
                                      ))
                                  .toList(),
                              onChanged: (value) => setState(
                                () => booleanFieldValue = value!,
                              ),
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                              )),
                            )
                        ],
                      ),
                    ),
                  ),
                  UpdateDialogTypePicker(
                    selectedType: fieldType,
                    onTypeChanged: onTypeChanged,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(125, 50),
                  ),
                  onPressed: () {
                    Object updatedValue;
                    switch (fieldType) {
                      case UpdateDialogType.datePicker:
                        updatedValue = _controller.text;
                        break;
                      case UpdateDialogType.string:
                        updatedValue = _controller.text;
                        break;
                      case UpdateDialogType.num:
                        updatedValue = num.parse(_controller.text);
                        break;
                      case UpdateDialogType.bool:
                        updatedValue = booleanFieldValue;
                        break;
                    }
                    jsonObject[widget.fieldName] = updatedValue;
                    Navigator.pop(context, jsonObject);
                  },
                  child: const Text('Confirm'),
                ),
                const SizedBox(width: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(125, 50),
                  ),
                  onPressed: () {
                    FlutterClipboard.copy(
                        jsonObject[widget.fieldName].toString());
                  },
                  child: const Text('Copy Value'),
                ),
              ],
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

enum UpdateDialogType {
  datePicker,
  string,
  num,
  bool,
}
