import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/models/service_counter.dart';
import '../../domain/models/queue_token.dart';
import 'live_ticket_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<ServiceCounter> counters = [
    ServiceCounter(
      id: 'c1',
      name: 'OPD General Consultation',
      category: 'Healthcare',
      locationName: 'City General Hospital',
      activeQueueCount: 7,
      averageServiceTimeMinutes: 4,
    ),
    ServiceCounter(
      id: 'c2',
      name: 'Teller & Cash Deposits',
      category: 'Banking',
      locationName: 'Apex Commercial Bank (Main Branch)',
      activeQueueCount: 12,
      averageServiceTimeMinutes: 3,
    ),
    ServiceCounter(
      id: 'c3',
      name: 'Passport & License Renewal',
      category: 'Government',
      locationName: 'District Secretariat Office',
      activeQueueCount: 19,
      averageServiceTimeMinutes: 6,
    ),
    ServiceCounter(
      id: 'c4',
      name: 'Pharmacy & Drug Distribution',
      category: 'Healthcare',
      locationName: 'City General Hospital',
      activeQueueCount: 4,
      averageServiceTimeMinutes: 2,
    ),
  ];

  String selectedCategory = 'All';

  void _joinQueue(ServiceCounter counter) {
    // Generate mock active token
    final newToken = QueueToken(
      tokenId: 'SMARTQ-${counter.id}-${DateTime.now().millisecondsSinceEpoch}',
      ticketNumber: 'A-104',
      counterName: counter.name,
      locationName: counter.locationName,
      currentPosition: 6,
      peopleAhead: counter.activeQueueCount,
      predictedWaitMinutes: counter.activeQueueCount * counter.averageServiceTimeMinutes,
      recommendedDepartureTime: '10:45 AM (Leave in 20m)',
      status: QueueStatus.waiting,
      createdAt: DateTime.now(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveTicketScreen(token: newToken),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredCounters = selectedCategory == 'All'
        ? counters
        : counters.where((c) => c.category == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(LucideIcons.sparkles, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            const Text(
              'SmartQ',
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.bell),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Search & Header Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'No Lines, No Waiting. 🚀',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Join queues remotely and receive AI smart departure alerts.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Search Field
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search hospital, bank, counter...',
                      hintStyle: const TextStyle(color: AppColors.textSecondaryDark),
                      prefixIcon: const Icon(LucideIcons.search, color: AppColors.primaryLight),
                      filled: true,
                      fillColor: AppColors.cardDark,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: AppColors.cardBorderDark),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: AppColors.cardBorderDark),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Category Filter Buttons
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'Healthcare', 'Banking', 'Government'].map((cat) {
                        final isSelected = selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            selectedColor: AppColors.primary,
                            backgroundColor: AppColors.cardDark,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textSecondaryDark,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: isSelected ? AppColors.primary : AppColors.cardBorderDark,
                              ),
                            ),
                            onSelected: (val) {
                              setState(() {
                                selectedCategory = cat;
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Counter List Section
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final counter = filteredCounters[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildCounterCard(counter),
                  );
                },
                childCount: filteredCounters.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterCard(ServiceCounter counter) {
    final estWait = counter.activeQueueCount * counter.averageServiceTimeMinutes;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  counter.category,
                  style: const TextStyle(
                    color: AppColors.primaryLight,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(LucideIcons.users, size: 14, color: AppColors.textSecondaryDark),
              const SizedBox(width: 4),
              Text(
                '${counter.activeQueueCount} in line',
                style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            counter.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(LucideIcons.mapPin, size: 14, color: AppColors.textSecondaryDark),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  counter.locationName,
                  style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AI Predicted Wait',
                    style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 11),
                  ),
                  Text(
                    '~$estWait mins',
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _joinQueue(counter),
                icon: const Icon(LucideIcons.ticket, size: 18),
                label: const Text('Join Queue'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.05, end: 0);
  }
}
