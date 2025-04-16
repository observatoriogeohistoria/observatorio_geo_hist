import 'package:equatable/equatable.dart';
import 'package:observatorio_geo_hist/app/core/models/academic_production_model.dart';
import 'package:observatorio_geo_hist/app/core/models/article_model.dart';
import 'package:observatorio_geo_hist/app/core/models/artist_model.dart';
import 'package:observatorio_geo_hist/app/core/models/book_model.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/document_model.dart';
import 'package:observatorio_geo_hist/app/core/models/event_model.dart';
import 'package:observatorio_geo_hist/app/core/models/film_model.dart';
import 'package:observatorio_geo_hist/app/core/models/magazine_model.dart';
import 'package:observatorio_geo_hist/app/core/models/music_model.dart';
import 'package:observatorio_geo_hist/app/core/models/podcast_model.dart';
import 'package:observatorio_geo_hist/app/core/models/search_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';

abstract class PostBody extends Equatable {
  const PostBody({
    required this.title,
    required this.image,
  });

  final String title;
  final String image;

  Map<String, dynamic> toJson();
}

class PostModel extends Equatable {
  final String? id;

  final String categoryId;
  final CategoryModel? category;

  final List<PostsAreas> areas;

  final PostType type;
  final PostBody? body;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final bool isPublished;
  final bool isHighlighted;

  const PostModel({
    this.id,
    required this.categoryId,
    this.category,
    required this.areas,
    required this.type,
    this.body,
    this.createdAt,
    this.updatedAt,
    this.isPublished = false,
    this.isHighlighted = false,
  });

  bool get isAcademicProduction => type == PostType.academicProduction;
  bool get isArticle => type == PostType.article;
  bool get isArtist => type == PostType.artist;
  bool get isBook => type == PostType.book;
  bool get isDocument => type == PostType.document;
  bool get isEvent => type == PostType.event;
  bool get isFilm => type == PostType.film;
  bool get isMagazine => type == PostType.magazine;
  bool get isMusic => type == PostType.music;
  bool get isPodcast => type == PostType.podcast;
  bool get isSearch => type == PostType.search;

  @override
  List<Object?> get props => [
        id,
        categoryId,
        category,
        areas,
        type,
        body,
        createdAt,
        updatedAt,
        isPublished,
        isHighlighted,
      ];

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final type = PostType.values.firstWhere((element) => element.name == json['type']);
    final body = type.getBody(json['body']);

    return PostModel(
      id: json['id'],
      categoryId: json['categoryId'],
      areas: (json['areas'] as List).map((area) => PostsAreas.fromKey(area as String)).toList(),
      type: type,
      body: body,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isPublished: json['isPublished'],
      isHighlighted: json['isHighlighted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'areas': areas.map((area) => area.key).toList(),
      'type': type.name,
      'body': body?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isPublished': isPublished,
      'isHighlighted': isHighlighted,
    };
  }

  PostModel copyWith({
    String? id,
    String? categoryId,
    CategoryModel? category,
    List<PostsAreas>? areas,
    PostType? type,
    PostBody? body,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPublished,
    bool? isHighlighted,
  }) {
    return PostModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      areas: areas ?? this.areas,
      type: type ?? this.type,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPublished: isPublished ?? this.isPublished,
      isHighlighted: isHighlighted ?? this.isHighlighted,
    );
  }
}

enum PostType {
  academicProduction,
  article,
  artist,
  book,
  document,
  event,
  film,
  magazine,
  music,
  podcast,
  search;

  String get value {
    switch (this) {
      case PostType.academicProduction:
        return 'producoes-academicas';
      case PostType.article:
        return 'artigos';
      case PostType.artist:
        return 'artistas';
      case PostType.book:
        return 'livros';
      case PostType.document:
        return 'documentos';
      case PostType.event:
        return 'eventos';
      case PostType.film:
        return 'filmes';
      case PostType.magazine:
        return 'revistas';
      case PostType.music:
        return 'musicas';
      case PostType.podcast:
        return 'podcasts';
      case PostType.search:
        return 'pesquisas';
    }
  }

  String get portuguese {
    switch (this) {
      case PostType.academicProduction:
        return 'Produção Acadêmica';
      case PostType.article:
        return 'Artigo';
      case PostType.artist:
        return 'Artista';
      case PostType.book:
        return 'Livro';
      case PostType.document:
        return 'Documento';
      case PostType.event:
        return 'Evento';
      case PostType.film:
        return 'Filme';
      case PostType.magazine:
        return 'Revista';
      case PostType.music:
        return 'Música';
      case PostType.podcast:
        return 'Podcast';
      case PostType.search:
        return 'Pesquisa';
    }
  }

  String get portuguesePlural {
    switch (this) {
      case PostType.academicProduction:
        return 'Produções Academicas';
      case PostType.article:
        return 'Artigos';
      case PostType.artist:
        return 'Artistas';
      case PostType.book:
        return 'Livros';
      case PostType.document:
        return 'Documentos';
      case PostType.event:
        return 'Eventos';
      case PostType.film:
        return 'Filmes';
      case PostType.magazine:
        return 'Revistas';
      case PostType.music:
        return 'Músicas';
      case PostType.podcast:
        return 'Podcasts';
      case PostType.search:
        return 'Pesquisas';
    }
  }

  PostBody getBody(Map<String, dynamic> json) {
    switch (this) {
      case PostType.academicProduction:
        return AcademicProductionModel.fromJson(json);
      case PostType.article:
        return ArticleModel.fromJson(json);
      case PostType.artist:
        return ArtistModel.fromJson(json);
      case PostType.book:
        return BookModel.fromJson(json);
      case PostType.document:
        return DocumentModel.fromJson(json);
      case PostType.event:
        return EventModel.fromJson(json);
      case PostType.film:
        return FilmModel.fromJson(json);
      case PostType.magazine:
        return MagazineModel.fromJson(json);
      case PostType.music:
        return MusicModel.fromJson(json);
      case PostType.podcast:
        return PodcastModel.fromJson(json);
      case PostType.search:
        return SearchModel.fromJson(json);
    }
  }

  static PostType? fromString(String? value) {
    switch (value) {
      case 'producoes-academicas':
        return PostType.academicProduction;
      case 'artigos':
        return PostType.article;
      case 'artistas':
        return PostType.artist;
      case 'livros':
        return PostType.book;
      case 'documentos':
        return PostType.document;
      case 'eventos':
        return PostType.event;
      case 'filmes':
        return PostType.film;
      case 'revistas':
        return PostType.magazine;
      case 'musicas':
        return PostType.music;
      case 'podcasts':
        return PostType.podcast;
      case 'pesquisas':
        return PostType.search;
      default:
        return null;
    }
  }
}
