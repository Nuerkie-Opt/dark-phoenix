import 'package:flutter/material.dart';
import 'package:lotusadmin/models/user.dart';
import 'package:lotusadmin/reports/inventory.dart';
import 'package:lotusadmin/reports/newUsers.dart';
import 'package:lotusadmin/reports/profitMade.dart';
import 'package:lotusadmin/screens/dashboard/header.dart';

import '../constants.dart';

class ReportDuration {
  String title;
  DateTimeRange dateTimeRange;
  String formatString;
  ReportDuration({required this.title, required this.dateTimeRange, required this.formatString});
}

class Reports extends StatefulWidget {
  final User user;
  Reports({Key? key, required this.user}) : super(key: key);

  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  List<ReportDuration> reportDurations = [
    ReportDuration(
        title: "Last 24 hours",
        dateTimeRange: DateTimeRange(start: DateTime.now().subtract(Duration(hours: 24)), end: DateTime.now()),
        formatString: 'Hms'),
    ReportDuration(
        title: "Last 48 hours",
        dateTimeRange: DateTimeRange(start: DateTime.now().subtract(Duration(hours: 48)), end: DateTime.now()),
        formatString: 'MMMd'),
    ReportDuration(
        title: "Last 30 days",
        dateTimeRange: DateTimeRange(start: DateTime.now().subtract(Duration(days: 30)), end: DateTime.now()),
        formatString: 'MMMMd'),
    ReportDuration(
        title: "Last 365 days",
        dateTimeRange: DateTimeRange(start: DateTime.now().subtract(Duration(days: 365)), end: DateTime.now()),
        formatString: 'yMMMMd'),
  ];
  ReportDuration? initialDuration;
  @override
  void initState() {
    initialDuration = reportDurations[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            padding: EdgeInsets.all(defaultPadding),
            child: Container(
                child: Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Header(title: 'Reports', user: widget.user),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    Container(
                      width: 250,
                      child: DropdownButtonFormField<ReportDuration>(
                        value: initialDuration,
                        onChanged: (newvalue) {
                          setState(() {
                            initialDuration = newvalue!;
                          });
                        },
                        items: reportDurations.map((ReportDuration reportDuration) {
                          return DropdownMenuItem<ReportDuration>(
                            child: Text(reportDuration.title),
                            value: reportDuration,
                          );
                        }).toList(),
                        validator: (value) {
                          if (initialDuration != value) {
                            return '--Select range--';
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    Row(
                      children: [
                        NewUsers(
                          dateTimeRange: initialDuration!.dateTimeRange,
                          formatString: initialDuration!.formatString,
                        ),
                        SizedBox(
                          width: defaultPadding,
                        ),
                        ProfitMade(
                          dateTimeRange: initialDuration!.dateTimeRange,
                        )
                      ],
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    Inventory()
                  ],
                ),
              ),
            ))));
  }
}
