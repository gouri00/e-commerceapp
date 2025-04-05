import 'dart:typed_data';

import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor_app_only/vendor/controller/vendor_controller.dart';

class VendorReg extends StatefulWidget {
  const VendorReg({super.key});

  @override
  State<VendorReg> createState() => _VendorRegState();
}

class _VendorRegState extends State<VendorReg> {
  final VendorController _vendorController = VendorController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Uint8List? _image;
  late String bussinessName;
  late bool approved;
  late String vendorId;
  late String emailAddress;
  late String phone;
  late String countryValue;
  late String stateValue;
  late String cityValue;

  selecGalleryImage() async {
    Uint8List im = await _vendorController.pickStoreImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  selecCameraImage() async {
    Uint8List im = await _vendorController.pickStoreImage(ImageSource.camera);

    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          backgroundColor: Colors.pink,
          toolbarHeight: 200,
          flexibleSpace: LayoutBuilder(builder: ((context, constraints) {
            return FlexibleSpaceBar(
                background: Center(
              child: Form(
                key: _formKey,
                child: Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: _image != null
                      ? Image.memory(_image!)
                      : IconButton(
                          onPressed: () {
                            selecGalleryImage();
                          },
                          icon: Icon(
                            CupertinoIcons.photo,
                          )),
                ),
              ),
            ));
          })),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please fill Business Name';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  bussinessName = value;
                },
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: 'Business Name',
                  hintText: 'Business Name',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Email Address';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  emailAddress = value;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'Email Address',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please fill phone number';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  phone = value;
                },
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Phone Number',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SelectState(
                onCountryChanged: (value) {
                  setState(() {
                    countryValue = value;
                  });
                },
                onStateChanged: (value) {
                  setState(() {
                    stateValue = value;
                  });
                },
                onCityChanged: (value) {
                  setState(() {
                    cityValue = value;
                  });
                },
              ),
            ],
          ),
        )
      ]),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            if (_formKey.currentState!.validate()) {
              EasyLoading.show(status: 'Please wait');
              _vendorController
                  .vendorRegistrationForm(bussinessName, emailAddress, phone,
                      countryValue, stateValue, cityValue, _image)
                  .whenComplete(() {
                EasyLoading.dismiss();
              });
            } else {
              print('false');
            }
          },
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(
                  8,
                )),
            child: Center(
              child: Text(
                'Save',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 4,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
