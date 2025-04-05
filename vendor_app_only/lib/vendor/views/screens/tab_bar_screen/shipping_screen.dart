import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app_only/vendor/provider/product_provider.dart';

class ShippingScreen extends StatefulWidget {
  const ShippingScreen({super.key});

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool _chargeshipping = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context);
    return Column(
      children: [
        CheckboxListTile(
          title: Text('Charge Shipping'),
          value: _chargeshipping,
          onChanged: (value) {
            setState(() {
              _chargeshipping = value ?? false;
            });
            productProvider.getFormData(chargeShipping: _chargeshipping);
          },
        ),
        if (_chargeshipping == true)
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Shipping charge';
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                productProvider.getFormData(
                    shippingCharge: double.parse(value));
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Shipping Charge Fee',
                hintText: 'Enter Shipping Charge',
              ),
            ),
          ),
      ],
    );
  }
}
