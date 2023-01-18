import 'package:flutter/material.dart';
import 'package:number_pagination/number_pagination.dart';

class ListPaginationView extends StatelessWidget {
  final Function(int) onPageChanged;
  final int pageTotal;
  final int pageInit;

  const ListPaginationView({
    Key? key,
    required this.onPageChanged,
    required this.pageTotal,
    required this.pageInit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NumberPagination(
      pageTotal: pageTotal,
      onPageChanged: (page) => onPageChanged(page - 1),
      // initially selected index
      pageInit: pageInit + 1,
      iconPrevious: const Icon(Icons.arrow_back),
      iconNext: const Icon(Icons.arrow_forward),
    );
  }
}
