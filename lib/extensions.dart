import 'dart:convert';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:hive_ui/widgets/list_details_dialog.dart';

import 'boxes_view.dart';
import 'widgets/hive_boxes_details.dart';

bool isMap(dynamic fieldValue) {
  bool containKeys = false;
  try {
    containKeys = fieldValue is Map<String, dynamic>;
  } on TypeError {
    containKeys = false;
  }
  return containKeys;
}

bool isList(dynamic fieldValue) {
  try {
    fieldValue.toList();
    return true;
  } catch (e) {
    return false;
  }
}

mixin BoxViewMixin on State<HiveBoxesDetails> {
  void showListDetailsDialog(String title, List values) => showDialog(
        context: context,
        builder: (_) => ListDetailsDialog(values: values, title: title),
      );

  DataColumn buildColumn(String columnTitle) => DataColumn(
        label: Center(
          child: Text(
            columnTitle,
            textAlign: TextAlign.center,
          ),
        ),
      );
  DataRow buildRow({
    required Map<String, dynamic> objectAsJson,
    required FieldPressedCallback onFieldPressed,
    required int cellsNumber,
    required int objectIndex,
    required void Function({
      required bool selected,
      required int index,
    })
        onSelectRow,
    required bool isSelected,
    required bool enableSelection,
    required List<String> keys,
  }) {
    String dataCellValue(
      dynamic field,
    ) {
      if (field.runtimeType == List<Map<String, dynamic>>) {
        return 'List OF Objects';
      } else if (isMap(field)) {
        return "Object";
      } else if (isList(field)) {
        return 'List';
      } else {
        return field.toString();
      }
    }

    List<String> rowKeys = [];
    rowKeys = keys;

    return DataRow(
      onSelectChanged: !enableSelection
          ? null
          : (isSelected) =>
              onSelectRow(selected: isSelected!, index: objectIndex),
      selected: isSelected,
      cells: rowKeys.map<DataCell>((fieldName) {
        final cellValue = dataCellValue(objectAsJson[fieldName]);
        final isList = cellValue == 'List';
        return DataCell(
          onLongPress: () {
            final value = objectAsJson[fieldName];
            final json = const JsonEncoder.withIndent('  ').convert(value);
            FlutterClipboard.copy(json);
          },
          Center(
            child: Text(
              cellValue,
            ),
          ),
          onTap: () => !isList
              ? onFieldPressed(
                  "boxName",
                  fieldName,
                  objectAsJson,
                  objectIndex: objectIndex,
                )
              : showListDetailsDialog(
                  fieldName,
                  objectAsJson[fieldName] as List,
                ),
        );
      }).toList(),
    );
  }

  List<DataColumn> mapToDataColumns(List<String> columnKeys) {
    if (columnKeys.isEmpty) {
      return [];
    } else {
      return columnKeys.map<DataColumn>(buildColumn).toList();
    }
  }

  List<DataRow> mapToDataRows(
    List<Map<String, dynamic>> nestedObject,
    FieldPressedCallback onFieldPressed,
    int cellsNumber,
    void Function({required bool selected, required int index}) onSelectRow,
    List<int> selectedRows,
    bool enableSelection,
    List<String> keys,
  ) {
    return nestedObject.map((obj) {
      final index = nestedObject.indexOf(obj);
      final isSelected = selectedRows.contains(index);
      return buildRow(
        objectAsJson: obj,
        onFieldPressed: onFieldPressed,
        cellsNumber: cellsNumber,
        objectIndex: index,
        isSelected: isSelected,
        onSelectRow: onSelectRow,
        enableSelection: enableSelection,
        keys: keys,
      );
    }).toList();
  }
}
