import 'package:lotusadmin/models/order.dart';
import 'package:flutter/foundation.dart';

class Orders with ChangeNotifier {
  static List<Order>? orders = [];
  static num ordersAmountTotal = 0;
  static List<Order>? completeOrders = [];
  static num completeOrdersAmountTotal = 0;
  static List<Order>? awaitingDeliveryOrders = [];
  static num awaitingDeliveryOrdersAmountTotal = 0;
  static List<Order>? awaitingPaymentOrders = [];
  static num awaitingPaymentOrdersAmountTotal = 0;
}
