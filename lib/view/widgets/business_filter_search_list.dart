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
              .where("name", isLessThan: '${controller.searchValue.value}')
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
              .where("categoryID", isLessThan: '${controller.category.value}')
              .orderBy("categoryID");
        }

        if (controller.state.value.isNotEmpty &&
            controller.state.value != allStates) {
          query = query
              .where("state", isGreaterThanOrEqualTo: controller.state.value)
              .where("state", isLessThan: '${controller.state.value}')
              .orderBy("state");
        }

        if (controller.township.value.isNotEmpty &&
            controller.township.value != allTownship) {
          query = query
              .where(
                "township",
                isGreaterThanOrEqualTo: controller.township.value,
              )
              .where("township", isLessThan: '${controller.township.value}')
              .orderBy("township");
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          // don't force height = size.height; let the list scroll naturally
          width: size.width,
          child: FirestorePagination(
            key: ValueKey(query),
            initialLoader: const CupertinoActivityIndicator(),
            bottomLoader: const CupertinoActivityIndicator(),
            query: query,

            // IMPORTANT: use wrap view, and make it vertically scrollable
            viewType: ViewType.wrap,
            scrollDirection:
                Axis.vertical, // (vertical is default, but explicit is nice)
            wrapOptions: const WrapOptions(
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              spacing: 8,
              runSpacing: 8,
            ),

            itemBuilder: (context, docs, index) {
              final bl = docs[index].data() as Map<String, dynamic>;
              final screenW = MediaQuery.sizeOf(context).width;
              const horizontalMargin = 10.0; // matches your Container margin
              const spacing = 8.0; // same as wrapOptions.spacing

              // half width (2 columns) minus margins & spacing
              final halfW = (screenW - (horizontalMargin * 2) - spacing) / 2;
              final isSmall = (bl["businessLogo"]?["width"] ?? 0) <= 360;

              // small => half row; large => full row
              final tileW =
                  isSmall ? halfW : (screenW - (horizontalMargin * 2));

              return SizedBox(
                width: tileW,
                child: InkWell(
                  onTap: () {
                    controller.setSelectedBL(BusinessListing.fromJson(bl));
                    Get.toNamed(businessDetailScreen);
                  },
                  child: Card(
                    elevation: 0,
                    color: Colors.white,
                    child: CachedNetworkImage(
                      // fill the sized box width
                      width: double.infinity,
                      fit: BoxFit.contain,
                      imageUrl: bl["businessLogo"]["imagePath"],
                      progressIndicatorBuilder:
                          (context, url, status) => Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.white,
                            child: Container(
                              height: 120,
                            ), // give it some height while loading
                          ),
                      errorWidget:
                          (context, url, whatever) => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/logo.png',
                                width: 100,
                                height: 100,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "No Business Data",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                    ),
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
