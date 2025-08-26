import 'package:flutter/material.dart';
import 'package:mmbl/view/widgets/advertisement_widget.dart';
import 'package:mmbl/view/widgets/home_grid_list.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Advertisement
              const AdvertisementWidget(),
              //Size Categories Widget
              const HomeGridList(),
              //Adding Business Listing Button
            ],
          ),
        ),
      ),
    );
  }
}
