import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user_model.dart';
import '../data/models/transaction_model.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _currentUser;
  List<TransactionModel> _transactions = [];

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  List<TransactionModel> get transactions => _transactions;

  AuthProvider() {
    _loadData();
  }

  void register(String name, String phone, String cni, String pin) {
    _currentUser = UserModel(
      fullName: name,
      phoneNumber: phone,
      idNumber: cni,
      pin: pin,
      balance: 250000.0,
    );
    notifyListeners();
    _saveData();
  }

  void logout() {
    _currentUser = null;
    _transactions = [];
    notifyListeners();
    _clearData();
  }

  bool verifyPin(String inputPin) {
    return _currentUser?.pin == inputPin;
  }

  // Dépôt
  void deposit(double amount) {
    if (_currentUser != null) {
      _currentUser!.balance += amount;
      _transactions.insert(0, TransactionModel(
        id: const Uuid().v4(),
        title: "Dépôt d'argent",
        amount: amount, // ✅ toujours positif
        date: DateTime.now(),
        type: TransactionType.reception,
      ));
      notifyListeners();
      _saveData();
    }
  }

  // Envoi d'argent
  bool transferMoney(String recipient, double amount) {
    if (_currentUser != null && _currentUser!.balance >= amount) {
      _currentUser!.balance -= amount;
      _transactions.insert(0, TransactionModel(
        id: const Uuid().v4(),
        title: "Envoi à $recipient",
        amount: amount, // ✅ positif — type 'envoi' indique la sortie
        date: DateTime.now(),
        type: TransactionType.envoi,
      ));
      notifyListeners();
      _saveData();
      return true;
    }
    return false;
  }

  // Paiement QR Code
  bool payByQRCode(String merchant, double amount) {
    if (_currentUser != null && _currentUser!.balance >= amount) {
      _currentUser!.balance -= amount;
      _transactions.insert(0, TransactionModel(
        id: const Uuid().v4(),
        title: "Paiement $merchant",
        amount: amount, // ✅ positif
        date: DateTime.now(),
        type: TransactionType.facture,
      ));
      notifyListeners();
      _saveData();
      return true;
    }
    return false;
  }

  // Paiement facture
  bool payBill(String serviceName, String reference, double amount) {
    if (_currentUser != null && _currentUser!.balance >= amount) {
      _currentUser!.balance -= amount;
      _transactions.insert(0, TransactionModel(
        id: const Uuid().v4(),
        title: "$serviceName - $reference",
        amount: amount, // ✅ positif
        date: DateTime.now(),
        type: TransactionType.facture,
      ));
      notifyListeners();
      _saveData();
      return true;
    }
    return false;
  }

  void updateUserInfo(String newName) {
    if (_currentUser != null) {
      _currentUser = UserModel(
        fullName: newName,
        phoneNumber: _currentUser!.phoneNumber,
        idNumber: _currentUser!.idNumber,
        pin: _currentUser!.pin,
        balance: _currentUser!.balance,
        favorites: _currentUser!.favorites,
      );
      notifyListeners();
      _saveData();
    }
  }

  bool changePin(String oldPin, String newPin) {
    if (_currentUser != null && _currentUser!.pin == oldPin) {
      _currentUser = UserModel(
        fullName: _currentUser!.fullName,
        phoneNumber: _currentUser!.phoneNumber,
        idNumber: _currentUser!.idNumber,
        pin: newPin,
        balance: _currentUser!.balance,
        favorites: _currentUser!.favorites,
      );
      notifyListeners();
      _saveData();
      return true;
    }
    return false;
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentUser != null) {
      await prefs.setString('user_data', jsonEncode(_currentUser!.toJson()));
      List<String> transactionsJson = _transactions
          .map((t) => jsonEncode(t.toJson()))
          .toList();
      await prefs.setStringList('transactions_data', transactionsJson);
    }
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString('user_data');
    if (userString != null) {
      _currentUser = UserModel.fromJson(jsonDecode(userString));
    }
    List<String>? transactionsList = prefs.getStringList('transactions_data');
    if (transactionsList != null) {
      _transactions = transactionsList
          .map((t) => TransactionModel.fromJson(jsonDecode(t)))
          .toList();
    }
    notifyListeners();
  }

  Future<void> _clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    await prefs.remove('transactions_data');
  }
}