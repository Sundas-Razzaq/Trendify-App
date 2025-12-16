import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? id;
  final String? sellerId;
  final String category;
  final String image;
  final String title;
  final String? subtitle;
  final String? description;
  final double price;
  final double? oldPrice;
  final double? rating;
  final int? reviews;

  Product({
    this.id,
    this.sellerId,
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

  factory Product.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Product(
      id: doc.id,
      sellerId: data['sellerId'],
      category: data['category'] ?? '',
      image: data['image'] ?? '',
      title: data['title'] ?? '',
      subtitle: data['subtitle'],
      description: data['description'],
      price: (data['price'] as num).toDouble(),
      oldPrice: (data['oldPrice'] as num?)?.toDouble(),
      rating: (data['rating'] as num?)?.toDouble(),
      reviews: (data['reviews'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (sellerId != null) 'sellerId': sellerId,
      'category': category,
      'image': image,
      'title': title,
      if (subtitle != null) 'subtitle': subtitle,
      if (description != null) 'description': description,
      'price': price,
      if (oldPrice != null) 'oldPrice': oldPrice,
      if (rating != null) 'rating': rating,
      if (reviews != null) 'reviews': reviews,
    };
  }
}
