import 'package:get/get.dart';
import 'package:shopping_app/admin/add_product.dart';
import 'package:shopping_app/admin/admin_home.dart';
import 'package:shopping_app/admin/admin_login.dart';
import 'package:shopping_app/admin/all_orders.dart';
import 'package:shopping_app/pages/bottom_navigation.dart';
import 'package:shopping_app/pages/home.dart';
import 'package:shopping_app/pages/login_page.dart';
import 'package:shopping_app/pages/onboarding.dart';
import 'package:shopping_app/pages/order_page.dart';
import 'package:shopping_app/pages/product_details.dart';
import 'package:shopping_app/pages/profile_page.dart';
import 'package:shopping_app/pages/signup_page.dart';

var pages = [
  GetPage(name: '/add_product', page: () => AddProduct()),
  GetPage(name: '/admin_home', page: () => AdminHome()),
  GetPage(name: '/admin_login', page: () => AdminLogin()),
  GetPage(name: '/all_orders', page: () => AllOrders()),
  GetPage(name: '/bottom_navigation', page: () => BottomNavigation()),
  GetPage(name: '/home', page: () => Home()),
  GetPage(name: '/login_page', page: () => LoginPage()),
  GetPage(name: '/onboarding', page: () => Onboarding()),
  GetPage(name: '/order_page', page: () => OrderPage()),
  GetPage(name: '/profile_page', page: () => ProfilePage()),
  GetPage(name: '/signup_page', page: () => SignupPage()),
];