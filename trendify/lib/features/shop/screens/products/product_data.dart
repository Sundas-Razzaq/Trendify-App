// import 'package:trendify/utils/constants/image_strings.dart';
import 'package:trendify/features/shop/models/product.dart';

/// Small helper to access products by category. Implement this to fetch
/// real product lists from your backend. Currently returns an empty list.
class ProductData {
  ProductData._();

  // Returns an empty list for now. Replace this implementation with
  // a service call that fetches `List<Product>` from your backend.
  static List<Product> getProductsByCategory(String category) {
    return <Product>[];
  }
}
