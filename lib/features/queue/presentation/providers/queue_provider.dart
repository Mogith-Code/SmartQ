import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../domain/models/queue_token.dart';
import '../../domain/models/service_category.dart';

class QueueState {
  final QueueToken? activeToken;
  final List<ServiceCategory> services;
  final List<QueueToken> history;
  final String aiRushStatus;
  final String aiOptimalVisitTime;
  final double aiPeakConfidence;

  const QueueState({
    this.activeToken,
    required this.services,
    required this.history,
    required this.aiRushStatus,
    required this.aiOptimalVisitTime,
    required this.aiPeakConfidence,
  });

  QueueState copyWith({
    QueueToken? activeToken,
    bool clearActiveToken = false,
    List<ServiceCategory>? services,
    List<QueueToken>? history,
    String? aiRushStatus,
    String? aiOptimalVisitTime,
    double? aiPeakConfidence,
  }) {
    return QueueState(
      activeToken: clearActiveToken ? null : (activeToken ?? this.activeToken),
      services: services ?? this.services,
      history: history ?? this.history,
      aiRushStatus: aiRushStatus ?? this.aiRushStatus,
      aiOptimalVisitTime: aiOptimalVisitTime ?? this.aiOptimalVisitTime,
      aiPeakConfidence: aiPeakConfidence ?? this.aiPeakConfidence,
    );
  }
}

class QueueNotifier extends StateNotifier<QueueState> {
  QueueNotifier()
      : super(
          QueueState(
            activeToken: QueueToken(
              ticketId: 'TKN-8842',
              tokenNumber: 'A-104',
              serviceId: 'srv-1',
              serviceName: 'Express Banking & Cash Clearance',
              categoryName: 'Banking',
              positionAhead: 3,
              estimatedWaitMinutes: 12,
              status: QueueStatus.waiting,
              counterNumber: 'Counter 03',
              issuedAt: DateTime.now().subtract(const Duration(minutes: 8)),
              qrData: 'SMARTQ-TKN-8842-A104-VAL',
            ),
            services: const [
              ServiceCategory(
                id: 'srv-1',
                title: 'Express Cash & Deposits',
                description: 'Quick counter for cash deposit, withdrawal & forex.',
                icon: LucideIcons.banknote,
                activeQueueCount: 7,
                avgWaitMinutes: 8,
                tag: 'Fast Track',
                accentColor: Color(0xFF00F2FE),
              ),
              ServiceCategory(
                id: 'srv-2',
                title: 'Account & Card Operations',
                description: 'New account setup, card issuance & KYC verification.',
                icon: LucideIcons.creditCard,
                activeQueueCount: 14,
                avgWaitMinutes: 18,
                tag: 'Normal Demand',
                accentColor: Color(0xFF4FACFE),
              ),
              ServiceCategory(
                id: 'srv-3',
                title: 'Loans & Mortgage Advisory',
                description: 'Personal loans, home mortgages & credit consulting.',
                icon: LucideIcons.building2,
                activeQueueCount: 4,
                avgWaitMinutes: 25,
                tag: 'High Priority',
                accentColor: Color(0xFF7F00FF),
              ),
              ServiceCategory(
                id: 'srv-4',
                title: 'VIP & Corporate Services',
                description: 'Dedicated lounge assistance for business accounts.',
                icon: LucideIcons.crown,
                activeQueueCount: 2,
                avgWaitMinutes: 5,
                tag: 'VIP Express',
                accentColor: Color(0xFFE100FF),
              ),
            ],
            history: [
              QueueToken(
                ticketId: 'TKN-7719',
                tokenNumber: 'B-042',
                serviceId: 'srv-2',
                serviceName: 'Account & Card Operations',
                categoryName: 'Banking',
                positionAhead: 0,
                estimatedWaitMinutes: 0,
                status: QueueStatus.completed,
                counterNumber: 'Counter 01',
                issuedAt: DateTime.now().subtract(const Duration(days: 2)),
                qrData: 'SMARTQ-TKN-7719-B042',
              ),
            ],
            aiRushStatus: 'Moderate (62% capacity)',
            aiOptimalVisitTime: '2:30 PM - 3:45 PM',
            aiPeakConfidence: 0.94,
          ),
        );

  void joinQueue(ServiceCategory service) {
    final newTokenIndex = (state.services.firstWhere((s) => s.id == service.id).activeQueueCount) + 1;
    final tokenLetter = service.title.startsWith('Express') ? 'A' : (service.title.startsWith('Account') ? 'B' : 'C');
    final tokenNum = '$tokenLetter-${100 + newTokenIndex}';

    final newToken = QueueToken(
      ticketId: 'TKN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      tokenNumber: tokenNum,
      serviceId: service.id,
      serviceName: service.title,
      categoryName: 'SmartQ Virtual Line',
      positionAhead: service.activeQueueCount,
      estimatedWaitMinutes: service.avgWaitMinutes,
      status: QueueStatus.waiting,
      counterNumber: 'Counter 0${(newTokenIndex % 4) + 1}',
      issuedAt: DateTime.now(),
      qrData: 'SMARTQ-TKN-$tokenNum-VAL',
    );

    // Update service count
    final updatedServices = state.services.map((s) {
      if (s.id == service.id) {
        return ServiceCategory(
          id: s.id,
          title: s.title,
          description: s.description,
          icon: s.icon,
          activeQueueCount: s.activeQueueCount + 1,
          avgWaitMinutes: s.avgWaitMinutes,
          tag: s.tag,
          accentColor: s.accentColor,
        );
      }
      return s;
    }).toList();

    state = state.copyWith(
      activeToken: newToken,
      services: updatedServices,
    );
  }

  void cancelToken() {
    if (state.activeToken != null) {
      final cancelledToken = state.activeToken!.copyWith(status: QueueStatus.cancelled);
      state = state.copyWith(
        clearActiveToken: true,
        history: [cancelledToken, ...state.history],
      );
    }
  }

  void snoozeToken5Mins() {
    if (state.activeToken != null) {
      state = state.copyWith(
        activeToken: state.activeToken!.copyWith(
          positionAhead: state.activeToken!.positionAhead + 2,
          estimatedWaitMinutes: state.activeToken!.estimatedWaitMinutes + 5,
        ),
      );
    }
  }
}

final queueProvider = StateNotifierProvider<QueueNotifier, QueueState>((ref) {
  return QueueNotifier();
});
