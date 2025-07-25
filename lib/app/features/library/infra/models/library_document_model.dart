import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

class LibraryDocumentModel extends Equatable {
  final DocumentArea area;
  final String title;
  final String author;
  final String? id;
  final DocumentType? type;
  final List<DocumentCategory> categories;
  final String? documentUrl;
  final String? institution;
  final String? slug;
  final int? year;
  final String? status;
  final DateTime? createdAt;

  const LibraryDocumentModel({
    required this.area,
    required this.title,
    required this.author,
    this.id,
    this.type,
    this.categories = const [],
    this.documentUrl,
    this.institution,
    this.slug,
    this.year,
    this.status,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        area,
        title,
        author,
        id,
        type,
        categories,
        documentUrl,
        institution,
        slug,
        year,
        status,
        createdAt,
      ];

  factory LibraryDocumentModel.fromJson(Map<String, dynamic> json) {
    return LibraryDocumentModel(
      area: DocumentArea.fromKey(json['area']) ?? DocumentArea.geografia,
      title: json['title'],
      author: json['author'],
      id: json['id'],
      type: DocumentType.fromKey(json['type']),
      categories: json['category']
              ?.map((e) => DocumentCategory.fromKey(e))
              .whereType<DocumentCategory>()
              .toList() ??
          [],
      documentUrl: json['documentUrl'],
      institution: json['institution'],
      slug: json['slug'],
      year: json['year'] != null ? int.tryParse(json['year'].toString()) : null,
      status: json['status'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'area': area.value,
      'title': title,
      'author': author,
      'id': id,
      'type': type?.value,
      'category': categories.map((e) => e.value).toList(),
      'documentUrl': documentUrl,
      'institution': institution,
      'slug': slug,
      'year': year,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  LibraryDocumentModel copyWith({
    DocumentArea? area,
    String? title,
    String? author,
    String? id,
    DocumentType? type,
    List<DocumentCategory>? categories,
    String? documentUrl,
    String? institution,
    String? slug,
    int? year,
    String? status,
    DateTime? createdAt,
  }) {
    return LibraryDocumentModel(
      area: area ?? this.area,
      title: title ?? this.title,
      author: author ?? this.author,
      id: id ?? this.id,
      type: type ?? this.type,
      categories: categories ?? this.categories,
      documentUrl: documentUrl ?? this.documentUrl,
      institution: institution ?? this.institution,
      slug: slug ?? this.slug,
      year: year ?? this.year,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
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

  String get bucketKey => switch (this) {
        DocumentArea.geografia => 'geography',
        DocumentArea.historia => 'history',
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
