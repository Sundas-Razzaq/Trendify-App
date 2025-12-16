import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:trendify/features/shop/models/order.dart';
import 'package:trendify/utils/services/order_service.dart';
import 'package:trendify/utils/constants/sizes.dart';

class SellerOrders extends StatelessWidget {
  const SellerOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final sellerId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      body: StreamBuilder<List<Order>>(
        stream: OrderService().getOrdersForCurrentSeller(sellerId),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No orders yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Orders from buyers will appear here',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                ],
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
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Order #${order.id.substring(0, 8)}',
                              style: Theme.of(context).textTheme.titleMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '\$${order.total.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
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
                            '${order.items.length} item(s)',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
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
                      const SizedBox(height: TSizes.md),
                      ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        title: const Text('View Items'),
                        children: order.items.map<Widget>((item) {
                          final title = item['title'] ?? 'Item';
                          final price = (item['price'] ?? 0).toString();
                          return ListTile(
                            dense: true,
                            title: Text(title),
                            trailing: Text('\$$price'),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: TSizes.sm),
                      const Divider(),
                      const SizedBox(height: TSizes.sm),
                      Text(
                        'Update Status',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: TSizes.sm),
                      Wrap(
                        spacing: 8,
                        children: [
                          _StatusButton(
                            label: 'Shipped',
                            status: 'shipped',
                            orderId: order.id,
                            currentStatus: order.status.toString(),
                          ),
                          _StatusButton(
                            label: 'Completed',
                            status: 'completed',
                            orderId: order.id,
                            currentStatus: order.status.toString(),
                          ),
                          _StatusButton(
                            label: 'Cancelled',
                            status: 'cancelled',
                            orderId: order.id,
                            currentStatus: order.status.toString(),
                            isDestructive: true,
                          ),
                        ],
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

class _StatusButton extends StatefulWidget {
  final String label;
  final String status;
  final String orderId;
  final String currentStatus;
  final bool isDestructive;

  const _StatusButton({
    required this.label,
    required this.status,
    required this.orderId,
    required this.currentStatus,
    this.isDestructive = false,
  });

  @override
  State<_StatusButton> createState() => _StatusButtonState();
}

class _StatusButtonState extends State<_StatusButton> {
  bool _isLoading = false;

  Future<void> _updateStatus() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      await OrderService().updateOrderStatus(widget.orderId, widget.status);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order status updated to ${widget.label}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update status: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCurrent = widget.currentStatus.contains(widget.status);

    return ElevatedButton(
      onPressed: isCurrent || _isLoading ? null : _updateStatus,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.isDestructive ? Colors.red : Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(fontSize: 12),
      ),
      child: _isLoading
          ? const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(isCurrent ? '✓ ${widget.label}' : widget.label),
    );
  }
}
