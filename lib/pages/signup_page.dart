import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/configs/messages.dart';
import 'package:shopping_app/pages/bottom_navigation.dart';
import 'package:shopping_app/services/database.dart';
import 'package:shopping_app/services/shared_preference.dart';

import '../configs/assets_path.dart';
import '../configs/colors.dart';
import '../widgets/support_widget.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String? name, email, password;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formStateKey =GlobalKey<FormState>();

  registration() async {
    if(name!=null && email!=null && password!=null) {
      try{
        UserCredential userCredential = await FirebaseAuth
            .instance
            .createUserWithEmailAndPassword(
            email: email!,
            password: password!
        );

        String id = randomAlphaNumeric(10);
        await SharedPreferenceHelper().saveUserId(id);
        await SharedPreferenceHelper().saveUserEmail(email!);
        await SharedPreferenceHelper().saveUserName(name!);
        await SharedPreferenceHelper().saveUserImage("https://firebasestorage.googleapis.com/v0/b/happy-food-ecf6b.appspot.com/o/MenuImages%2Fboy.png?alt=media&token=b389d7a7-3df3-4f35-8654-b501ab8e179e");

        Map<String, dynamic> userInfo = {
          "name": name,
          "email": email,
          "id": id,
          "image": "https://firebasestorage.googleapis.com/v0/b/happy-food-ecf6b.appspot.com/o/MenuImages%2Fboy.png?alt=media&token=b389d7a7-3df3-4f35-8654-b501ab8e179e",
        };

        await DatabaseMethods().addUserDetails(userInfo, id);
        scaffoldMessage(context, "Registered Successfully");
        Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavigation()));
      } on FirebaseAuthException catch(e) {
        if(e.code=='weak-password') {
          scaffoldMessage(context, "Password Provided is Weak");
        }
        else if(e.code=='email-already-in-use') {
          scaffoldMessage(context, "Account Already Exists");
        } else {
          scaffoldMessage(context, e as String);
        }
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
                      "Sign Up",
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
                  // Name
                  const SizedBox(height: 40,),
                  Text(
                    textAlign: TextAlign.start,
                    "Name",
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
                            return 'Please enter your name...';
                          }
                          return null;
                        },
                        controller: nameController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter your name..."
                        ),
                      )
                  ),
                  // Email
                  const SizedBox(height: 25,),
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
                            return 'Please enter your email...';
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
                            return 'Please enter your password...';
                          }
                          return null;
                        },
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter the password...",
                        ),
                      )
                  ),
                  const SizedBox(height: 12,),
                  // Login Button.
                  const SizedBox(height: 45,),
                  GestureDetector(
                    onTap: () {
                      if(formStateKey.currentState!.validate()) {
                        setState(() {
                          name = nameController.text;
                          email = emailController.text;
                          password = passwordController.text;
                        });
                      }
                      registration();
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
                          "Sign Up",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
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
                        "Already have an account? ",
                        style: AppWidget.lightTextFieldStyle(),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                        },
                        child: Text(
                          "Login!",
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
