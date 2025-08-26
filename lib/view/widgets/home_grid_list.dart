import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mmbl/constant/constant.dart';
import 'package:mmbl/controller/filter_form_controller.dart';
import 'package:mmbl/model/category.dart';
import 'package:mmbl/view/business_filter_screen.dart';

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
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    getGridList();
    super.initState();
  }

  Future<void> getGridList() async {
    final result =
        await FirebaseFirestore.instance
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
      //color: Colors.white,
      padding: const EdgeInsets.only(top: 10),
      child:
          isLoading
              ? Center(child: CupertinoActivityIndicator())
              : gridList.isNotEmpty
              ? GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: gridList.length,
                itemBuilder: (context, index) {
                  final data = gridList[index];
                  return InkWell(
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
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Image
                        SizedBox(
                          height: 85,
                          width: 85,
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Image.network(
                                data.image ?? "",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        //Text
                        Text(
                          data.name,
                          style: const TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              )
              : const SizedBox(),
    );
  }
}
