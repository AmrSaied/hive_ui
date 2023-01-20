import 'package:flutter/material.dart';
import 'package:hive_ui/widgets/update_dialog.dart';

class UpdateDialogTypePicker extends StatelessWidget {
  final UpdateDialogType selectedType;
  final void Function(UpdateDialogType? type) onTypeChanged;
  const UpdateDialogTypePicker({
    Key? key,
    required this.selectedType,
    required this.onTypeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: UpdateDialogType.values
          .map(
            (e) => Flexible(
              child: RadioListTile<UpdateDialogType>(
                value: e,
                groupValue: selectedType,
                onChanged: onTypeChanged,
                title: Text(e.name),
              ),
            ),
          )
          .toList(),
    );
  }
}
