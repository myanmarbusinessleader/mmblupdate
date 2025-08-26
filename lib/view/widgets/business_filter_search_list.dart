import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mmbl/controller/filter_form_controller.dart';
import 'package:mmbl/model/business_listing.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/router/router.dart';

class BusinessFilterSearchList extends StatelessWidget {
  const BusinessFilterSearchList({
    super.key,
    required this.searchValue,
    required this.search,
    required this.onSelected,
  });

  final String? searchValue;
  final void Function(BusinessListing value) onSelected;
  final Future<void> Function(String? value) search;

  @override
  Widget build(BuildContext context) {
    final FilterFormController controller = Get.find();
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Obx(() {
        if (controller.isLoadingBusinessByCategory.value) {
          return Center(child: CupertinoActivityIndicator());
        }

        final dataList = controller.searchListByCategory;
        /* final List<BusinessListing> dataList =
            list.isNotEmpty ? list.take(5).toList() : []; */
        if (dataList.isEmpty) {
          return Center(child: Text("No items found!."));
        }
        return SizedBox(
          height: size.height,
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Wrap(
                direction: Axis.horizontal,
                spacing: 6,
                runSpacing: 6,
                children:
                    dataList.map((bl) {
                      return InkWell(
                        onTap: () {
                          controller.setSelectedBL(
                            BusinessListing.fromJson(bl),
                          );
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
                    }).toList(),
              ),
            ),
          ),
        );
      }),
    );
  }
}
