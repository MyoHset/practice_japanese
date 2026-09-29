import 'package:flutter/foundation.dart';

/// Represents a unit within a study source along with user mastery progress.
@immutable
class UnitProgress {
  const UnitProgress({
    required this.id,
    required this.name,
    required this.orderNo,
    required this.total,
    required this.mastered,
  });

  final int id;
  final String name;
  final int orderNo;
  final int total;
  final int mastered;

  /// Ratio of mastered items to total items in [0.0, 1.0].
  /// Returns 0.0 when total is 0.
  double get ratio => total == 0 ? 0.0 : (mastered / total).clamp(0.0, 1.0);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitProgress &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          orderNo == other.orderNo &&
          total == other.total &&
          mastered == other.mastered;

  @override
  int get hashCode => Object.hash(id, name, orderNo, total, mastered);

  @override
  String toString() =>
      'UnitProgress(id: $id, name: $name, orderNo: $orderNo, total: $total, mastered: $mastered)';
}
