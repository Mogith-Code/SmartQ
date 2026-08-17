import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/ai_prediction_card.dart';
import '../../domain/models/queue_token.dart';

class LiveTicketScreen extends StatefulWidget {
  final QueueToken token;

  const LiveTicketScreen({Key? key, required this.token}) : super(key: key);

  @override
  State<LiveTicketScreen> createState() => _LiveTicketScreenState();
}

class _LiveTicketScreenState extends State<LiveTicketScreen> {
  late int peopleAhead;
  late int waitMinutes;

  @override
  void initState() {
    super.initState();
    peopleAhead = widget.token.peopleAhead;
    waitMinutes = widget.token.predictedWaitMinutes;
  }

  void _simulateQueueMovement() {
    if (peopleAhead > 0) {
      setState(() {
        peopleAhead--;
        waitMinutes = (peopleAhead * 3.5).round();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(LucideIcons.bellRing, color: Colors.white),
              SizedBox(width: 12),
              Text('Queue Updated! 1 turn served.'),
            ],
          ),
          backgroundColor: AppColors.accent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double progressPercent = (10 - peopleAhead) / 10.0;
    if (progressPercent < 0.1) progressPercent = 0.1;
    if (progressPercent > 1.0) progressPercent = 1.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Virtual Token'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.refreshCw),
            onPressed: _simulateQueueMovement,
            tooltip: 'Simulate Live Turn Drop',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Active Token Header Card
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.token.counterName,
                            style: const TextStyle(
                              color: AppColors.textSecondaryDark,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.token.locationName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.accent, width: 1),
                        ),
                        child: Row(
                          children: const [
                            Icon(LucideIcons.wifi, color: AppColors.accent, size: 14),
                            SizedBox(width: 6),
                            Text(
                              'LIVE SYNC',
                              style: TextStyle(
                                color: AppColors.accent,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Circular Queue Progress Indicator
                  CircularPercentIndicator(
                    radius: 90.0,
                    lineWidth: 12.0,
                    animation: true,
                    animateFromLastPercent: true,
                    percent: progressPercent,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.token.ticketNumber,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryLight,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'YOUR TOKEN',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: AppColors.accent,
                    backgroundColor: AppColors.cardBorderDark,
                  ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMetricItem(
                        icon: LucideIcons.users,
                        value: '$peopleAhead',
                        label: 'People Ahead',
                      ),
                      Container(height: 30, width: 1, color: AppColors.cardBorderDark),
                      _buildMetricItem(
                        icon: LucideIcons.clock,
                        value: '${waitMinutes}m',
                        label: 'Est. Wait Time',
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().slideY(begin: 0.1, end: 0, duration: 300.ms),

            const SizedBox(height: 20),

            // AI Inference Card Component
            AiPredictionCard(
              predictedMinutes: waitMinutes,
              departureTimeRecommendation: widget.token.recommendedDepartureTime,
            ),

            const SizedBox(height: 20),

            // QR Check-in Code Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorderDark),
              ),
              child: Row(
                children: [
                  QrImageView(
                    data: widget.token.tokenId,
                    version: QrVersions.auto,
                    size: 90.0,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: Colors.white,
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: AppColors.primaryLight,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'On-Site QR Verification',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Scan this barcode at the counter kiosk when your token is called for instant entry.',
                          style: TextStyle(
                            color: AppColors.textSecondaryDark,
                            fontSize: 13,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.accent, size: 18),
            const SizedBox(width: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondaryDark,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
