import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trendify/features/shop/models/order.dart' as app_order;

class OrderService {
  final FirebaseFirestore _db;
  OrderService({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _orders =>
      _db.collection('orders');

  /// Persist order to Firestore under `orders/<orderId>`.
  /// Ensures `sellerId`, `buyerId`, `status` and `createdAt` are present.
  Future<void> addOrder(app_order.Order order) async {
    final data = Map<String, dynamic>.from(order.toJson());

    // Normalize status to simple enum name (e.g. 'pending')
    final statusStr = order.status.toString().split('.').last;
    data['status'] = statusStr;

    // Ensure sellerId / buyerId keys exist (may be null)
    data['sellerId'] = order.sellerId;
    data['buyerId'] = order.buyerId;

    // Use server timestamp for createdAt to keep consistent ordering
    data['createdAt'] = FieldValue.serverTimestamp();

    await _orders.doc(order.id).set(data);
  }

  /// Stream orders for a given sellerId. Returns an empty list if there
  /// are no orders. Orders are sorted by `createdAt` descending.
  Stream<List<app_order.Order>> getOrdersForSeller(String sellerId) {
    final query = _orders
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('createdAt', descending: true);

    return query.snapshots().map((snap) {
      return snap.docs.map((d) {
        final map = <String, dynamic>{...d.data(), 'id': d.id};
        return app_order.Order.fromMap(map);
      }).toList();
    });
  }

  /// Convenience: stream for the current authenticated seller (if any).
  Stream<List<app_order.Order>> getOrdersForCurrentSeller(
    String? currentSellerId,
  ) {
    if (currentSellerId == null || currentSellerId.isEmpty) {
      // Return an empty stream
      return Stream.value(<app_order.Order>[]);
    }
    return getOrdersForSeller(currentSellerId);
  }

  /// Stream orders for a given buyerId. Returns an empty list if there
  /// are no orders. Orders are sorted by `createdAt` descending.
  Stream<List<app_order.Order>> getOrdersForBuyer(String buyerId) {
    final query = _orders
        .where('buyerId', isEqualTo: buyerId)
        .orderBy('createdAt', descending: true);

    return query.snapshots().map((snap) {
      return snap.docs.map((d) {
        final map = <String, dynamic>{...d.data(), 'id': d.id};
        return app_order.Order.fromMap(map);
      }).toList();
    });
  }

  /// Convenience: stream for the current authenticated buyer (if any).
  Stream<List<app_order.Order>> getOrdersForCurrentBuyer(
    String? currentBuyerId,
  ) {
    if (currentBuyerId == null || currentBuyerId.isEmpty) {
      // Return an empty stream
      return Stream.value(<app_order.Order>[]);
    }
    return getOrdersForBuyer(currentBuyerId);
  }

  /// Update order status. Only updates the status field, does NOT allow
  /// changes to sellerId or buyerId. Throws if order doesn't exist.
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final docRef = _orders.doc(orderId);

    // Check if order exists
    final snapshot = await docRef.get();
    if (!snapshot.exists) {
      throw Exception('Order not found');
    }

    // Only update the status field, preserve other fields
    await docRef.update({
      'status': newStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
