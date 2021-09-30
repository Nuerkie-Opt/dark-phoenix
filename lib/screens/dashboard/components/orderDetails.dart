import 'package:flutter/material.dart';
import 'package:lotusadmin/providers/ordersProvider.dart';

import '../../../constants.dart';
import 'chart.dart';
import 'ordersCard.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Orders",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          Chart(),
          OrderInfoCard(
            svgSrc: "assets/icons/Documents.svg",
            title: "Total Orders",
            amountOfOrders: Orders.ordersAmountTotal,
            numOfOrders: Orders.orders!.length,
          ),
          OrderInfoCard(
              svgSrc: "assets/icons/media.svg",
              title: "Completed",
              amountOfOrders: Orders.completeOrdersAmountTotal,
              numOfOrders: Orders.completeOrders!.length),
          OrderInfoCard(
            svgSrc: "assets/icons/folder.svg",
            title: "Awaiting Delivery",
            amountOfOrders: Orders.awaitingDeliveryOrdersAmountTotal,
            numOfOrders: Orders.awaitingDeliveryOrders!.length,
          ),
          OrderInfoCard(
            svgSrc: "assets/icons/unknown.svg",
            title: "Awaiting Payment",
            amountOfOrders: Orders.awaitingPaymentOrdersAmountTotal,
            numOfOrders: Orders.awaitingPaymentOrders!.length,
          ),
        ],
      ),
    );
  }
}
