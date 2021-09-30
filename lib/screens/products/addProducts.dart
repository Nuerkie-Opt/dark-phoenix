import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../constants.dart';

class AddProducts extends StatefulWidget {
  AddProducts({Key? key}) : super(key: key);

  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  final _formKey = GlobalKey<FormState>();
  bool imageSelected = false;
  bool adding = false;
  var picked;
  var selectedImage;
  var productsCollection = FirebaseFirestore.instance.collection("products");
  TextEditingController name = TextEditingController();
  TextEditingController serialNumber = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController subCategory = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController costPrice = TextEditingController();
  TextEditingController discountPrice = TextEditingController();
  TextEditingController desciption = TextEditingController();
  TextEditingController quantity = TextEditingController();
  List<TextEditingController> sizeControllers =
      List<TextEditingController>.generate(5, (index) => TextEditingController());
  List<TextEditingController> colorsControllers =
      List<TextEditingController>.generate(5, (index) => TextEditingController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Product"),
          leading: Container(),
          backgroundColor: bgColor,
          elevation: 0,
        ),
        body: SafeArea(
          child: Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Container(
                      margin: EdgeInsets.all(defaultPadding),
                      padding: EdgeInsets.all(defaultPadding),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: imageSelected
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(child: Image.memory(selectedImage)),
                                SizedBox(height: defaultPadding),
                                Container(
                                  padding: EdgeInsets.all(defaultPadding),
                                  width: 200,
                                  child: ElevatedButton(
                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white)),
                                    onPressed: () async {
                                      picked = await FilePicker.platform.pickFiles(type: FileType.image);
                                      selectedImage = picked.files.first.bytes;
                                      setState(() {
                                        imageSelected = true;
                                      });
                                    },
                                    child: Text(
                                      'Change',
                                      style: TextStyle(color: secondaryColor),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              height: 120,
                              child: IconButton(
                                  onPressed: () async {
                                    picked = await FilePicker.platform.pickFiles(type: FileType.image);
                                    selectedImage = picked.files.first.bytes;
                                    setState(() {
                                      imageSelected = true;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.add_a_photo_rounded,
                                    color: Colors.white,
                                    size: 100,
                                  )),
                            ))),
              Expanded(
                flex: 5,
                child: Container(
                  margin: EdgeInsets.all(defaultPadding),
                  padding: EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        TextFormField(
                          controller: name,
                          decoration: InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter product name";
                            }
                            if (value.contains(RegExp(r'^[0-9]*$'))) {
                              return "Product name should not contain a number";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        TextFormField(
                          controller: serialNumber,
                          decoration: InputDecoration(labelText: 'Serial Number', border: OutlineInputBorder()),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter product serial number";
                            }
                            if (!value.contains(RegExp(r'^[0-9]*$'))) {
                              return "Serial number should be a number";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        TextFormField(
                          controller: price,
                          decoration: InputDecoration(labelText: 'Sale Price', border: OutlineInputBorder()),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter product sale price";
                            }
                            if (!value.contains(RegExp(r'^[0-9]*$'))) {
                              return "sale Price should be a number";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        TextFormField(
                          controller: costPrice,
                          decoration: InputDecoration(labelText: 'Cost Price', border: OutlineInputBorder()),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter product cost price";
                            }
                            if (!value.contains(RegExp(r'^[0-9]*$'))) {
                              return "Cost Price should be a number";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        TextFormField(
                          controller: quantity,
                          decoration: InputDecoration(labelText: 'Stock Quantity', border: OutlineInputBorder()),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter the number of this product in stock";
                            }
                            if (!value.contains(RegExp(r'^[0-9]*$'))) {
                              return "Stock quantity should be a number";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        TextFormField(
                          controller: category,
                          decoration: InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter product category";
                            }
                            if (value.contains(RegExp(r'^[0-9]*$'))) {
                              return "Product category should not contain a number";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        TextFormField(
                          controller: subCategory,
                          decoration: InputDecoration(labelText: 'Sub-Category', border: OutlineInputBorder()),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter product sub-category";
                            }
                            if (value.contains(RegExp(r'[0-9]'))) {
                              return "Product sub-category should not contain a number";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        TextFormField(
                          controller: desciption,
                          decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter product description";
                            }

                            return null;
                          },
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        TextFormField(
                          controller: discountPrice,
                          decoration: InputDecoration(labelText: 'Price After Discount', border: OutlineInputBorder()),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter price after discount";
                            }
                            if (!value.contains(RegExp(r'^[0-9]*$'))) {
                              return "Price should be a number";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        ListTile(
                          title: Text('Sizes'),
                          subtitle: ListView.builder(
                              shrinkWrap: true,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(defaultPadding),
                                  child: TextFormField(
                                    controller: sizeControllers[index],
                                    decoration:
                                        InputDecoration(labelText: 'Size - ${index + 1}', border: OutlineInputBorder()),
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (!value!.contains(RegExp(r'^[0-9]*$'))) {
                                        return "Size should be a number";
                                      }
                                      return null;
                                    },
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        ListTile(
                          title: Text('Colours'),
                          subtitle: ListView.builder(
                              shrinkWrap: true,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(defaultPadding),
                                  child: TextFormField(
                                    controller: colorsControllers[index],
                                    decoration: InputDecoration(
                                        labelText: 'Colour - ${index + 1}', border: OutlineInputBorder()),
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value!.contains(RegExp(r'^[0-9]*$'))) {
                                        return "Colour should not contain a number";
                                      }
                                      if (value.isEmpty) return null;
                                      return null;
                                    },
                                  ),
                                );
                              }),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 350),
                          width: 200,
                          child: ElevatedButton(
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white)),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    adding = true;
                                  });
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
                                  var imagePath = await uploadproductImage(
                                      name.text, category.text.toLowerCase(), subCategory.text.toLowerCase());
                                  await productsCollection.doc().set({
                                    "name": name.text,
                                    "serialNumber": int.parse(serialNumber.text),
                                    "price": double.parse(price.text),
                                    "quantity": int.parse(quantity.text),
                                    "costPrice": double.parse(costPrice.text),
                                    "discountPrice": discountPrice.text.isEmpty ? 0 : double.parse(discountPrice.text),
                                    "discountAvailable": discountPrice.text.isEmpty ? false : true,
                                    "description": desciption.text,
                                    "descriptionAvailable": true,
                                    "category": category.text.toLowerCase(),
                                    "subCategory": subCategory.text.toLowerCase(),
                                    "colors": colors,
                                    "sizes": sizes,
                                    "productImage": imagePath
                                  });

                                  Navigator.pop(context);
                                }
                              },
                              child: adding
                                  ? CircularProgressIndicator(
                                      color: secondaryColor,
                                    )
                                  : Row(
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
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<String?> uploadproductImage(String? productName, String? productCategory, String? productSubcategory) async {
    String? returnURL;
    if (picked != null) {
      Uint8List fileBytes = picked.files.first.bytes;
      String fileName = picked.files.first.name;
      firebase_storage.Reference storageReference =
          firebase_storage.FirebaseStorage.instance.ref('products/$productCategory/$productSubcategory/$fileName');

      firebase_storage.UploadTask uploadTask = storageReference.putData(fileBytes);

      await uploadTask.whenComplete(() async {
        await storageReference.getDownloadURL().then((fileURL) async {
          returnURL = fileURL;

          return returnURL;
        });
      });
    }
    return returnURL;
  }
}
