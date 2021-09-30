import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lotusadmin/models/user.dart';

import '../constants.dart';

class UserNumber {
  int date;
  int number;
  UserNumber({required this.date, required this.number});
}

class NewUsers extends StatefulWidget {
  final DateTimeRange dateTimeRange;
  final String formatString;
  NewUsers({Key? key, required this.dateTimeRange, required this.formatString}) : super(key: key);

  @override
  _NewUsersState createState() => _NewUsersState();
}

class _NewUsersState extends State<NewUsers> {
  List<User> newUsers = [];
  List usersNumbers = [];
  List<FlSpot> chartData = [];
  var collection = FirebaseFirestore.instance.collection('users');
  getUsersDataFromFirebase() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await collection
        .where('dateSignedUp', isGreaterThanOrEqualTo: widget.dateTimeRange.start)
        .where("dateSignedUp", isLessThanOrEqualTo: widget.dateTimeRange.end)
        .get();
    List<QueryDocumentSnapshot> docs = snapshot.docs;
    var output = docs.map((e) => e.data()).toList();
    newUsers = (output as List).map((e) => User.fromMap(e)).toList();
    Map usersDates = Map<int, List<User>>.fromIterable(newUsers,
        key: (e) => e.dateSignedUp.toUtc().millisecondsSinceEpoch,
        value: (e) => newUsers.where((element) => element.dateSignedUp == e.dateSignedUp).toList());
    print(usersDates);
    usersNumbers.clear();
    usersDates.forEach((key, value) {
      usersNumbers.add(UserNumber(date: key, number: value.length));
    });
    print(usersNumbers);
    if (usersNumbers.isNotEmpty) {
      chartData = List<FlSpot>.generate(usersNumbers.length,
          (index) => FlSpot(usersNumbers[index].date.toDouble(), usersNumbers[index].number.toDouble()));
      return chartData;
    }
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
            future: getUsersDataFromFirebase(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              if (snapshot.hasData) {
                return Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    height: 250,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      color: secondaryColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("New Users : ${usersNumbers.length}"),
                        Flexible(
                          child: ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: Text(
                                      '${DateFormat('${widget.formatString}').format(DateTime.fromMillisecondsSinceEpoch(usersNumbers[index].date))}'),
                                  trailing: Text('${usersNumbers[index].number}'),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Divider();
                              },
                              itemCount: usersNumbers.length),
                        )
                      ],
                    ));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}

class _BarChart extends StatefulWidget {
  final List<FlSpot> chartData;
  final DateTimeRange dateTimeRange;
  final String formatString;
  _BarChart({Key? key, required this.chartData, required this.dateTimeRange, required this.formatString})
      : super(key: key);

  @override
  __BarChartState createState() => __BarChartState();
}

class __BarChartState extends State<_BarChart> {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: const EdgeInsets.all(0),
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.y.round().toString(),
              TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            final DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
            return DateFormat('${widget.formatString}').format(date);
          },
          margin: 20,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          margin: 8,
          reservedSize: 30,
        ),
        topTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(showTitles: false),
      );

  FlBorderData get borderData => FlBorderData(
      show: true, border: Border(bottom: BorderSide(color: Colors.white), left: BorderSide(color: Colors.white)));

  List<BarChartGroupData> get barGroups => List.generate(
      widget.chartData.length,
      (index) => BarChartGroupData(x: widget.chartData[index].x.toInt(), barRods: [
            BarChartRodData(y: widget.chartData[index].y, colors: [Colors.white])
          ]));
}
