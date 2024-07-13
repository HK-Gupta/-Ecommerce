import 'dart:ffi';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:shopping_app/configs/colors.dart';
import 'package:shopping_app/configs/messages.dart';
import 'package:shopping_app/services/database.dart';
import 'package:shopping_app/widgets/support_widget.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final ImagePicker imagePicker = ImagePicker();
  File? selectedImage;
  bool adding = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  Future getImage() async{
    var image = await imagePicker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {

    });
  }
  uploadItem() async{
    if(selectedImage!=null && nameController.text!="") {
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageReference = FirebaseStorage
          .instance
          .ref()
          .child("blog_image_e")
          .child(addId);

      final UploadTask task = firebaseStorageReference.putFile(selectedImage!);
      var downloadUrl = await (await task).ref.getDownloadURL();
      String firstLetter = nameController.text.substring(0, 1).toUpperCase();

      Map<String, dynamic> addProduct = {
        "name": nameController.text,
        "image": downloadUrl,
        "price": priceController.text,
        "details": detailController.text,
        'search_key': firstLetter,
        'updated_name': nameController.text.toUpperCase(),
      };

      await DatabaseMethods().addProduct( addProduct, value!).then((value) async{
        await DatabaseMethods().addAllProducts(addProduct);
        adding = false;
        setState(() {
          selectedImage = null;
          nameController.text="";
          priceController.text="";
          detailController.text="";
        });

          scaffoldMessage(context, "Product has been uploaded successfully");
      });
    }
  }

  String? value;
  final List<String> categoryItems=[
    'Watch',
    'Laptop',
    'TV',
    'Headphones',
    'Smartphones'
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_new_outlined
            ),
          ),
          title: Text(
              "Add Product",
            style: AppWidget.semiBoldTextFieldStyle(),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Upload the Product Image",
                  style: AppWidget.lightTextFieldStyle(),
                ),
                const SizedBox(height: 20,),
                selectedImage==null?
                InkWell(
                  onTap: () {
                    getImage();
                  },
                  child: Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.5
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        size: 45,
                      ),
                    ),
                  ),
                ): Center(
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black,
                            width: 1.5
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                            selectedImage!,
                          fit: BoxFit.fill,
                        ),
                      )
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Text(
                  "Product Name",
                  style: AppWidget.lightTextFieldStyle(),
                ),
                const SizedBox(height: 7,),
                Container(
                  width: w,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter the Product Name",
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Text(
                  "Product Price",
                  style: AppWidget.lightTextFieldStyle(),
                ),
                const SizedBox(height: 7,),
                Container(
                  width: w,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: priceController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter the Product Price",
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Text(
                  "Product Details",
                  style: AppWidget.lightTextFieldStyle(),
                ),
                const SizedBox(height: 7,),
                Container(
                  width: w,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: detailController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter the Product Details",
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
                Text(
                  "Product Category",
                  style: AppWidget.lightTextFieldStyle(),
                ),
                const SizedBox(height: 7,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  width: w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      items: categoryItems.map((item) =>
                        DropdownMenuItem(
                          value: item,
                            child: Text(
                              item,
                              style: AppWidget.semiBoldTextFieldStyle(),
                            )
                        )
                      ).toList(),
                      onChanged: ((value) =>
                        setState(() {
                          this.value = value;
                        })
                      ),
                      dropdownColor: Colors.white,
                      hint: Text("Select Category"),
                      iconSize: 35,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.black,),
                      value: value,
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Center(
                  child:  adding?
                  CircularProgressIndicator():
                  ElevatedButton(
                      onPressed: () {
                        adding = true;
                        setState(() {});
                        uploadItem();
                      },
                      child: Text(
                          "Add Product",
                        style: TextStyle(
                          fontSize: 21
                        ),
                      )
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
