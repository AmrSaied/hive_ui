import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../boxes_view.dart';
import 'hive_view_state.dart';

class BoxUpdateHandler {
  final HiveViewState _hiveViewState;
  final ErrorCallback _errorCallback;
  final int? objectIndex;
  BoxUpdateHandler(
    this._hiveViewState,
    this._errorCallback, {
    this.objectIndex,
  });

  Future<bool> addObject(Map<String, dynamic> addedObject) async {
    final currentBox = _hiveViewState.currentOpenedBox!;
    try {
      final fromJson = _hiveViewState.boxesMap[currentBox]!;
      final newAddedObject = fromJson(addedObject);
      await currentBox.put(addedObject["id"], newAddedObject);
      return true;
    } catch (e) {
      _errorCallback(e.toString());
      return false;
    }
  }

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

  /* Future<bool> _addBoxWithObject(
    Box box,
    var id,
    dynamic replacementObject,
  ) async {
    try {
      final fromJson = _hiveViewState.boxesMap[box]!;
      final addedObject = fromJson(replacementObject);
      await box.put(id, addedObject);
      return true;
    } catch (e) {
      _errorCallback(e.toString());
      return false;
    }
  }*/
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

/* Future<bool> addRowObject(Map<String,dynamic> addedRow) async {
    final viewState = _hiveViewState;
    final currentBox = viewState.currentOpenedBox!;
    var boxValue = viewState.selectedBoxValue!;
    final nestedObjectIndices = viewState.objectNestedIndices!;
   // if (nestedObjectIndices.isEmpty) {
      try {
     
          await currentBox.putAt(boxValue.length,addedRow);
        
        return true;
      } catch (e) {
        _errorCallback(e.toString());
        return false;
      }
   // } 
   
  }
*/
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
