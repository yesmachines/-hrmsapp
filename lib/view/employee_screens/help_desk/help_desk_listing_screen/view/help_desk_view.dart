import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/utils/no_data_page/no_data_page.dart';
import 'package:yes_hrm/view/employee_screens/help_desk/help_desk_listing_screen/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/help_desk/help_desk_listing_screen/view/widgets/ticket_card.dart';

class HelpDeskView extends GetView<HelpDeskController> {
  const HelpDeskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      appBar: TitleAppBar(title: "Help Desk"),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.onAddTicket,
        backgroundColor: appColors.brandColor,
        shape: const CircleBorder(),
        child: Icon(
          Icons.add,
          color: appColors.whiteColor,
          size: appSize.icon26,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                appSize.size16.w,
                appSize.size8.h,
                appSize.size16.w,
                appSize.size8.h,
              ),
              child: Text(
                'MY TICKETS',
                style: fontStyles.font10LightGrey500.copyWith(
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                final tickets = controller.tickets;
                if (tickets.isEmpty) return const NoDataPage();
                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                    appSize.size16.w,
                    0,
                    appSize.size16.w,
                    90.h,
                  ),
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    return TicketCard(ticket: tickets[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
