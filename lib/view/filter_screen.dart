import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mmbl/controller/filter_form_controller.dart';
import 'package:mmbl/utils/widgets/search_widget.dart';
import 'package:mmbl/view/widgets/filter_search_list.dart';

import '../constant/constant.dart';

class CategoryFilterScreen extends StatefulWidget {
  final String appBarTitle;
  final String hintText;
  final void Function(String) onSelected;
  const CategoryFilterScreen({
    super.key,
    required this.appBarTitle,
    required this.hintText,
    required this.onSelected,
  });

  @override
  State<CategoryFilterScreen> createState() => _CategoryFilterScreenState();
}

class _CategoryFilterScreenState extends State<CategoryFilterScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final FilterFormController controller = Get.find();
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
          SearchWidget(size: size, hintText: widget.hintText),
          Obx(() {
            Query query = FirebaseFirestore.instance.collection(
              categoryCollection,
            );

            // Add filters only if they are not empty
            if (controller.searchValue.value.isNotEmpty) {
              query = query
                  .where(
                    "name",
                    isGreaterThanOrEqualTo: controller.searchValue.value,
                  )
                  .where(
                    "name",
                    isLessThan: '${controller.searchValue.value}\uf8ff',
                  )
                  .orderBy("name");
            }

            return FilterSearchList(
              key: ValueKey(query),
              query: query,
              onSelected: (value) {
                widget.onSelected(value);
                Get.back();
              },
            );
          }),
        ],
      ),
    );
  }
}
