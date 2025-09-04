import 'package:get/get.dart';
import 'package:mmbl/view/business_detail/business_detail_screen.dart';


import '../../view/about_us.dart';
import '../../view/home_screen.dart';

const homeScreen = "/home_screen";
const addBusinessScreen = "/add_business_screen";
const businessDetailScreen = "/business_detail_screen";
const manageCategoriesScreen = "/manage_categories_screen";
const manageAdvertisementsScreen = "/manage_advertisement_screen";
const updateBusinessScreen = "/update_business_screen";
const manageBusinessScreen = "/manage_business_screen";

List<GetPage<dynamic>> getPages = [
  GetPage(
    name: homeScreen, 
    page:() => const HomeScreen()
    ),
 
  GetPage(
    name: businessDetailScreen, 
    page:() => const BusinessDetailScreen()
    ),


];