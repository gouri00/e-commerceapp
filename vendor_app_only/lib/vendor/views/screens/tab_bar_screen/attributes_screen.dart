import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app_only/vendor/provider/product_provider.dart';

class AttributesScreen extends StatefulWidget {
  const AttributesScreen({super.key});

  @override
  State<AttributesScreen> createState() => _AttributesScreenState();
}

class _AttributesScreenState extends State<AttributesScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final TextEditingController _sizeController = TextEditingController();
  bool _isEntered = false;

  bool _isSaved = false;

  final List<String> _sizeList = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter Product Brand';
              } else {
                return null;
              }
            },
            onChanged: (value) {
              productProvider.getFormData(brandName: value);
            },
            decoration: InputDecoration(
              labelText: 'Brand',
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Flexible(
                child: TextFormField(
                  controller: _sizeController,
                  onChanged: (value) {
                    setState(() {
                      _isEntered = value.isNotEmpty;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Size'),
                ),
              ),
              SizedBox(width: 10),
              _isEntered
                  ? ElevatedButton(
                      onPressed: () {
                        if (_sizeController.text.isNotEmpty) {
                          setState(() {
                            _sizeList.add(_sizeController.text);
                            _sizeController.clear();
                            _isEntered = false;
                          });
                        }
                      },
                      child: Text('Add Size'),
                    )
                  : SizedBox(),
            ],
          ),
          SizedBox(height: 10),
          if (_sizeList.isNotEmpty)
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _sizeList
                  .asMap()
                  .entries
                  .map(
                    (entry) => InkWell(
                      onTap: () {
                        setState(() {
                          _sizeList.removeAt(entry.key);
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          entry.value,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          if (_sizeList.isNotEmpty) SizedBox(height: 10),
          if (_sizeList.isNotEmpty)
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isSaved = true;
                  });
                  productProvider.getFormData(sizeList: _sizeList);
                },
                child: _isSaved ? Text('Saved') : Text('Save')),
        ],
      ),
    );
  }
}
