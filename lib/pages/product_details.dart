import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shopping_app/configs/colors.dart';
import 'package:shopping_app/services/database.dart';
import 'package:shopping_app/services/shared_preference.dart';
import 'package:shopping_app/widgets/support_widget.dart';
import 'package:http/http.dart' as http;

import '../services/constants.dart';

class ProductDetails extends StatefulWidget {
  final String image, name, details, price;
  const ProductDetails({super.key, required this.image, required this.name, required this.details, required this.price});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

  String? name, email;
  SharedPreferenceHelper spHelper = SharedPreferenceHelper();
  getTheSharedPreferences() async {
    name = await spHelper.getUserName();
    email = await spHelper.getUserEmail();
    setState(() { });
  }
  onTheLoad() async {
    await  getTheSharedPreferences();
    setState(() {});
  }

  @override
  void initState() {
    onTheLoad();
    super.initState();
  }

  Map<String, dynamic>? paymentIntent;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, ),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(100)
                ),
                  child: Icon(Icons.arrow_back_ios_new_outlined)
              ),
            ),
            const SizedBox(height: 5,),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  widget.image,
                  height: 300,
                  width: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            widget.name,
                          style: AppWidget.boldTextFieldStyle(),
                        ),
                        Text(
                            "\$ ${widget.price}",
                            style: TextStyle(
                                color: Colors.orange,
                                fontSize: 22,
                                fontWeight: FontWeight.bold
                            )
                        )
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Text(
                        "Details: ",
                      style: AppWidget.semiBoldTextFieldStyle(),
                    ),
                    SizedBox(height: 10,),
                    Container(height: 140,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Text(
                          widget.details
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    InkWell(
                      onTap: () {
                        makePayment(widget.price);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xffFD6F3E),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Buy Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> makePayment(String amount) async {
    try{
      paymentIntent = await createPaymentIntent(amount, 'INR');
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent?['client_secret'],
            style: ThemeMode.dark,
            merchantDisplayName: 'Cricket'
          )
      ).then((value) {  });

      displayPaymentSheet();
    } catch(e, s) {
      print('Exception: $e $e');
    }
  }

  displayPaymentSheet() async {
    try {
       await Stripe.instance.presentPaymentSheet().then((value) async {
         Map<String, dynamic> orderInfoMap = {
           'product': widget.name,
           'price': widget.price,
           'product_image': widget.image,
           'name': name,
           'email': email,
           'status': 'On the way'
         };
         await DatabaseMethods().addProductPaymentDetails(orderInfoMap);

         showDialog(
             context: context,
             builder: (_)=>
                 AlertDialog(
                   content: Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           Icon(Icons.check_circle, color: Colors.green,),
                           Text("Payment Successful"),
                         ],
                       )
                     ],
                   ),
                 )
         );
         paymentIntent = null;
       }).onError((error, stackTrace) {
         print("Error is: ---> $error $stackTrace");
       });
    } on StripeException catch(e) {
      print("Error is: ---> $e");
      showDialog(
          context: context,
          builder: (_) =>
              AlertDialog(
                content: Text("Cancelled"),
              )
      );
    } catch(e) {
      print("Error: $e");
    }
  }
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body={
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      return jsonDecode(response.body);
    } catch(e) {
      print("Error charging User: ${e.toString()}");
    }
  }
  calculateAmount(String amount) {
    final calculatedAmount=(int.parse(amount)*100);
    return calculatedAmount.toString();
  }
}
