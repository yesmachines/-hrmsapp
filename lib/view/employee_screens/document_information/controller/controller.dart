import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';

enum DocumentStatus { valid, expiringSoon, expired, none }

class DocumentItem {
  const DocumentItem({
    required this.title,
    required this.numberLabel,
    required this.numberValue,
    required this.expiryDate,
    this.status = DocumentStatus.none,
  });

  final String title;
  final String numberLabel;
  final String numberValue;
  final String expiryDate;
  final DocumentStatus status;
}

class DocumentInformationController extends GetxController with Bindings {
  final RxBool isEditing = false.obs;

  final RxList<DocumentItem> documents = <DocumentItem>[
    const DocumentItem(
      title: 'Passport',
      numberLabel: 'Passport Number',
      numberValue: 'P123456789',
      expiryDate: 'OCT 12, 2032',
      status: DocumentStatus.valid,
    ),
    const DocumentItem(
      title: 'Visa File Number',
      numberLabel: 'Visa File Number',
      numberValue: 'VF -2567 87652',
      expiryDate: 'May 12, 2032',
      status: DocumentStatus.expiringSoon,
    ),
    const DocumentItem(
      title: 'UID Number',
      numberLabel: 'UID Number',
      numberValue: 'UID-784-1990-1234567',
      expiryDate: 'No Expiry',
    ),
    const DocumentItem(
      title: 'Visa Expiry',
      numberLabel: 'Visa Expiry Number',
      numberValue: 'N/A',
      expiryDate: 'June 16, 2032',
      status: DocumentStatus.expiringSoon,
    ),
    const DocumentItem(
      title: 'Emirates ID Number',
      numberLabel: 'Emirates ID Number',
      numberValue: '784-1990-1234567-1',
      expiryDate: 'June 16, 2032',
      status: DocumentStatus.expiringSoon,
    ),
    const DocumentItem(
      title: 'Emirates ID Expiry',
      numberLabel: 'Emirates ID Number',
      numberValue: 'N/A',
      expiryDate: 'June 31, 2032',
    ),
    const DocumentItem(
      title: 'Labour ID Expiry',
      numberLabel: 'Emirates ID Number',
      numberValue: 'N/A',
      expiryDate: 'Dec 31, 2034',
      status: DocumentStatus.expired,
    ),
  ].obs;

  Color statusBg(DocumentStatus status) {
    switch (status) {
      case DocumentStatus.valid:
        return appColors.activeBadgeBg;
      case DocumentStatus.expiringSoon:
        return appColors.expiringBadgeBg;
      case DocumentStatus.expired:
        return appColors.expiredBadgeBg;
      case DocumentStatus.none:
        return Colors.transparent;
    }
  }

  Color statusText(DocumentStatus status) {
    switch (status) {
      case DocumentStatus.valid:
        return appColors.activeBadgeText;
      case DocumentStatus.expiringSoon:
        return appColors.expiringBadgeText;
      case DocumentStatus.expired:
        return appColors.expiredBadgeText;
      case DocumentStatus.none:
        return appColors.lightGreyColor;
    }
  }

  String statusLabel(DocumentStatus status) {
    switch (status) {
      case DocumentStatus.valid:
        return 'VALID';
      case DocumentStatus.expiringSoon:
        return 'EXPIRING SOON';
      case DocumentStatus.expired:
        return 'EXPIRED';
      case DocumentStatus.none:
        return '';
    }
  }

  void toggleEdit() {
    isEditing.value = !isEditing.value;
  }

  @override
  void dependencies() {
    Get.put(DocumentInformationController());
  }
}
