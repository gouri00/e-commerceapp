import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber_shop_app/controllers/auth_controller.dart';
import 'package:uber_shop_app/views/screens/auth/login_screen.dart';
import 'package:image_picker/image_picker.dart';

class CustomerRegisterScreen extends StatefulWidget {
  @override
  State<CustomerRegisterScreen> createState() => _CustomerRegisterScreenState();
}

class _CustomerRegisterScreenState extends State<CustomerRegisterScreen> {
  final AuthController _authController = AuthController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  late String email;

  late String fullName;

  late String password;

  Uint8List? _image;

  selectGalleryImage() async {
    Uint8List? im = await _authController.pickProfileImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  captureImage() async {
    await _authController.pickProfileImage(ImageSource.camera);
  }

  registerUser() async {
    if (_image != null) {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        String res = await _authController.createNewUser(
            email, fullName, password, _image);

        setState(() {
          _isLoading = false;
        });

        if (res == 'sucess') {
          /*Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LoginScreen();
          }));*/
          /*setState(() {
            _isLoading = false;
          });*/
          Get.to(CustomerLoginScreen());
          Get.snackbar(
            'Success',
            'Account has been created for you',
            backgroundColor: Colors.pink,
            colorText: Colors.white,
            margin: EdgeInsets.all(
              15,
            ),
            icon: Icon(
              Icons.message,
              color: Colors.white,
            ),
          );
        } else {
          Get.snackbar('Error occured', res,
              //Get.snackbar('Error occured', res.toString(),
              backgroundColor: Colors.red,
              colorText: Colors.white,
              margin: EdgeInsets.all(
                15,
              ),
              icon: Icon(
                Icons.message,
                color: Colors.white,
              ),
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.snackbar(
          'Form',
          'Form filled is not valid',
          backgroundColor: Colors.pink,
          colorText: Colors.white,
          margin: EdgeInsets.all(
            15,
          ),
          icon: Icon(
            Icons.message,
            color: Colors.white,
          ),
        );
      }
    } else {
      Get.snackbar(
        'No image',
        'Please Capture or select an image',
        backgroundColor: Colors.pink,
        colorText: Colors.white,
        margin: EdgeInsets.all(
          15,
        ),
        snackPosition: SnackPosition.BOTTOM,
        icon: Icon(
          Icons.message,
          color: Colors.white,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Register Account',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),

                  SizedBox(
                    height: 15,
                  ),
                  Stack(
                    children: [
                      _image == null
                          ? CircleAvatar(
                              radius: 65,
                              child: Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.white,
                              ),
                            )
                          : CircleAvatar(
                              radius: 65,
                              backgroundImage: MemoryImage(_image!),
                            ),
                      Positioned(
                          right: 0,
                          top: 15,
                          child: IconButton(
                              onPressed: () {
                                selectGalleryImage();
                              },
                              icon: Icon(CupertinoIcons.photo))),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //Email
                  TextFormField(
                    onChanged: (value) {
                      email = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Email Address must not be Empty';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'Enter Email Address',
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.pink,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //FullName
                  TextFormField(
                    onChanged: (value) {
                      fullName = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Full Name Must Not be Empty';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Full Name',
                        hintText: 'Enter Fullname',
                        //if it is hintextthen the text will be permanently shown down while in hunttext the text
                        //will be only be shown when we click on the respective box
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.pink,
                        ),
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //Password
                  TextFormField(
                    onChanged: (value) {
                      password = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Password Must Not be Empty';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter Password',
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.pink,
                        ),
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      /* if (_formKey.currentState!.validate()) {
                      _authController.createNewUser(email,fullName, password)
                   print('success');
                  } else {
                    print('not valid');
                  }*/
                      CustomerLoginScreen();
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                      ),
                      child: Center(
                        child: _isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 4,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CustomerLoginScreen();
                          },
                        ),
                      );
                    },
                    child: Text(
                      'Already Have An Account ?',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
