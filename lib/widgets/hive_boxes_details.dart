import 'dart:async';
import 'dart:convert';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:hive_ui/extensions.dart';
import 'package:hive_ui/search/search_widget.dart';
import 'package:hive_ui/widgets/columns_filter_dialog.dart';

import '../boxes_view.dart';
import 'list_pagination_view.dart';

class HiveBoxesDetails extends StatefulWidget {
  final TextStyle? columnTitleTextStyle;
  final TextStyle? rowTitleTextStyle;
  final VoidCallback onDeleteAll;
  final void Function(List<int> rowIndices)? onDeleteRows;
  final List<String> columns;
  final List<Map<String, dynamic>> rows;
  final VoidCallback onBackPressed;
  final FieldPressedCallback onFieldPressed;
  final void Function(
    Map<String, dynamic> rowIndices,
    List<String> columns,
  ) onAddRow;

  const HiveBoxesDetails({
    Key? key,
    required this.onDeleteAll,
    this.onDeleteRows,
    required this.columnTitleTextStyle,
    required this.rowTitleTextStyle,
    required this.onBackPressed,
    required this.columns,
    required this.rows,
    required this.onFieldPressed,
    required this.onAddRow,
  }) : super(key: key);

  @override
  State<HiveBoxesDetails> createState() => _HiveBoxesDetailsState();
}

class _HiveBoxesDetailsState extends State<HiveBoxesDetails> with BoxViewMixin {
  late ScrollController _verticalScrollController;
  late ScrollController _horizontalScrollController;
  late ValueNotifier<PaginationModel> _paginationModel;
  late List<Map<String, dynamic>> rows;
  bool enableSelection = false;
  String searchField = '';
  String searchValue = '';
  Timer? _timer;
  @override
  void initState() {
    _verticalScrollController = ScrollController();
    _horizontalScrollController = ScrollController();
    rows = widget.rows;
    if (rows.length > 1) enableSelection = true;
    _paginationModel = ValueNotifier<PaginationModel>(
      PaginationModel(
        totalPageCount: (rows.length / 20).ceil(),
        currentPageIndex: 0,
        length: rows.length,
        selectedRows: {},
        columnsKeysToShow: widget.columns,
      ),
    );
    super.initState();
  }

  void onSearchValue(String value) {
    searchValue = value;
    if (_timer?.isActive ?? false) _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 500), () {
      if (searchValue.isNotEmpty || searchField.isNotEmpty) {
        rows = widget.rows
            .where((element) => element[searchField]
                .toString()
                .toLowerCase()
                .contains(searchValue))
            .toList();
      } else {
        rows = widget.rows;
      }
      setState(() {});
    });
  }

  void _onRowSelected({
    required bool selected,
    required int index,
  }) {
    final selectedRows = _paginationModel.value.selectedRows;
    final page = _paginationModel.value.currentPageIndex;
    if (selected) {
      selectedRows.containsKey(page)
          ? selectedRows[page]!.add(index)
          : selectedRows.addAll({
              page: [index]
            });
    } else {
      selectedRows[page]?.remove(index);
    }
    _paginationModel.value = _paginationModel.value.copyWith(
      selectedRows: selectedRows,
    );
  }

  int calculateEndRange(int startRange, PaginationModel paginationModel) {
    if (paginationModel.totalPageCount == 1) {
      return paginationModel.length;
    } else if (paginationModel.currentPageIndex + 1 ==
        paginationModel.totalPageCount) {
      return paginationModel.length;
    } else {
      return startRange + 20;
    }
  }

  List<DataRow> getRowsByPage(PaginationModel paginationModel) {
    final start = paginationModel.currentPageIndex == 0
        ? 0
        : (paginationModel.currentPageIndex * 20);
    final end = calculateEndRange(start, paginationModel);
    if (rows.length < 20) {
      return mapToDataRows(
        rows,
        (boxName, fieldName, objectAsJson, {objectIndex}) =>
            widget.onFieldPressed(boxName, fieldName, objectAsJson,
                objectIndex:
                    (paginationModel.currentPageIndex * 20) + objectIndex!),
        widget.columns.length,
        _onRowSelected,
        paginationModel.selectedRows[paginationModel.currentPageIndex] ?? [],
        enableSelection,
        paginationModel.columnsKeysToShow,
      );
    } else {
      return mapToDataRows(
        rows.getRange(start, end).toList(),
        (boxName, fieldName, objectAsJson, {objectIndex}) =>
            widget.onFieldPressed(
          boxName,
          fieldName,
          objectAsJson,
          objectIndex: (paginationModel.currentPageIndex * 20) + objectIndex!,
        ),
        widget.columns.length,
        _onRowSelected,
        paginationModel.selectedRows[paginationModel.currentPageIndex] ?? [],
        enableSelection,
        paginationModel.columnsKeysToShow,
      );
    }
  }

  List<int> getSelectedObjectIndices() {
    final objectsIndices = <int>[];
    _paginationModel.value.selectedRows.forEach((page, indices) {
      final factor = ((page * 20));
      for (int index in indices) {
        objectsIndices.add(index + factor);
      }
    });
    return objectsIndices;
  }

  @override
  void setState(VoidCallback fn) {
    _paginationModel = ValueNotifier<PaginationModel>(
      PaginationModel(
        totalPageCount: (rows.length / 20).ceil(),
        currentPageIndex: _paginationModel.value.currentPageIndex,
        length: rows.length,
        selectedRows: {},
        columnsKeysToShow: widget.columns,
      ),
    );
    super.setState(fn);
  }

  @override
  void dispose() {
    _verticalScrollController.dispose();
    _horizontalScrollController.dispose();
    _paginationModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const buttonSize = Size(150, 50);
    return WillPopScope(
      onWillPop: () async {
        widget.onBackPressed();
        return false;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SearchWidget(
                scope: SearchScope.field,
                onSearch: (query) => searchField = query,
                onSearchValue: onSearchValue,
                fields: widget.columns,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("length of data :  ${rows.length}"),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => widget.onAddRow.call(
                    {},
                    _paginationModel.value.columnsKeysToShow,
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize: buttonSize,
                  ),
                  child: const FittedBox(
                    child: Text('Add New'),
                  ),
                ),
                const SizedBox(width: 32),
                ElevatedButton(
                  onPressed: widget.onDeleteAll,
                  style: ElevatedButton.styleFrom(
                    fixedSize: buttonSize,
                  ),
                  child: const FittedBox(
                    child: Text('Delete All'),
                  ),
                ),
                const SizedBox(width: 32),
                if (enableSelection)
                  ElevatedButton(
                    onPressed: () {
                      final objectsIndices = getSelectedObjectIndices();
                      widget.onDeleteRows?.call(objectsIndices);
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: buttonSize,
                    ),
                    child: const FittedBox(
                      child: Text('Delete Selected'),
                    ),
                  ),
                const SizedBox(width: 32),
                ElevatedButton(
                  onPressed: () async {
                    final selectedColumns = await showDialog(
                      context: context,
                      builder: (_) => ColumnsFilterDialog(
                        allColumns: widget.columns,
                        selectedColumns:
                            _paginationModel.value.columnsKeysToShow,
                      ),
                    );
                    if (selectedColumns != null) {
                      _paginationModel.value = _paginationModel.value.copyWith(
                        columnsKeysToShow: selectedColumns,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: buttonSize,
                  ),
                  child: const FittedBox(
                    child: Text('Select Columns'),
                  ),
                ),
                const SizedBox(width: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: buttonSize,
                  ),
                  onPressed: () {
                    final objectsIndices = getSelectedObjectIndices();
                    final objects = [];
                    for (int index in objectsIndices) {
                      objects.add(widget.rows[index]);
                    }
                    final json =
                        const JsonEncoder.withIndent("  ").convert(objects);
                    FlutterClipboard.copy(json);
                  },
                  child: const Text('Copy Selected'),
                )
              ],
            ),
          ),
          ValueListenableBuilder<PaginationModel>(
              valueListenable: _paginationModel,
              builder: (_, pagination, __) {
                return Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: _verticalScrollController,
                    child: SingleChildScrollView(
                      controller:
                          _verticalScrollController, // <---- Here, the controller

                      child: Scrollbar(
                        thumbVisibility: true,
                        controller: _horizontalScrollController,
                        child: SingleChildScrollView(
                          controller:
                              _horizontalScrollController, // <---- Here, the controller

                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingTextStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.deepPurpleAccent,
                            ),
                            columns:
                                mapToDataColumns(pagination.columnsKeysToShow),
                            rows: getRowsByPage(pagination),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
          SizedBox(
            child: _paginationModel.value.totalPageCount > 1
                ? ListPaginationView(
                    onPageChanged: (int pageNumber) {
                      _paginationModel.value = _paginationModel.value.copyWith(
                        currentPageIndex: pageNumber,
                      );
                    },
                    pageTotal: _paginationModel.value.totalPageCount,
                    pageInit: _paginationModel.value.currentPageIndex,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class PaginationModel {
  final int totalPageCount;
  final int currentPageIndex;
  final int length;
  final Map<int, List<int>> selectedRows;
  final List<String> columnsKeysToShow;

  PaginationModel({
    required this.totalPageCount,
    required this.currentPageIndex,
    required this.length,
    required this.selectedRows,
    required this.columnsKeysToShow,
  });

  PaginationModel copyWith({
    int? totalPageCount,
    int? currentPageIndex,
    int? length,
    Map<int, List<int>>? selectedRows,
    List<String>? columnsKeysToShow,
  }) {
    return PaginationModel(
      totalPageCount: totalPageCount ?? this.totalPageCount,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      length: length ?? this.length,
      selectedRows: selectedRows ?? this.selectedRows,
      columnsKeysToShow: columnsKeysToShow ?? this.columnsKeysToShow,
    );
  }
}
