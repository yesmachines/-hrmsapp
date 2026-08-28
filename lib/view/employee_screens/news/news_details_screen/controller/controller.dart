import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/news/news_listing_screen/service/model/news_model.dart';

class NewsDetailsController extends GetxController with Bindings {
  late final NewsModel news;

  @override
  void onInit() {
    final args = Get.arguments;
    if (args is NewsModel) {
      news = args;
    } else {
      news = NewsModel(
        id: '0',
        title: 'News',
        summary: '',
        body: '',
        category: NewsCategory.hr,
        date: DateTime.now(),
        author: '-',
      );
    }
    super.onInit();
  }

  String formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  void onViewAttachment(NewsAttachment file) {
    notificationHandler.sendNotification(
      message: 'Opening ${file.name}',
      notificationType: .success,
    );
  }

  void onDownloadAttachment(NewsAttachment file) {
    notificationHandler.sendNotification(
      message: 'Downloading ${file.name}',
      notificationType: .success,
    );
  }

  @override
  void dependencies() {
    Get.put(NewsDetailsController());
  }
}
