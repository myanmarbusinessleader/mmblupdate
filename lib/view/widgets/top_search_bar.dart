import 'package:flutter/material.dart';

import '../../controller/filter_form_controller.dart';
import '../../utils/other/debounce.dart';

class TopSearchBar extends StatelessWidget {
  const TopSearchBar({super.key, required this.size, required this.controller});

  final Size size;
  final FilterFormController controller;

  @override
  Widget build(BuildContext context) {
    final debouncer = Debouncer(milliseconds: 500);
    return Container(
      color: Colors.amber,
      padding: const EdgeInsets.only(left: 25, top: 10, right: 20),
      height: 70,
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.white, size: 30),
          ),
          //TextField
          Expanded(
            child: TextField(
              controller: TextEditingController(
                text: controller.searchValue.value,
              ),
              cursorColor: Colors.white,
              onChanged: (value) {
                debouncer.run(() {
                  controller.changeSearchValue(value);
                });
              },
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const InputDecoration(
                hintText: "လုပ်ငန်းအမည်",
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38),
                ),
                hintStyle: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
