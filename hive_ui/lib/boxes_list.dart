import 'dart:async';

import 'package:flutter/material.dart';

import 'search/search_widget.dart';

class HiveBoxesList extends StatefulWidget {
  final List<String> boxesNames;
  final void Function(String boxName) onBoxNameSelected;
  const HiveBoxesList({
    Key? key,
    required this.boxesNames,
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
    boxNamesList = widget.boxesNames;
    super.initState();
  }

  void onSearchValue(String value) {
    searchValue = value;
    if (_timer?.isActive ?? false) _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 500), () {
      if (searchValue.isNotEmpty) {
        boxNamesList = widget.boxesNames
            .where((element) => element.contains(searchValue))
            .toList();
      } else {
        boxNamesList = widget.boxesNames;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
