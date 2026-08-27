import 'package:flutter/material.dart';

class ServiceCategory {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final int activeQueueCount;
  final int avgWaitMinutes;
  final String tag;
  final Color accentColor;

  const ServiceCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.activeQueueCount,
    required this.avgWaitMinutes,
    required this.tag,
    required this.accentColor,
  });
}
