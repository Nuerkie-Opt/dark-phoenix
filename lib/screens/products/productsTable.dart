import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:lotusadmin/models/product.dart';
import 'package:lotusadmin/providers/productsProvider.dart';
import 'package:lotusadmin/responsive.dart';
import 'package:lotusadmin/screens/products/productDetails.dart';

import '../../../constants.dart';

class ProductsTable extends StatefulWidget {
  const ProductsTable({Key? key}) : super(key: key);

  @override
  _ProductsTableState createState() => _ProductsTableState();
}

class _ProductsTableState extends State<ProductsTable> {
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
            "Products",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            width: double.infinity,
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
                  label: Text("Sale Price"),
                ),
                DataColumn(
                  label: Text("Cost Price"),
                ),
                DataColumn(
                  label: Text("Stock"),
                ),
                if (Responsive.isDesktop(context))
                  DataColumn(
                    label: Text("Discount Price"),
                  ),
                if (Responsive.isDesktop(context))
                  DataColumn(
                    label: Text("Category"),
                  ),
                if (Responsive.isDesktop(context))
                  DataColumn(
                    label: Text("Sub Category"),
                  ),
                if (Responsive.isDesktop(context))
                  DataColumn(
                    label: Text("Description"),
                  ),
                // Un comment to print out all fields to see what is missing
                if (Responsive.isDesktop(context))
                  DataColumn(
                    label: Text("Discounted"),
                  ),
                if (Responsive.isDesktop(context))
                  DataColumn(
                    label: Text("Description Avail"),
                  ),
              ],
              rows: List.generate(
                Products.productsList.length,
                (index) => productDataRow(Products.productsList[index], context),
              ),
            ),
          ),
        ],
      ),
    );
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
      DataCell(Text('${product.price}')),
      DataCell(Text('${product.costPrice}')),
      DataCell(Text('${product.quantity}')),
      if (Responsive.isDesktop(context)) DataCell(Text('${product.discountPrice}')),
      if (Responsive.isDesktop(context)) DataCell(Text(product.category ?? "")),
      if (Responsive.isDesktop(context)) DataCell(Text(product.subCategory ?? "")),
      if (Responsive.isDesktop(context)) DataCell(Text(product.description ?? "")),
      if (Responsive.isDesktop(context)) DataCell(Text('${product.discounted ?? ""}')),
      if (Responsive.isDesktop(context)) DataCell(Text('${product.descriptionAvailable ?? ""}')),
    ],
  );
}
