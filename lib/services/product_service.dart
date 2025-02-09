import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/product.dart';
import 'recipe_service.dart';

class ProductService extends ChangeNotifier {
  // Add StreamController for products
  final _productsStreamController = StreamController<List<Product>>.broadcast();

  // Expose stream for listeners
  Stream<List<Product>> get productsStream => _productsStreamController.stream;

  final List<Product> _products = [];
  RecipeService? _recipeService;

  void initRecipeService(RecipeService recipeService) {
    _recipeService = recipeService;
    _updateAvailableIngredients();
    // Initial stream value
    _productsStreamController.add(_products);
  }

  List<Product> get products => List.unmodifiable(_products);

  void _updateAvailableIngredients() {
    if (_recipeService != null) {
      final availableIngredients = _products.map((p) {
        // Ensure proper type conversion for quantity
        double quantity = p.quantity is int
            ? (p.quantity).toDouble()
            : (p.quantity as double);

        return {
          'name': p.name.toLowerCase(),
          'quantity': quantity,
          'unit': p.unit,
        };
      }).toList();

      // Update recipe service with the new ingredients
      _recipeService!.updateAvailableIngredients(availableIngredients);
    }
  }

  @override
  void dispose() {
    _productsStreamController.close();
    super.dispose();
  }

  void addProduct(Product product) {
    _products.add(product);
    _updateAvailableIngredients();
    _productsStreamController.add(_products); // Notify stream listeners
    notifyListeners();
  }

  void updateProduct(Product updatedProduct) {
    final index =
        _products.indexWhere((product) => product.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      _updateAvailableIngredients();
      _productsStreamController.add(_products); // Notify stream listeners
      notifyListeners();
    }
  }

  List<Product> getExpiringProducts() {
    final now = DateTime.now();
    return _products.where((product) {
      final daysUntilExpiration = product.expirationDate.difference(now).inDays;
      return daysUntilExpiration <= 3 && daysUntilExpiration >= 0;
    }).toList();
  }

  void deleteProduct(String id) {
    _products.removeWhere((product) => product.id == id);
    _updateAvailableIngredients();
    _productsStreamController.add(_products); // Notify stream listeners
    notifyListeners();
  }

  List<Product> getFilteredProducts(String category, String searchQuery) {
    return _products.where((product) {
      final matchesCategory = category == 'Все' || product.category == category;
      final matchesSearch =
          product.name.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }
}
