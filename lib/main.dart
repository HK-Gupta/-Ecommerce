import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:shopping_app/admin/add_product.dart';
import 'package:shopping_app/admin/admin_home.dart';
import 'package:shopping_app/admin/admin_login.dart';
import 'package:shopping_app/admin/all_orders.dart';
import 'package:shopping_app/pages/bottom_navigation.dart';
import 'package:shopping_app/pages/home.dart';
import 'package:shopping_app/pages/onboarding.dart';
import 'package:shopping_app/pages/signup_page.dart';
import 'package:shopping_app/services/constants.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = publishedKey;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme:ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: AdminLogin(),
      // home: Onboarding(),
      home: auth.currentUser!=null ? const BottomNavigation(): const Onboarding() ,
    );
  }
}


// 01:05 -- 04/07
// 01:58 -- 05/07
// 03:05 -- 06/07
// 04:10 -- 07/07
// 04:50 -- 08/07
// 05:34 -- 09/07
// 06:20 -- 10/07
