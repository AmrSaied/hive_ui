import 'package:hive_flutter/hive_flutter.dart';

import '../boxes_view.dart';

typedef HiveViewObject = List<Map<String, dynamic>>;

class HiveViewState {
  final Map<Box, FromJsonConverter> boxesMap;
  final Box? currentOpenedBox;
  final HiveViewObject? selectedBoxValue;
  final List<HiveViewObject>? nestedObjectList;
  final List<Map<int, String>>? objectNestedIndices;

  HiveViewState({
    required this.boxesMap,
    this.currentOpenedBox,
    this.selectedBoxValue,
    this.nestedObjectList,
    this.objectNestedIndices,
  });

  HiveViewState copyWith({
    Box? currentOpenedBox,
    HiveViewObject? selectedBoxValue,
    List<HiveViewObject>? nestedObjectList,
    Map<Box, FromJsonConverter>? boxesMap,
    List<Map<int, String>>? objectNestedIndices,
  }) {
    return HiveViewState(
      boxesMap: boxesMap ?? this.boxesMap,
      currentOpenedBox: currentOpenedBox ?? this.currentOpenedBox,
      selectedBoxValue: selectedBoxValue ?? this.selectedBoxValue,
      nestedObjectList: nestedObjectList ?? this.nestedObjectList,
      objectNestedIndices: objectNestedIndices ?? this.objectNestedIndices,
    );
  }

  HiveViewState clearState() => HiveViewState(boxesMap: boxesMap);
}
