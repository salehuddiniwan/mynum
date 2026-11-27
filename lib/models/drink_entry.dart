/// The kinds of cup a drink can be logged with.
abstract final class CupType {
  static const cup = 'cup';
  static const glass = 'glass';
  static const bottle = 'bottle';
  static const other = 'other';

  static const all = [cup, glass, bottle, other];

  /// Size used by the one-tap buttons on the Today screen.
  static const sizes = {cup: 150, glass: 250, bottle: 500};

  static String label(String type) => switch (type) {
    cup => 'Cup',
    glass => 'Glass',
    bottle => 'Bottle',
    _ => 'Other',
  };
}

/// One drink the user logged. This is the app's main model class.
class DrinkEntry {
  const DrinkEntry({
    required this.id,
    required this.amountMl,
    required this.cupType,
    required this.loggedAt,
    this.dropsEarned = 0,
    this.reachedGoal = false,
  });

  /// Unique id, used to find this drink again when editing or deleting it.
  final String id;

  /// How much water, in millilitres.
  final int amountMl;

  /// One of [CupType.all]: 'cup', 'glass', 'bottle' or 'other'.
  final String cupType;

  /// When the drink was logged.
  final DateTime loggedAt;

  /// Drops (the in-app currency) this drink earned.
  final int dropsEarned;

  /// True if this drink is the one that completed the daily goal.
  final bool reachedGoal;

  /// A copy of this drink with some fields changed (used when editing).
  DrinkEntry copyWith({
    int? amountMl,
    String? cupType,
    int? dropsEarned,
    bool? reachedGoal,
  }) {
    return DrinkEntry(
      id: id,
      amountMl: amountMl ?? this.amountMl,
      cupType: cupType ?? this.cupType,
      loggedAt: loggedAt,
      dropsEarned: dropsEarned ?? this.dropsEarned,
      reachedGoal: reachedGoal ?? this.reachedGoal,
    );
  }

  /// Turns the drink into a map so it can be saved as JSON.
  Map<String, Object> toJson() => {
    'id': id,
    'amountMl': amountMl,
    'cupType': cupType,
    'loggedAt': loggedAt.millisecondsSinceEpoch,
    'dropsEarned': dropsEarned,
    'reachedGoal': reachedGoal,
  };

  /// Rebuilds a drink from the saved JSON map.
  factory DrinkEntry.fromJson(Map<String, dynamic> json) {
    return DrinkEntry(
      id: json['id'] as String,
      amountMl: json['amountMl'] as int,
      cupType: json['cupType'] as String? ?? CupType.other,
      loggedAt: DateTime.fromMillisecondsSinceEpoch(json['loggedAt'] as int),
      dropsEarned: json['dropsEarned'] as int? ?? 0,
      reachedGoal: json['reachedGoal'] as bool? ?? false,
    );
  }
}
