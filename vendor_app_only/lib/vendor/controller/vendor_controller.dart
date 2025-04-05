import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class VendorController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //Function to pick image from gallery or capture from camera

  pickStoreImage(ImageSource source) async {
    final ImagePicker pickImage = ImagePicker();

    XFile? file = await pickImage.pickImage(source: source);

    if (file != null) {
      return await file.readAsBytes();
    } else {
      print('No image');
    }
  }

  ///FUNCTION TO UPLOAD VENDOR STORE IMAGE TO STORAGE
  _uploadVendorStoreImage(Uint8List? image) async {
    Reference ref =
        _storage.ref().child('storeImage').child(_auth.currentUser!.uid);

    UploadTask uploadTask = ref.putData(image!);

    TaskSnapshot snapshot = await uploadTask;

    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  Future<String> vendorRegistrationForm(
      String bussinnesName,
      String emailAddress,
      String phone,
      String countryValue,
      String stateValue,
      String cityValue,
      Uint8List? image) async {
    String res = 'Something went wrong';

    try {
      String downloadUrl = await _uploadVendorStoreImage(image);
      await _firestore.collection('vendors').doc(_auth.currentUser!.uid).set({
        'bussinessName': bussinnesName,
        'storeImage': downloadUrl,
        'emailAddress': emailAddress,
        'countryValue': countryValue,
        'stateValue': stateValue,
        'cityValue': cityValue,
        'vendorId': _auth.currentUser!.uid,
        'approved': false,
      });

      res = 'sucess';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
