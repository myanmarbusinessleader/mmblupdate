import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mmbl/constant/constant.dart';
import 'package:mmbl/constant/state.dart';
import 'package:mmbl/constant/township.dart';
import 'package:mmbl/model/business_listing.dart';

class FilterFormController extends GetxController {
  final TextEditingController ePController = TextEditingController();
  RxList<Map<String, dynamic>> categoryList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> businessList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> searchList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> searchListByCategory =
      <Map<String, dynamic>>[].obs;
  var isLoadingBusiness = false.obs;
  var isLoadingBusinessByCategory = false.obs;
  var isLoadingSearch = false.obs;

  var category = allCategory.obs;
  var state = allStates.obs;
  var township = allTownship.obs;
  var tabIndex = 0.obs;
  BusinessListing? selectedBL;
  BusinessListing? editedBL;

  var searchValue = "".obs;

  void changeSearchValue(String value) => searchValue.value = value;

  @override
  void onInit() {
    signInAnonymus();

    // listenCategories();
    /*  listenBusinesses(); */
    super.onInit();
  }

  Future<void> listenBusinesses() async {
    isLoadingBusiness.value = true;
    final result =
        await FirebaseFirestore.instance
            .collection(businesses)
            .orderBy("dateTime", descending: true)
            .orderBy("businessLogo.width", descending: true)
            .get();
    businessList.value = result.docs.map((e) => e.data()).toList();
    log(">>>>>BUSINESS-LIST: ${businessList.length}");
    isLoadingBusiness.value = false;
  }

  void listenCategories() {
    FirebaseFirestore.instance
        .collection(categoryCollection)
        .snapshots()
        .listen((event) {
          var catList = event.docs.map((e) => e.data()).toList();
          catList.sort((a, b) => a["name"].compareTo(b["name"]));
          categoryList.value = catList;
        });
  }

  void setSelectedBL(BusinessListing b) => selectedBL = b;
  void setEditedBL(BusinessListing b) => editedBL = b;
  void changeCategory(String value) {
    category.value = value;
    //searchBusinessByCateogry(value);
  }

  void changeState(String value) => state.value = value;
  void changeTownship(String value) => township.value = value;
  void changeTabIndex(int value) {
    tabIndex.value = value;
    if (value == 1) {
      state.value = allStates;
      township.value = allTownship;
      category.value = allCategory;
    }
  }

  Future<List<Map<String, dynamic>>> search(String? value) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (value == null || value.isEmpty) {
      return categoryList;
    } else {
      final whereResult = categoryList.where(
        (e) => e["name"].startsWith(value),
      );
      return whereResult.toList();
    }
  }

  Future<List<Map<String, dynamic>>> searchState(String? value) async {
    await Future.delayed(const Duration(milliseconds: 500));
    var mock = stateMap;
    mock.sort((a, b) => a["name"]!.compareTo(b["name"]!));
    if (value == null || value.isEmpty) {
      return mock;
    } else {
      return mock
          .where((element) => element["name"]!.startsWith(value))
          .toList();
    }
  }

  Future<List<Map<String, dynamic>>> searchTownship(String? value) async {
    await Future.delayed(const Duration(milliseconds: 500));
    var mock = townshipMap[state.value];
    mock!.sort((a, b) => a["name"]!.compareTo(b["name"]!));
    if (value == null || value.isEmpty) {
      return mock;
    } else {
      return mock
          .where((element) => element["name"]!.startsWith(value))
          .toList();
    }
  }

  Future<void> searchBusinessByCateogry(String value) async {
    isLoadingBusinessByCategory.value = true;
    searchListByCategory.value =
        businessList.where((e) {
          final name = e["categoryID"] as String;
          return name.startsWith(value) || name.contains(value);
        }).toList();
    searchListByCategory.sort(
      (a, b) => a["businessLogo"]["width"] - b["businessLogo"]["width"],
    );
    log("SearchListByCategory: ${searchListByCategory.length}");
    isLoadingBusinessByCategory.value = false;
  }

  Future<void> searchBusiness(String? value) async {
    isLoadingSearch.value = true;
    await Future.delayed(const Duration(milliseconds: 10));
    if (value == null || value.isEmpty) {
      searchList.value = searchListByCategory;
    } else {
      searchList.value =
          searchListByCategory.where((e) {
            final name = e["name"] as String;
            return name.startsWith(value) || name.contains(value);
          }).toList();
    }
    isLoadingSearch.value = false;
  }

  List<String> getCategoryNameList(String element) {
    final List<String> tempList = [];
    String temp = "";
    for (var i = 0; i < element.length; i++) {
      temp = temp + element[i];
      tempList.add(temp);
    }
    return tempList;
  }

  signInAnonymus() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          break;
        default:
      }
    }
  }
}
