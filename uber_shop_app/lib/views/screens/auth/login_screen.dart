import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber_shop_app/controllers/auth_controller.dart';
import 'package:uber_shop_app/views/screens/auth/register_screen.dart';
import 'package:uber_shop_app/views/screens/map_screen.dart';

class CustomerLoginScreen extends StatefulWidget {
  @override
  State<CustomerLoginScreen> createState() => _CustomerLoginScreenState();
}

class _CustomerLoginScreenState extends State<CustomerLoginScreen> {
  final AuthController _authController = AuthController();
  State<CustomerLoginScreen> createState() => _CustomerLoginScreenState();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String email;

  late String password;
  bool _isLoading = false;

  loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      String res = await _authController.loginUser(email, password);

      setState(() {
        _isLoading = false;
      });
      if (res == 'sucess') {
        /* setState(() {
          _isLoading = false;
        });*/

        Get.to(MapScreen());

        Get.snackbar(
          'Login Success',
          'You are now logged in',
          backgroundColor: Colors.pink,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error occurred',
          res.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15), // EdgeInsets.only(top:50,left:50)
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login Account',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
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
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 20,
              ), //space between two textformfields
              //Password
              TextFormField(
                onChanged: (value) {
                  password = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Password must not be Empty';
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
              ), // to give space between login button and textformfield
              InkWell(
                onTap: () {
                  /* if (_formKey.currentState!.validate()) {
                    print('logged in');
                    print(email);
                    print(password);
                  } else {
                    print('unable to authenticate user');
                  }*/
                  loginUser();
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: Center(
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              letterSpacing: 4,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return CustomerRegisterScreen();
                      },
                    ),
                  );
                },
                child: Text(
                  'Need An Account',
                ),
              )
              /*InkWell(
                onTap: () {
                  
                },
                child: Text(
                  'Need an Account'),
                  ), to make a button*/
            ],
          ),
        ),
      ),
    );
  }
}
