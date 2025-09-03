import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/constant.dart';
import '../../controller/filter_form_controller.dart';
import '../../utils/widgets/filter_row_widget.dart';
import '../business_filter_screen.dart';
import '../filter_screen.dart';
import '../filter_screen_second.dart';

class FilterSearch extends StatelessWidget {
  const FilterSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final FilterFormController controller = Get.find();
    return Container(
      color: Colors.amber,
      padding: const EdgeInsets.only(left: 10, right: 20, top: 5),
      child: Column(
        children: [
          Obx(() {
            return FilterRowWidget(
              leadingText: "What",
              value: controller.category.value,
              buttonPressed: () {
                Get.to(
                  () => CategoryFilterScreen(
                    appBarTitle: "လုပ်ငန်းအမျိုးအစားရွေးချယ်ပါ",
                    hintText: "လုပ်ငန်းအမျိုးအစား",

                    onSelected: controller.changeCategory,
                  ),
                );
                //Get.toName(filterScreen)
              },
              returnData: (value) => controller.changeCategory(value),
            );
          }),
          Obx(
            () => FilterRowWidget(
              leadingText: "State",
              value: controller.state.value,
              buttonPressed: () {
                Get.to(
                  () => FilterScreenSecond(
                    appBarTitle: "ပြည်နယ်နှင့်တိုင်းဒေသကြီး ရွေးချယ်ပါ",
                    hintText: "ပြည်နယ်နှင့်တိုင်း",
                    search: controller.searchState,
                    onSelected: controller.changeState,
                  ),
                );
              },
              returnData: (value) => controller.changeState(value),
            ),
          ),
          Obx(
            () => FilterRowWidget(
              leadingText: "Township",
              value: controller.township.value,
              buttonPressed: () {
                if (controller.state.value == allStates) {
                  Get.defaultDialog(
                    title: "Warnning!",
                    content: const Text("Please choose state first"),
                  );
                  return;
                }
                Get.to(
                  () => FilterScreenSecond(
                    appBarTitle: "မြို့နယ်ရွေးချယ်ပါ",
                    hintText: "မြို့နယ်",
                    search: controller.searchTownship,
                    onSelected: controller.changeTownship,
                  ),
                );
              },
              returnData: (value) => controller.changeTownship(value),
            ),
          ),
          //Search Button
          Padding(
            padding: const EdgeInsets.all(15),
            child: SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.black,
                ),
                onPressed: () {
                  Get.to(
                    () => BusinessFilterScreen(
                      appBarTitle: controller.category.value,
                      hintText: "လုပ်ငန်းအမည်",
                    ),
                  );
                },
                child: const Text(
                  "ရှာရန်",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
