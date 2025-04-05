import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  Map<String, dynamic> productData = {};

  getFormData({
    String? productName,
    double? productPrice,
    int? productQuantity,
    String? category,
    String? descriptions,
    bool? chargeShipping,
    double? shippingCharge,
    String? brandName,
    List<String>? sizeList,
    List<String>? imageUrlList,
  }) {
    if (productName != null) {
      productData['productName'] = productName;
    }
    if (productPrice != null) {
      productData['productPrice'] = productPrice;
    }
    if (productQuantity != null) {
      productData['productQuantity'] = productQuantity;
    }
    if (category != null) {
      productData['category'] = category;
    }
    if (descriptions != null) {
      productData['productName'] = descriptions;
    }
    if (shippingCharge != null) {
      productData['shippingCharge'] = shippingCharge;
    }
    if (chargeShipping != null) {
      productData['chargeShipping'] = chargeShipping;
    }
    if (brandName != null) {
      productData['brandName'] = brandName;
    }
    if (sizeList != null) {
      productData['sizeList'] = sizeList;
    }
    if (imageUrlList != null) {
      productData['imageUrlList'] = imageUrlList;
    }
    notifyListeners();
  }

  clearData() {
    productData.clear();
    notifyListeners();
  }
}
