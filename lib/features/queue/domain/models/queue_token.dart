enum QueueStatus { waiting, approaching, serving, completed, cancelled }

class QueueToken {
  final String tokenId;
  final String ticketNumber; // e.g., A-104
  final String counterName;
  final String locationName;
  final int currentPosition;
  final int peopleAhead;
  final int predictedWaitMinutes;
  final String recommendedDepartureTime;
  final QueueStatus status;
  final DateTime createdAt;

  QueueToken({
    required this.tokenId,
    required this.ticketNumber,
    required this.counterName,
    required this.locationName,
    required this.currentPosition,
    required this.peopleAhead,
    required this.predictedWaitMinutes,
    required this.recommendedDepartureTime,
    required this.status,
    required this.createdAt,
  });
}
