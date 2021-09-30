import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lotusadmin/models/order.dart';
import 'package:lotusadmin/models/orderedProduct.dart';
import 'package:lotusadmin/models/product.dart';

import '../constants.dart';

class Profit {
  num costPrice;
  num salePrice;
  int profit;
  Profit({required this.costPrice, required this.salePrice, required this.profit});
}

class ProfitMade extends StatefulWidget {
  final DateTimeRange dateTimeRange;

  ProfitMade({Key? key, required this.dateTimeRange}) : super(key: key);

  @override
  _ProfitMadeState createState() => _ProfitMadeState();
}

class _ProfitMadeState extends State<ProfitMade> {
  var collection = FirebaseFirestore.instance.collection('orders');
  Profit? profitDetails;
  List<Order> orders = [];
  getProfitfromFirebase() async {
    num costPrice = 0;
    num salesPrice = 0;

    QuerySnapshot<Map<String, dynamic>> snapshot = await collection
        .where('date', isGreaterThanOrEqualTo: widget.dateTimeRange.start)
        .where("date", isLessThanOrEqualTo: widget.dateTimeRange.end)
        .get();
    List<QueryDocumentSnapshot> docs = snapshot.docs;
    var output = docs.map((e) => e.data()).toList();
    orders = (output as List).map((e) => Order.fromMap(e)).toList();

    for (var i = 0; i < orders.length; i++) {
      List<OrderedProduct> products = [];
      salesPrice = salesPrice + orders[i].amount - 10;

      for (var j = 0; j < orders[i].products!.length; j++) {
        products.add(OrderedProduct.fromJson(orders[i].products![j]));
      }
      if (products.isNotEmpty)
        for (var x = 0; x < products.length; x++) {
          costPrice = costPrice + products[x].product.costPrice;
        }
    }
    profitDetails = Profit(costPrice: costPrice, salePrice: salesPrice, profit: (salesPrice - costPrice).toInt());
    return profitDetails;
  }

  @override
  void initState() {
    getProfitfromFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: FutureBuilder(
            future: getProfitfromFirebase(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              if (snapshot.hasData) {
                return Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width * 0.3,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Container(
                        decoration: const BoxDecoration(
                          color: secondaryColor,
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Text("Sales"),
                            ListTile(
                              title: Text('Total Sales : '),
                              trailing: Text('${profitDetails!.salePrice}'),
                            ),
                            ListTile(
                              title: Text('Total Cost : '),
                              trailing: Text('${profitDetails!.costPrice}'),
                            ),
                            ListTile(
                              title: Text('Total Orders : '),
                              trailing: Text('${orders.length}'),
                            ),
                            ListTile(
                              title: Text('Profit : '),
                              trailing: Text('${profitDetails!.profit}'),
                            )
                          ],
                        )));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}

class ChartRenderer extends StatefulWidget {
  final List<FlSpot> chartData;
  final DateTimeRange dateTimeRange;
  final String formatString;
  ChartRenderer({Key? key, required this.chartData, required this.dateTimeRange, required this.formatString})
      : super(key: key);

  @override
  _ChartRendererState createState() => _ChartRendererState();
}

class _ChartRendererState extends State<ChartRenderer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          height: 1000,
          decoration: const BoxDecoration(
            color: secondaryColor,
          ),
          child: LineChart(
            mainData(widget.chartData),
            swapAnimationDuration: Duration(milliseconds: 2000),
          ),
        ));
  }

  LineChartData mainData(var data) {
    final List<Color> color = <Color>[];
    color.add(Colors.white60);
    color.add(Colors.white70);
    color.add(Colors.white);

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.5);
    stops.add(1.0);
    double _maxX = widget.dateTimeRange.end.millisecondsSinceEpoch.toDouble();
    double _minX = widget.dateTimeRange.start.millisecondsSinceEpoch.toDouble();

    //final LinearGradient gradientColors = LinearGradient(colors: color, stops: stops);
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.white54,
            strokeWidth: 1,
          );
        },
      ),
      lineTouchData: LineTouchData(
          enabled: true,
          getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
            return spotIndexes.map((spotIndex) {
              return TouchedSpotIndicatorData(
                  FlLine(color: Colors.white, strokeWidth: 1, dashArray: [3, 2]), FlDotData(show: false));
            }).toList();
          },
          touchTooltipData: LineTouchTooltipData(showOnTopOfTheChartBoxArea: true, fitInsideVertically: true)),
      minY: 0.0,
      maxY: widget.chartData.last.y + 5,
      minX: _minX,
      maxX: _maxX,
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
            final DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
            return DateFormat('Hm').format(date);
          },
          margin: 8,
          interval: (_maxX - _minX) / 6,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(show: true, border: Border.all(color: Colors.white)),
      lineBarsData: [
        LineChartBarData(
          show: true,
          spots: widget.chartData, //actualData(data),
          isCurved: true,
          colors: color,
          colorStops: stops,
          barWidth: 2,
          isStrokeCapRound: false,
          dotData: FlDotData(
            show: false,
          ),

          belowBarData: BarAreaData(
            show: true,
          ),
        )
      ],
    );
  }
}
