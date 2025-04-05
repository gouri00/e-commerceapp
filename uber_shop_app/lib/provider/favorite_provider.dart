import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uber_shop_app/models/favorite_model.dart';

final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, Map<String, FavoriteModel>>((ref) {
  return FavoriteNotifier();
});

class FavoriteNotifier extends StateNotifier<Map<String, FavoriteModel>> {
  FavoriteNotifier() : super({});

  void addProducttoFavorite(
    String productName,
    String productId,
    List imageUrl,
    int quantity,
    int productQuantity,
    double price,
    String vendorId,
  ) {
    state[productId] = FavoriteModel(
      productName: productName,
      productId: productId,
      imageUrl: imageUrl,
      quantity: quantity,
      productQuantity: productQuantity,
      price: price,
      vendorId: vendorId,
    );

    state = {...state};
  }

  void removeAllItems() {
    state.clear();
//notify listeners that the state has changed
    state = {...state};
  }

  void removeItem(String productId) {
    state.remove(productId);

    state = {...state};
  }

  Map<String, FavoriteModel> get getFavoriteItem => state;
}
