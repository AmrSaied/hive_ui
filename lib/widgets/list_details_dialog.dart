import 'package:flutter/material.dart';

class ListDetailsDialog extends StatelessWidget {
  final String title;
  final List values;
  const ListDetailsDialog({Key? key, required this.values, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          children: values
              .map<Widget>((value) => ListTile(
                    title: Text('$value'),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
