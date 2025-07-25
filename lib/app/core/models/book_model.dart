import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';

class BookModel extends PostBody {
  const BookModel({
    required super.title,
    required super.image,
    required this.category,
    required this.author,
    required this.year,
    required this.publisher,
    required this.synopsis,
    required this.link,
  });

  final BookCategory category;
  final String author;
  final int year;
  final String publisher;
  final String synopsis;
  final String link;

  @override
  List<Object?> get props => [
        title,
        image,
        category,
        author,
        year,
        publisher,
        synopsis,
        link,
      ];

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      title: json['title'],
      image: FileModel(url: json['image']),
      category: BookCategory.values.byName(json['category']),
      author: json['author'],
      year: json['year'],
      publisher: json['publisher'],
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
      'author': author,
      'year': year,
      'publisher': publisher,
      'synopsis': synopsis,
      'link': link,
    };
  }

  @override
  BookModel copyWith({
    String? title,
    FileModel? image,
    BookCategory? category,
    String? author,
    int? year,
    String? publisher,
    String? synopsis,
    String? link,
  }) {
    return BookModel(
      title: title ?? this.title,
      image: image ?? this.image,
      category: category ?? this.category,
      author: author ?? this.author,
      year: year ?? this.year,
      publisher: publisher ?? this.publisher,
      synopsis: synopsis ?? this.synopsis,
      link: link ?? this.link,
    );
  }
}

enum BookCategory {
  book,
  ebook;

  String get portuguese {
    switch (this) {
      case BookCategory.book:
        return 'Livro';
      case BookCategory.ebook:
        return 'Ebook';
    }
  }

  static BookCategory? fromPortuguese(String portuguese) {
    switch (portuguese) {
      case 'Livro':
        return BookCategory.book;
      case 'Ebook':
        return BookCategory.ebook;
      default:
        return null;
    }
  }
}
