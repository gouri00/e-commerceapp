import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app_only/vendor/provider/product_provider.dart';

class GeneralScreen extends StatefulWidget {
  const GeneralScreen({super.key});

  @override
  State<GeneralScreen> createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late String productName;
  late double productPrice;
  late int productQuantity;

  final List<String> _categoriesList = [];

  _getCategories() {
    return firestore
        .collection('categories')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _categoriesList.add(doc['categoryName']);
        });
      }
    });
  }

  @override
  void initState() {
    _getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Product Name';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  productProvider.getFormData(productName: value);
                },
                decoration: InputDecoration(
                    labelText: 'Enter Product name',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    )),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Product Price';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  productProvider.getFormData(
                      productPrice: double.parse(value));
                },
                decoration: InputDecoration(
                  labelText: 'Enter Product price',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Product Quantity';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  productProvider.getFormData(
                      productQuantity: int.parse(value));
                },
                decoration: InputDecoration(
                  hintText: 'Enter Product quantity',
                  labelText: 'Enter Product quantity',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              DropdownButtonFormField(
                  hint: Text(
                    'Select category',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  items: _categoriesList.map<DropdownMenuItem<dynamic>>((e) {
                    return DropdownMenuItem(value: e, child: Text(e));
                  }).toList(),
                  onChanged: (value) {
                    productProvider.getFormData(category: value);
                  }),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Product Description';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  productProvider.getFormData(descriptions: value);
                },
                maxLines: 10,
                minLines: 3,
                maxLength: 800,
                decoration: InputDecoration(
                  hintText: 'Enter Product description',
                  labelText: 'Enter Product description',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
