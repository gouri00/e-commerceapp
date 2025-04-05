import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uber_shop_app/models/cart_models.dart';

final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, CartModel>>(
        (ref) => CartNotifier());

class CartNotifier extends StateNotifier<Map<String, CartModel>> {
  CartNotifier() : super({});

  void addProducttoCart(
    String productName,
    String productid,
    List imageUrl,
    int quantity,
    int productQuantity,
    double price,
    String vendorId,
    String productSize,
  ) {
    if (state.containsKey(productid)) {
      state = {
        ...state,
        productid: CartModel(
          productName: state[productid]!.productName,
          productid: state[productid]!.productid,
          imageUrl: state[productid]!.imageUrl,
          price: state[productid]!.price,
          vendorId: state[productid]!.vendorId,
          productQuantity: state[productid]!.productQuantity,
          productSize: state[productid]!.productSize,
          quantity: state[productid]!.quantity + 1,
        )
      };
    } else {
      state = {
        ...state,
        productid: CartModel(
            productName: productName,
            productid: productid,
            imageUrl: imageUrl,
            price: price,
            vendorId: vendorId,
            productQuantity: productQuantity,
            productSize: productSize,
            quantity: quantity)
      };
    }
  }

  void incremetItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.quantity++;

      ///notify listeners that the state has changed
      state = {...state};
    }
  }

  void decrementItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.quantity--;

      ///notify listeners that the state has changed
      state = {...state};
    }
  }

  void removeItem(String productId) {
    state.remove(productId);

    state = {...state};
  }

  void removeAllItem() {
    state.clear();
    state = {...state};
  }

  double calculateTotalAmout() {
    double totalAmount = 0.0;
    state.forEach((productId, cartItem) {
      totalAmount += cartItem.quantity * cartItem.price;
    });

    return totalAmount;
  }

  Map<String, CartModel> get getCartItems => state;
}
