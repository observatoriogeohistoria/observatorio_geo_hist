import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:observatorio_geo_hist/app/core/components/buttons/custom_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/divider/divider.dart';
import 'package:observatorio_geo_hist/app/core/components/loading/circular_loading.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';
import 'package:pdfx/pdfx.dart';

class LibraryDocumentViewer extends StatefulWidget {
  const LibraryDocumentViewer({
    required this.document,
    super.key,
  });

  final LibraryDocumentModel document;

  @override
  State<LibraryDocumentViewer> createState() => _LibraryDocumentViewerState();
}

class _LibraryDocumentViewerState extends State<LibraryDocumentViewer> {
  late final PdfController _pdfController;

  bool _hasError = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _pdfController = PdfController(
      document: PdfDocument.openData(_fetchDocument(widget.document.documentUrl ?? '')),
      initialPage: 1,
    );
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: SecondaryButton.small(
            text: 'Baixar Documento',
            onPressed: _saveDocument,
          ),
        ),
        const AppDivider(),
        Expanded(
          child: Stack(
            children: [
              PdfView(
                controller: _pdfController,
                pageSnapping: false,
                physics: const NeverScrollableScrollPhysics(),
                onDocumentLoaded: (_) {
                  if (!mounted) return;
                  setState(() => _isLoading = false);
                },
                onDocumentError: (_) {
                  if (!mounted) return;
                  setState(() => _hasError = true);
                },
              ),
              if (_isLoading) const CircularLoading(),
              if (_hasError)
                AppTitle.medium(
                  text: "Error ao carregar o documento",
                  color: AppTheme.colors.darkGray,
                ),
            ],
          ),
        ),
        const AppDivider(),
        SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
        AppTitle.medium(
          text:
              '${_pdfController.page}${_pdfController.pagesCount != null ? '/${_pdfController.pagesCount!}' : ''}',
          color: AppTheme.colors.darkGray,
        ),
        SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IntrinsicHeight(
              child: CustomIconButton(
                icon: Icons.arrow_back_ios_outlined,
                onTap: () => _jumpToPage(false),
              ),
            ),
            SizedBox(width: AppTheme.dimensions.space.medium.horizontalSpacing),
            IntrinsicHeight(
              child: CustomIconButton(
                icon: Icons.arrow_forward_ios_outlined,
                onTap: () => _jumpToPage(true),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _jumpToPage(bool isNext) {
    _pdfController
        .animateToPage(
      _pdfController.page + (isNext ? 1 : -1),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    )
        .then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  Future<Uint8List> _fetchDocument(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) return response.bodyBytes;

      throw Exception('Falha ao baixar o documento: ${response.statusCode}');
    } catch (error) {
      throw Exception('Erro ao baixar o documento: $error');
    }
  }

  Future<void> _saveDocument() async {
    final url = widget.document.documentUrl;
    if (url == null) return;

    openUrl(url);

    final bytes = await fetchUrl(url);
    if (bytes == null) return;

    final extension = url.split('.').last;

    await FileSaver.instance.saveFile(
      name: widget.document.slug ?? widget.document.title,
      bytes: bytes,
      fileExtension: extension,
      mimeType: MimeType.get(extension) ?? MimeType.other,
    );
  }
}
