import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trendify/utils/constants/enums.dart';

/// Simple in-memory order model used for demo/test purposes.
class Order {
  final String id; // order id
  final String? buyerId;
  final String? sellerId;
  final List<Map<String, dynamic>> items; // store product maps
  final double total; // legacy key 'total'
  final DateTime date; // legacy key 'date'
  final OrderStatus status;

  Order({
    required this.id,
    this.buyerId,
    this.sellerId,
    required this.items,
    required this.total,
    required this.date,
    this.status = OrderStatus.preprocessing,
  });

  /// Create Order from a Map. Supports legacy keys and new keys for
  /// backward compatibility (`orderId` / `id`, `totalAmount` / `total`,
  /// `createdAt` / `date`). Missing `buyerId`/`sellerId` will be null.
  factory Order.fromMap(Map<String, dynamic> map) {
    final id = map['id'] ?? map['orderId'] ?? '';
    final items =
        (map['items'] as List<dynamic>?)
            ?.map((e) => Map<String, dynamic>.from(e as Map))
            .toList() ??
        <Map<String, dynamic>>[];

    double parseDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    DateTime parseDate(dynamic v) {
      if (v == null) return DateTime.fromMillisecondsSinceEpoch(0);
      if (v is DateTime) return v;
      if (v is Timestamp) return v.toDate();
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return DateTime.fromMillisecondsSinceEpoch(0);
      }
    }

    final total = parseDouble(map['total'] ?? map['totalAmount']);
    final date = parseDate(map['date'] ?? map['createdAt']);
    final statusRaw =
        map['status']?.toString() ?? OrderStatus.preprocessing.toString();
    OrderStatus parseStatus(String s) {
      try {
        return OrderStatus.values.firstWhere((e) => e.toString() == s);
      } catch (_) {
        return OrderStatus.preprocessing;
      }
    }

    return Order(
      id: id,
      buyerId: map['buyerId'] as String?,
      sellerId: map['sellerId'] as String?,
      items: items,
      total: total,
      date: date,
      status: parseStatus(statusRaw),
    );
  }

  /// Convert order to map. Emits both legacy and modern keys where useful
  /// so older readers won't break and new readers can use `sellerId`.
  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{
      'id': id,
      'orderId': id,
      'items': items,
      'total': total,
      'totalAmount': total,
      'date': date.toIso8601String(),
      'createdAt': date.toIso8601String(),
      'status': status.toString(),
    };

    if (buyerId != null) m['buyerId'] = buyerId;
    if (sellerId != null) m['sellerId'] = sellerId;

    return m;
  }

  @override
  String toString() => 'Order(id: $id, total: $total, items: ${items.length})';
}
