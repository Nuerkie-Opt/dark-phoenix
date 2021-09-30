import 'package:lotusadmin/models/order.dart';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:lotusadmin/providers/ordersProvider.dart';
import 'package:lotusadmin/screens/orders/components/orderDetail.dart';

import '../../../constants.dart';

class OrdersTable extends StatelessWidget {
  const OrdersTable({
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
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable2(
              columnSpacing: defaultPadding,
              minWidth: 600,
              columns: [
                DataColumn(
                  label: Text("User ID"),
                ),
                DataColumn(
                  label: Text("Status"),
                ),
                DataColumn(
                  label: Text("Amount"),
                ),
                DataColumn(
                  label: Text("Date"),
                ),
              ],
              rows: List.generate(
                Orders.orders!.length,
                (index) => orderDataRow(Orders.orders![index], context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow orderDataRow(Order order, BuildContext context) {
  return DataRow2(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetail(order: order)));
    },
    cells: [
      DataCell(
        Text(order.id ?? ''),
      ),
      DataCell(Text(order.status ?? '')),
      DataCell(Text('GHS ${order.amount}')),
      DataCell(Text('${order.date}')),
    ],
  );
}
