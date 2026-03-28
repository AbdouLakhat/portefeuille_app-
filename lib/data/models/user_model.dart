/// Modèle représentant un utilisateur du portefeuille numérique
class UserModel {
  static const String _fullNameKey = 'fullName';
  static const String _phoneNumberKey = 'phoneNumber';
  static const String _idNumberKey = 'idNumber';
  static const String _pinKey = 'pin';
  static const String _balanceKey = 'balance';
  static const String _favoritesKey = 'favorites';

  static const int _pinLength = 4;

  final String fullName;
  final String phoneNumber;
  final String idNumber; // Numéro CNI
  final String pin; // Code PIN
  double balance; // Solde du compte
  List<String> favorites; // Contacts favoris

  /// Crée une instance de UserModel
  ///
  /// [fullName] et [phoneNumber] ne peuvent pas être vides
  /// [pin] doit contenir exactement 4 chiffres
  /// [balance] doit être positif
  UserModel({
    required this.fullName,
    required this.phoneNumber,
    required this.idNumber,
    required this.pin,
    this.balance = 0.0,
    this.favorites = const [],
  }) {
    _validate();
  }

  /// Valide les paramètres du modèle
  void _validate() {
    if (fullName.trim().isEmpty) {
      throw ArgumentError('fullName ne peut pas être vide');
    }
    if (phoneNumber.trim().isEmpty) {
      throw ArgumentError('phoneNumber ne peut pas être vide');
    }
    if (idNumber.trim().isEmpty) {
      throw ArgumentError('idNumber ne peut pas être vide');
    }
    if (pin.length != _pinLength) {
      throw ArgumentError('pin doit contenir exactement $_pinLength chiffres');
    }
    if (!pin.contains(RegExp(r'^[0-9]+$'))) {
      throw ArgumentError('pin doit contenir uniquement des chiffres');
    }
    if (balance < 0) {
      throw ArgumentError('balance ne peut pas être négative');
    }
  }

  /// Crée une copie avec certains paramètres modifiés
  UserModel copyWith({
    String? fullName,
    String? phoneNumber,
    String? idNumber,
    String? pin,
    double? balance,
    List<String>? favorites,
  }) {
    return UserModel(
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      idNumber: idNumber ?? this.idNumber,
      pin: pin ?? this.pin,
      balance: balance ?? this.balance,
      favorites: favorites ?? List<String>.from(this.favorites),
    );
  }

  /// Ajoute un contact aux favoris
  void addFavorite(String phoneNumber) {
    if (!favorites.contains(phoneNumber)) {
      favorites.add(phoneNumber);
    }
  }

  /// Supprime un contact des favoris
  void removeFavorite(String phoneNumber) {
    favorites.remove(phoneNumber);
  }

  /// Vérifie si un contact est dans les favoris
  bool isFavorite(String phoneNumber) {
    return favorites.contains(phoneNumber);
  }

  /// Crédite le compte
  void deposit(double amount) {
    if (amount <= 0) {
      throw ArgumentError('amount doit être positif');
    }
    balance += amount;
  }

  /// Débite le compte
  bool withdraw(double amount) {
    if (amount <= 0) {
      throw ArgumentError('amount doit être positif');
    }
    if (balance < amount) {
      return false; // Solde insuffisant
    }
    balance -= amount;
    return true;
  }

  /// Convertit le modèle en JSON pour sauvegarder
  Map<String, dynamic> toJson() => {
    _fullNameKey: fullName,
    _phoneNumberKey: phoneNumber,
    _idNumberKey: idNumber,
    _pinKey: pin,
    _balanceKey: balance,
    _favoritesKey: favorites,
  };

  /// Crée une instance depuis un JSON
  ///
  /// Throws [FormatException] si les données JSON sont invalides
  factory UserModel.fromJson(Map<String, dynamic> json) {
    try {
      return UserModel(
        fullName: json[_fullNameKey] as String? ?? '',
        phoneNumber: json[_phoneNumberKey] as String? ?? '',
        idNumber: json[_idNumberKey] as String? ?? '',
        pin: json[_pinKey] as String? ?? '',
        balance: (json[_balanceKey] as num?)?.toDouble() ?? 0.0,
        favorites: List<String>.from(json[_favoritesKey] ?? []),
      );
    } catch (e) {
      throw FormatException('Erreur lors du parsing JSON: $e');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          fullName == other.fullName &&
          phoneNumber == other.phoneNumber &&
          idNumber == other.idNumber &&
          pin == other.pin &&
          balance == other.balance &&
          _listEquals(favorites, other.favorites);

  @override
  int get hashCode =>
      fullName.hashCode ^
      phoneNumber.hashCode ^
      idNumber.hashCode ^
      pin.hashCode ^
      balance.hashCode ^
      favorites.hashCode;

  /// Vérifie l'égalité de deux listes
  static bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  String toString() =>
      'UserModel(fullName: $fullName, phoneNumber: $phoneNumber, idNumber: $idNumber, balance: $balance, favorites: ${favorites.length})';
}
