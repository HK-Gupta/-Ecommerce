import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {

  Future addUserDetails(Map<String, dynamic> userInfo, String id) async {
    return await FirebaseFirestore
        .instance
        .collection("users_e")
        .doc(id)
        .set(userInfo);
  }
  Future addAllProducts(Map<String, dynamic> productsInfo) async {
    return await FirebaseFirestore
        .instance
        .collection('products_e')
        .add(productsInfo);
  }
  Future addProduct(Map<String, dynamic> userInfo, String categoryName) async {
    return await FirebaseFirestore
        .instance
        .collection(categoryName)
        .add(userInfo);
  }
  updateStatus(String id) async {
    return await FirebaseFirestore
        .instance
        .collection('orders_e')
        .doc(id)
        .update({'status': 'Delivered'});
  }

  Future<Stream<QuerySnapshot>> getProducts(String category) async {
    return await FirebaseFirestore
        .instance
        .collection(category)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getOrders(String email) async {
    return await FirebaseFirestore
        .instance
        .collection('orders_e')
        .where('email', isEqualTo: email)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getAllOrders() async {
    return await FirebaseFirestore
        .instance
        .collection('orders_e')
        .where('status', isEqualTo: "On the way")
        .snapshots();
  }

  Future addProductPaymentDetails(Map<String, dynamic> userInfo) async {
    return await FirebaseFirestore
        .instance
        .collection("orders_e")
        .add(userInfo);
  }

  Future<QuerySnapshot> searchProducts(String updateName) async {
    return await FirebaseFirestore
        .instance
        .collection("products_e")
        .where('search_key', isEqualTo: updateName.substring(0, 1).toUpperCase())
        .get();
  }
}