import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mmbl/controller/filter_form_controller.dart';
import 'package:mmbl/view/ourmission.dart';
import 'package:mmbl/view/tab_bar_view/categories_view.dart';
import 'package:mmbl/view/tab_bar_view/emergency_view.dart';
import 'package:mmbl/view/tab_bar_view/home_view.dart';
import 'package:mmbl/view/tab_bar_view/search_view.dart';

import '../utils/other/intent_method.dart';
import 'about_us.dart';

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

  /// Closes the drawer (if open) then performs [next].
  Future<void> _closeDrawerThen(Future<void> Function() next) async {
    final scaffoldState = Scaffold.maybeOf(context);
    if (scaffoldState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop(); // Close Drawer
      await Future.delayed(const Duration(milliseconds: 220)); // let it finish
    }
    if (!mounted) return;
    await next();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
        // Soft brand gradient for the app bar
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.amber.shade600, Colors.amber.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
        title: FadeInDown(
          duration: const Duration(milliseconds: 600),
          child: const Center(
            child: Text(
              "MYANMAR BUSINESS LEADER",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
              ),
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

      // BEAUTIFIED DRAWER
      drawer: SafeArea(
        child: SlideInLeft(
          duration: const Duration(milliseconds: 500),
          child: Container(
            width: size.width * 0.75,
            height: size.height,
            decoration: BoxDecoration(
              color: const Color(0xFFFDFDFD),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 16,
                  offset: const Offset(3, 0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with gradient + circular logo
                FadeInDown(
                  duration: const Duration(milliseconds: 600),
                  child: Container(
                    width: double.infinity,
                    height: size.height * 0.25,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.amber.shade200, Colors.amber.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Image.asset(
                              "assets/logo.png",
                              fit: BoxFit.cover,
                              width: 96,
                              height: 96,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Myanmar Business Leader",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Items (as soft cards) + subtle stagger
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    children: [
                      _buildDrawerSectionLabel("General"),
                      _buildDrawerItem(
                        icon: Icons.group,
                        title: "About Us",
                        onTap:
                            () => _closeDrawerThen(() async {
                              await Get.to(() => const AboutUsScreenLight());
                            }),
                        delayMs: 0,
                      ),
                      _buildDrawerItem(
                        icon: Icons.question_mark_rounded,
                        title: "Our Mission",
                        onTap:
                            () => _closeDrawerThen(() async {
                              await Get.to(() => const OurMission());
                            }),
                        delayMs: 80,
                      ),

                      const SizedBox(height: 6),
                      const Divider(indent: 12, endIndent: 12, height: 24),

                      _buildDrawerSectionLabel(
                        "To Advertise and Partner with us",
                      ),
                      _buildDrawerItem(
                        icon: Icons.phone,
                        title: "Call Us",
                        onTap:
                            () => _closeDrawerThen(() async {
                              await makePhoneCall("09976947648");
                            }),
                        delayMs: 120,
                      ),
                    ],
                  ),
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
      /*   floatingActionButton: ZoomIn(
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
      ), */
    );
  }

  // Section label for drawer
  Widget _buildDrawerSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.5,
          color: Colors.grey.shade700,
          letterSpacing: 0.6,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Soft-card Drawer Item with ripple, hover, and subtle shadow.
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    int delayMs = 0,
  }) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 450),
      delay: Duration(milliseconds: delayMs),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.grey.withOpacity(0.08)),
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(14),
              hoverColor: Colors.blue.shade50,
              splashColor: Colors.blue.shade200.withOpacity(0.35),
              highlightColor: Colors.blue.shade100.withOpacity(0.25),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListTile(
                  dense: false,
                  leading: Icon(icon, size: 28, color: Colors.amber),
                  title: Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey.shade900,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
