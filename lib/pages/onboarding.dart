import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shopping_app/configs/assets_path.dart';
import 'package:shopping_app/configs/colors.dart';
import 'package:shopping_app/pages/signup_page.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final x = w<h? h/2: w/2;
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Lottie.asset(
                LottiePath.startLottie,
            ),
            const SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                  "Explore\nThe Best\nProducts",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 40),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: InkWell(
                    onTap: () {
                      Get.to(SignupPage());
                    },
                    child: Text(
                      "Next",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ],
            )
          ],
        )
      ),
    );
  }
}
