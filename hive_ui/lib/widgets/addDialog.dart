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
      child: SizedBox(
        height: mediaQuerySize.height * 0.5,
        width: mediaQuerySize.width * 0.35,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.center,
              child: Text('Add New Row'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: widget.allColumns.map(
                    (column) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(column),
                            trailing: SizedBox(
                                width: 200,
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
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                          horizontal: 16,
                                        )),
                                      )),
                            onTap: () {},
                          ),
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: UpdateDialogTypePicker(
                              selectedType: fieldType,
                              onTypeChanged: onTypeChanged,
                            ),
                          )
                        ],
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    fixedSize: const Size(
                      100,
                      50,
                    ),
                  ),
                  child: const Text('Reset'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, widget.objectAsJson);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                    fixedSize: const Size(
                      100,
                      50,
                    ),
                  ),
                  child: const Text('Confirm'),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
