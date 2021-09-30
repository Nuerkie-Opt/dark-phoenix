import 'package:lotusadmin/constants.dart';
import 'package:flutter/material.dart';

class AdminInfo {
  final String? svgSrc, title;
  final int? numberofItem, percentage;
  final Color? color;

  AdminInfo({
    this.svgSrc,
    this.title,
    this.numberofItem,
    this.percentage,
    this.color,
  });
}

List demoMyFiles = [
  AdminInfo(
    title: "Revenue",
    numberofItem: 1328,
    svgSrc: "assets/icons/Documents.svg",
    color: primaryColor,
  ),
  AdminInfo(
    title: "Products",
    numberofItem: 1328,
    svgSrc: "assets/icons/google_drive.svg",
    color: Color(0xFFFFA113),
  ),
  AdminInfo(
    title: "All Orders",
    numberofItem: 1328,
    svgSrc: "assets/icons/one_drive.svg",
    color: Color(0xFFA4CDFF),
    percentage: 10,
  ),
  AdminInfo(
    title: "Pending Orders",
    numberofItem: 748,
    svgSrc: "assets/icons/drop_box.svg",
    color: Color(0xFF007EE5),
    percentage: 38,
  ),
];
