import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';

extension LibraryDocumentAddress on LibraryDocumentModel {
  static const _maxSlugLength = 200;

  // O slug é texto livre no painel: há resumos gravados nele, com `/` e espaço no fim, que não
  // sobrevivem ao endereço. Nesses casos vai o identificador, que o detalhe também procura.
  String? get addressKey {
    final slug = this.slug ?? '';
    final usableSlug = slug.isNotEmpty &&
        !slug.contains(RegExp(r'\s')) &&
        !slug.contains('/') &&
        slug.length <= _maxSlugLength;
    if (usableSlug) return Uri.encodeComponent(slug);

    final id = this.id?.trim() ?? '';
    return id.isEmpty ? null : Uri.encodeComponent(id);
  }
}
