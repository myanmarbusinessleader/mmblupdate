import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/constant.dart';
import '../../controller/filter_form_controller.dart';
import '../../model/category.dart';
import '../business_filter_screen.dart';

class CaregorySearchList extends StatefulWidget {
  const CaregorySearchList({
    super.key,
    required this.controller,
    required this.searchValue,
  });

  final FilterFormController controller;
  final String? searchValue;

  @override
  State<CaregorySearchList> createState() => _CaregorySearchListState();
}

class _CaregorySearchListState extends State<CaregorySearchList> {
  var isLoading = true;
  List<Category> categories = [];
  @override
  void initState() {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    super.initState();
  }

  Future<List<Map<String, dynamic>>> request() {
    return widget.controller.tabIndex.value == 3
        ? widget.controller.search(null)
        : widget.controller.search(widget.searchValue);
  }

  Future<void> getCategories() async {
    final response = await request();
    if (mounted) {
      setState(() {
        categories = response.map((e) => Category.fromJson(e)).toList();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:
          isLoading
              ? const Center(child: Text("Something was wrong!.Try again"))
              : categories.isEmpty
              ? const Center(child: Text("No results found!"))
              : ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];

                  return InkWell(
                    onTap: () {
                      widget.controller.changeState(allStates);
                      widget.controller.changeTownship(allTownship);
                      widget.controller.changeCategory(category.name);
                      Get.to(
                        () => BusinessFilterScreen(
                          appBarTitle: category.name,
                          hintText: "လုပ်ငန်းအမည်",
                          search: widget.controller.searchBusiness,
                          onSelected: (value) {
                            debugPrint("*********GO TO: ${value.name} page");
                          },
                        ),
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          category.name,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
