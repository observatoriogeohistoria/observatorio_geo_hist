import 'package:observatorio_geo_hist/app/core/models/post_model.dart';

class EventModel extends PostBody {
  const EventModel({
    required super.title,
    required super.image,
    required this.scope,
    required this.link,
    required this.local,
    required this.city,
    this.time,
    this.details,
  });

  final EventScope scope;
  final String link;
  final String local;
  final String city;
  final String? time;
  final String? details;

  @override
  List<Object?> get props => [
        title,
        image,
        scope,
        link,
        local,
        city,
        time,
        details,
      ];

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      title: json['title'],
      image: json['image'],
      scope: json['scope'],
      link: json['link'],
      local: json['local'],
      city: json['city'],
      time: json['time'],
      details: json['details'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'image': image,
      'scope': scope,
      'link': link,
      'local': local,
      'city': city,
      'time': time,
      'details': details,
    };
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
}
