import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/configs/colors.dart';
import 'package:shopping_app/pages/product_details.dart';
import 'package:shopping_app/services/database.dart';

import '../configs/assets_path.dart';
import '../widgets/support_widget.dart';

class CategoryProducts extends StatefulWidget {
  final String category;
  const CategoryProducts({super.key, required this.category});

  @override
  State<CategoryProducts> createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {

  Stream? CategoryStream;
  getOnTheLoad() async {
    CategoryStream = await DatabaseMethods().getProducts(widget.category);
    setState(() {  });
  }
  @override
  void initState() {
    getOnTheLoad();
    super.initState();
  }

  Widget allProducts() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
          stream: CategoryStream,
          builder: (context, AsyncSnapshot snapshot) {
            return snapshot.hasData ?
                GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10
                    ),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                      return Container(
                        margin: EdgeInsets.all(2),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 10,),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                documentSnapshot["image"],
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Text(documentSnapshot["name"], style: AppWidget.semiBoldTextFieldStyle(),),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "\$${documentSnapshot["price"]}",
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetails(
                                                    image: documentSnapshot["image"],
                                                    name: documentSnapshot["name"],
                                                    details: documentSnapshot["details"],
                                                    price: documentSnapshot["price"]
                                                )
                                        )
                                    );
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Icon(Icons.add, color: Colors.white, size: 30,)
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10,),
                          ],
                        ),
                      );
                    }
                ) :
                Container();
          }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            title: Text(widget.category, style: AppWidget.boldTextFieldStyle(),),
            backgroundColor: bgColor,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                  Icons.arrow_back_ios_new_outlined,
                size: 27,
              ),
            ),
          ),
          body: Container(
            child: Column(
              children: [
                Expanded(
                  child: allProducts()
                )
              ],
            ),
          ),
        )
    );
  }
}
