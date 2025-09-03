import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mmbl/controller/filter_form_controller.dart';

import '../other/debounce.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key, required this.size, required this.hintText});

  final Size size;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final FilterFormController controller = Get.find();
    final debouncer = Debouncer(milliseconds: 500);
    return Container(
      color: Colors.amber,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 100,
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.white, size: 25),
          ),
          //TextField
          Expanded(
            child: TextField(
              controller: TextEditingController(
                text: controller.searchValue.value,
              ),
              cursorColor: Colors.white,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              onChanged: (value) {
                debouncer.run(() {
                  controller.changeSearchValue(value);
                });
              },
              decoration: InputDecoration(
                hintText: hintText,
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38),
                ),
                hintStyle: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
