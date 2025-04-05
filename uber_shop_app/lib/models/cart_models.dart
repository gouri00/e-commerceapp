class CartModel {
  final String productName;
  final String productid;
  final List imageUrl;

  int quantity;

  int productQuantity;

  final double price;

  final String vendorId;
  final String productSize;

  CartModel({
    required this.productName,
    required this.productid,
    required this.imageUrl,
    required this.price,
    required this.vendorId,
    required this.productQuantity,
    required this.productSize,
    required this.quantity,
  });
}
