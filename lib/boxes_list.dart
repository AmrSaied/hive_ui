import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_ui/search/search_widget.dart';

class HiveBoxesList extends StatefulWidget {
  final List<Box> boxes;
  final void Function(String boxName) onBoxNameSelected;

  const HiveBoxesList({
    Key? key,
    required this.boxes,
    required this.onBoxNameSelected,
  }) : super(key: key);

  @override
  State<HiveBoxesList> createState() => _HiveBoxesListState();
}

class _HiveBoxesListState extends State<HiveBoxesList> {
  Timer? _timer;
  String searchValue = '';
  late List<String> boxNamesList;

  @override
  void initState() {
    boxNamesList = widget.boxes.map((e) => e.name).toList();
    super.initState();
  }

  void onSearchValue(String value) {
    searchValue = value;
    if (_timer?.isActive ?? false) _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 500), () {
      if (searchValue.isNotEmpty) {
        boxNamesList = widget.boxes
            .map((e) => e.name)
            .toList()
            .where((element) => element.contains(searchValue))
            .toList();
      } else {
        boxNamesList = widget.boxes.map((e) => e.name).toList();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int getLength(String name) {
    final selectedBox = widget.boxes.singleWhere(
      (element) => element.name == name,
    );
    return selectedBox.values.length;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchWidget(
          scope: SearchScope.box,
          onSearch: onSearchValue,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: boxNamesList.map(
                (boxName) {
                  return ListTile(
                    title: Text(boxName),
                    trailing: Text("Length : ${getLength(boxName)}"),
                    onTap: () => widget.onBoxNameSelected(boxName),
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
