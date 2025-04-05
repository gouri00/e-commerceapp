import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app_only/models/vendor_model.dart';
import 'package:vendor_app_only/vendor/views/auth/vendor_reg.dart';
import 'package:vendor_app_only/vendor/views/screens/main_vendor_screen.dart';

class LandingScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionReference vendorStream =
        FirebaseFirestore.instance.collection('vendors');
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: vendorStream.doc(_auth.currentUser!.uid).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.data!.exists) {
            return VendorReg();
          }

          VendorModel vendorModel = VendorModel.fromJson(
              snapshot.data!.data() as Map<String, dynamic>);

          if (vendorModel.approved == true) {
            return MainVendorScreen();
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    vendorModel.storeImage,
                    width: 90,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  vendorModel.bussinessName,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Your application has been sent to shop admin. admin will get back to you',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextButton(
                    onPressed: () async {
                      await _auth.signOut();
                    },
                    child: Text('Sign out'))
              ],
            ),
          );
        },
      ),
    );
  }
}
