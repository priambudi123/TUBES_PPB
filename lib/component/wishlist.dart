// wishlist.dart

import 'package:flutter/foundation.dart';
import '../data/data.dart';

class Wishlist extends ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  void addToWishlist(Product product) {
    // Periksa apakah barang dengan nama yang sama sudah ada di dalam Wishlist
    bool isAlreadyAdded = _products.any((item) => item.name == product.name);

    if (!isAlreadyAdded) {
      _products.add(product);
      notifyListeners();
    }
  }

  void removeFromWishlist(int index) {
    if (index < _products.length) {
      _products.removeAt(index);
      notifyListeners();
    }
  }

  double getTotalPrice() {
    return _products.fold(
        0, (total, product) => total + double.parse(product.price));
  }
}
