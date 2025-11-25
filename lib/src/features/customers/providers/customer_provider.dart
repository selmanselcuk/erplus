import 'package:flutter/foundation.dart';
import '../models/customer_model.dart';
import '../repositories/customer_repository.dart';

class CustomerProvider extends ChangeNotifier {
  final CustomerRepository _repository = CustomerRepository();

  List<Customer> _customers = [];
  List<Customer> _filteredCustomers = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  List<Customer> get customers => _filteredCustomers;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  // Tüm müşterileri yükle
  Future<void> loadCustomers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _customers = await _repository.getAllCustomers();
      _filteredCustomers = _customers;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Müşteri ara
  Future<void> searchCustomers(String query) async {
    _searchQuery = query;

    if (query.isEmpty) {
      _filteredCustomers = _customers;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _filteredCustomers = await _repository.searchCustomers(query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Yeni müşteri ekle
  Future<bool> addCustomer(Customer customer) async {
    try {
      final newCustomer = await _repository.createCustomer(customer);
      _customers.insert(0, newCustomer);
      _filteredCustomers = _customers;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Müşteri güncelle
  Future<bool> updateCustomer(Customer customer) async {
    try {
      await _repository.updateCustomer(customer);

      final index = _customers.indexWhere((c) => c.id == customer.id);
      if (index != -1) {
        _customers[index] = customer;
        _filteredCustomers = _customers;
        notifyListeners();
      }

      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Müşteri sil
  Future<bool> deleteCustomer(String id) async {
    try {
      await _repository.deleteCustomer(id);

      _customers.removeWhere((c) => c.id == id);
      _filteredCustomers = _customers;
      notifyListeners();

      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ID'ye göre müşteri getir
  Future<Customer?> getCustomerById(String id) async {
    try {
      return await _repository.getCustomerById(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Müşteri kodunun benzersiz olup olmadığını kontrol et
  Future<bool> isCodeUnique(String code, {String? excludeId}) async {
    try {
      return await _repository.isCodeUnique(code, excludeId: excludeId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Toplam müşteri sayısı
  Future<int> getCustomerCount() async {
    try {
      return await _repository.getCustomerCount();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return 0;
    }
  }

  // Hesap grubuna göre sayıları getir
  Future<Map<String, int>> getCustomerCountByGroup() async {
    try {
      return await _repository.getCustomerCountByGroup();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return {};
    }
  }

  // Hatayı temizle
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Filtreyi temizle
  void clearSearch() {
    _searchQuery = '';
    _filteredCustomers = _customers;
    notifyListeners();
  }
}
