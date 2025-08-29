import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mmbl/constant/constant.dart';
import 'package:mmbl/controller/filter_form_controller.dart';
import 'package:mmbl/model/category.dart';
import 'package:mmbl/view/business_filter_screen.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeGridList extends StatefulWidget {
  const HomeGridList({super.key});

  @override
  State<HomeGridList> createState() => _HomeGridListState();
}

class _HomeGridListState extends State<HomeGridList> {
  var isLoading = true;
  List<Category> gridList = [];

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    getGridList();
  }

  Future<void> getGridList() async {
    final result = await FirebaseFirestore.instance
        .collection(categoryCollection)
        .where("isGrid", isEqualTo: true)
        .orderBy("name")
        .get();
    if (mounted) {
      setState(() {
        gridList = result.docs.map((e) => Category.fromJson(e.data())).toList();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final FilterFormController controller = Get.find();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: isLoading
          ? Skeletonizer(
        effect: ShimmerEffect(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[100]!,
          duration: const Duration(milliseconds: 800),
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 3 / 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return FadeInUp(
              duration: Duration(milliseconds: 300 + (index * 100)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 50,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      )
          : gridList.isNotEmpty
          ? GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 3 / 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: gridList.length,
        itemBuilder: (context, index) {
          final data = gridList[index];
          return FadeInUp(
            duration: Duration(milliseconds: 300 + (index * 100)),
            child: InkWell(
              onTap: () {
                controller.changeState(allStates);
                controller.changeTownship(allTownship);
                controller.changeCategory(data.name);
                Get.to(
                      () => BusinessFilterScreen(
                    appBarTitle: data.name,
                    hintText: "လုပ်ငန်းအမည်",
                    search: controller.searchBusiness,
                    onSelected: (value) {
                      debugPrint("*********GO TO: ${value.name} page");
                    },
                  ),
                  transition: Transition.cupertino,
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image Card
                  ZoomIn(
                    duration: const Duration(milliseconds: 400),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        height: 85,
                        width: 85,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: CachedNetworkImage(
                          imageUrl: data.image ?? "",
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Icon(
                            Icons.broken_image,
                            color: Colors.grey[400],
                            size: 40,
                          ),
                        )

                      ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Text
                  Text(
                    data.name,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      )
          : const Center(
        child: Text(
          "No categories available",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
    );
  }
}