import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shopping_app/admin/admin_home.dart';
import 'package:shopping_app/configs/messages.dart';

import '../configs/assets_path.dart';
import '../configs/colors.dart';
import '../pages/login_page.dart';
import '../widgets/support_widget.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {

  TextEditingController userNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  loginAdmin() {
    FirebaseFirestore
        .instance
        .collection("admin_e")
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((result) {
        if(result.data()['username'] != userNameController.text.trim()) {
          scaffoldMessage(context, "Incorrect UserName");
        } else if(result.data()['password'] != userPasswordController.text.trim()) {
          scaffoldMessage(context, "Incorrect Password");
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminHome()));
          scaffoldMessage(context, "Logged In  Successfully");
        }
      });
    });
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
              // key: formStateKey,
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
                      "Admin Panel",
                      style: AppWidget.semiBoldTextFieldStyle(),
                    ),
                  ),
                  // Name
                  const SizedBox(height: 20,),
                  Text(
                    textAlign: TextAlign.start,
                    "Username",
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
                        controller: userNameController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Username..."
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
                        controller: userPasswordController,
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
                      loginAdmin();
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
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
