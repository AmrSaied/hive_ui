import 'package:flutter/material.dart';

class ColumnsFilterDialog extends StatefulWidget {
  final List<String> allColumns;
  final List<String> selectedColumns;
  const ColumnsFilterDialog({
    Key? key,
    required this.allColumns,
    required this.selectedColumns,
  }) : super(key: key);

  @override
  State<ColumnsFilterDialog> createState() => _ColumnsFilterDialogState();
}

class _ColumnsFilterDialogState extends State<ColumnsFilterDialog> {
  late List<String> _selectedColumns;

  @override
  void initState() {
    _selectedColumns = List.of(widget.selectedColumns);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              child: Text('Select Columns To Show'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: widget.allColumns.map(
                    (column) {
                      final isSelected = _selectedColumns.contains(column);
                      return ListTile(
                        title: Text(column),
                        selected: isSelected,
                        onTap: () {
                          if (isSelected) {
                            _selectedColumns.remove(column);
                          } else {
                            _selectedColumns.add(column);
                          }
                          setState(() {});
                        },
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
                  onPressed: () {
                    _selectedColumns = widget.allColumns;
                    setState(() {});
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red, fixedSize: const Size(
                      100,
                      50,
                    ),
                  ),
                  child: const Text('Reset'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, _selectedColumns);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green, fixedSize: const Size(
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
