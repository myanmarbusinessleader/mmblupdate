import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mmbl/controller/filter_form_controller.dart';

import 'about_us.dart';
import 'business_profile.dart';
import 'visit_us.dart';

class BusinessDetailScreen extends StatelessWidget {
  const BusinessDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FilterFormController _controller = Get.find();
    final bL = _controller.selectedBL!;
    return DefaultTabController(
      length: 3, 
      child: Scaffold(
        appBar:  AppBar(
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white,size: 35,),
            centerTitle: true,
            title:  Text(bL.name,
            style: const TextStyle(color: Colors.white,)),
            bottom: const TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.white,
              tabs: [
                Tab(
                  text: "PROFILE"
                ),
                Tab(
                  text: "ABOUT US"
                ),
                Tab(
                  text: "VISIT US"
                ),
              ],
              ),
          ),
        body: TabBarView(
          children: [
            BusinessProfile(bL: bL),
            //About Us
            AboutUs(bL: bL),
            //Visit Us
            VisitUs(bL: bL)
        ]),
      ),
      );

  }
}
