// ignore_for_file: use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vendor_app_only/vendor/provider/product_provider.dart';
import 'package:vendor_app_only/vendor/views/screens/tab_bar_screen/attributes_screen.dart';
import 'package:vendor_app_only/vendor/views/screens/tab_bar_screen/general_screen.dart';
import 'package:vendor_app_only/vendor/views/screens/tab_bar_screen/images_screen.dart';
import 'package:vendor_app_only/vendor/views/screens/tab_bar_screen/shipping_screen.dart';

class UploadScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ProductProvider productprovider =
        Provider.of<ProductProvider>(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          //backgroundColor: Colors.pink,
          bottom: TabBar(tabs: [
            Tab(
              child: Text('General'),
            ),
            Tab(
              child: Text('Shipping'),
            ),
            Tab(
              child: Text('Attributes'),
            ),
            Tab(
              child: Text('Images'),
            ),
          ]),
        ),
        body: Form(
          key: _formKey,
          child: TabBarView(children: [
            GeneralScreen(),
            ShippingScreen(),
            AttributesScreen(),
            ImagesScreen(),
          ]),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () async {
              DocumentSnapshot userDoc = await firestore
                  .collection('vendors')
                  .doc(_auth.currentUser!.uid)
                  .get();
              final productId = Uuid().v4();
              if (_formKey.currentState!.validate()) {
                EasyLoading.show(status: 'Uplaoding');
                await firestore.collection('products').doc(productId).set({
                  'productId': productId,
                  'productName': productprovider.productData['productName'],
                  'productPrice': productprovider.productData['productPrice'],
                  'productQuantity':
                      productprovider.productData['productQuantity'],
                  'category': productprovider.productData['category'],
                  'descriptions': productprovider.productData['descriptions'],
                  'chargeShipping':
                      productprovider.productData['chargeShipping'],
                  'shippingCharge':
                      productprovider.productData['shippingCharge'],
                  'brandName': productprovider.productData['brandName'],
                  'sizeList': productprovider.productData['sizeList'],
                  'productImages': productprovider.productData['imageUrlList'],
                  'bussinessName':
                      (userDoc.data() as Map<String, dynamic>)['bussinessName'],
                  'storeImage':
                      (userDoc.data() as Map<String, dynamic>)['storeImage'],
                  'countryValue':
                      (userDoc.data() as Map<String, dynamic>)['countryValue'],
                  'cityValue':
                      (userDoc.data() as Map<String, dynamic>)['cityValue'],
                  'stateValue':
                      (userDoc.data() as Map<String, dynamic>)['stateValue'],
                  'vendorId': _auth.currentUser!.uid,
                }).whenComplete(() {
                  EasyLoading.dismiss();
                  productprovider.clearData();
                });
              } else {
                print('Not Valid');
              }
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(
                  8,
                ),
              ),
              child: Center(
                child: Text(
                  'Upload Product',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
