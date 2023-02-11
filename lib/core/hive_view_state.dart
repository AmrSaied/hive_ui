import 'package:hive_flutter/hive_flutter.dart';

import '../boxes_view.dart';

typedef HiveViewObject = List<Map<String, dynamic>>;

class HiveViewState {
  /// A map of Box objects and their associated FromJsonConverter functions
  final Map<Box, FromJsonConverter> boxesMap;

  /// The currently opened box
  final Box? currentOpenedBox;

  /// The selected value of the current opened box
  final HiveViewObject? selectedBoxValue;

  /// List of nested objects in the current opened box
  final List<HiveViewObject>? nestedObjectList;

  /// Indices of the nested objects in the current opened box
  final List<Map<int, String>>? objectNestedIndices;

  /// Initializes a HiveViewState object with the given parameters
  ///
  /// [boxesMap] : A map of Box objects and their associated FromJsonConverter functions
  /// [currentOpenedBox] : The currently opened box
  /// [selectedBoxValue] : The selected value of the current opened box
  /// [nestedObjectList] : List of nested objects in the current opened box
  /// [objectNestedIndices] : Indices of the nested objects in the current opened box
  HiveViewState({
    required this.boxesMap,
    this.currentOpenedBox,
    this.selectedBoxValue,
    this.nestedObjectList,
    this.objectNestedIndices,
  });

  /// Creates a new HiveViewState object with the given parameters
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

  /// Clears the state of the HiveViewState object
  HiveViewState clearState() => HiveViewState(boxesMap: boxesMap);
}
