import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AuthController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ///Function to select image from gallery or camera for android
  Future<Uint8List?> pickProfileImage(ImageSource source) async {
    try {
      final ImagePicker _imagePicker = ImagePicker();

      XFile? _file = await _imagePicker.pickImage(source: source);

      if (_file != null) {
        return await _file.readAsBytes();
      } else {
        print('No Image Selected or Captured');
        return null;
      }
    } catch (e) {
      print('Error picking image; $e');
      return null;
    }
  }

  /// Function to upload image to firebase storage
  Future<String> _uploadImageToStorage(Uint8List? image) async {
    try {
      Reference ref = _storage.ref().child(_auth.currentUser!.uid);
      UploadTask uploadTask = ref.putData(image!);

      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error picking image; $e');
      rethrow;
    }
  }

  Future<String> createNewUser(
      String email, String fullName, String password, Uint8List? image) async {
    String res = 'Some error occurred';

    try {
      if (image == null) throw 'Profile image is required';
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      String downloadUrl = await _uploadImageToStorage(image);

      await _firestore.collection('buyers').doc(userCredential.user!.uid).set({
        'fullName': fullName,
        'profileImage': downloadUrl,
        'email': email,
        'buyerId': userCredential.user!.uid,
      });
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res; // Ensure a value is always returned
  }

  //Function to login the created user

  Future<String> loginUser(String email, String password) async {
    String res = 'some error occured';

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res = 'success';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }
}
