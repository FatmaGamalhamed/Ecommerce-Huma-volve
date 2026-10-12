import 'package:flutter/foundation.dart';
import '../../../core/services/api_service.dart';

class ProductsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<dynamic> _products = [];
  bool _isLoading = false;
  String? _error;

  List<dynamic> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _apiService.getProducts();
    } catch (e) {
      _error = 'Failed to load products. Please try again.';
      debugPrint('FETCH PRODUCTS ERROR: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
