import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/configs/assets_path.dart';
import 'package:shopping_app/configs/colors.dart';
import 'package:shopping_app/services/database.dart';
import 'package:shopping_app/services/shared_preference.dart';
import 'package:shopping_app/widgets/support_widget.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String? email;
  Stream? orderStream;


  getSharedPreferences() async {
    email = await SharedPreferenceHelper().getUserEmail();
    setState(() {  });
  }
  getOnTheLoad() async {
    await getSharedPreferences();
    orderStream = await DatabaseMethods().getOrders(email!);
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
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
                                      documentSnapshot['product'],
                                      style: AppWidget.semiBoldTextFieldStyle()
                                    ),
                                    Text(
                                        "\$ ${documentSnapshot['price']}",
                                        style: TextStyle(
                                            color: Colors.orange,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold
                                        )
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10,),
                                Text(
                                  textAlign: TextAlign.center,
                                  "Status:\n ${documentSnapshot['status']}",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                  ),
                                )
                              ],
                            ),
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
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
            "Current Orders",
          style: AppWidget.boldTextFieldStyle(),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined
          ),
        ),
        backgroundColor: bgColor,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
