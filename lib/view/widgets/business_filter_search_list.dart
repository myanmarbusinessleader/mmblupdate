import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mmbl/constant/constant.dart';
import 'package:mmbl/controller/filter_form_controller.dart';
import 'package:mmbl/model/business_listing.dart';
import 'package:shimmer/shimmer.dart';
import '../../utils/router/router.dart';

class BusinessFilterSearchList extends StatelessWidget {
  const BusinessFilterSearchList({super.key});

  @override
  Widget build(BuildContext context) {
    final FilterFormController controller = Get.find();
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Obx(() {
        Query query = FirebaseFirestore.instance
            .collection("businesses")
            .orderBy("dateTime", descending: true)
            .orderBy("businessLogo.width", descending: true);
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
        // Add filters only if they are not empty
        if (controller.category.value.isNotEmpty &&
            controller.category.value != allCategory) {
          query = query
              .where(
                "categoryID",
                isGreaterThanOrEqualTo: controller.category.value,
              )
              .where(
                "categoryID",
                isLessThan: '${controller.category.value}\uf8ff',
              )
              .orderBy("categoryID");
        }

        if (controller.state.value.isNotEmpty &&
            controller.state.value != allStates) {
          query = query
              .where("state", isGreaterThanOrEqualTo: controller.state.value)
              .where("state", isLessThan: '${controller.state.value}\uf8ff')
              .orderBy("state");
        }

        if (controller.township.value.isNotEmpty &&
            controller.township.value != allTownship) {
          query = query
              .where(
                "township",
                isGreaterThanOrEqualTo: controller.township.value,
              )
              .where(
                "township",
                isLessThan: '${controller.township.value}\uf8ff',
              )
              .orderBy("township");
        }

        return SizedBox(
          height: size.height,
          width: size.width,
          child: FirestorePagination(
            key: ValueKey(query),
            initialLoader: const CupertinoActivityIndicator(),
            bottomLoader: const CupertinoActivityIndicator(),
            limit: 10,
            query: query,
            viewType: ViewType.wrap,
            itemBuilder: (context, docs, index) {
              final bl = docs[index].data() as Map<String, dynamic>;
              return InkWell(
                onTap: () {
                  controller.setSelectedBL(BusinessListing.fromJson(bl));
                  Get.toNamed(businessDetailScreen);
                },
                child: Card(
                  elevation: 10,
                  color: Colors.white,
                  child: CachedNetworkImage(
                    width:
                        (bl["businessLogo"]["width"] < 300)
                            ? (bl["businessLogo"]["width"] * 0.61) + 0.0
                            : bl["businessLogo"]["width"] + 0.0,
                    //height: bl.businessLogo.height + 0.0,
                    fit: BoxFit.contain,
                    progressIndicatorBuilder: (context, url, status) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.white,
                        child: Container(color: Colors.white),
                      );
                    },
                    errorWidget: (context, url, whatever) {
                      return const Text("Image not available");
                    },
                    imageUrl: bl["businessLogo"]["imagePath"],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
