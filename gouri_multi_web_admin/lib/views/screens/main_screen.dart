import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:gouri_multi_web_admin/views/screens/side_bar_screen/categories_screen.dart';
import 'package:gouri_multi_web_admin/views/screens/side_bar_screen/dashboard.dart';
import 'package:gouri_multi_web_admin/views/screens/side_bar_screen/orders_screen.dart';
import 'package:gouri_multi_web_admin/views/screens/side_bar_screen/product.dart';
import 'package:gouri_multi_web_admin/views/screens/side_bar_screen/upload_screen.dart';
import 'package:gouri_multi_web_admin/views/screens/side_bar_screen/withdrawal_screen.dart';

import 'side_bar_screen/vendors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _selectedItem = Dashboard();

  screenSelector(item) {
    switch (item.route) {
      case Dashboard.routeName:
        setState(() {
          _selectedItem = Dashboard();
        });
        break;

      case Vendors.routeName:
        setState(() {
          _selectedItem = Vendors();
        });
        break;

      case Products.routeName:
        setState(() {
          _selectedItem = Products();
        });
        break;
      case OrdersScreen.routeName:
        setState(() {
          _selectedItem = OrdersScreen();
        });
        break;
      case WithdrawalScreen.routeName:
        setState(() {
          _selectedItem = WithdrawalScreen();
        });
        break;
      case UploadScreen.routeName:
        setState(() {
          _selectedItem = UploadScreen();
        });
        break;
      case CategoriesScreen.routeName:
        setState(() {
          _selectedItem = CategoriesScreen();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.yellow.shade900,
          title: Text('Management'),
        ),
        sideBar: SideBar(
          items: [
            AdminMenuItem(
              title: 'Dashboard',
              icon: Icons.dashboard,
              route: Dashboard.routeName,
            ),
            AdminMenuItem(
              title: 'Vendors',
              icon: CupertinoIcons.person_3,
              route: Vendors.routeName,
            ),
            AdminMenuItem(
              title: 'Withdrawal',
              icon: CupertinoIcons.money_dollar,
              route: WithdrawalScreen.routeName,
            ),
            AdminMenuItem(
              title: 'Orders',
              icon: CupertinoIcons.shopping_cart,
              route: OrdersScreen.routeName,
            ),
            AdminMenuItem(
              title: 'Categories',
              icon: Icons.category,
              route: CategoriesScreen.routeName,
            ),
            AdminMenuItem(
              title: 'Products',
              icon: Icons.shop,
              route: Products.routeName,
            ),
            AdminMenuItem(
              title: 'Upload',
              icon: CupertinoIcons.add,
              route: UploadScreen.routeName,
            ),
          ],
          selectedRoute: '',
          onSelected: (item) {
            screenSelector(item);
          },
          header: Container(
            height: 50,
            width: double.infinity,
            color: const Color(0xff444444),
            child: const Center(
              child: Text(
                'Vendor Store Panel',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        /* footer : Container( footer not supported in this flutter admin scaffold version
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'footer',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),   
        bottomnavigationBar is also not supported
        other alternative is column inside body as shown below
        AdminScaffold(
  body: Column(
    children: [
      Expanded(child: SomeWidget()),  // Main content
      Container(  // Footer added inside the body
        color: Colors.grey,
        height: 50,
        child: Center(child: Text("Footer Text")),
      ),
    ],
  ),
);

            */
        body: _selectedItem);
  }
}
