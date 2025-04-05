import 'package:flutter/material.dart';
import 'package:uber_shop_app/views/screens/widgets/banner_widget.dart';
import 'package:uber_shop_app/views/screens/widgets/category_text_widget.dart';
import 'package:uber_shop_app/views/screens/widgets/home_products.dart';
import 'package:uber_shop_app/views/screens/widgets/location_widget.dart';
import 'package:uber_shop_app/views/screens/widgets/mens_product_widget.dart';
import 'package:uber_shop_app/views/screens/widgets/reuseText.dart';
import 'package:uber_shop_app/views/screens/widgets/women_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocationWidget(),
          SizedBox(
            height: 10,
          ),
          BannerWidget(),
          SizedBox(
            height: 10,
          ),
          CategoryItemWidget(),
          SizedBox(
            height: 10,
          ),
          HomeProducts(),
          SizedBox(
            height: 10,
          ),
          Reusetext(
            title: "Men's Product",
          ),
          SizedBox(
            height: 10,
          ),
          MensProductWidget(),
          SizedBox(
            height: 10,
          ),
          WomenWidget(),
        ],
      ),
    );
  }
}
