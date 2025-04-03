import 'package:observatorio_geo_hist/app/core/models/post_model.dart';

class BookModel extends PostBody {
  const BookModel({
    required super.title,
    required super.image,
    required this.category,
    required this.author,
    required this.publicationYear,
    required this.publisher,
    required this.synopsis,
    required this.link,
  });

  final BookCategory category;
  final String author;
  final String publicationYear;
  final String publisher;
  final String synopsis;
  final String link;

  @override
  List<Object?> get props => [
        title,
        image,
        category,
        author,
        publicationYear,
        publisher,
        synopsis,
        link,
      ];

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      title: json['title'],
      image: json['image'],
      category: BookCategory.values.firstWhere((cat) => cat.portuguese == json['category']),
      author: json['author'],
      publicationYear: json['publicationYear'],
      publisher: json['publisher'],
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
      'author': author,
      'publicationYear': publicationYear,
      'publisher': publisher,
      'synopsis': synopsis,
      'link': link,
    };
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
}
