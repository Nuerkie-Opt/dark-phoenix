import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lotusadmin/providers/ordersProvider.dart';
import 'package:lotusadmin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:lotusadmin/models/adminInfo.dart';
import '../../../constants.dart';
import 'adminInfoCard.dart';

class AdminItem extends StatelessWidget {
  const AdminItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Responsive(
          mobile: AdminInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 ? 1.3 : 1,
          ),
          tablet: AdminInfoCardGridView(),
          desktop: AdminInfoCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class AdminInfoCardGridView extends StatefulWidget {
  const AdminInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  _AdminInfoCardGridViewState createState() => _AdminInfoCardGridViewState();
}

int? productListCount;
int? orderListCount;
int? userListCount;

class _AdminInfoCardGridViewState extends State<AdminInfoCardGridView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("orders").snapshots(),
        builder: (context, snapshot) {
          orderListCount = snapshot.data?.docs.length;
          return StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("products").snapshots(),
              builder: (context, snapshot) {
                productListCount = snapshot.data?.docs.length;
                return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .snapshots(),
                    builder: (context, snapshot) {
                      userListCount = snapshot.data?.docs.length;
                      List adminItems = [
                        AdminInfo(
                          title: "Revenue",
                          numberofItem:
                              Orders.completeOrdersAmountTotal.toInt(),
                          svgSrc: "assets/icons/Documents.svg",
                          color: primaryColor,
                        ),
                        AdminInfo(
                          title: "Products",
                          numberofItem: productListCount,
                          svgSrc: "assets/icons/google_drive.svg",
                          color: Color(0xFFFFA113),
                        ),
                        AdminInfo(
                          title: "Orders",
                          numberofItem: orderListCount,
                          svgSrc: "assets/icons/one_drive.svg",
                          color: Color(0xFFA4CDFF),
                          percentage: 10,
                        ),
                        AdminInfo(
                          title: "Users",
                          numberofItem: userListCount,
                          svgSrc: "assets/icons/drop_box.svg",
                          color: Color(0xFF007EE5),
                          percentage: 38,
                        ),
                      ];
                      return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: demoMyFiles.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: widget.crossAxisCount,
                          crossAxisSpacing: defaultPadding,
                          mainAxisSpacing: defaultPadding,
                          childAspectRatio: widget.childAspectRatio,
                        ),
                        itemBuilder: (context, index) =>
                            AdminInfoCard(info: adminItems[index]),
                      );
                    });
              });
        });
  }
}
