import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mmbl/constant/constant.dart';
import 'package:mmbl/controller/filter_form_controller.dart';
import 'package:mmbl/utils/widgets/search_widget.dart';

import '../utils/other/debounce.dart';
import 'widgets/business_filter_search_list.dart';

class BusinessFilterScreen extends StatefulWidget {
  final String appBarTitle;
  final String hintText;
  const BusinessFilterScreen({
    super.key,
    required this.appBarTitle,
    required this.hintText,
  });

  @override
  State<BusinessFilterScreen> createState() => _BusinessFilterScreenState();
}

class _BusinessFilterScreenState extends State<BusinessFilterScreen> {
  final debouncer = Debouncer(milliseconds: 500);
  final FilterFormController _controller = Get.find();
  String? searchValue;

  @override
  void initState() {
    searchValue = _controller.ePController.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        _controller.changeCategory(allCategory);
        _controller.changeState(allStates);
        _controller.changeTownship(allTownship);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white, size: 25),
          centerTitle: true,
          title: Text(
            _controller.category.value,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        body: Column(

          children: [
            SearchWidget(size: size, hintText: widget.hintText),
            const BusinessFilterSearchList(),
          ],
        ),
      ),
    );
  }
}
