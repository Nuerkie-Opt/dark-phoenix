import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lotusadmin/models/product.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../constants.dart';

class ProductDetails extends StatefulWidget {
  final Product product;
  ProductDetails({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  List<TextEditingController> controllers = List<TextEditingController>.generate(8, (index) => TextEditingController());
  List<TextEditingController> sizeControllers =
      List<TextEditingController>.generate(5, (index) => TextEditingController());
  List<TextEditingController> colorsControllers =
      List<TextEditingController>.generate(5, (index) => TextEditingController());
  bool? discount;
  bool? description;
  bool noedit = true;

  @override
  Widget build(BuildContext context) {
    var collection = FirebaseFirestore.instance.collection('products');
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text('${widget.product.name}'),
        backgroundColor: bgColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                noedit = false;
                controllers[0].text = widget.product.name ?? "";

                controllers[1].text = widget.product.price.toString();
                controllers[2].text = widget.product.category ?? "";
                controllers[3].text = widget.product.subCategory ?? "";
                controllers[4].text = widget.product.discountPrice.toString();
                controllers[5].text = widget.product.description ?? "";
                controllers[6].text = widget.product.quantity.toString();
                controllers[7].text = widget.product.costPrice.toString();
              });
            },
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            tooltip: 'Edit Product',
          ),
          SizedBox(
            width: defaultPadding,
          ),
          IconButton(
            onPressed: () async {
              await collection.doc(widget.product.productDocId).delete();
              await firebase_storage.FirebaseStorage.instance.refFromURL(widget.product.productImage).delete();
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            tooltip: 'Delete',
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(children: [
            SizedBox(height: defaultPadding),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                      padding: EdgeInsets.all(defaultPadding),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Image.network(widget.product.productImage)),
                ),
                SizedBox(width: defaultPadding),
                Expanded(
                  flex: 4,
                  child: Container(
                      padding: EdgeInsets.all(defaultPadding),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          noedit
                              ? ProductDetailsTile(productDetailType: 'Name', productDetail: widget.product.name ?? '')
                              : TextField(
                                  decoration: InputDecoration(labelText: 'Name'),
                                  controller: controllers[0],
                                ),
                          noedit
                              ? ProductDetailsTile(
                                  productDetailType: 'Serial Number',
                                  productDetail: widget.product.serialNumber.toString())
                              : Container(),
                          noedit
                              ? ProductDetailsTile(
                                  productDetailType: 'Sale Price', productDetail: widget.product.price.toString())
                              : TextField(
                                  decoration: InputDecoration(labelText: 'Sale Price'),
                                  controller: controllers[1],
                                ),
                          noedit
                              ? ProductDetailsTile(
                                  productDetailType: 'Category', productDetail: widget.product.category ?? '')
                              : TextField(
                                  decoration: InputDecoration(labelText: 'Category'),
                                  controller: controllers[2],
                                ),
                          noedit
                              ? ProductDetailsTile(
                                  productDetailType: 'Sub-Category', productDetail: widget.product.subCategory ?? '')
                              : TextField(
                                  decoration: InputDecoration(labelText: 'Sub-Category'),
                                  controller: controllers[3],
                                ),
                          noedit
                              ? Card(
                                  color: secondaryColor,
                                  child: ListTile(
                                    title: Text('Available Sizes',
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200)),
                                    subtitle: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: widget.product.sizes!.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                              title: Text(
                                            "${widget.product.sizes![index]}",
                                            style: TextStyle(
                                                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                                          ));
                                        }),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(defaultPadding),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: 5,
                                      itemBuilder: (context, index) {
                                        for (var i = 0; i < widget.product.sizes!.length; i++) {
                                          sizeControllers[i].text = widget.product.sizes![i].toString();
                                        }

                                        return TextField(
                                          decoration: InputDecoration(
                                              labelStyle: TextStyle(
                                                  fontSize: 12, color: Colors.white, fontWeight: FontWeight.w200),
                                              labelText: 'Size - ${index + 1}',
                                              hintText: 'Enter size'),
                                          controller: sizeControllers[index],
                                        );
                                      }),
                                ),
                          noedit
                              ? Card(
                                  color: secondaryColor,
                                  child: ListTile(
                                    title: Text(
                                      'Available Colours',
                                      style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w200),
                                    ),
                                    subtitle: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: widget.product.colors!.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                              title: Text(
                                            "${widget.product.colors![index]}",
                                            style: TextStyle(
                                                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                                          ));
                                        }),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(defaultPadding),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: 5,
                                      itemBuilder: (context, index) {
                                        for (var i = 0; i < widget.product.colors!.length; i++) {
                                          colorsControllers[i].text = widget.product.colors![i].toString();
                                        }
                                        return TextField(
                                          decoration: InputDecoration(
                                              labelStyle: TextStyle(
                                                  fontSize: 12, color: Colors.white, fontWeight: FontWeight.w200),
                                              labelText: 'Colour - ${index + 1}',
                                              hintText: 'Enter colour'),
                                          controller: colorsControllers[index],
                                        );
                                      }),
                                ),
                          noedit
                              ? ProductDetailsTile(
                                  productDetailType: 'Discount Available',
                                  productDetail: widget.product.discounted.toString())
                              : Container(),
                          noedit
                              ? ProductDetailsTile(
                                  productDetailType: 'Discount Price',
                                  productDetail: widget.product.discountPrice.toString())
                              : TextField(
                                  decoration: InputDecoration(labelText: 'Discount Price'),
                                  controller: controllers[4],
                                ),
                          noedit
                              ? ProductDetailsTile(
                                  productDetailType: 'Description Available',
                                  productDetail: widget.product.descriptionAvailable.toString())
                              : Container(),
                          noedit
                              ? ProductDetailsTile(
                                  productDetailType: 'Description', productDetail: widget.product.description ?? '')
                              : TextField(
                                  decoration: InputDecoration(labelText: 'Description'),
                                  controller: controllers[5],
                                ),
                          noedit
                              ? ProductDetailsTile(
                                  productDetailType: 'Stock Quantity',
                                  productDetail: widget.product.quantity.toString())
                              : TextField(
                                  decoration: InputDecoration(labelText: 'Stock Quantity'),
                                  controller: controllers[6],
                                ),
                          noedit
                              ? ProductDetailsTile(
                                  productDetailType: 'Cost Price', productDetail: widget.product.costPrice.toString())
                              : TextField(
                                  decoration: InputDecoration(labelText: 'Cost Price'),
                                  controller: controllers[7],
                                ),
                          Visibility(
                              visible: !noedit,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: defaultPadding,
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all<Color>(Colors.white)),
                                          onPressed: () async {
                                            List<int> sizes = [];
                                            List<String> colors = [];
                                            for (var i = 0; i < sizeControllers.length; i++) {
                                              if (sizeControllers[i].text.isNotEmpty) {
                                                sizes.add(int.parse(sizeControllers[i].text));
                                              }
                                              if (colorsControllers[i].text.isNotEmpty) {
                                                colors.add(colorsControllers[i].text);
                                              }
                                            }
                                            await collection.doc(widget.product.productDocId).update({
                                              'name': controllers[0].text,
                                              "sizes": sizes,
                                              "colors": colors,
                                              "price": int.parse(controllers[1].text),
                                              'category': controllers[2].text.toLowerCase(),
                                              "subCategory": controllers[3].text.toLowerCase(),
                                              "discountPrice": int.parse(controllers[4].text),
                                              'description': controllers[5].text,
                                              'quantity': int.parse(controllers[6].text),
                                              "descriptionAvailable": controllers[5].text.isEmpty ? false : true,
                                              "discounted": int.parse(controllers[4].text) == 0 ? false : true,
                                            });
                                            setState(() {
                                              noedit = true;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Submit',
                                            style: TextStyle(color: secondaryColor),
                                          )),
                                      SizedBox(width: defaultPadding),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all<Color>(secondaryColor)),
                                          onPressed: () {
                                            setState(() {
                                              noedit = true;
                                            });
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(color: Colors.white),
                                          ))
                                    ],
                                  ),
                                  SizedBox(height: defaultPadding),
                                ],
                              ))
                        ],
                      )),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}

class ProductDetailsTile extends StatelessWidget {
  const ProductDetailsTile({Key? key, required this.productDetailType, required this.productDetail}) : super(key: key);
  final String productDetailType;
  final String productDetail;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: secondaryColor,
      child: ListTile(
        title: Text(productDetailType, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200)),
        subtitle: Text(
          productDetail,
          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
