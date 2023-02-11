import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../boxes_view.dart';
import 'hive_view_state.dart';

class BoxUpdateHandler {
  final HiveViewState _hiveViewState;
  final ErrorCallback _errorCallback;
  final int? objectIndex;

  /// BoxUpdateHandler constructor
  ///
  /// [_hiveViewState] : The HiveViewState instance.
  /// [_errorCallback] : The callback function to handle errors.
  /// [objectIndex] : Optional, the index of the object to update.
  BoxUpdateHandler(
    this._hiveViewState,
    this._errorCallback, {
    this.objectIndex,
  });

  /// Adds an object to the current opened box
  ///
  /// [addedObject] : A Map<String, dynamic> representing the new object to be added.
  /// Returns a Future<bool> indicating success or failure of the operation.
  Future<bool> addObject(Map<String, dynamic> addedObject) async {
    // final currentBox = _hiveViewState.currentOpenedBox!;
    // try {
    //   final fromJson = _hiveViewState.boxesMap[currentBox]!;
    //   final newAddedObject = fromJson(addedObject);
    //   await currentBox.put(addedObject["id"], newAddedObject);
    //   return true;
    // } catch (e) {
    //   _errorCallback(e.toString());
    //   return false;
    // }

    try {
      bool isThereBoxes = _hiveViewState.boxesMap.entries.isNotEmpty;
      bool isFoundOpenBox = _hiveViewState.currentOpenedBox != null;
      bool isHaveIdProperty =
          addedObject.keys.any((element) => element == "id");
      if (!isThereBoxes) {
        _errorCallback("there is Not Boxes");
        return false;
      } else if (!isFoundOpenBox) {
        _errorCallback("there is Not Open Box");
        return false;
      } else if (!isHaveIdProperty) {
        _errorCallback("there is Not ID  Property \n add {\"id\":(888 as id)}");
        return false;
      } else {
        final currentBox = _hiveViewState.currentOpenedBox!;

        final fromJson = _hiveViewState.boxesMap[currentBox]!;
        final newAddedObject = fromJson(addedObject);
        await currentBox.put(addedObject["id"], newAddedObject);
        return true;
      }
    } catch (e) {
      _errorCallback(e.toString());
      return false;
    }
  }

  /// Updates an object in the current opened box
  ///
  /// Returns a Future<bool> indicating success or failure of the operation.
  Future<bool> updateObject() async {
    final boxValue = _hiveViewState.selectedBoxValue!;
    final currentBox = _hiveViewState.currentOpenedBox!;
    Map<String, dynamic> updatedObjectJson = {};
    int index = 0;
    if (_hiveViewState.objectNestedIndices!.isNotEmpty) {
      index = _hiveViewState.objectNestedIndices!.first.keys.single;
      updatedObjectJson = boxValue[index];
    } else {
      index = objectIndex!;
      updatedObjectJson = boxValue[index];
    }
    debugPrint(_hiveViewState.objectNestedIndices.toString());
    return await _updateBoxWithObject(
      currentBox,
      index,
      updatedObjectJson,
    );
  }

  /// Helper method to update an object in a box
  ///
  /// [box] : The Hive box.
  /// [indexOfObject] : The index of the object to update.
  /// [replacementObject] : The new object to replace the existing one.
  /// Returns a Future<bool> indicating success or failure of the operation.
  Future<bool> _updateBoxWithObject(
    Box box,
    int indexOfObject,
    dynamic replacementObject,
  ) async {
    try {
      final fromJson = _hiveViewState.boxesMap[box]!;
      final updatedObject = fromJson(replacementObject);
      await box.putAt(indexOfObject, updatedObject);
      return true;
    } catch (e) {
      _errorCallback(e.toString());
      return false;
    }
  }

  /// Deletes a field of an object in the current opened box
  ///
  /// Returns a Future<bool> indicating success or failure of the operation.
  Future<bool> deleteFieldOfObject() async {
    final viewState = _hiveViewState;
    final currentBox = viewState.currentOpenedBox!;
    var boxValue = viewState.selectedBoxValue!;
    final indices = viewState.objectNestedIndices!;
    final firstIndexMap = indices.first;
    final lastIndexMap = indices.last;
    var refObj =
        boxValue[firstIndexMap.keys.single][firstIndexMap.values.single];
    if (indices.length == 1) {
      refObj.clear();
    } else {
      for (var indexMap in indices..removeAt(0)) {
        if (indexMap == lastIndexMap) {
          refObj[indexMap.values.single].clear();
        } else if (indexMap.keys.single == -1) {
          refObj = refObj[indexMap.values.single];
        } else {
          refObj = refObj[indexMap.keys.single][indexMap.values.single];
        }
      }
    }
    final replacementObject = boxValue[firstIndexMap.keys.single];

    return await _updateBoxWithObject(
      currentBox,
      firstIndexMap.keys.single,
      replacementObject,
    );
  }

  /// Deletes multiple rows of an object in the current opened box
  ///
  /// [rowIndices] : A list of indices of the rows to delete.
  /// Returns a Future<bool> indicating success or failure of the operation.
  Future<bool> deleteRowObject(List<int> rowIndices) async {
    final viewState = _hiveViewState;
    final currentBox = viewState.currentOpenedBox!;
    var boxValue = viewState.selectedBoxValue!;
    final nestedObjectIndices = viewState.objectNestedIndices!;
    if (nestedObjectIndices.isEmpty) {
      try {
        for (var index in rowIndices) {
          await currentBox.deleteAt(index);
        }
        return true;
      } catch (e) {
        _errorCallback(e.toString());
        return false;
      }
    } else {
      final firstIndexMap = nestedObjectIndices.first;
      final lastIndexMap = nestedObjectIndices.last;
      var refObj =
          boxValue[firstIndexMap.keys.single][firstIndexMap.values.single];
      if (nestedObjectIndices.length == 1) {
        for (int index in rowIndices) {
          refObj.removeAt(index);
        }
      } else {
        for (var indexMap in nestedObjectIndices..removeAt(0)) {
          if (indexMap == lastIndexMap) {
            for (int index in rowIndices) {
              refObj[indexMap.values.single].removeAt(index);
            }
          } else if (indexMap.keys.single == -1) {
            refObj = refObj[indexMap.values.single];
          } else {
            refObj = refObj[indexMap.keys.single][indexMap.values.single];
          }
        }
      }
      final replacementObject = boxValue[firstIndexMap.keys.single];

      return await _updateBoxWithObject(
        currentBox,
        firstIndexMap.keys.single,
        replacementObject,
      );
    }
  }

  Future<bool> clearBox() async {
    try {
      await _hiveViewState.currentOpenedBox?.clear();
      return true;
    } catch (e) {
      _errorCallback(e.toString());
      return false;
    }
  }
}
