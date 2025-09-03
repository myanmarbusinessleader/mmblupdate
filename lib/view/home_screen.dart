import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:mmbl/controller/filter_form_controller.dart';
import 'package:mmbl/view/tab_bar_view/categories_view.dart';
import 'package:mmbl/view/tab_bar_view/emergency_view.dart';
import 'package:mmbl/view/tab_bar_view/home_view.dart';
import 'package:mmbl/view/tab_bar_view/search_view.dart';

import '../utils/other/intent_method.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final FilterFormController controller = Get.find();
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      controller.changeTabIndex(tabController.index);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void _showAdvertiseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => ZoomIn(
            duration: const Duration(milliseconds: 400),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: BounceInDown(
                duration: const Duration(milliseconds: 500),
                child: Center(
                  child: const Text(
                    "Advertise with us",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ),
              content: FadeInUp(
                duration: const Duration(milliseconds: 600),
                child: const Text(
                  "Contact us to place your advertisement!",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
              actions: [
                ElasticIn(
                  duration: const Duration(milliseconds: 700),
                  child: TextButton.icon(
                    onPressed: () {
                      makePhoneCall("09976947648");
                      //Navigator.pop(context);
                    },
                    icon: const Icon(Icons.phone, color: Colors.white),
                    label: const Text(
                      "Call Now",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.amber.shade700,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
        flexibleSpace: Container(),
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
        title: FadeInDown(
          duration: const Duration(milliseconds: 600),
          child: const Text(
            "MYANMAR BUSINESS LEADER",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              letterSpacing: 1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: FadeInDown(
            duration: const Duration(milliseconds: 700),
            child: TabBar(
              controller: tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              tabs: const [
                Tab(text: "ပင်မ"),
                Tab(text: "ရှာဖွေရန်"),
                Tab(text: "အုပ်စုများ"),
                Tab(text: "အရေးပေါ်"),
              ],
            ),
          ),
        ),
      ),
      drawer: SafeArea(
        child: SlideInLeft(
          duration: const Duration(milliseconds: 500),
          child: Container(
            width: size.width * 0.75,
            height: size.height,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInDown(
                  duration: const Duration(milliseconds: 600),
                  child: Container(
                    width: double.infinity,
                    height: size.height * 0.25,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.amber.shade300,
                        width: 2,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                      child: Image.asset("assets/logo.png", fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildDrawerItem(
                  icon: Icons.group,
                  title: "About",
                  onTap: () {
                    debugPrint("Navigate to About");
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.question_mark_rounded,
                  title: "Our Guides",
                  onTap: () {
                    debugPrint("Navigate to Our Guides");
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.money,
                  title: "Exchange Rate",
                  onTap: () {
                    debugPrint("Navigate to Exchange Rate");
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.phone,
                  title: "Call to advertise with us",
                  onTap: () {
                    debugPrint("Call to advertise");
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: FadeIn(
        duration: const Duration(milliseconds: 500),
        child: TabBarView(
          controller: tabController,
          physics: const BouncingScrollPhysics(),
          children: const [
            HomeView(),
            SearchView(),
            CategoriesView(),
            EmergencyView(),
          ],
        ),
      ),
      floatingActionButton: ZoomIn(
        duration: const Duration(milliseconds: 800),
        child: FloatingActionButton(
          onPressed: () => _showAdvertiseDialog(context),
          backgroundColor: Colors.amber.shade700,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ElasticIn(
            duration: const Duration(milliseconds: 600),
            child: const Icon(Icons.phone, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 600),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          hoverColor: Colors.blue.shade50,
          highlightColor: Colors.blue.shade100.withOpacity(0.3),
          splashColor: Colors.blue.shade200.withOpacity(0.5),
          child: ListTile(
            leading: Icon(icon, size: 30, color: Colors.blue.shade700),
            title: Text(
              title,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
