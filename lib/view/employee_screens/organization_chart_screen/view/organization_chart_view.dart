import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/view/employee_screens/organization_chart_screen/controller/controller.dart';

class OrganizationChartView extends GetView<OrganizationChartController> {
  const OrganizationChartView({super.key});

  @override
  Widget build(BuildContext context) {
    final ancestors = controller.ancestors;
    final current = controller.current;
    final reports = controller.reports;

    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      appBar: TitleAppBar(title: "Organization Chart"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            appSize.size16.w,
            appSize.size8.h,
            appSize.size16.w,
            appSize.size24.h,
          ),
          child: Column(
            children: [
              for (final node in ancestors) ...[
                _OrgPersonCard(node: node),
                const _VerticalConnector(),
              ],
              _OrgPersonCard(node: current),
              if (reports.isNotEmpty) ...[
                if (reports.length == 1) ...[
                  const _VerticalConnector(),
                  _OrgPersonCard(node: reports.first),
                ] else
                  _BranchSection(nodes: reports),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BranchSection extends StatelessWidget {
  const _BranchSection({required this.nodes});

  final List<OrgChartNode> nodes;

  @override
  Widget build(BuildContext context) {
    final rows = <List<OrgChartNode>>[];
    for (var i = 0; i < nodes.length; i += 2) {
      rows.add(nodes.sublist(i, i + 2 > nodes.length ? nodes.length : i + 2));
    }

    return Column(
      children: [
        const _VerticalConnector(height: 16),
        for (var r = 0; r < rows.length; r++) ...[
          if (r == 0) _ForkBar(count: rows[r].length),
          if (r > 0) const _VerticalConnector(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final node in rows[r])
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 2.w,
                        height: 16.h,
                        color: appColors.strokeColor,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: _OrgPersonCard(node: node, compact: true),
                      ),
                    ],
                  ),
                ),
              if (rows[r].length == 1) const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ],
    );
  }
}

class _ForkBar extends StatelessWidget {
  const _ForkBar({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    if (count < 2) return const SizedBox.shrink();
    return SizedBox(
      height: 2.h,
      child: Row(
        children: [
          const Expanded(child: SizedBox()),
          Expanded(
            flex: 2,
            child: Container(height: 2.h, color: appColors.strokeColor),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

class _VerticalConnector extends StatelessWidget {
  const _VerticalConnector({this.height});

  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2.w,
      height: height ?? 20.h,
      color: appColors.strokeColor,
    );
  }
}

class _OrgPersonCard extends GetView<OrganizationChartController> {
  const _OrgPersonCard({required this.node, this.compact = false});

  final OrgChartNode node;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = controller.levelColors(node.level);
    final person = node.employee;
    final initials = person.name.isNotEmpty
        ? person.name
              .trim()
              .split(RegExp(r'\s+'))
              .where((part) => part.isNotEmpty)
              .take(2)
              .map((part) => part[0].toUpperCase())
              .join()
        : '?';

    return Align(
      child: Container(
        width: compact ? double.infinity : 220.w,
        padding: EdgeInsets.fromLTRB(
          appSize.size14.w,
          appSize.size16.h,
          appSize.size14.w,
          appSize.size14.h,
        ),
        decoration: BoxDecoration(
          color: appColors.whiteColor,
          borderRadius: BorderRadius.circular(appSize.radius16),
          border: Border.all(
            color: node.isCurrent
                ? appColors.brandColor.withValues(alpha: 0.45)
                : appColors.strokeColor.withValues(alpha: 0.7),
          ),
          boxShadow: [
            BoxShadow(
              color: appColors.blackColor.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: compact ? 52.w : 58.w,
              height: compact ? 52.w : 58.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: appColors.profileIconBlueBg,
                image: person.avatarUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(person.avatarUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: person.avatarUrl.isEmpty
                  ? Center(
                      child: Text(
                        initials,
                        style: fontStyles.font14Black600.copyWith(
                          color: appColors.brandColor,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(height: appSize.size10.h),
            Text(
              person.name,
              textAlign: TextAlign.center,
              style: fontStyles.font14Black600,
            ),
            if (person.designation.isNotEmpty) ...[
              SizedBox(height: 4.h),
              Text(
                person.designation,
                textAlign: TextAlign.center,
                style: fontStyles.font12LightGrey500.copyWith(
                  letterSpacing: 0,
                ),
              ),
            ],
            SizedBox(height: appSize.size10.h),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: appSize.size10.w,
                vertical: appSize.size4.h,
              ),
              decoration: BoxDecoration(
                color: colors.bg,
                borderRadius: BorderRadius.circular(appSize.radius60),
              ),
              child: Text(
                'Level ${node.level}',
                style: fontStyles.font10LightGrey500.copyWith(
                  color: colors.text,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
