import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shopping_app/configs/assets_path.dart';
import 'package:shopping_app/configs/colors.dart';
import 'package:shopping_app/configs/messages.dart';
import 'package:shopping_app/pages/bottom_navigation.dart';
import 'package:shopping_app/pages/signup_page.dart';
import 'package:shopping_app/widgets/support_widget.dart';

import '../services/shared_preference.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email, password;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formStateKey = GlobalKey<FormState>();

  userLogin() async {
    try {
      await FirebaseAuth
          .instance
          .signInWithEmailAndPassword(
          email: email!,
          password: password!
      );
      await SharedPreferenceHelper().saveUserEmail(email!);
      scaffoldMessage(context, "Logged in Successfully");
      Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavigation()));
    } on FirebaseAuthException catch(e) {
      if(e.code == 'user-not-found') {
        scaffoldMessage(context, "User Node Found");
      } else if(e.code == 'wrong-password') {
        scaffoldMessage(context, "Wrong Password");
      } else {
        scaffoldMessage(context, e as String);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final w =  MediaQuery.of(context).size.width;
    final h =  MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Form(
              key: formStateKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Lottie.asset(
                        LottiePath.startLottie,
                        height: h/3,
                        width: w,
                        fit: BoxFit.fill
                      ),
                    ),
                  ),
                  const SizedBox(height: 18,),
                  Center(
                    child: Text(
                      "Sign In",
                      style: AppWidget.semiBoldTextFieldStyle(),
                    ),
                  ),
                  const SizedBox(height: 7,),
                  Center(
                    child: Text(
                      "Please enter the details below to continue..",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16
                      ),
                    ),
                  ),
                  // Email
                  const SizedBox(height: 40,),
                  Text(
                    textAlign: TextAlign.start,
                    "Email",
                    style: AppWidget.semiBoldTextFieldStyle(),
                  ),
                  const SizedBox(height: 5,),
                  Container(
                      padding: EdgeInsets.only(left: 18),
                      decoration: BoxDecoration(
                        color: textFieldColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        validator: (value) {
                          if(value==null || value.isEmpty) {
                            return 'Please enter the registered email';
                          }
                          return null;
                        },
                        controller: emailController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter the email..."
                        ),
                      )
                  ),
                  // Password
                  const SizedBox(height: 25,),
                  Text(
                    textAlign: TextAlign.start,
                    "Password",
                    style: AppWidget.semiBoldTextFieldStyle(),
                  ),
                  const SizedBox(height: 5,),
                  Container(
                      padding: EdgeInsets.only(left: 18),
                      decoration: BoxDecoration(
                        color: textFieldColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        validator: (value) {
                          if(value==null || value.isEmpty) {
                            return 'Please enter the password';
                          }
                          return null;
                        },
                        controller: passwordController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter the password...",
                        ),
                      )
                  ),
                  const SizedBox(height: 12,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Forget Password?",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 15
                        ),
                      ),
                    ],
                  ),
                  // Login Button.
                  const SizedBox(height: 45,),
                  GestureDetector(
                    onTap: () {
                      if(formStateKey.currentState!.validate()) {
                        setState(() {
                          email = emailController.text;
                          password = passwordController.text;
                        });
                      }
                      userLogin();
                    },
                    child: Center(
                      child: Container(
                        alignment: Alignment.center,
                        width: w/1.5,
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          "Don't have an account? ",
                        style: AppWidget.lightTextFieldStyle(),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupPage()));
                        },
                        child: Text(
                          "Sign Up!",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 18
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
