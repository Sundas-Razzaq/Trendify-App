import 'package:trendify/utils/constants/enums.dart';

/// Simple in-memory order model used for demo/test purposes.
class Order {
  final String id;
  final List<Map<String, dynamic>> items; // store product maps
  final double total;
  final DateTime date;
  final OrderStatus status;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
    this.status = OrderStatus.preprocessing,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items,
      'total': total,
      'date': date.toIso8601String(),
      'status': status.toString(),
    };
  }

  @override
  String toString() => 'Order(id: $id, total: $total, items: ${items.length})';
}
