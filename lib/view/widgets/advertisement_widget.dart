import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mmbl/constant/constant.dart';
import 'package:mmbl/model/advertisement.dart';
import 'package:shimmer/shimmer.dart';
import 'package:getwidget/getwidget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AdvertisementWidget extends StatefulWidget {
  const AdvertisementWidget({super.key});

  @override
  State<AdvertisementWidget> createState() => _AdvertisementWidgetState();
}

class _AdvertisementWidgetState extends State<AdvertisementWidget> {
  List<Advertisement> advertisementList = [];
  var isLoading = true;
  @override
  void initState() {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    getAdvertisement();
    super.initState();
  }

  Future<void> getAdvertisement() async {
    final response =
        await FirebaseFirestore.instance
            .collection(advertisementCollection)
            .orderBy("dateTime", descending: true)
            .get();
    if (mounted) {
      setState(() {
        advertisementList =
            response.docs.map((e) => Advertisement.fromJson(e.data())).toList();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return isLoading
        ? AspectRatio(
            aspectRatio: 16 / 9,
            child: Skeletonizer(
              enabled: true,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: width * 0.8,
                      height: (width * 0.8) / 16 * 9,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ),
          )
        : advertisementList.isEmpty
        ? const SizedBox()
        : Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GFCarousel(
            scrollPhysics: const BouncingScrollPhysics(),
            aspectRatio: 16 / 9,
            autoPlay: true,
            viewportFraction: 1.0,
            hasPagination: true,
            activeIndicator: Colors.black,
            passiveIndicator: Colors.grey,
            autoPlayInterval: const Duration(seconds: 6),
            items:
                advertisementList.map((advertisement) {
                  return Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: CachedNetworkImage(
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
                          imageUrl: advertisement.image,
                          fit: BoxFit.fill,
                          height: 200,
                          width: width,
                        ),
                      ),
                    ],
                  );
                }).toList(),
          ),
        );
  }
}
