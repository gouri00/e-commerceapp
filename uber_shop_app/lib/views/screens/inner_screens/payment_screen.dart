import 'package:flutter/material.dart';
import 'package:uber_shop_app/views/screens/inner_screens/checkout_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isPayOnDelivery = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment Options',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            letterSpacing: 4,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w300,
                color: Colors.black87,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pay on Delivery',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Switch(
                    value: _isPayOnDelivery,
                    onChanged: (value) {
                      setState(() {
                        _isPayOnDelivery = value;
                      });

                      if (_isPayOnDelivery) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CheckoutScreen();
                        }));
                      }
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
