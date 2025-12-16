import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? id;
  final String category;
  final String image;
  final String title;
  final String? description;
  final String? subtitle;
  final double price;
  final double? oldPrice;
  final double? rating;
  final int? reviews;

  Product({
    this.id,
    required this.category,
    required this.image,
    required this.title,
    this.subtitle,
    this.description,
    required this.price,
    this.oldPrice,
    this.rating,
    this.reviews,
  });

  factory Product.fromMap(Map<String, dynamic> m) => Product(
    id: m['id'] as String?,
    category: (m['category'] as String?) ?? 'uncategorized',
    image: m['image'] as String? ?? '',
    title: m['title'] as String? ?? '',
    subtitle: m['subtitle'] as String?,
    description: m['description'] as String?,
    price: (m['price'] as num?)?.toDouble() ?? 0.0,
    oldPrice: (m['oldPrice'] as num?)?.toDouble(),
    rating: (m['rating'] as num?)?.toDouble(),
    reviews: m['reviews'] as int?,
  );

  factory Product.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    final reviewsValue = data['reviews'];
    final int? reviews = reviewsValue is int
        ? reviewsValue
        : (reviewsValue is num ? reviewsValue.toInt() : null);

    return Product(
      id: doc.id,
      category: (data['category'] as String?) ?? 'uncategorized',
      image: data['image'] as String? ?? '',
      title: data['title'] as String? ?? '',
      subtitle: data['subtitle'] as String?,
      description: data['description'] as String?,
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      oldPrice: (data['oldPrice'] as num?)?.toDouble(),
      rating: (data['rating'] as num?)?.toDouble(),
      reviews: reviews,
    );
  }

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'category': category,
    'image': image,
    'title': title,
    if (description != null) 'description': description,
    if (subtitle != null) 'subtitle': subtitle,
    'price': price,
    if (oldPrice != null) 'oldPrice': oldPrice,
    if (rating != null) 'rating': rating,
    if (reviews != null) 'reviews': reviews,
  };
}
