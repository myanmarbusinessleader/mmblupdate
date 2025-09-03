import 'package:flutter/material.dart';

import '../../utils/other/debounce.dart';
import '../../utils/widgets/search_widget.dart';
import '../widgets/caregory_search_list.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  String? searchValue;
  final debouncer = Debouncer(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      child: Column(
        children: [
          //
          SearchWidget(size: size, hintText: "လုပ်ငန်းအမျိုးအစားအမည်"),
          //ResultList
          const CaregorySearchList(),
        ],
      ),
    );
  }
}
