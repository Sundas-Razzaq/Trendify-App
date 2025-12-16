import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trendify/features/shop/models/order.dart';
import 'package:trendify/utils/services/order_service.dart';
import 'package:trendify/utils/constants/sizes.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final buyerId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: StreamBuilder<List<Order>>(
        stream: OrderService().getOrdersForCurrentBuyer(buyerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading orders: ${snapshot.error}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return Center(
              child: Text(
                'You have no orders yet.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            itemCount: orders.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: TSizes.spaceBtwItems),
            itemBuilder: (context, index) {
              final order = orders[index];
              final date = DateFormat.yMMMd().add_jm().format(order.date);
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order #${order.id}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '\$${order.total.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.sm),
                      Text(date, style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: TSizes.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${order.items.length} items',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(order.status),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getStatusText(order.status),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.sm),
                      ExpansionTile(
                        title: const Text('View items'),
                        children: order.items.map<Widget>((it) {
                          final title = it['title'] ?? 'Item';
                          final price = (it['price'] ?? 0).toString();
                          return ListTile(
                            title: Text(title),
                            trailing: Text('\$ $price'),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _getStatusText(status) {
    final statusStr = status.toString().split('.').last;
    return statusStr[0].toUpperCase() + statusStr.substring(1);
  }

  Color _getStatusColor(status) {
    final statusStr = status.toString().split('.').last;
    switch (statusStr) {
      case 'preprocessing':
        return Colors.orange;
      case 'shipped':
        return Colors.blue;
      case 'delivered':
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
