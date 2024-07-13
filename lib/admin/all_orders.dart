import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/configs/colors.dart';
import 'package:shopping_app/services/database.dart';
import 'package:shopping_app/widgets/support_widget.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  Stream? orderStream;

  getOnTheLoad() async {
    orderStream = await DatabaseMethods().getAllOrders();
    setState(() {});
  }
  @override
  void initState() {
    getOnTheLoad();
    super.initState();
  }

  Widget allOrders() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
          stream: orderStream,
          builder: (context, AsyncSnapshot snapshot) {
            return snapshot.hasData ?
            ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                  print("Images: ${documentSnapshot['product_image']}");
                  return Container(
                    margin: EdgeInsets.only(bottom: 18),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    child: Image.network(
                                      documentSnapshot['product_image'],
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  const SizedBox(width: 20,),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Name: ${documentSnapshot['name']}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text(
                                        "Email: ${documentSnapshot['email']}",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 15
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            documentSnapshot['product'],
                                            style: AppWidget.semiBoldTextFieldStyle(),
                                          ),
                                          const SizedBox(width: 30,),
                                          Text(
                                              "\$ ${documentSnapshot['price']}",
                                              style: TextStyle(
                                                  color: Colors.orange,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                              )
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 10,),
                              InkWell(
                                onTap: () async {
                                  await DatabaseMethods().updateStatus(documentSnapshot.id);
                                  setState(() {});
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Done",
                                    style: AppWidget.semiBoldTextFieldStyle(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            ],
                          )
                      ),
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
          title: Text(
            "All Orders",
            style: AppWidget.boldTextFieldStyle(),
          ),
          backgroundColor: bgColor,
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
                Expanded(child: allOrders())
            ],
          ),
        ),
      ),
    );
  }
}
