import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mmbl/controller/filter_form_controller.dart';
import '../widgets/filter_search.dart';
import '../widgets/top_search_bar.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final FilterFormController controller = Get.find();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //TopSearchBar Enteprise Name
              TopSearchBar(size: size, controller: controller),
              //FilterSearch
              FilterSearch(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}
