// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class VendorOrdersScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String formattedDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat("dd/MM/yyyy").format(date);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final Stream<QuerySnapshot> _ordersStream = _firestore
        .collection('orders')
        .where('vendorId', isEqualTo: _auth.currentUser!.uid)
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

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No orders found.'));
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              return Slidable(
                key: ValueKey(data['orderId']),
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  dismissible: DismissiblePane(onDismissed: () {}),
                  children: [
                    SlidableAction(
                      onPressed: (context) async {
                        await _firestore
                            .collection('orders')
                            .doc(data['orderId'])
                            .update({'accepted': false});
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Reject',
                    ),
                    SlidableAction(
                      onPressed: (context) async {
                        await _firestore
                            .collection('orders')
                            .doc(data['orderId'])
                            .update({'accepted': true});
                      },
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      icon: Icons.check,
                      label: 'Accept',
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 14,
                        child: Icon(
                          data['accepted'] == true
                              ? Icons.delivery_dining
                              : Icons.access_time,
                          color: data['accepted'] == true
                              ? Colors.blue
                              : Colors.red,
                        ),
                      ),
                      title: Text(
                        data['accepted'] == true ? 'Accepted' : 'Not Accepted',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: data['accepted'] == true
                              ? Colors.blue
                              : Colors.red,
                        ),
                      ),
                      trailing: Text(
                        "\$${(data['price'] as num?)?.toStringAsFixed(2) ?? '0.00'}",
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
                            backgroundColor: Colors.white,
                            child: data['productImage'] is List &&
                                    data['productImage'].isNotEmpty
                                ? Image.network(data['productImage'][0])
                                : Icon(Icons.image_not_supported),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['productName'] ?? 'Unknown Product',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Quantity',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    (data['quantity'] ?? '0').toString(),
                                    style: TextStyle(
                                      color: Colors.pink.shade900,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          subtitle: ListTile(
                            title: Text(
                              'Buyer Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['fullName'] ?? 'Unknown Buyer',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  data['email'] ?? 'No Email Provided',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Order Date: ${formattedDate(data['orderDate'])}',
                                    style: TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
