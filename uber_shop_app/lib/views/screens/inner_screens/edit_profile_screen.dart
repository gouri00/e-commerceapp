import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController(); // For reauthentication

  @override
  void initState() {
    super.initState();
    _populateController();
  }

  /// **Fetch user email and full name, then populate text fields**
  void _populateController() async {
    User? user = _auth.currentUser;
    if (user != null) {
      _emailController.text = user.email ?? "";
      _fullNameController.text = await getUserFullName() ?? "";
    }
  }

  /// **Fetch user's full name from Firestore**
  Future<String?> getUserFullName() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('buyers')
            .doc(user.uid)
            .get();
        return userDoc['fullName'] as String?;
      } catch (e) {
        print('Error fetching user full name: $e');
        return null;
      }
    }
    return null;
  }

  /// **Reauthenticate User Before Updating Email**
  Future<bool> _reauthenticateUser(String password) async {
    try {
      User? user = _auth.currentUser;
      if (user != null && user.email != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
        return true;
      }
    } catch (e) {
      print("Reauthentication failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Reauthentication failed. Please try again.")),
      );
    }
    return false;
  }

  /// **Update Profile After Reauthentication**
  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Ask the user to re-enter their password for reauthentication
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Reauthenticate to Update Email"),
            content: TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Enter your password"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  bool isReauthenticated =
                      await _reauthenticateUser(_passwordController.text);
                  if (isReauthenticated) {
                    await _proceedWithProfileUpdate(user);
                  }
                },
                child: Text("Confirm"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  /// **Proceed with Updating Email & Firestore**
  Future<void> _proceedWithProfileUpdate(User user) async {
    try {
      // **Update Email After Reauthentication**
      await user.verifyBeforeUpdateEmail(_emailController.text);

      // **Update Firestore Document**
      await FirebaseFirestore.instance
          .collection('buyers')
          .doc(user.uid)
          .update({
        'email': _emailController.text,
        'fullName': _fullNameController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Edit Your Profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 20),

                // **Email Input Field**
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email cannot be empty';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // **Full Name Input Field**
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Full name cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // **Update Profile Button**
                InkWell(
                  onTap: _updateProfile,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Update Profile',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
