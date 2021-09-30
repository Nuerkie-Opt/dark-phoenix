import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lotusadmin/providers/ordersProvider.dart';

import '../../../constants.dart';

class Chart extends StatelessWidget {
  const Chart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: pieChartSectionData,
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: defaultPadding),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Text(
                    "${Orders.orders!.length} Orders",
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20),
                  ),
                ),
                Text("GHS ${Orders.ordersAmountTotal.ceil()}")
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<PieChartSectionData> pieChartSectionData = [
  PieChartSectionData(
    color: Color(0xFF26E5FF),
    value: Orders.completeOrders!.length.toDouble(),
    showTitle: false,
    radius: 22,
  ),
  PieChartSectionData(
    color: Color(0xFFFFCF26),
    value: Orders.awaitingDeliveryOrders!.length.toDouble(),
    showTitle: false,
    radius: 19,
  ),
  PieChartSectionData(
    color: Color(0xFFEE2727),
    value: Orders.awaitingPaymentOrders!.length.toDouble(),
    showTitle: false,
    radius: 16,
  ),
];
