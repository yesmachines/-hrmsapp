import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/constants/api_routes/api_routes.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/utils/loading_screen/loading_screen.dart';
import 'package:yes_hrm/utils/middleware/api_call_handler/api_call_handler.dart';
import 'package:yes_hrm/utils/no_data_page/no_data_page.dart';

enum AttachmentKind { image, pdf }

String resolveMediaUrl(String url) {
  final value = url.trim();
  if (value.isEmpty) return '';
  if (value.startsWith('https://') || value.startsWith('http://')) {
    return value;
  }
  if (value.startsWith('/')) return '${ApiRoutes.baseUrl}$value';
  return '${ApiRoutes.baseUrl}/$value';
}

AttachmentKind? attachmentKindFrom({
  required String name,
  required String url,
  String? contentType,
}) {
  final haystack = '${name.toLowerCase()} ${url.toLowerCase()}';
  final type = contentType?.toLowerCase() ?? '';
  if (type.contains('pdf') || haystack.contains('.pdf')) {
    return AttachmentKind.pdf;
  }
  const imageHints = [
    '.png',
    '.jpg',
    '.jpeg',
    '.gif',
    '.webp',
    '.heic',
    '.bmp',
    'image/',
  ];
  if (type.contains('image') || imageHints.any(haystack.contains)) {
    return AttachmentKind.image;
  }
  return null;
}

bool _bytesLookLikePdf(Uint8List bytes) {
  return bytes.length >= 4 &&
      bytes[0] == 0x25 &&
      bytes[1] == 0x50 &&
      bytes[2] == 0x44 &&
      bytes[3] == 0x46;
}

Future<void> openAttachmentViewer({
  required String url,
  String name = 'Attachment',
}) async {
  final resolved = resolveMediaUrl(url);
  if (resolved.isEmpty) {
    notificationHandler.sendNotification(
      message: 'Attachment not available',
      notificationType: .warning,
    );
    return;
  }
  await Get.to(
    () => AttachmentViewerPage(url: resolved, name: name),
  );
}

class AttachmentViewerPage extends StatefulWidget {
  const AttachmentViewerPage({
    super.key,
    required this.url,
    required this.name,
  });

  final String url;
  final String name;

  @override
  State<AttachmentViewerPage> createState() => _AttachmentViewerPageState();
}

class _AttachmentViewerPageState extends State<AttachmentViewerPage> {
  bool _loading = true;
  bool _hasError = false;
  Uint8List? _bytes;
  AttachmentKind _kind = AttachmentKind.image;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final response = await dioApiCall().get(
        widget.url,
        options: Options(responseType: ResponseType.bytes),
      );
      final raw = response.data;
      final bytes = raw is Uint8List
          ? raw
          : Uint8List.fromList(List<int>.from(raw as List));
      final contentType = response.headers.value('content-type');
      final kind =
          attachmentKindFrom(
            name: widget.name,
            url: widget.url,
            contentType: contentType,
          ) ??
          (_bytesLookLikePdf(bytes)
              ? AttachmentKind.pdf
              : AttachmentKind.image);
      if (!mounted) return;
      setState(() {
        _bytes = bytes;
        _kind = kind;
        _loading = false;
        _hasError = false;
      });
    } catch (e) {
      appVariables.errorPrinting(e);
      if (!mounted) return;
      setState(() {
        _loading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kind == AttachmentKind.image
          ? appColors.blackColor
          : appColors.scaffoldGreyColor,
      appBar: TitleAppBar(title: widget.name),
      body: SafeArea(child: _body()),
    );
  }

  Widget _body() {
    if (_loading) {
      return Center(
        child: LoadingScreen(
          loaderColor: _kind == AttachmentKind.image
              ? appColors.whiteColor
              : appColors.brandColor,
        ),
      );
    }
    if (_hasError || _bytes == null) {
      return ColoredBox(
        color: appColors.scaffoldGreyColor,
        child: const NoDataPage(message: 'Unable to open attachment'),
      );
    }
    if (_kind == AttachmentKind.pdf) {
      return PDFView(
        pdfData: _bytes,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        backgroundColor: appColors.scaffoldGreyColor,
        onError: (_) {
          if (!mounted) return;
          setState(() => _hasError = true);
        },
      );
    }
    return InteractiveViewer(
      minScale: 0.8,
      maxScale: 5,
      child: Center(
        child: Image.memory(
          _bytes!,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return ColoredBox(
              color: appColors.scaffoldGreyColor,
              child: const NoDataPage(message: 'Unable to open attachment'),
            );
          },
        ),
      ),
    );
  }
}
