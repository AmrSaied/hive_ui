import 'package:flutter/material.dart';
import 'package:hive_ui/widgets/update_dialog.dart';
import 'package:hive_ui/widgets/update_dialog_type_picker.dart';

import 'idgenerator.dart';

class AddNewDialog extends StatefulWidget {
  final Map<String, dynamic> objectAsJson;

  final List<String> allColumns;

  const AddNewDialog({
    Key? key,
    required this.objectAsJson,
    required this.allColumns,
  }) : super(key: key);

  @override
  State<AddNewDialog> createState() => _AddNewDialogState();
}

class _AddNewDialogState extends State<AddNewDialog> {
  UpdateDialogType fieldType = UpdateDialogType.string;
  final textControllers = <String, TextEditingController>{};
  late bool booleanFieldValue;

  @override
  void initState() {
    super.initState();
  }

  void initTextControllers() {
    var id = IdGenerator.generate();
    for (int index = 0; index < widget.allColumns.length; index++) {
      if (widget.allColumns[index] == 'id') {
        textControllers[widget.allColumns[index]] =
            TextEditingController(text: id);
        widget.objectAsJson[widget.allColumns[index]] = id;
      } else {
        textControllers[widget.allColumns[index]] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    //try{_controller.dispose();}catch(e){}
    super.dispose();
  }

  void onTypeChanged(UpdateDialogType? type) {
    if (type == UpdateDialogType.bool) {
      booleanFieldValue = false;
    }
    setState(() => fieldType = type!);
  }

  @override
  Widget build(BuildContext context) {
    initTextControllers();
    final mediaQuerySize = MediaQuery.of(context).size;
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Container(
        constraints: BoxConstraints.loose(Size(
          mediaQuerySize.width * 0.5,
          mediaQuerySize.height * 0.6,
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Add New Row',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: widget.allColumns.map(
                    (column) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            child: UpdateDialogTypePicker(
                              selectedType: fieldType,
                              onTypeChanged: onTypeChanged,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                              constraints: BoxConstraints.loose(
                                Size(mediaQuerySize.width * 0.2, 50),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: (fieldType != UpdateDialogType.bool)
                                  ? TextField(
                                      readOnly: fieldType ==
                                          UpdateDialogType.datePicker,
                                      //   onTap: () async => await onFormFieldTapped(),
                                      onChanged: (value) =>
                                          widget.objectAsJson[column] =
                                              textControllers[column]?.text,

                                      onEditingComplete: () {
                                        switch (fieldType) {
                                          case UpdateDialogType.datePicker:
                                            widget.objectAsJson[column] =
                                                textControllers[column]?.text;
                                            break;
                                          case UpdateDialogType.string:
                                            widget.objectAsJson[column] =
                                                textControllers[column]?.text;
                                            break;
                                          case UpdateDialogType.num:
                                            widget.objectAsJson[column] =
                                                num.parse(
                                                    textControllers[column]!
                                                        .text);
                                            break;
                                          case UpdateDialogType.bool:
                                            widget.objectAsJson[column] =
                                                booleanFieldValue;
                                            break;
                                        }
                                      },
                                      controller: textControllers[column],
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        label: Text(
                                          column,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        hintText: 'New Value',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                    )
                                  : DropdownButtonFormField<bool>(
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
                                    )),
                          const SizedBox(height: 42),
                        ],
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      fixedSize: const Size(
                        100,
                        42,
                      ),
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, widget.objectAsJson);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.green,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      fixedSize: const Size(
                        100,
                        42,
                      ),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
