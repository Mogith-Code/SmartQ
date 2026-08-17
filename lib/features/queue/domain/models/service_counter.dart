class ServiceCounter {
  final String id;
  final String name;
  final String category; // Healthcare, Bank, Government
  final String locationName;
  final int activeQueueCount;
  final int averageServiceTimeMinutes;
  final bool isOpen;

  ServiceCounter({
    required this.id,
    required this.name,
    required this.category,
    required this.locationName,
    required this.activeQueueCount,
    required this.averageServiceTimeMinutes,
    this.isOpen = true,
  });

  factory ServiceCounter.fromJson(Map<String, dynamic> json) {
    return ServiceCounter(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      locationName: json['locationName'] as String,
      activeQueueCount: json['activeQueueCount'] as int,
      averageServiceTimeMinutes: json['averageServiceTimeMinutes'] as int,
      isOpen: json['isOpen'] as bool? ?? true,
    );
  }
}
