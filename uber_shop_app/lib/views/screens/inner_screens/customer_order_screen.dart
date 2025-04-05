// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class CustomerOrderScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  double rating = 0.0;
  final TextEditingController _reviewController = TextEditingController();

  String formattedDate(Timestamp timestamp) {
    final DateFormat outputDateFormat = DateFormat("dd/MM/yyyy");
    return outputDateFormat.format(timestamp.toDate());
  }

  Future<bool> hasUserReviewedProduct(String productId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('productReviews')
        .where('buyerId', isEqualTo: _auth.currentUser!.uid)
        .where('productId', isEqualTo: productId)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> updateProductRating(String productId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('productReviews')
        .where('productId', isEqualTo: productId)
        .get();

    double totalRating = 0;
    int totalReviews = querySnapshot.docs.length;

    for (final doc in querySnapshot.docs) {
      totalRating += doc['rating'];
    }

    final double averageRating =
        totalReviews > 0 ? totalRating / totalReviews : 0;

    // Ensure you're updating the correct 'products' collection
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .update({
      'rating': averageRating,
      'totalReviews': totalReviews,
    });
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where('buyerId', isEqualTo: _auth.currentUser!.uid)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ordersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 14,
                      child: Icon(
                        data['accepted'] == true
                            ? Icons.delivery_dining
                            : Icons.access_time,
                      ),
                    ),
                    title: Text(
                      data['accepted'] == true ? 'Accepted' : 'Not Accepted',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                            data['accepted'] == true ? Colors.blue : Colors.red,
                      ),
                    ),
                    trailing: Text(
                      "\$${data['price'].toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  ExpansionTile(
                    title: Text('Order Details'),
                    subtitle: Text('View Order Details'),
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(data['productImage'][0]),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['productName'],
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text("Quantity: ${data['quantity']}"),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Buyer Details',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              data['fullName'],
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              data['email'],
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Order Date: ${formattedDate(data['orderDate'])}',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            data['accepted'] == true
                                ? ElevatedButton(
                                    onPressed: () async {
                                      final productId = data['productId'];
                                      final hasReviewed =
                                          await hasUserReviewedProduct(
                                              productId);

                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(hasReviewed
                                                ? 'Update Review'
                                                : 'Leave a Review'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextFormField(
                                                  controller: _reviewController,
                                                  decoration: InputDecoration(
                                                    labelText: 'Your Review',
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: RatingBar.builder(
                                                    initialRating: rating,
                                                    itemCount: 5,
                                                    minRating: 1,
                                                    allowHalfRating: true,
                                                    itemSize: 25,
                                                    unratedColor: Colors.grey,
                                                    itemPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 4),
                                                    itemBuilder: (context, _) =>
                                                        Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    onRatingUpdate: (value) {
                                                      rating = value;
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () async {
                                                  final review =
                                                      _reviewController.text;
                                                  final reviewData = {
                                                    'productId': productId,
                                                    'fullName':
                                                        data['fullName'],
                                                    'buyerId': data['buyerId'],
                                                    'rating': rating,
                                                    'review': review,
                                                    'email': data['email'],
                                                    'profilePhoto':
                                                        data['profileImages'],
                                                  };

                                                  if (hasReviewed) {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'productReviews')
                                                        .doc(data['orderId'])
                                                        .update(reviewData);
                                                  } else {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'productReviews')
                                                        .doc(data['orderId'])
                                                        .set(reviewData);
                                                  }

                                                  await updateProductRating(
                                                      productId);
                                                  Navigator.pop(context);
                                                  _reviewController.clear();
                                                },
                                                child: Text('Submit'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text('Review'),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
