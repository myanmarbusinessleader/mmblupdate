import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/constant.dart';
import '../../controller/filter_form_controller.dart';
import '../../model/category.dart';
import '../business_filter_screen.dart';

class CaregorySearchList extends StatefulWidget {
  const CaregorySearchList({super.key});

  @override
  State<CaregorySearchList> createState() => _CaregorySearchListState();
}

class _CaregorySearchListState extends State<CaregorySearchList> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final FilterFormController controller = Get.find();
    return Expanded(
      child: Obx(() {
        Query query = FirebaseFirestore.instance
            .collection(categoryCollection)
            .orderBy("name")
            .orderBy("id");
        if (controller.searchValue.isNotEmpty) {
          query = query
              .where(
                "name",
                isGreaterThanOrEqualTo: controller.searchValue.value,
              )
              .where(
                "name",
                isLessThan: '${controller.searchValue.value}\uf8ff',
              );
        }

        return SizedBox(
          height: size.height,
          width: size.width,
          child: FirestorePagination(
            key: ValueKey(query),
            initialLoader: const CupertinoActivityIndicator(),
            bottomLoader: const CupertinoActivityIndicator(),
            limit: 20,
            query: query,
            itemBuilder: (context, docs, index) {
              final doc = docs[index];
              final category = Category.fromJson(
                doc.data() as Map<String, dynamic>,
              );

              /*  final categoriesList =
                  dataList.map((d) => Category.fromJson(d)).toList(); */
              return InkWell(
                onTap: () {
                  controller.changeState(allStates);
                  controller.changeTownship(allTownship);
                  controller.changeCategory(category.name);
                  Get.to(
                    () => BusinessFilterScreen(
                      appBarTitle: category.name,
                      hintText: "လုပ်ငန်းအမည်",
                    ),
                  );
                },
                child: SizedBox(
                  width: size.width,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        category.name,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ) /* Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    categoriesList
                        .map(
                          (category) => InkWell(
                            onTap: () {
                              controller.changeState(allStates);
                              controller.changeTownship(allTownship);
                              controller.changeCategory(category.name);
                              Get.to(
                                () => BusinessFilterScreen(
                                  appBarTitle: category.name,
                                  hintText: "လုပ်ငန်းအမည်",
                                ),
                              );
                            },
                            child: SizedBox(
                              width: size.width,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    category.name,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ) */;
            },
          ),
        );
      }),
    );
  }
}
