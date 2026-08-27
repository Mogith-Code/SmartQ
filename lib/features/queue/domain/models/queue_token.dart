enum QueueStatus {
  waiting,
  called,
  serving,
  completed,
  cancelled,
}

class QueueToken {
  final String ticketId;
  final String tokenNumber; // e.g. "A-104"
  final String serviceId;
  final String serviceName;
  final String categoryName;
  final int positionAhead;
  final int estimatedWaitMinutes;
  final QueueStatus status;
  final String counterNumber; // e.g. "Counter 03"
  final DateTime issuedAt;
  final String qrData;

  const QueueToken({
    required this.ticketId,
    required this.tokenNumber,
    required this.serviceId,
    required this.serviceName,
    required this.categoryName,
    required this.positionAhead,
    required this.estimatedWaitMinutes,
    required this.status,
    required this.counterNumber,
    required this.issuedAt,
    required this.qrData,
  });

  QueueToken copyWith({
    String? ticketId,
    String? tokenNumber,
    String? serviceId,
    String? serviceName,
    String? categoryName,
    int? positionAhead,
    int? estimatedWaitMinutes,
    QueueStatus? status,
    String? counterNumber,
    DateTime? issuedAt,
    String? qrData,
  }) {
    return QueueToken(
      ticketId: ticketId ?? this.ticketId,
      tokenNumber: tokenNumber ?? this.tokenNumber,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      categoryName: categoryName ?? this.categoryName,
      positionAhead: positionAhead ?? this.positionAhead,
      estimatedWaitMinutes: estimatedWaitMinutes ?? this.estimatedWaitMinutes,
      status: status ?? this.status,
      counterNumber: counterNumber ?? this.counterNumber,
      issuedAt: issuedAt ?? this.issuedAt,
      qrData: qrData ?? this.qrData,
    );
  }
}
