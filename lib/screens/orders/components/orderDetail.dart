import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lotusadmin/models/order.dart';

import 'package:flutter/material.dart';
import 'package:lotusadmin/models/orderedProduct.dart';
import 'package:lotusadmin/screens/products/productDetails.dart';

import '../../../constants.dart';

class OrderDetail extends StatefulWidget {
  const OrderDetail({Key? key, required this.order}) : super(key: key);
  final Order order;

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  List<String> orderStatus = [
    "awaitingPayment",
    "awaitingDelivery",
    "completed"
  ];
  bool changeStatus = false;
  String? dropDownValue;
  @override
  void initState() {
    super.initState();
    dropDownValue = widget.order.status;
  }

  @override
  Widget build(BuildContext context) {
    var collection = FirebaseFirestore.instance.collection('orders');
    List<OrderedProduct> orderProducts =
        widget.order.products!.map((e) => OrderedProduct.fromJson(e)).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.order.id}'s order ${widget.order.orderNo}"),
        backgroundColor: secondaryColor,
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.all(defaultPadding),
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              "Order Details",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            OrderDetailsTile(
                orderDetailType: "ID", orderDetail: widget.order.id ?? ''),
            OrderDetailsTile(
                orderDetailType: "Order No of User",
                orderDetail: widget.order.orderNo.toString()),
            Card(
              color: secondaryColor,
              child: ListTile(
                title: Text(
                  "Status",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
                ),
                subtitle: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: dropDownValue,
                      dropdownColor: secondaryColor,
                      onChanged: (newvalue) {
                        setState(() {
                          dropDownValue = newvalue;
                          changeStatus = true;
                        });
                      },
                      items: orderStatus.map((String orderStatus) {
                        return DropdownMenuItem(
                          child: Text(
                            orderStatus.toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                          value: orderStatus,
                        );
                      }).toList(),
                      validator: (value) {
                        if (dropDownValue != value) {
                          return 'Choose status';
                        }
                      },
                    ),
                    Visibility(
                        visible: changeStatus,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: defaultPadding),
                            Text(
                              "Change order status?",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w200),
                            ),
                            SizedBox(height: defaultPadding),
                            Row(
                              children: [
                                ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white)),
                                    onPressed: () async {
                                      await collection
                                          .doc(
                                              "${widget.order.id}-${widget.order.orderNo}")
                                          .update({"status": dropDownValue});
                                      setState(() {
                                        changeStatus = false;
                                      });
                                    },
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(color: secondaryColor),
                                    )),
                                SizedBox(width: defaultPadding),
                                ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white)),
                                    onPressed: () {
                                      setState(() {
                                        changeStatus = false;
                                      });
                                    },
                                    child: Text(
                                      'No',
                                      style: TextStyle(color: secondaryColor),
                                    ))
                              ],
                            ),
                            SizedBox(height: defaultPadding),
                          ],
                        ))
                  ],
                ),
              ),
            ),
            Card(
              color: secondaryColor,
              child: ListTile(
                  title: Text(
                    "Products",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
                  ),
                  subtitle: ListView.builder(
                      shrinkWrap: true,
                      itemCount: orderProducts.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text("Product ${index + 1} Details",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                          subtitle: Column(children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductDetails(
                                            product:
                                                orderProducts[index].product)));
                              },
                              child: Row(
                                children: [
                                  Text("Product Name :",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w200)),
                                  SizedBox(
                                    width: defaultPadding,
                                  ),
                                  Text(
                                    orderProducts[index].product.name ?? "",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Text("Product Serial Number :",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w200)),
                                SizedBox(
                                  width: defaultPadding,
                                ),
                                Text(
                                  orderProducts[index]
                                      .product
                                      .serialNumber
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text("Sale Price :",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w200)),
                                SizedBox(
                                  width: defaultPadding,
                                ),
                                Text(
                                  orderProducts[index].salePrice.toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text("Quantity :",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w200)),
                                SizedBox(
                                  width: defaultPadding,
                                ),
                                Text(
                                  orderProducts[index].quantity.toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text("Selected Size :",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w200)),
                                SizedBox(
                                  width: defaultPadding,
                                ),
                                Text(
                                  orderProducts[index].selectedSize.toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text("Selected Colour : ",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w200)),
                                SizedBox(
                                  width: defaultPadding,
                                ),
                                Text(
                                  orderProducts[index].selectedColor ?? "",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )
                          ]),
                        );
                      })),
            ),
            OrderDetailsTile(
                orderDetailType: "Amount",
                orderDetail: "GHS" + widget.order.amount.toString()),
            OrderDetailsTile(
                orderDetailType: "Delivery Fee",
                orderDetail: widget.order.deliveryFee.toString()),
            OrderDetailsTile(
                orderDetailType: "Date",
                orderDetail: widget.order.date.toString()),
            OrderDetailsTile(
                orderDetailType: "Customer Name",
                orderDetail: widget.order.deliveryName ?? ""),
            OrderDetailsTile(
                orderDetailType: "Phone Number",
                orderDetail: widget.order.phoneNumber ?? ""),
            ListTile(
              title: Text(
                "Customer Address",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.order.userAddress!.address,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.order.userAddress!.city,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.order.userAddress!.region ?? "",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderDetailsTile extends StatelessWidget {
  const OrderDetailsTile(
      {Key? key, required this.orderDetailType, required this.orderDetail})
      : super(key: key);
  final String orderDetailType;
  final String orderDetail;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: secondaryColor,
      child: ListTile(
        title: Text(orderDetailType,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200)),
        subtitle: Text(
          orderDetail,
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
