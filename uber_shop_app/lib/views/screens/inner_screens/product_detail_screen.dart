import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:uber_shop_app/provider/cart_provider.dart';
import 'package:uber_shop_app/provider/selected_size_provider.dart';
import 'package:uber_shop_app/views/screens/inner_screens/chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final dynamic productData;

  const ProductDetailScreen({super.key, required this.productData});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _imageIndex = 0;
  int _selectedVariation = -1; // Stores the selected variation index

  void callVendor(String phoneNumber) async {
    final String url = "tel:$phoneNumber";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw ('Could not launch phone call');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productReviewsStream = FirebaseFirestore
        .instance
        .collection('productReviews')
        .where('productId', isEqualTo: widget.productData['productId'])
        .snapshots();
    final _cartProvider = ref.read(cartProvider.notifier);
    final cartItem = ref.watch(cartProvider);
    final selectedSize = ref.watch(selectedSizeProvider);
    final isInCart = cartItem.containsKey(widget.productData['productId']);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.productData['productName'],
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      widget.productData['productImages'][_imageIndex],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.productData['productImages'].length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _imageIndex = index;
                              });
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.pink.shade900,
                                ),
                              ),
                              child: Image.network(
                                widget.productData['productImages'][index],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productData['productName'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '\$${(widget.productData['productPrice'] as num).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink.shade900,
                    ),
                  ),
                  widget.productData['rating'] == 0
                      ? Text('')
                      : Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              Text(
                                widget.productData['rating'].toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              Text(
                                "${widget.productData['totalReviews']}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                  const SizedBox(height: 10),
                  ExpansionTile(
                    title: const Text('Product Description'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.productData['description'],
                          style: const TextStyle(
                            fontSize: 16,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ExpansionTile(
                    title: const Text(
                      'Variation Available',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    initiallyExpanded: true,
                    children: [
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.productData['sizeList'].length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedVariation = index;
                                  });
                                  ref
                                      .read(selectedSizeProvider.notifier)
                                      .setSelectedSize(widget
                                          .productData['sizeList'][index]);
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: _selectedVariation == index
                                      ? Colors.pink.shade900
                                      : Colors.white,
                                  side: BorderSide(
                                      color: Colors.pink.shade900, width: 2),
                                ),
                                child: Text(
                                  widget.productData['sizeList'][index],
                                  style: TextStyle(
                                    color: _selectedVariation == index
                                        ? Colors.white
                                        : Colors.pink.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        widget.productData['storeImage'],
                      ),
                    ),
                    title: Text(
                      widget.productData['businessName'],
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      'SEE PROFILE',
                      style: TextStyle(
                        color: Colors.pink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            RatingSummary(
              counter: widget.productData['totalReviews'],
              average: widget.productData['rating'],
              showAverage: true,
              counterFiveStars: 5,
              counterFourStars: 4,
              counterThreeStars: 2,
              counterTwoStars: 1,
              counterOneStars: 1,
            ),
            SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _productReviewsStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text("Loading Reviews"));
                }

                return SizedBox(
                  height: 50,
                  child: ListView.builder(
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, index) {
                        final reviewData = snapshot.data!.docs[index];
                        Card(
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  reviewData['buyerPhoto'],
                                ),
                              ),
                              Text(
                                reviewData['fullName'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                reviewData['review'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                );
              },
            ),
            SizedBox(
              height: 80,
            )
          ],
        ),
      ),
      bottomSheet: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: isInCart
                    ? null
                    : () {
                        if (_selectedVariation == -1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select a variation first."),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        _cartProvider.addProducttoCart(
                          widget.productData['productName'],
                          widget.productData['productId'],
                          widget.productData['productImages'],
                          1,
                          widget.productData['productQuantity'],
                          widget.productData['productPrice'],
                          widget.productData['vendorId'],
                          selectedSize,
                        );

                        if (_cartProvider.getCartItems.isNotEmpty) {
                          print(_cartProvider
                              .getCartItems.values.first.productName);
                        }
                      },
                child: Container(
                  decoration: BoxDecoration(
                    color: isInCart ? Colors.grey : Colors.pink.shade900,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(
                          CupertinoIcons.shopping_cart,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          isInCart ? "IN CART" : 'ADD TO CART',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            letterSpacing: 2,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChatScreen(
                      sellerId: widget.productData['vendorId'],
                      buyerId: FirebaseAuth.instance.currentUser!.uid,
                      productId: widget.productData['productId'],
                      productName: widget.productData['productName'],
                    );
                  }));
                },
                icon: Icon(CupertinoIcons.chat_bubble, color: Colors.pink),
              ),
              IconButton(
                onPressed: () {
                  callVendor(widget.productData['phoneNumber']);
                },
                icon: Icon(CupertinoIcons.phone, color: Colors.pink),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
