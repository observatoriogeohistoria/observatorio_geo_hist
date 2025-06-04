import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';

class EventModel extends PostBody {
  const EventModel({
    required super.title,
    required super.image,
    required this.scope,
    required this.link,
    required this.location,
    required this.city,
    required this.date,
    this.time,
    this.details,
  });

  final EventScope scope;
  final String link;
  final String location;
  final String city;
  final String date;
  final String? time;
  final String? details;

  @override
  List<Object?> get props => [
        title,
        image,
        scope,
        link,
        location,
        city,
        date,
        time,
        details,
      ];

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      title: json['title'],
      image: ImageModel(url: json['image']),
      scope: EventScope.values.byName(json['scope']),
      link: json['link'],
      location: json['location'],
      city: json['city'],
      date: json['date'],
      time: json['time'],
      details: json['details'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'image': image.url,
      'scope': scope.name,
      'link': link,
      'location': location,
      'city': city,
      'date': date,
      'time': time,
      'details': details,
    };
  }

  @override
  EventModel copyWith({
    String? title,
    ImageModel? image,
    EventScope? scope,
    String? link,
    String? location,
    String? city,
    String? date,
    String? time,
    String? details,
  }) {
    return EventModel(
      title: title ?? this.title,
      image: image ?? this.image,
      scope: scope ?? this.scope,
      link: link ?? this.link,
      location: location ?? this.location,
      city: city ?? this.city,
      date: date ?? this.date,
      time: time ?? this.time,
      details: details ?? this.details,
    );
  }
}

enum EventScope {
  national,
  international;

  String get portuguese {
    switch (this) {
      case EventScope.national:
        return 'Nacional';
      case EventScope.international:
        return 'Internacional';
    }
  }

  static EventScope? fromPortuguese(String portuguese) {
    switch (portuguese) {
      case 'Nacional':
        return EventScope.national;
      case 'Internacional':
        return EventScope.international;
      default:
        return null;
    }
  }
}
