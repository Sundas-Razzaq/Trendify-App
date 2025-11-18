import 'package:flutter/foundation.dart';
import 'package:trendify/features/shop/models/order.dart';

class OrdersStore {
  OrdersStore._();
  static final OrdersStore _instance = OrdersStore._();
  factory OrdersStore() => _instance;

  // ValueNotifier so UI can listen and update
  final ValueNotifier<List<Order>> orders = ValueNotifier<List<Order>>([]);

  void addOrder(Order order) {
    orders.value = List<Order>.from(orders.value)..add(order);
  }

  void clear() {
    orders.value = [];
  }
}
