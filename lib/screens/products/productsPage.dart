import 'package:flutter/material.dart';
import 'package:lotusadmin/models/product.dart';
import 'package:lotusadmin/models/user.dart';
import 'package:lotusadmin/providers/productsProvider.dart';
import 'package:lotusadmin/screens/dashboard/header.dart';
import 'package:lotusadmin/screens/products/addProducts.dart';
import 'package:lotusadmin/screens/products/productsTable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants.dart';

class ProductsPage extends StatefulWidget {
  final User user;
  const ProductsPage({Key? key, required this.user}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Header(
            title: 'Products',
            user: widget.user,
          ),
          Container(
            padding: EdgeInsets.all(defaultPadding),
            width: 200,
            child: ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white)),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddProducts()));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.add_circle,
                      color: secondaryColor,
                    ),
                    SizedBox(
                      width: defaultPadding,
                    ),
                    Text(
                      'Add Product',
                      style: TextStyle(color: secondaryColor),
                    ),
                  ],
                )),
          ),
          SizedBox(height: defaultPadding),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("products").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return Center(child: Text('${snapshot.error.toString()}'));
                if (!snapshot.hasData) return Center(child: Text('Loading ...'));
                var output = snapshot.data?.docs.map((doc) => doc.data()).toList();
                List<String> documentID = snapshot.data!.docs.map((doc) => doc.id).toList();

                Products.productsList = (output as List).map((item) => Product.fromMap(item)).toList();
                for (var i = 0; i < Products.productsList.length; i++) {
                  Products.productsList[i].productDocId = documentID[i].toString();
                }
                Products.productsList.sort((a, b) {
                  return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
                });
                return Row(
                  children: [
                    Expanded(child: ProductsTable()),
                  ],
                );
              }),
        ]),
      ),
    );
  }
}
