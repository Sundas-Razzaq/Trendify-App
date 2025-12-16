import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trendify/features/shop/shop_services/orders_store.dart';
import 'package:trendify/utils/constants/sizes.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = OrdersStore();

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: ValueListenableBuilder(
        valueListenable: store.orders,
        builder: (context, List orders, _) {
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
                      Text(
                        '${order.items.length} items',
                        style: Theme.of(context).textTheme.bodyMedium,
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
}
