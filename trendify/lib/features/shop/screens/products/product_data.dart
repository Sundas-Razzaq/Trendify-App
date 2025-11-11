import 'package:trendify/utils/constants/image_strings.dart';

const Map<String, List<Map<String, dynamic>>> categoryProducts = {
  "Beauty": [
    {
      "image": TImages.productImage1,
      "title": "Rose Face Serum",
      "subtitle": "Glow Skin Care",
      "price": 12.99,
      "oldPrice": 18.99,
      "rating": 4.5,
      "reviews": 34,
    },
    {
      "image": TImages.productImage7,
      "title": "Matte Lipstick",
      "subtitle": "Long Lasting",
      "price": 8.49,
      "oldPrice": null,
      "rating": 4.2,
      "reviews": 19,
    },
  ],

  "Fashion": [
    {
      "image": TImages.productImage2,
      "title": "Trendy Handbag",
      "subtitle": "Leather Collection",
      "price": 45.00,
      "oldPrice": 60.00,
      "rating": 4.6,
      "reviews": 27,
    },
    {
      "image": TImages.productImage8,
      "title": "Stylish Sunglasses",
      "subtitle": "UV Protected",
      "price": 15.99,
      "oldPrice": 21.99,
      "rating": 4.3,
      "reviews": 40,
    },
  ],

  "Kids": [
    {
      "image": TImages.productImage3,
      "title": "Kids Backpack",
      "subtitle": "School Bag",
      "price": 22.50,
      "oldPrice": null,
      "rating": 4.7,
      "reviews": 12,
    },
    {
      "image": TImages.productImage9,
      "title": "Toy Car Set",
      "subtitle": "Pack of 5",
      "price": 14.99,
      "oldPrice": 19.99,
      "rating": 4.4,
      "reviews": 8,
    },
  ],

  "Home": [
    {
      "image": TImages.productImage4,
      "title": "Wall Decor Frame",
      "subtitle": "Modern Design",
      "price": 19.99,
      "oldPrice": 25.99,
      "rating": 4.1,
      "reviews": 14,
    },
    {
      "image": TImages.productImage10,
      "title": "LED Desk Lamp",
      "subtitle": "Touch Control",
      "price": 28.99,
      "oldPrice": null,
      "rating": 4.8,
      "reviews": 30,
    },
  ],

  "Mens": [
    {
      "image": TImages.productImage6,
      "title": "Men's T-Shirt",
      "subtitle": "Cotton Fit",
      "price": 16.99,
      "oldPrice": 24.99,
      "rating": 4.3,
      "reviews": 51,
    },
    {
      "image": TImages.productImage12,
      "title": "Sports Sneakers",
      "subtitle": "Running Shoes",
      "price": 59.99,
      "oldPrice": 79.99,
      "rating": 4.6,
      "reviews": 76,
    },
  ],

  "Womens": [
    {
      "image": TImages.productImage5,
      "title": "Summer Dress",
      "subtitle": "Floral Design",
      "price": 34.99,
      "oldPrice": 44.99,
      "rating": 4.9,
      "reviews": 102,
    },
    {
      "image": TImages.productImage11,
      "title": "Shoulder Bag",
      "subtitle": "Casual Style",
      "price": 27.49,
      "oldPrice": null,
      "rating": 4.5,
      "reviews": 37,
    },
  ],
};

/// Small helper to access products by category. This keeps your existing
/// `categoryProducts` data and provides the requested API `ProductData.getProductsByCategory`.
class ProductData {
  ProductData._();

  static List<Map<String, dynamic>> getProductsByCategory(String category) {
    final list = categoryProducts[category];
    return list != null
        ? List<Map<String, dynamic>>.from(list)
        : <Map<String, dynamic>>[];
  }
}
