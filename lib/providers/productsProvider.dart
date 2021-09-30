import 'package:lotusadmin/models/product.dart';
import 'package:flutter/foundation.dart';

class Products with ChangeNotifier {
  static List<Map<String, List<Product>>> productsWithId = [];
  static List<Product> productsList = [];
}
