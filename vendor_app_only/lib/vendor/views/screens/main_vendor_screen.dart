import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app_only/vendor/views/screens/earnings_screen.dart';
import 'package:vendor_app_only/vendor/views/screens/edi_screen.dart';
import 'package:vendor_app_only/vendor/views/screens/log_out_screen.dart';
import 'package:vendor_app_only/vendor/views/screens/upload_screen.dart';
import 'package:vendor_app_only/vendor/views/screens/vendor_orders_screen.dart';
import 'package:vendor_app_only/vendor/views/screens/vandor_message_screen.dart'; // Importing VendorMessageScreen

class MainVendorScreen extends StatefulWidget {
  const MainVendorScreen({super.key});

  @override
  State<MainVendorScreen> createState() => _MainVendorScreenState();
}

class _MainVendorScreenState extends State<MainVendorScreen> {
  int _pageIndex = 0;

  List<Widget> pages = [
    EarningsScreen(),
    UploadScreen(),
    VendorOrdersScreen(),
    VendorMessageScreen(), // Now imported from a separate file
    EdiScreen(),
    LogOutScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _pageIndex,
          onTap: (value) {
            setState(() {
              _pageIndex = value;
            });
          },
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.pink,
          items: [
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.money_dollar), label: 'Earnings'),
            BottomNavigationBarItem(icon: Icon(Icons.upload), label: 'Upload'),
            BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Orders'),
            BottomNavigationBarItem(
                icon: Icon(Icons.message), label: 'Messages'),
            BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Edit'),
            BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
          ]),
      body: pages[_pageIndex],
    );
  }
}
