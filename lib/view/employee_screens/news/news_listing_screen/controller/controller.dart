import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/news/news_listing_screen/service/model/news_model.dart';

class NewsController extends GetxController with Bindings {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final Rxn<NewsCategory> selectedCategory = Rxn();
  final Rxn<DateTimeRange> selectedDateRange = Rxn();

  final List<NewsCategory> categoryOptions = NewsCategory.values;

  late final List<NewsModel> news = [
    NewsModel(
      id: '1',
      title: 'Important HR Policy Update',
      summary:
          'Please review the latest company policy updates regarding hybrid work arrangements and updated leave guidelines for all employees.',
      body:
          'We are pleased to inform all employees about the latest HR policy updates.\n\nPlease review the updated guidelines and follow all applicable requirements.',
      category: NewsCategory.hr,
      date: DateTime(2026, 8, 20),
      author: 'HR Admin',
      isPinned: true,
      actionItems: const [
        'Review the updated policy',
        'Complete the required acknowledgement',
        'Contact HR for clarification',
      ],
      attachments: const [
        NewsAttachment(
          name: 'HR_Policy_Update.pdf',
          type: NewsAttachmentType.pdf,
        ),
        NewsAttachment(
          name: 'Event_Poster.jpg',
          type: NewsAttachmentType.image,
        ),
      ],
    ),
    NewsModel(
      id: '2',
      title: 'Annual Company Event',
      summary:
          'Join us for the annual gathering at the main plaza. Food, games, and team activities are planned for everyone.',
      body:
          'We are excited to invite all employees to the annual company event at the main plaza.\n\nThe day will include team activities, food stalls, and recognition of outstanding contributions across departments.',
      category: NewsCategory.company,
      date: DateTime(2026, 8, 20),
      author: 'Events Team',
      actionItems: const [
        'Confirm your attendance',
        'Review the event schedule',
        'Coordinate with your team lead',
      ],
      attachments: const [
        NewsAttachment(
          name: 'Event_Poster.jpg',
          type: NewsAttachmentType.image,
        ),
      ],
    ),
    NewsModel(
      id: '3',
      title: 'New Safety Guidelines',
      summary:
          'Updated workplace safety procedures are now in effect. Please review the guidelines before your next shift.',
      body:
          'Updated workplace safety guidelines are now in effect across all locations.\n\nPlease review the procedures carefully and complete the required safety acknowledgement before your next shift.',
      category: NewsCategory.safety,
      date: DateTime(2026, 8, 20),
      author: 'Safety Officer',
      actionItems: const [
        'Read the new safety guidelines',
        'Complete the safety acknowledgement',
        'Report any hazards to your supervisor',
      ],
      attachments: const [
        NewsAttachment(
          name: 'Safety_Guidelines.pdf',
          type: NewsAttachmentType.pdf,
        ),
      ],
    ),
    NewsModel(
      id: '4',
      title: 'Payroll Processing Schedule',
      summary:
          'Payroll for August will be processed on the 28th. Please submit any pending claims before the cutoff date.',
      body:
          'Payroll for August will be processed on 28 August 2026.\n\nPlease ensure all pending claims, overtime, and reimbursements are submitted before the cutoff to avoid delays.',
      category: NewsCategory.hr,
      date: DateTime(2026, 8, 18),
      author: 'HR Admin',
    ),
    NewsModel(
      id: '5',
      title: 'Office Relocation Notice',
      summary:
          'The Dubai office will move to the new tower next month. More details on seating and access will follow.',
      body:
          'The Dubai office will relocate to the new tower next month.\n\nA detailed seating plan, access instructions, and moving timeline will be shared with all teams shortly.',
      category: NewsCategory.company,
      date: DateTime(2026, 8, 15),
      author: 'Facilities Team',
      attachments: const [
        NewsAttachment(
          name: 'Relocation_Plan.pdf',
          type: NewsAttachmentType.pdf,
        ),
      ],
    ),
  ];

  List<NewsModel> get filteredNews {
    final query = searchQuery.value.trim().toLowerCase();
    final category = selectedCategory.value;
    final range = selectedDateRange.value;

    final results = news.where((item) {
      if (category != null && item.category != category) return false;
      if (range != null) {
        final date = DateTime(item.date.year, item.date.month, item.date.day);
        final start = DateTime(range.start.year, range.start.month, range.start.day);
        final end = DateTime(range.end.year, range.end.month, range.end.day);
        if (date.isBefore(start) || date.isAfter(end)) return false;
      }
      if (query.isEmpty) return true;
      return item.title.toLowerCase().contains(query) ||
          item.summary.toLowerCase().contains(query) ||
          item.category.label.toLowerCase().contains(query) ||
          item.author.toLowerCase().contains(query);
    }).toList();

    results.sort((a, b) {
      if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
      return b.date.compareTo(a.date);
    });
    return results;
  }

  String get categoryLabel => selectedCategory.value?.label ?? 'Category';

  String get dateRangeLabel {
    final range = selectedDateRange.value;
    if (range == null) return 'Date Range';
    if (range.start.year == range.end.year &&
        range.start.month == range.end.month &&
        range.start.day == range.end.day) {
      return formatDate(range.start);
    }
    return '${DateFormat('dd MMM').format(range.start)} - ${formatDate(range.end)}';
  }

  void onSearchChanged(String value) => searchQuery.value = value;

  void onCategoryChanged(NewsCategory? category) {
    selectedCategory.value = category;
  }

  void clearDateRange() => selectedDateRange.value = null;

  Future<void> pickDateRange() async {
    final now = DateTime(2026, 8, 20);
    final picked = await showDateRangePicker(
      context: Get.context!,
      firstDate: DateTime(2024),
      lastDate: DateTime(2027, 12, 31),
      initialDateRange:
          selectedDateRange.value ??
          DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: appColors.brandColor,
              onPrimary: appColors.whiteColor,
              surface: appColors.whiteColor,
              onSurface: appColors.blackColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      selectedDateRange.value = picked;
    }
  }

  void onViewNews(NewsModel item) {
    Get.toNamed(appRoutes.newsDetails, arguments: item);
  }

  String formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  @override
  void dependencies() {
    Get.put(NewsController());
  }
}
