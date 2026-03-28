/// Types de transactions possibles
enum TransactionType {
  envoi,
  reception,
  facture;

  /// Description textuelle du type de transaction
  String get label {
    return switch (this) {
      TransactionType.envoi => 'Envoi',
      TransactionType.reception => 'Réception',
      TransactionType.facture => 'Facture',
    };
  }
}

/// Modèle représentant une transaction financière
class TransactionModel {
  static const String _idKey = 'id';
  static const String _titleKey = 'title';
  static const String _amountKey = 'amount';
  static const String _dateKey = 'date';
  static const String _typeKey = 'type';

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;

  /// Crée une instance de TransactionModel
  ///
  /// [amount] doit être positif
  /// [title] ne doit pas être vide
  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
  }) {
    _validate();
  }

  /// Valide les paramètres
  void _validate() {
    if (id.isEmpty) {
      throw ArgumentError('id ne peut pas être vide');
    }
    if (title.isEmpty) {
      throw ArgumentError('title ne peut pas être vide');
    }
    if (amount < 0) {
      throw ArgumentError('amount doit être positif');
    }
  }

  /// Crée une copie avec certains paramètres modifiés
  TransactionModel copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    TransactionType? type,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
    );
  }

  /// Convertit le modèle en JSON pour sauvegarder
  Map<String, dynamic> toJson() => {
    _idKey: id,
    _titleKey: title,
    _amountKey: amount,
    _dateKey: date.toIso8601String(),
    _typeKey: type.name,
  };

  /// Crée une instance depuis un JSON
  ///
  /// Throws [FormatException] si les données JSON sont invalides
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    try {
      final typeString = json[_typeKey];
      final type = TransactionType.values.firstWhere(
        (t) => t.name == typeString,
        orElse: () => TransactionType.envoi,
      );

      return TransactionModel(
        id: json[_idKey] as String? ?? '',
        title: json[_titleKey] as String? ?? '',
        amount: (json[_amountKey] as num?)?.toDouble() ?? 0.0,
        date:
            DateTime.tryParse(json[_dateKey] as String? ?? '') ??
            DateTime.now(),
        type: type,
      );
    } catch (e) {
      throw FormatException('Erreur lors du parsing JSON: $e');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          amount == other.amount &&
          date == other.date &&
          type == other.type;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      amount.hashCode ^
      date.hashCode ^
      type.hashCode;

  @override
  String toString() =>
      'TransactionModel(id: $id, title: $title, amount: $amount, date: $date, type: ${type.label})';
}
