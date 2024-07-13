import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/configs/colors.dart';
import 'package:shopping_app/pages/home.dart';
import 'package:shopping_app/pages/order_page.dart';
import 'package:shopping_app/pages/profile_page.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late List<Widget> pages;
  late Home homePage;
  late OrderPage orderPage;
  late ProfilePage profilePage;
  int currentTabIndex= 0;

  @override
  void initState() {
    homePage = Home();
    orderPage = OrderPage();
    profilePage = ProfilePage();
    pages = [homePage, orderPage, profilePage];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          height: 55,
          backgroundColor: bgColor,
          color: Colors.black,
          animationDuration: Duration(milliseconds: 500),
          onTap: (int index) {
            setState(() {
              currentTabIndex = index;
            });
          },
          items: [
            Icon(Icons.home_outlined, color: Colors.white,),
            Icon(Icons.shopping_cart_outlined, color: Colors.white,),
            Icon(Icons.person_outline_rounded, color: Colors.white,),
          ],
        ),
        body: pages[currentTabIndex],
      ),
    );
  }
}
