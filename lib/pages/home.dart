import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app/configs/colors.dart';
import 'package:shopping_app/pages/category_products.dart';
import 'package:shopping_app/pages/product_details.dart';
import 'package:shopping_app/services/database.dart';
import 'package:shopping_app/services/shared_preference.dart';
import 'package:shopping_app/widgets/support_widget.dart';

import '../configs/assets_path.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  bool search = false;
  List categories = [
    ImagePath.watch,
    ImagePath.laptop,
    ImagePath.tv,
    ImagePath.headphone,
    ImagePath.smartphone,
  ];
  List categoryName = [
    'Watch',
    'Laptop',
    'TV',
    'Headphones',
    'Smartphones'
  ];

  var queryResult=[];
  var tempSearchStore = [];

  initiateSearch(value) {
    if(value.length==0){
      setState(() {
        queryResult=[];
        tempSearchStore=[];
      });
    }
    setState(() {
      search = true;
    });

    var capitalisedValue = value.substring(0,1).toUpperCase() + value.substring(1);
    if(queryResult.isEmpty && value.length>=1) {
      DatabaseMethods().searchProducts(value)
          .then((QuerySnapshot docs) {
         for(int i=0; i<docs.docs.length; i++) {
           queryResult.add(docs.docs[i].data());
         }
      });
    } else {
      tempSearchStore=[];
      queryResult.forEach((element) {
        if(element['updated_name'].startsWith(capitalisedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }

  }
  String? name, image;
  String tempImg = "https://firebasestorage.googleapis.com/v0/b/happy-food-ecf6b.appspot.com/o/MenuImages%2Fboy.png?alt=media&token=b389d7a7-3df3-4f35-8654-b501ab8e179e";
  SharedPreferenceHelper sharedPreferenceHelper = SharedPreferenceHelper();
  getSharedPreferences() async {
    name = await sharedPreferenceHelper.getUserName();
    image = await sharedPreferenceHelper.getUserImage();
    setState(() {  });
  }
  onTheLoad() async {
    await getSharedPreferences();
    setState(() {  });
  }
  @override
  void initState() {
    onTheLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // App Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        name==null
                        ? CircularProgressIndicator()
                        : Text(
                          "Hey, $name",
                          style: AppWidget.boldTextFieldStyle(),
                        ),
                        Text(
                          "Good Morning",
                          style: AppWidget.lightTextFieldStyle(),
                        )
                      ],
                    ),
                    image==tempImg || image==null?
                    Image.asset(ImagePath.boyImgPath, height: 50, width: 50,):
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        image!,
                        height: 50, width: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                // Search Bar
                Container(
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        initiateSearch(value.toUpperCase());
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search Product",
                          hintStyle: AppWidget.lightTextFieldStyle(),
                          prefixIcon: InkWell(
                            onTap: () {
                              if(search) {
                                search = false;
                                tempSearchStore = [];
                                queryResult = [];
                                searchController.text = "";
                                setState(() {});
                              }
                            },
                            child: Icon(
                              search? Icons.cancel:
                              Icons.search,
                              color: Colors.black,
                            ),
                          )
                      ),
                    )
                ),
                const SizedBox(height: 20,),
                // Category Tiles
                if (search) ListView(
                  primary: false,
                  shrinkWrap: true,
                  children:
                    tempSearchStore.map((element) {
                      return buildResultCard(element);
                    }).toList()
                ) else Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "Categories",
                            style: AppWidget.semiBoldTextFieldStyle()
                        ),
                        Text(
                            "See All",
                            style: TextStyle(
                                color: Colors.orange,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            )
                        )
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        Container(
                            height: 100,
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Center(
                              child: Text(
                                "All",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                ),
                              ),
                            )
                        ),
                        Expanded(
                          child: Container(
                            height: 100,
                            child: ListView.builder(
                                itemCount: categories.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return CategoryTile(image: categories[index], name: categoryName[index],);
                                }
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30,),
                    // All Products
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "All Products",
                            style: AppWidget.semiBoldTextFieldStyle()
                        ),
                        Text(
                            "See All",
                            style: TextStyle(
                                color: Colors.orange,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            )
                        )
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      alignment: Alignment.topLeft,
                      height: 230,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 15),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const SizedBox(height: 5,),
                                ClipRRect(
                                  child: Image.asset(
                                    ImagePath.headphone,
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                Text("Headphone", style: AppWidget.semiBoldTextFieldStyle(),),
                                Row(
                                  children: [
                                    Text(
                                      "\$100",
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    const SizedBox(width: 30,),
                                    Container(
                                        decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius: BorderRadius.circular(100)
                                        ),
                                        child: Icon(Icons.add, color: Colors.white,)
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 15),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const SizedBox(height: 5,),
                                ClipRRect(
                                  child: Image.asset(
                                    ImagePath.laptop,
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                Text("Laptop", style: AppWidget.semiBoldTextFieldStyle(),),
                                Row(
                                  children: [
                                    Text(
                                      "\$700",
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    const SizedBox(width: 30,),
                                    Container(
                                        decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius: BorderRadius.circular(100)
                                        ),
                                        child: Icon(Icons.add, color: Colors.white,)
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 15),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const SizedBox(height: 5,),
                                ClipRRect(
                                  child: Image.asset(
                                    ImagePath.smartphone,
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                Text("Smartphone", style: AppWidget.semiBoldTextFieldStyle(),),
                                Row(
                                  children: [
                                    Text(
                                      "\$1000",
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    const SizedBox(width: 30,),
                                    Container(
                                        decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius: BorderRadius.circular(100)
                                        ),
                                        child: Icon(Icons.add, color: Colors.white,)
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget buildResultCard(data) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context)=>
                    ProductDetails(
                        image: data['image'],
                        name: data['name'],
                        details: data['details'],
                        price: data['price']
                    )
            )
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    data['image'],
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 20,),
                Text(
                  data['name'],
                  style: AppWidget.semiBoldTextFieldStyle(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class CategoryTile extends StatelessWidget {
  String image;
  String name;
  CategoryTile({super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(CategoryProducts(category: name));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Image.asset(
                  image,
                fit: BoxFit.cover,
                height: 50,
                width: 50,
              ),
            ),
            Icon(Icons.arrow_forward, size: 20,)
          ],
        ),
      ),
    );
  }

}

