import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mmbl/utils/widgets/search_widget_second.dart';

import '../utils/other/debounce.dart';
import 'widgets/filter_search_list_second.dart';

class FilterScreenSecond extends StatefulWidget {
  final String appBarTitle;
  final String hintText;
  final void Function(String) onSelected;
  final Future<List<Map<String, dynamic>>> Function(String?) search;
  const FilterScreenSecond({
    super.key,
    required this.appBarTitle,
    required this.hintText,
    required this.search,
    required this.onSelected,
  });

  @override
  State<FilterScreenSecond> createState() => _FilterScreenSecondState();
}

class _FilterScreenSecondState extends State<FilterScreenSecond> {
  final debouncer = Debouncer(milliseconds: 500);
  String? searchValue;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white, size: 25),
        centerTitle: true,
        title: Text(
          widget.appBarTitle,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          SearchWidgetSecond(
            size: size,
            onChanged: (value) {
              setState(() {
                searchValue = value;
              });
            },
            debouncer: debouncer,
            hintText: widget.hintText,
          ),
          FilterSearchListSecond(
            searchValue: searchValue,
            search: widget.search,
            onSelected: (value) {
              widget.onSelected(value);
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
