import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:lotusadmin/models/userAddress.dart';

class Order {
  List<String>? products;
  String? id;
  DateTime? date;
  num? deliveryFee;
  num amount;
  UserAddress? userAddress;
  String? status;
  int? orderNo;
  String? deliveryName;
  String? phoneNumber;
  Order(
      {this.products,
      this.id,
      this.date,
      this.deliveryFee,
      required this.amount,
      this.userAddress,
      this.status,
      this.orderNo,
      this.deliveryName,
      this.phoneNumber});

  Order copyWith({
    List<String>? products,
    String? id,
    DateTime? date,
    num? deliveryFee,
    num? amount,
    UserAddress? userAddress,
    String? status,
    int? orderNo,
  }) {
    return Order(
      products: products ?? this.products,
      id: id ?? this.id,
      date: date ?? this.date,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      amount: amount ?? this.amount,
      userAddress: userAddress ?? this.userAddress,
      status: status ?? this.status,
      orderNo: orderNo ?? this.orderNo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'products': products,
      'id': id,
      'date': date,
      'deliveryFee': deliveryFee,
      'amount': amount,
      'userAddress': userAddress?.toMap(),
      'status': status,
      'orderNo': orderNo,
      'deliveryName': deliveryName,
      'phoneNumber': phoneNumber,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
        products: List<String>.from(map['products']),
        id: map['id'],
        date: map['date'].toDate(),
        deliveryFee: map['deliveryFee'],
        amount: map['amount'],
        userAddress: UserAddress.fromJson(map['userAddress']),
        status: map['status'],
        orderNo: map['orderNo'],
        phoneNumber: map['phoneNumber'],
        deliveryName: map['deliveryName']);
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Order(products: $products, id: $id, date: $date, deliveryFee: $deliveryFee, amount: $amount, userAddress: $userAddress, status: $status, orderNo: $orderNo,deliveryName:$deliveryName,phoneNumber:$phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Order &&
        listEquals(other.products, products) &&
        other.id == id &&
        other.date == date &&
        other.deliveryFee == deliveryFee &&
        other.amount == amount &&
        other.userAddress == userAddress &&
        other.status == status &&
        other.orderNo == orderNo &&
        other.deliveryName == deliveryName &&
        other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode {
    return products.hashCode ^
        id.hashCode ^
        date.hashCode ^
        deliveryFee.hashCode ^
        amount.hashCode ^
        userAddress.hashCode ^
        status.hashCode ^
        orderNo.hashCode ^
        deliveryName.hashCode ^
        phoneNumber.hashCode;
  }
}
