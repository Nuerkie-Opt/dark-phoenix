import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lotusadmin/models/order.dart';
import 'package:lotusadmin/models/user.dart';
import 'package:lotusadmin/screens/dashboard/header.dart';
import 'package:lotusadmin/screens/orders/components/orderTable.dart';
import 'package:lotusadmin/providers/ordersProvider.dart';

import '../../constants.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(children: [
          Header(
            title: 'Orders',
            user: user,
          ),
          SizedBox(height: defaultPadding),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("orders").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return Center(child: Text('${snapshot.error.toString()}'));
                if (!snapshot.hasData) return Center(child: Text('Something went wrong'));

                var output = snapshot.data?.docs.map((doc) => doc.data()).toList();

                print(output);

                Orders.orders = (output as List).map((e) => Order.fromMap(e)).toList();
                print(Orders.orders);
                return Row(
                  children: [
                    Expanded(child: OrdersTable()),
                  ],
                );
              })
        ]),
      ),
    );
  }
}
