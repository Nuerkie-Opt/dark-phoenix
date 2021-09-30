import 'dart:convert';

import 'package:flutter/foundation.dart';

class OrderList {
  List order;
  OrderList({
    required this.order,
  });

  OrderList copyWith({
    List? order,
  }) {
    return OrderList(
      order: order ?? this.order,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'order': order,
    };
  }

  factory OrderList.fromMap(Map<String, dynamic> map) {
    return OrderList(
      order: List.from(map['order']),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderList.fromJson(String source) => OrderList.fromMap(json.decode(source));

  @override
  String toString() => 'OrderList(order: $order)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderList && listEquals(other.order, order);
  }

  @override
  int get hashCode => order.hashCode;
}
