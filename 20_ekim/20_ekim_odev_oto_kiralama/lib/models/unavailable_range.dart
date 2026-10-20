class UnavailableRange {
  final DateTime startDate;
  final DateTime endDate;

  const UnavailableRange({
    required this.startDate,
    required this.endDate,
  });

  factory UnavailableRange.fromJson(Map<String, dynamic> json) {
    return UnavailableRange(
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UnavailableRange &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode => startDate.hashCode ^ endDate.hashCode;
}
