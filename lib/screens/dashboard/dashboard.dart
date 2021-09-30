import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lotusadmin/models/order.dart';
import 'package:lotusadmin/models/user.dart';
import 'package:lotusadmin/providers/ordersProvider.dart';
import 'package:lotusadmin/responsive.dart';
import 'package:lotusadmin/screens/dashboard/components/adminItem.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'header.dart';

import 'components/recentUsers.dart';
import 'components/orderDetails.dart';

class DashboardScreen extends StatefulWidget {
  final User user;
  DashboardScreen({required this.user});
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
              title: 'Dashboard',
              user: widget.user,
            ),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      AdminItem(),
                      SizedBox(height: defaultPadding),
                      RecentFiles(),
                      if (Responsive.isMobile(context)) SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context))
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection("orders").snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) return Center(child: Text('${snapshot.error.toString()}'));
                              if (!snapshot.hasData) return Center(child: Text('Loading ...'));

                              var output = snapshot.data?.docs.map((doc) => doc.data()).toList();

                              Orders.orders = (output as List).map((e) => Order.fromMap(e)).toList();

                              Orders.completeOrders =
                                  Orders.orders!.where((element) => element.status == "completed").toList();

                              Orders.awaitingDeliveryOrders =
                                  Orders.orders!.where((element) => element.status == "awaitingDelivery").toList();

                              Orders.awaitingPaymentOrders =
                                  Orders.orders!.where((element) => element.status == "awaitingPayment").toList();

                              if (Orders.orders != null) {
                                Orders.ordersAmountTotal = 0;
                                for (var i = 0; i < Orders.orders!.length; i++) {
                                  Orders.ordersAmountTotal = Orders.ordersAmountTotal + Orders.orders![i].amount;
                                }
                              } else {
                                Orders.ordersAmountTotal = 0;
                              }
                              if (Orders.completeOrders != null) {
                                Orders.completeOrdersAmountTotal = 0;
                                for (var i = 0; i < Orders.completeOrders!.length; i++) {
                                  Orders.completeOrdersAmountTotal =
                                      Orders.completeOrdersAmountTotal + Orders.completeOrders![i].amount;
                                }
                              } else {
                                Orders.completeOrdersAmountTotal = 0;
                              }
                              if (Orders.awaitingDeliveryOrders != null) {
                                Orders.awaitingDeliveryOrdersAmountTotal = 0;
                                for (var i = 0; i < Orders.awaitingDeliveryOrders!.length; i++) {
                                  Orders.awaitingDeliveryOrdersAmountTotal = Orders.awaitingDeliveryOrdersAmountTotal +
                                      Orders.awaitingDeliveryOrders![i].amount;
                                }
                              } else {
                                Orders.awaitingDeliveryOrdersAmountTotal = 0;
                              }
                              if (Orders.awaitingPaymentOrders != null) {
                                Orders.awaitingPaymentOrdersAmountTotal = 0;
                                for (var i = 0; i < Orders.awaitingPaymentOrders!.length; i++) {
                                  Orders.awaitingPaymentOrdersAmountTotal =
                                      Orders.awaitingPaymentOrdersAmountTotal + Orders.awaitingPaymentOrders![i].amount;
                                }
                              } else {
                                Orders.awaitingPaymentOrdersAmountTotal = 0;
                              }
                              return OrderDetails();
                            }),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context)) SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we dont want to show it
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection("orders").snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) return Center(child: Text('${snapshot.error.toString()}'));
                          if (!snapshot.hasData) return Center(child: Text('Loading ...'));

                          var output = snapshot.data?.docs.map((doc) => doc.data()).toList();

                          Orders.orders = (output as List).map((e) => Order.fromMap(e)).toList();

                          Orders.completeOrders =
                              Orders.orders!.where((element) => element.status == "completed").toList();

                          Orders.awaitingDeliveryOrders =
                              Orders.orders!.where((element) => element.status == "awaitingDelivery").toList();

                          Orders.awaitingPaymentOrders =
                              Orders.orders!.where((element) => element.status == "awaitingPayment").toList();

                          if (Orders.orders != null) {
                            Orders.ordersAmountTotal = 0;
                            for (var i = 0; i < Orders.orders!.length; i++) {
                              Orders.ordersAmountTotal = Orders.ordersAmountTotal + Orders.orders![i].amount;
                            }
                          } else {
                            Orders.ordersAmountTotal = 0;
                          }
                          if (Orders.completeOrders != null) {
                            for (var i = 0; i < Orders.completeOrders!.length; i++) {
                              Orders.completeOrdersAmountTotal =
                                  Orders.completeOrdersAmountTotal + Orders.completeOrders![i].amount;
                            }
                          } else {
                            Orders.completeOrdersAmountTotal = 0;
                          }
                          if (Orders.awaitingDeliveryOrders != null) {
                            for (var i = 0; i < Orders.awaitingDeliveryOrders!.length; i++) {
                              Orders.awaitingDeliveryOrdersAmountTotal =
                                  Orders.awaitingDeliveryOrdersAmountTotal + Orders.awaitingDeliveryOrders![i].amount;
                            }
                          } else {
                            Orders.awaitingDeliveryOrdersAmountTotal = 0;
                          }
                          if (Orders.awaitingPaymentOrders != null) {
                            for (var i = 0; i < Orders.awaitingPaymentOrders!.length; i++) {
                              Orders.awaitingPaymentOrdersAmountTotal =
                                  Orders.awaitingPaymentOrdersAmountTotal + Orders.awaitingPaymentOrders![i].amount;
                            }
                          } else {
                            Orders.awaitingPaymentOrdersAmountTotal = 0;
                          }
                          return OrderDetails();
                        }),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
