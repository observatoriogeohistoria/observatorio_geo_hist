import 'package:observatorio_geo_hist/app/core/models/post_model.dart';

class FilmModel extends PostBody {
  const FilmModel({
    required super.title,
    required super.image,
    required this.category,
    required this.posterImage,
    required this.releaseYear,
    required this.duration,
    required this.director,
    required this.country,
    required this.synopsis,
    required this.link,
  });

  final FilmCategory category;
  final String posterImage;
  final String releaseYear;
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
        posterImage,
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
      image: json['image'],
      category: FilmCategory.values.firstWhere((cat) => cat.portuguese == json['category']),
      posterImage: json['posterImage'],
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
      'image': image,
      'category': category.portuguese,
      'posterImage': posterImage,
      'releaseYear': releaseYear,
      'duration': duration,
      'director': director,
      'country': country,
      'synopsis': synopsis,
      'link': link,
    };
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
}
