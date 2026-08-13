import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/view/employee_screens/employee_home_screen/service/model/home_screen_tile_model.dart';

import '../../../../main.dart';

class HomeScreenController extends GetxController with Bindings {
  late final List<HomeScreenTileModel> tiles = [
    HomeScreenTileModel(
      title: 'Events Today',
      lines: const ['Friday Lunch Party', '3 Others Scheduled'],
      icon: Icons.confirmation_number_outlined,
      startColor: appColors.tileOrange,
      endColor: const Color(0xFFEA580C),
    ),
    HomeScreenTileModel(
      title: '3 Alerts',
      lines: const ['Leave Approved', 'Salary Pending', '2 Others Scheduled'],
      icon: Icons.notifications_active_outlined,
      startColor: appColors.tilePink,
      endColor: const Color(0xFFDB2777),
    ),
    HomeScreenTileModel(
      title: 'Celebrations',
      lines: const ["Sabbir's Birthday", "Muhashin's work anniversary"],
      icon: Icons.celebration_outlined,
      startColor: appColors.tileTeal,
      endColor: const Color(0xFF0D9488),
    ),
    HomeScreenTileModel(
      title: 'Wallet',
      lines: const ['Bonus Approved', 'Salary'],
      icon: Icons.account_balance_wallet_outlined,
      startColor: appColors.tilePurple,
      endColor: const Color(0xFF7C3AED),
    ),
    HomeScreenTileModel(
      title: 'Expenses',
      lines: const ['3 Items List', 'Submitted for View'],
      icon: Icons.receipt_long_outlined,
      startColor: appColors.tileGold,
      endColor: const Color(0xFFD97706),
    ),
    HomeScreenTileModel(
      title: 'Leave',
      lines: const ['10 days remaining', '10 taken', 'Sick Leave: 5'],
      icon: Icons.event_busy_outlined,
      startColor: appColors.tileBlue,
      endColor: const Color(0xFF2563EB),
    ),
    HomeScreenTileModel(
      title: 'Performance',
      lines: const ['25/100 %'],
      icon: Icons.bar_chart_rounded,
      startColor: appColors.tileIndigo,
      endColor: const Color(0xFF4F46E5),
      progress: 0.25,
    ),
    HomeScreenTileModel(
      title: 'Documents',
      lines: const ['Insurance', 'HR Policy'],
      icon: Icons.folder_outlined,
      startColor: appColors.tileRoyal,
      endColor: const Color(0xFF1D4ED8),
    ),
    HomeScreenTileModel(
      title: 'Assets',
      lines: const ['Laptop', 'T Shirt (L)'],
      icon: Icons.computer_outlined,
      startColor: appColors.tileHotPink,
      endColor: const Color(0xFFBE185D),
    ),
    HomeScreenTileModel(
      title: 'Learning',
      lines: const ['You had Dated Training'],
      icon: Icons.school_outlined,
      startColor: appColors.tileSky,
      endColor: const Color(0xFF0284C7),
    ),
    HomeScreenTileModel(
      title: 'News',
      lines: const ['Office started in Saudi', 'New Egyptian Partnership'],
      icon: Icons.newspaper_outlined,
      startColor: appColors.tileRose,
      endColor: const Color(0xFFE11D48),
    ),
    HomeScreenTileModel(
      title: 'Polling',
      lines: const ['Closes in 1 hr 1:30 PM'],
      icon: Icons.how_to_vote_outlined,
      startColor: appColors.tileAmber,
      endColor: const Color(0xFFF59E0B),
    ),
    HomeScreenTileModel(
      title: 'Socials',
      lines: const ['New Post from Hussain'],
      icon: Icons.public_outlined,
      startColor: appColors.tileViolet,
      endColor: const Color(0xFF8B5CF6),
    ),
    HomeScreenTileModel(
      title: 'Magazines',
      lines: const ['Quarterly magazine', '4th edition'],
      icon: Icons.menu_book_outlined,
      startColor: appColors.tileRed,
      endColor: const Color(0xFFDC2626),
    ),
    HomeScreenTileModel(
      title: 'Upcoming Events',
      lines: const ['Gulf Booking Expo', 'Ajlam Expo'],
      icon: Icons.event_note_outlined,
      startColor: appColors.tileBlue,
      endColor: const Color(0xFF1D4ED8),
    ),
    HomeScreenTileModel(
      title: 'Directory',
      lines: const ['240 Colleagues'],
      icon: Icons.badge_outlined,
      startColor: appColors.tileCyan,
      endColor: const Color(0xFF0891B2),
    ),
    HomeScreenTileModel(
      title: 'Ideas',
      lines: const ['Submit New Idea', 'Active Campaign'],
      icon: Icons.lightbulb_outline,
      startColor: appColors.tileGold,
      endColor: const Color(0xFFCA8A04),
    ),
    HomeScreenTileModel(
      title: 'Help',
      lines: const ['HR Support Desk'],
      icon: Icons.help_outline,
      startColor: appColors.tileSky,
      endColor: const Color(0xFF2563EB),
    ),
    HomeScreenTileModel(
      title: 'Visits',
      lines: const ["Today's Visits: 0"],
      icon: Icons.groups_outlined,
      startColor: appColors.tileSteel,
      endColor: const Color(0xFF475569),
    ),
    HomeScreenTileModel(
      title: 'Beyond Work',
      lines: const ['Activities - 11'],
      icon: Icons.favorite_border,
      startColor: appColors.tileDeepPurple,
      endColor: const Color(0xFF5B21B6),
    ),
  ];

  void onTileTap(HomeScreenTileModel tile) {
    switch (tile.title) {
      case 'Ideas':
        Get.toNamed(appRoutes.ideas);
        break;
      default:
        break;
    }
  }

  @override
  void dependencies() {
    Get.put(HomeScreenController());
  }
}
