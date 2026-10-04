import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:http/http.dart' as http;
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/state_message_box.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';
import 'package:pdfx/pdfx.dart';

enum _ViewerStatus { loading, ready, error }

typedef _RenderedPage = ({Uint8List bytes, double aspect});

class LibraryDocumentPdfViewer extends StatefulWidget {
  const LibraryDocumentPdfViewer({super.key, required this.url});

  final String? url;

  @override
  State<LibraryDocumentPdfViewer> createState() => _LibraryDocumentPdfViewerState();
}

class _LibraryDocumentPdfViewerState extends State<LibraryDocumentPdfViewer> {
  static const _cacheSize = 4;

  PdfDocument? _document;
  _ViewerStatus _status = _ViewerStatus.loading;
  int _page = 1;
  int? _pagesCount;
  final Map<int, _RenderedPage> _rendered = {};
  late double _aspect = AppTheme.dimensions.components.libraryViewerA4Aspect;
  bool _rendering = false;
  int _load = 0;

  String get _url => widget.url?.trim() ?? '';

  @override
  void initState() {
    super.initState();
    if (_url.isNotEmpty) _open();
  }

  @override
  void didUpdateWidget(covariant LibraryDocumentPdfViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url && _url.isNotEmpty) _open();
  }

  @override
  void dispose() {
    _load++;
    _document?.close();
    super.dispose();
  }

  Future<void> _open() async {
    final load = ++_load;
    _document?.close();
    _document = null;
    _rendered.clear();
    _rendering = false;
    setState(() {
      _status = _ViewerStatus.loading;
      _page = 1;
      _pagesCount = null;
      _aspect = AppTheme.dimensions.components.libraryViewerA4Aspect;
    });

    try {
      final response = await http.get(Uri.parse(_url));
      if (response.statusCode != 200) throw http.ClientException('${response.statusCode}');
      final bytes = response.bodyBytes;
      if (_isImage(bytes)) {
        await _showImage(bytes, load);
        return;
      }

      final document = await PdfDocument.openData(bytes);
      if (load != _load || !mounted) {
        document.close();
        return;
      }
      _document = document;
      _pagesCount = document.pagesCount;
      await _show(1);
    } catch (_) {
      if (load == _load && mounted) setState(() => _status = _ViewerStatus.error);
    }
  }

  // Alguns autores enviaram imagem no lugar do PDF, sem extensão no nome e servida como
  // octet-stream: só os primeiros bytes dizem o formato (JPEG, PNG, GIF, WebP).
  static bool _isImage(Uint8List bytes) {
    bool startsWith(List<int> signature, [int offset = 0]) {
      if (bytes.length < offset + signature.length) return false;
      for (var i = 0; i < signature.length; i++) {
        if (bytes[offset + i] != signature[i]) return false;
      }
      return true;
    }

    return startsWith([0xFF, 0xD8, 0xFF]) ||
        startsWith([0x89, 0x50, 0x4E, 0x47]) ||
        startsWith([0x47, 0x49, 0x46, 0x38]) ||
        (startsWith([0x52, 0x49, 0x46, 0x46]) && startsWith([0x57, 0x45, 0x42, 0x50], 8));
  }

  Future<void> _showImage(Uint8List bytes, int load) async {
    final image = await decodeImageFromList(bytes);
    final aspect = image.width / image.height;
    image.dispose();
    if (load != _load || !mounted) return;

    setState(() {
      _pagesCount = 1;
      _rendered[1] = (bytes: bytes, aspect: aspect);
      _aspect = aspect;
      _status = _ViewerStatus.ready;
    });
  }

  // Uma renderização por vez: cliques seguidos levam direto à última página pedida.
  Future<void> _show(int page) async {
    final document = _document;
    if (document == null) return;
    setState(() => _page = page);
    if (_rendering) return;

    _rendering = true;
    try {
      while (mounted && document == _document) {
        final target = _page;
        final rendered = _rendered[target] ?? await _render(document, target);
        if (!mounted || document != _document) return;
        _rendered[target] = rendered;
        if (_rendered.length > _cacheSize) _rendered.remove(_rendered.keys.first);
        if (target != _page) continue;

        setState(() {
          _aspect = rendered.aspect;
          _status = _ViewerStatus.ready;
        });
        return;
      }
    } catch (_) {
      if (mounted && document == _document) setState(() => _status = _ViewerStatus.error);
    } finally {
      if (document == _document) _rendering = false;
    }
  }

  Future<_RenderedPage> _render(PdfDocument document, int number) async {
    final page = await document.getPage(number);
    try {
      // O dobro do tamanho em pontos mantém o texto nítido em telas de alta densidade.
      final image = await page.render(
        width: page.width * 2,
        height: page.height * 2,
        format: PdfPageImageFormat.jpeg,
        backgroundColor: '#ffffff',
      );
      if (image == null) throw StateError('Página sem imagem');
      return (bytes: image.bytes, aspect: page.width / page.height);
    } finally {
      await page.close();
    }
  }

  void _go(int page) {
    _show(page);
    final count = _pagesCount;
    if (count == null) return;
    SemanticsService.sendAnnouncement(
      View.of(context),
      'Página $page de $count',
      TextDirection.ltr,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r16);

    if (_url.isEmpty) {
      return const StateMessageBox(
        icon: Icons.description_outlined,
        title: 'Arquivo indisponível',
        message: 'O arquivo deste documento ainda não foi enviado.',
      );
    }

    final Widget content;
    if (_status == _ViewerStatus.error) {
      content = _statePadding(
        StateMessageBox(
          icon: Icons.close,
          tone: StateMessageTone.error,
          title: 'Não foi possível exibir o documento',
          message: 'Use “Abrir documento” para ver o arquivo em outra aba.',
          action: PrimaryButton.small(text: 'Tentar de novo', onPressed: _open),
        ),
      );
    } else {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_bar(context), _sheet(context)],
      );
    }

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Visualizador do documento',
      child: Container(
        decoration: BoxDecoration(color: colors.surface, borderRadius: radius),
        // A borda vai por cima: por baixo, o fundo branco da barra apagava a curva dos cantos.
        foregroundDecoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(color: colors.line, width: AppTheme.dimensions.stroke.small),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(width: double.infinity, child: content),
      ),
    );
  }

  Widget _statePadding(Widget child) => Padding(
      padding: EdgeInsets.all(AppTheme.dimensions.components.libraryViewerStatePadding),
      child: child);

  Widget _bar(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final count = _pagesCount;
    final ready = _status == _ViewerStatus.ready && count != null;
    final label = count == null ? 'Página $_page' : 'Página $_page de $count';

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: components.libraryViewerBarPaddingV,
        horizontal: components.libraryViewerBarPaddingH,
      ),
      decoration: BoxDecoration(
        color: colors.page,
        border: Border(
          bottom: BorderSide(color: colors.line, width: AppTheme.dimensions.stroke.small),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ExcludeSemantics(
              child: Text(
                label,
                style: AppTheme.typography.of(context).small.copyWith(color: colors.inkSecondary),
              ),
            ),
          ),
          _PageButton(
            icon: Icons.chevron_left,
            tooltip: 'Página anterior',
            onPressed: ready && _page > 1 ? () => _go(_page - 1) : null,
          ),
          SizedBox(width: components.libraryViewerButtonGap),
          _PageButton(
            icon: Icons.chevron_right,
            tooltip: 'Próxima página',
            onPressed: ready && _page < count ? () => _go(_page + 1) : null,
          ),
        ],
      ),
    );
  }

  Widget _sheet(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final rendered = _rendered[_page];
    final count = _pagesCount;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: components.libraryViewerPageMargin),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = math.min(
            constraints.maxWidth * components.libraryViewerPageWidthFactor,
            components.libraryViewerPageMaxWidth,
          );
          final aspect = rendered?.aspect ?? _aspect;

          final Widget page;
          if (rendered != null) {
            page = Image.memory(
              rendered.bytes,
              fit: BoxFit.contain,
              gaplessPlayback: true,
              semanticLabel: count == null
                  ? 'Página $_page do documento'
                  : 'Página $_page de $count do documento',
            );
          } else if (_status == _ViewerStatus.loading) {
            page = Center(
              child: Semantics(
                liveRegion: true,
                child: Text(
                  'Carregando documento…',
                  style: AppTheme.typography.of(context).small.copyWith(color: colors.inkSecondary),
                ),
              ),
            );
          } else {
            page = const SizedBox.shrink();
          }

          return Center(
            child: Container(
              width: width,
              height: width / aspect,
              decoration: BoxDecoration(
                color: colors.page,
                boxShadow: AppTheme.dimensions.shadows.soft,
              ),
              child: page,
            ),
          );
        },
      ),
    );
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({required this.icon, required this.tooltip, required this.onPressed});

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r8);
    final size = Size.square(components.libraryViewerButton);

    return AppFocusRing(
      borderRadius: radius,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon),
        iconSize: components.libraryViewerButtonIcon,
        style: IconButton.styleFrom(
          fixedSize: size,
          minimumSize: size,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          foregroundColor: colors.ink,
          disabledForegroundColor: colors.lineStrong,
          hoverColor: colors.surface,
          focusColor: Colors.transparent,
          highlightColor: colors.line,
          shape: RoundedRectangleBorder(borderRadius: radius),
        ),
      ),
    );
  }
}
