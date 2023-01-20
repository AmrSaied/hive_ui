import 'package:flutter/material.dart';

import 'drop_down_search/dropdown.dart';

class SearchWidget extends StatefulWidget {
  final SearchScope scope;
  final void Function(String searchValue) onSearch;
  final void Function(String searchValue)? onSearchValue;
  final List<String> fields;
  const SearchWidget({
    Key? key,
    required this.scope,
    required this.onSearch,
    this.onSearchValue,
    this.fields = const [],
  }) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late TextEditingController textEditingController;
  late TextEditingController textEditingController2;
  @override
  void initState() {
    textEditingController = TextEditingController();
    textEditingController2 = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    try {
      textEditingController.dispose();
      textEditingController2.dispose();
    } catch (e) {}

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hintText =
        widget.scope == SearchScope.box ? "Search Boxes" : "Search Field";
    return Row(
      children: [
        if (widget.scope == SearchScope.box)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 8,
            ),
            height: 65,
            width: MediaQuery.of(context).size.width * 0.25,
            child: TextFormField(
              controller: textEditingController,
              onChanged: widget.onSearch,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                hintText: hintText,
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 8,
            ),
            constraints: BoxConstraints.loose(
              Size(
                MediaQuery.of(context).size.width * 0.3,
                65,
              ),
            ),
            child: DropdownFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: widget.onSearch,
              displayItemFn: (str) => Text(str ?? ""),
              findFn: (str) async => widget.fields
                  .where((element) => element.startsWith(str))
                  .toList(),
              dropdownItemFn: (item, position, focused, selected, onTap) {
                return ListTile(
                  title: Text(item),
                  tileColor: focused ? Colors.grey : Colors.transparent,
                  onTap: onTap,
                );
              },
            ),
          ),
        if (widget.scope == SearchScope.field)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 8,
            ),
            height: 65,
            width: MediaQuery.of(context).size.width * 0.25,
            child: TextFormField(
              controller: textEditingController2,
              onChanged: widget.onSearchValue,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                hintText: "Search Value",
              ),
            ),
          ),
      ],
    );
  }
}

enum SearchScope {
  box,
  field,
}
