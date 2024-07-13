import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:shopping_app/configs/colors.dart';
import 'package:shopping_app/pages/onboarding.dart';
import 'package:shopping_app/services/auth.dart';
import 'package:shopping_app/services/shared_preference.dart';
import 'package:shopping_app/widgets/support_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker imagePicker = ImagePicker();
  File? selectedImage;
  String? image, name, email;
  TextEditingController nameController = TextEditingController();

  SharedPreferenceHelper spHelper = SharedPreferenceHelper();
  getTheSharedPreferences() async{
    email = await spHelper.getUserEmail();
    image = await spHelper.getUserImage();
    name = await spHelper.getUserName();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getTheSharedPreferences();
  }

  Future getImage() async{
    var image = await imagePicker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    uploadItem();
    setState(() { });
  }
  uploadItem() async{
    if(selectedImage!=null) {
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageReference = FirebaseStorage
          .instance
          .ref()
          .child("users_image_e")
          .child(addId);

      final UploadTask task = firebaseStorageReference.putFile(selectedImage!);
      var downloadUrl = await (await task).ref.getDownloadURL();
      await spHelper.saveUserImage(downloadUrl);

    }
  }

  @override
  Widget build(BuildContext context) {
    print("Image Value: $image, Name: $name");
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
            "Profile",
          style: AppWidget.boldTextFieldStyle(),
        ),
        backgroundColor: bgColor,
      ),
      body: SafeArea(
        child: name==null?
        Center(child: CircularProgressIndicator()):
        Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const SizedBox(height: 20,),
              InkWell(
                onTap: () {
                  getImage();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: selectedImage!=null?
                  Image.file(
                      selectedImage!,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ):
                  Image.network(
                      image!,
                      height: 150,
                      width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.person_outline, size: 30,),
                        const SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name: ", style: AppWidget.lightTextFieldStyle(),),
                            Text(name!.toUpperCase(), style: AppWidget.semiBoldTextFieldStyle(),),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.mail_outline_rounded, size: 30,),
                        const SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Email: ", style: AppWidget.lightTextFieldStyle(),),
                            Text(email!.toUpperCase(), style: AppWidget.semiBoldTextFieldStyle(),),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await AuthMethods().signOut().then((value) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Onboarding()));
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.logout_rounded, size: 30,),
                          const SizedBox(width: 10,),
                          Text("Logout", style: AppWidget.semiBoldTextFieldStyle(),),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await AuthMethods().deleteUser().then((value) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Onboarding()));
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.delete_outline, size: 30,),
                          const SizedBox(width: 10,),
                          Text("Delete Account", style: AppWidget.semiBoldTextFieldStyle(),),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
