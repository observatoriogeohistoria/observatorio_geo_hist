import 'package:collection/collection.dart';

class LibraryDocumentModel {
  final String author;
  final DocumentArea area;
  final List<DocumentCategory> categories;
  final String createdAt;
  final String documentUrl;
  final String institution;
  final String slug;
  final String status;
  final String title;
  final DocumentType type;
  final int year;

  LibraryDocumentModel({
    required this.author,
    required this.area,
    required this.categories,
    required this.createdAt,
    required this.documentUrl,
    required this.institution,
    required this.slug,
    required this.status,
    required this.title,
    required this.type,
    required this.year,
  });

  factory LibraryDocumentModel.fromJson(Map<String, dynamic> json) {
    return LibraryDocumentModel(
      author: json['author'] ?? '',
      area: DocumentArea.fromKey(json['area']) ?? DocumentArea.geografia,
      categories: json['categories']
              ?.map((e) => DocumentCategory.fromKey(e))
              .whereType<DocumentCategory>()
              .toList() ??
          [],
      createdAt: json['createdAt'] ?? '',
      documentUrl: json['documentUrl'] ?? '',
      institution: json['institution'] ?? '',
      slug: json['slug'] ?? '',
      status: json['status'] ?? '',
      title: json['title'] ?? '',
      type: DocumentType.fromKey(json['type']) ?? DocumentType.tese,
      year: json['year'] is int ? json['year'] : int.tryParse(json['year']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'area': area.value,
      'categories': categories.map((e) => e.value).toList(),
      'createdAt': createdAt,
      'documentUrl': documentUrl,
      'institution': institution,
      'slug': slug,
      'status': status,
      'title': title,
      'type': type.value,
      'year': year,
    };
  }

  LibraryDocumentModel copyWith({
    String? author,
    DocumentArea? area,
    List<DocumentCategory>? categories,
    String? createdAt,
    String? documentUrl,
    String? institution,
    String? slug,
    String? status,
    String? title,
    DocumentType? type,
    int? year,
  }) {
    return LibraryDocumentModel(
      author: author ?? this.author,
      area: area ?? this.area,
      categories: categories ?? this.categories,
      createdAt: createdAt ?? this.createdAt,
      documentUrl: documentUrl ?? this.documentUrl,
      institution: institution ?? this.institution,
      slug: slug ?? this.slug,
      status: status ?? this.status,
      title: title ?? this.title,
      type: type ?? this.type,
      year: year ?? this.year,
    );
  }
}

enum DocumentArea {
  geografia('Geografia'),
  historia('História');

  final String value;
  const DocumentArea(this.value);

  String get routeKey => switch (this) {
        DocumentArea.geografia => 'geografia',
        DocumentArea.historia => 'historia',
      };

  static DocumentArea? fromRouteKey(String? key) {
    return DocumentArea.values.firstWhereOrNull((e) => e.routeKey == key);
  }

  static DocumentArea? fromKey(String? value) {
    if (value == null) return null;
    return DocumentArea.values.firstWhereOrNull((e) => e.value == value);
  }
}

enum DocumentType {
  tese('Tese'),
  dissertacao('Dissertação');

  final String value;
  const DocumentType(this.value);

  static DocumentType? fromKey(String? value) {
    return DocumentType.values.firstWhereOrNull((e) => e.value == value);
  }
}

enum DocumentCategory {
  avaliacao('Avaliação'),
  conceitosGeograficos('Conceitos geográficos'),
  curriculoPoliticasPublicas('Currículo e políticas públicas'),
  ensinoGeografiaDiversidade('Ensino de Geografia e diversidade'),
  ensinoGeografiaInclusao('Ensino de Geografia e inclusão'),
  formacaoProfessores('Formação de professores'),
  linguagemCartografica('Linguagem Cartográfica'),
  livroDidaticoHistoriaGeografiaEscolar('Livro didático e História da Geografia escolar'),
  metodologiaPraticasLinguagens('Metodologia práticas e linguagens'),
  naturezaMeioAmbiente('Natureza e meio ambiente'),
  curriculo('Currículo'),
  formacaoPraticaDocente('Formação e prática docente'),
  juventudeIdentidade('Juventude e identidade'),
  linguagens('Linguagens'),
  livroDidatico('Livro didático'),
  relacoesEtnicoRaciais('Relações étnico-raciais');

  final String value;
  const DocumentCategory(this.value);

  static DocumentCategory? fromKey(String? value) {
    return DocumentCategory.values.firstWhereOrNull((e) => e.value == value);
  }
}
