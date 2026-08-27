import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_theme.dart';
import '../../auth/presentation/widgets/glass_container.dart';
import '../providers/queue_provider.dart';

class LiveTicketScreen extends ConsumerStatefulWidget {
  const LiveTicketScreen({super.key});

  @override
  ConsumerState<LiveTicketScreen> createState() => _LiveTicketScreenState();
}

class _LiveTicketScreenState extends ConsumerState<LiveTicketScreen> {
  bool _audioNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final queueState = ref.watch(queueProvider);
    final activeToken = queueState.activeToken;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Live Ticket Virtual Pass',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _audioNotificationsEnabled ? LucideIcons.bellRing : LucideIcons.bellOff,
              color: _audioNotificationsEnabled ? AppColors.primaryCyan : AppColors.textMuted,
            ),
            onPressed: () {
              setState(() => _audioNotificationsEnabled = !_audioNotificationsEnabled);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 1),
                  content: Text(
                    _audioNotificationsEnabled
                        ? 'Audio proximity alerts enabled!'
                        : 'Audio proximity alerts muted',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: activeToken == null
          ? _buildNoActiveTicketView(context)
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // 1. Live Ticket Pass Card
                  _buildTicketPassCard(context, activeToken),

                  const SizedBox(height: 24),

                  // 2. Queue Progress Stepper
                  _buildProgressStepper(activeToken),

                  const SizedBox(height: 24),

                  // 3. Quick Action Buttons
                  _buildActionControls(context),
                ],
              ),
            ),
    );
  }

  Widget _buildNoActiveTicketView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.ticketX, size: 72, color: AppColors.textMuted.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            'No Active Ticket',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Join a virtual line from the service dashboard to get a ticket.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(LucideIcons.arrowLeft, size: 18),
            label: const Text('Return to Services'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryCyan,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketPassCard(BuildContext context, dynamic token) {
    return GlassContainer(
      borderRadius: 28,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Service Tag & Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryCyan.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryCyan.withValues(alpha: 0.3)),
                ),
                child: Text(
                  token.serviceName,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryCyan,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.success),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(end: const Offset(1.6, 1.6)),
                    const SizedBox(width: 6),
                    Text(
                      'ACTIVE LINE',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.extrabold,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Big Token Number Display
          ShaderMask(
            shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
            child: Text(
              token.tokenNumber,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 64,
                fontWeight: FontWeight.black,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),

          Text(
            'Assigned ${token.counterNumber}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 20),

          // QR Code View Container
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryCyan.withValues(alpha: 0.25),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: QrImageView(
              data: token.qrData,
              version: QrVersions.auto,
              size: 160.0,
              backgroundColor: Colors.white,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Scan at Counter Kiosk when called',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: AppColors.textMuted,
            ),
          ),

          const SizedBox(height: 20),
          const Divider(color: AppColors.glassBorder),
          const SizedBox(height: 16),

          // Metrics Grid: Position Ahead & Estimated Wait
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'PEOPLE AHEAD',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMuted,,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${token.positionAhead} People',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.extrabold,
                        color: AppColors.primaryCyan,
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.glassBorder),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'ESTIMATED WAIT',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '~${token.estimatedWaitMinutes} Mins',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.extrabold,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStepper(dynamic token) {
    return GlassContainer(
      borderRadius: 24,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Queue Journey Status',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildStepRow(
            isDone: true,
            isCurrent: false,
            title: 'Virtual Ticket Issued',
            subtitle: 'Joined queue via SmartQ App',
            icon: LucideIcons.check,
          ),
          _buildStepLine(isDone: true),
          _buildStepRow(
            isDone: true,
            isCurrent: true,
            title: 'Waiting in Virtual Queue',
            subtitle: '${token.positionAhead} people ahead in line',
            icon: LucideIcons.clock,
          ),
          _buildStepLine(isDone: false),
          _buildStepRow(
            isDone: false,
            isCurrent: false,
            title: 'Counter Calling',
            subtitle: 'Proceed to ${token.counterNumber}',
            icon: LucideIcons.megaphone,
          ),
          _buildStepLine(isDone: false),
          _buildStepRow(
            isDone: false,
            isCurrent: false,
            title: 'Service Completed',
            subtitle: 'Scan QR at counter exit',
            icon: LucideIcons.flag,
          ),
        ],
      ),
    );
  }

  Widget _buildStepRow({
    required bool isDone,
    required bool isCurrent,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final color = isDone
        ? (isCurrent ? AppColors.primaryCyan : AppColors.success)
        : AppColors.textMuted;

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: isCurrent ? 2 : 1),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: isCurrent || isDone ? FontWeight.bold : FontWeight.normal,
                  color: isCurrent ? AppColors.primaryCyan : (isDone ? AppColors.textPrimary : AppColors.textMuted),
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine({required bool isDone}) {
    return Container(
      margin: const EdgeInsets.only(left: 17, top: 4, bottom: 4),
      width: 2,
      height: 20,
      color: isDone ? AppColors.success : AppColors.glassBorder,
    );
  }

  Widget _buildActionControls(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              ref.read(queueProvider.notifier).snoozeToken5Mins();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Snoozed! Moved back 2 positions (+5 mins).')),
              );
            },
            icon: const Icon(LucideIcons.clock, size: 18, color: AppColors.primaryCyan),
            label: const Text('Delay 5 Mins'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryCyan,
              side: const BorderSide(color: AppColors.primaryCyan),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              ref.read(queueProvider.notifier).cancelToken();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ticket cancelled successfully.')),
              );
              Navigator.of(context).pop();
            },
            icon: const Icon(LucideIcons.trash2, size: 18),
            label: const Text('Cancel Ticket'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error.withValues(alpha: 0.2),
              foregroundColor: AppColors.error,
              elevation: 0,
              side: const BorderSide(color: AppColors.error),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
