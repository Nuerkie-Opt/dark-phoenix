import 'package:lotusadmin/models/user.dart';
import 'package:lotusadmin/reports/reports.dart';
import 'package:lotusadmin/responsive.dart';
import 'package:lotusadmin/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:lotusadmin/screens/orders/ordersPage.dart';
import 'package:lotusadmin/screens/products/productsPage.dart';
import 'package:lotusadmin/screens/users/usersPage.dart';

class MainScreen extends StatefulWidget {
  final User user;
  MainScreen({required this.user});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int active = 0;
  var tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this, initialIndex: 0)
      ..addListener(() {
        setState(() {
          active = tabController.index;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: adminMenu(),
              ),
            if (!Responsive.isDesktop(context))
              Expanded(
                flex: 1,
                child: mobileMenu(),
              ),
            Expanded(
                // It takes 5/6 part of the screen
                flex: 5,
                child: TabBarView(
                  controller: tabController,
                  children: [
                    DashboardScreen(
                      user: widget.user,
                    ),
                    ProductsPage(
                      user: widget.user,
                    ),
                    OrdersPage(
                      user: widget.user,
                    ),
                    UsersPage(
                      user: widget.user,
                    ),
                    Reports(user: widget.user)
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget mobileMenu() {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: [
        SizedBox(
          height: 30,
        ),
        ListTile(
          leading: Icon(
            Icons.dashboard,
            color: Colors.white,
            size: 40,
          ),
          selected: tabController.index == 0 ? true : false,
          onTap: () {
            tabController.animateTo(0);
          },
        ),
        SizedBox(
          height: 30,
        ),
        ListTile(
          leading: Icon(
            Icons.import_export,
            color: Colors.white,
            size: 40,
          ),
          selected: tabController.index == 1 ? true : false,
          onTap: () {
            tabController.animateTo(1);
          },
        ),
        SizedBox(
          height: 30,
        ),
        ListTile(
          leading: Icon(
            Icons.assignment,
            size: 40,
            color: Colors.white,
          ),
          selected: tabController.index == 2 ? true : false,
          onTap: () {
            tabController.animateTo(2);
          },
        ),
        SizedBox(
          height: 30,
        ),
        ListTile(
          leading: Icon(
            Icons.group,
            color: Colors.white,
            size: 40,
          ),
          selected: tabController.index == 3 ? true : false,
          onTap: () {
            tabController.animateTo(3);
          },
        ),
        SizedBox(
          height: 30,
        ),
        ListTile(
          leading: Icon(
            Icons.bar_chart,
            color: Colors.white,
            size: 40,
          ),
          selected: tabController.index == 4 ? true : false,
          onTap: () {
            tabController.animateTo(4);
          },
        )
      ],
    );
  }

  Widget adminMenu() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        DrawerHeader(
          child: Image.asset(
            "assets/images/logo_transparent.png",
            width: 200,
            height: 200,
          ),
        ),
        ListTile(
          horizontalTitleGap: 0.0,
          leading: Icon(
            Icons.dashboard,
            color: Colors.white,
            size: 30,
          ),
          title: Text(
            'Dashboard',
            style: TextStyle(color: Colors.white54),
          ),
          selected: tabController.index == 0 ? true : false,
          onTap: () {
            tabController.animateTo(0);
          },
        ),
        ListTile(
          horizontalTitleGap: 0.0,
          leading: Icon(
            Icons.import_export,
            color: Colors.white,
            size: 40,
          ),
          title: Text(
            'Products',
            style: TextStyle(color: Colors.white54),
          ),
          selected: tabController.index == 1 ? true : false,
          onTap: () {
            tabController.animateTo(1);
          },
        ),
        ListTile(
          horizontalTitleGap: 0.0,
          leading: Icon(
            Icons.assignment,
            size: 40,
            color: Colors.white,
          ),
          title: Text(
            'Orders',
            style: TextStyle(color: Colors.white54),
          ),
          selected: tabController.index == 2 ? true : false,
          onTap: () {
            tabController.animateTo(2);
          },
        ),
        ListTile(
          horizontalTitleGap: 0.0,
          leading: Icon(
            Icons.group,
            color: Colors.white,
            size: 30,
          ),
          title: Text(
            'Users',
            style: TextStyle(color: Colors.white54),
          ),
          selected: tabController.index == 3 ? true : false,
          onTap: () {
            tabController.animateTo(3);
          },
        ),
        ListTile(
          horizontalTitleGap: 0.0,
          leading: Icon(
            Icons.bar_chart,
            color: Colors.white,
            size: 40,
          ),
          title: Text(
            'Reports',
            style: TextStyle(color: Colors.white54),
          ),
          selected: tabController.index == 4 ? true : false,
          onTap: () {
            tabController.animateTo(4);
          },
        ),
      ],
    );
  }
}
