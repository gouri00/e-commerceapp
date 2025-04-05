import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uber_shop_app/provider/favorite_provider.dart';
import 'package:uber_shop_app/views/screens/inner_screens/product_detail_screen.dart';

class ProductModel extends ConsumerStatefulWidget {
  const ProductModel({
    super.key,
    required this.productData,
  });

  final QueryDocumentSnapshot<Object?> productData;

  @override
  _ProductModelState createState() => _ProductModelState();
}

class _ProductModelState extends ConsumerState<ProductModel> {
  @override
  Widget build(BuildContext context) {
    final _favoriteProvider = ref.read(favoriteProvider.notifier);
    ref.watch(favoriteProvider);

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetailScreen(
            productData: widget.productData,
          );
        }));
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 90,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                color: Color(0xffffffff),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xf000000),
                    // ❌ ERROR: Invalid color format.
                    // ✅ FIX: Use `Color(0xFF000000).withOpacity(0.1)`
                  ),
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.productData['productImages'][0],
                        // ❌ ERROR: If `productImages` is null or empty, app will crash.
                        // ✅ FIX: Use:
                        // widget.productData['productImages']?.isNotEmpty == true
                        //    ? widget.productData['productImages'][0]
                        //    : 'default_image_url'
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        widget.productData['productName'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                          color: Color(0xff000000),
                        ),
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "\$" +
                            " " +
                            widget.productData['productPrice']
                                .toStringAsFixed(2),
                        // ❌ ERROR: Unnecessary string concatenation.
                        // ✅ FIX: Use "\$ ${widget.productData['productPrice'].toStringAsFixed(2)}"
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                      widget.productData['rating'] == 0
                          ? SizedBox()
                          : Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 14,
                                ),
                                Text(
                                  widget.productData['rating'].toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                    ],
                  ))
                ],
              ),
            ),
          ),
          Positioned(
            right: 15,
            top: 15,
            child: IconButton(
              onPressed: () {
                _favoriteProvider.addProducttoFavorite(
                  widget.productData['productName'],
                  widget.productData['productId'],
                  widget.productData['productImages'],
                  1,
                  widget.productData['productQuantity'],
                  widget.productData['productPrice'],
                  widget.productData['vendorId'],
                );
              },
              icon: _favoriteProvider.getFavoriteItem
                      .containsKey(widget.productData['productId'])
                  ? Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
