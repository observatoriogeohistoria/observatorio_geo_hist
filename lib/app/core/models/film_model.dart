import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';

class FilmModel extends PostBody {
  const FilmModel({
    required super.title,
    required super.image,
    required this.category,
    required this.releaseYear,
    required this.duration,
    required this.director,
    required this.country,
    required this.synopsis,
    required this.link,
  });

  final FilmCategory category;
  final int releaseYear;
  final String duration;
  final String director;
  final String country;
  final String synopsis;
  final String link;

  @override
  List<Object?> get props => [
        title,
        image,
        category,
        releaseYear,
        duration,
        director,
        country,
        synopsis,
        link,
      ];

  factory FilmModel.fromJson(Map<String, dynamic> json) {
    return FilmModel(
      title: json['title'],
      image: FileModel(url: json['image']),
      category: FilmCategory.values.byName(json['category']),
      releaseYear: json['releaseYear'],
      duration: json['duration'],
      director: json['director'],
      country: json['country'],
      synopsis: json['synopsis'],
      link: json['link'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'title_lower': title.toLowerCase(),
      'image': image.url,
      'category': category.name,
      'releaseYear': releaseYear,
      'duration': duration,
      'director': director,
      'country': country,
      'synopsis': synopsis,
      'link': link,
    };
  }

  @override
  FilmModel copyWith({
    String? title,
    FileModel? image,
    FilmCategory? category,
    int? releaseYear,
    String? duration,
    String? director,
    String? country,
    String? synopsis,
    String? link,
  }) {
    return FilmModel(
      title: title ?? this.title,
      image: image ?? this.image,
      category: category ?? this.category,
      releaseYear: releaseYear ?? this.releaseYear,
      duration: duration ?? this.duration,
      director: director ?? this.director,
      country: country ?? this.country,
      synopsis: synopsis ?? this.synopsis,
      link: link ?? this.link,
    );
  }
}

enum FilmCategory {
  movie,
  documentary,
  shortFilm,
  series;

  String get portuguese {
    switch (this) {
      case FilmCategory.movie:
        return 'Filme';
      case FilmCategory.documentary:
        return 'Documentário';
      case FilmCategory.shortFilm:
        return 'Curta Metragem';
      case FilmCategory.series:
        return 'Série';
    }
  }

  static FilmCategory? fromPortuguese(String portuguese) {
    switch (portuguese) {
      case 'Filme':
        return FilmCategory.movie;
      case 'Documentário':
        return FilmCategory.documentary;
      case 'Curta Metragem':
        return FilmCategory.shortFilm;
      case 'Série':
        return FilmCategory.series;
      default:
        return null;
    }
  }
}
