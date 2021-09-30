import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:lotusadmin/models/product.dart';
import 'package:lotusadmin/screens/products/productDetails.dart';

import '../constants.dart';

class Inventory extends StatefulWidget {
  Inventory({Key? key}) : super(key: key);

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  var collection = FirebaseFirestore.instance.collection('products');
  List<Product> waningInventory = [];
  getProductsLessThan3() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await collection.where('quantity', isLessThanOrEqualTo: 3).get();
    List<QueryDocumentSnapshot> docs = snapshot.docs;
    var output = docs.map((e) => e.data()).toList();
    waningInventory = (output as List).map((e) => Product.fromMap(e)).toList();
    print(waningInventory);
    return waningInventory;
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
            future: getProductsLessThan3(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              if (snapshot.hasData) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "You are running out of the following products",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: DataTable2(
                          columnSpacing: defaultPadding,
                          dataRowHeight: 60,
                          minWidth: 600,
                          columns: [
                            DataColumn(
                              label: Text("Name"),
                            ),
                            DataColumn(
                              label: Text("Serial Number"),
                            ),
                            DataColumn(
                              label: Text("Stock"),
                            ),
                          ],
                          rows: List.generate(
                            waningInventory.length,
                            (index) => productDataRow(waningInventory[index], context),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}

DataRow productDataRow(Product product, BuildContext context) {
  return DataRow2(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(product: product)));
    },
    cells: [
      DataCell(
        Row(
          children: [
            product.productImage.isEmpty
                ? Image.asset(
                    'assets/images/backgroundAvatar.png',
                    height: 30,
                    width: 30,
                  )
                : Image.network(
                    product.productImage,
                    height: 30,
                    width: 30,
                  ),
            SizedBox(width: 3),
            Expanded(child: Text(product.name ?? "")),
          ],
        ),
      ),
      DataCell(Text('${product.serialNumber}')),
      DataCell(Text('${product.quantity}')),
    ],
  );
}
