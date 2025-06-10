import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';

class SearchModel extends PostBody {
  const SearchModel({
    required super.title,
    required super.image,
    required this.state,
    required this.imageCaption,
    required this.description,
    this.coordinator,
    this.researcher,
    this.advisor,
    this.coAdvisor,
    this.members,
    this.financier,
  });

  final SearchState state;
  final String imageCaption;
  final String description;
  final String? coordinator;
  final String? researcher;
  final String? advisor;
  final String? coAdvisor;
  final String? members;
  final String? financier;

  @override
  List<Object?> get props => [
        title,
        image,
        state,
        imageCaption,
        description,
        coordinator,
        researcher,
        advisor,
        coAdvisor,
        members,
        financier,
      ];

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      title: json['title'],
      image: ImageModel(url: json['image']),
      state: SearchState.values.byName(json['state']),
      imageCaption: json['imageCaption'],
      description: json['description'],
      coordinator: json['coordinator'],
      researcher: json['researcher'],
      advisor: json['advisor'],
      coAdvisor: json['coAdvisor'],
      members: json['members'],
      financier: json['financier'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'title_lower': title.toLowerCase(),
      'image': image.url,
      'state': state.name,
      'imageCaption': imageCaption,
      'description': description,
      'coordinator': coordinator,
      'researcher': researcher,
      'advisor': advisor,
      'coAdvisor': coAdvisor,
      'members': members,
      'financier': financier,
    };
  }

  @override
  SearchModel copyWith({
    String? title,
    ImageModel? image,
    SearchState? state,
    String? imageCaption,
    String? description,
    String? coordinator,
    String? researcher,
    String? advisor,
    String? coAdvisor,
    String? members,
    String? financier,
  }) {
    return SearchModel(
      title: title ?? this.title,
      image: image ?? this.image,
      state: state ?? this.state,
      imageCaption: imageCaption ?? this.imageCaption,
      description: description ?? this.description,
      coordinator: coordinator ?? this.coordinator,
      researcher: researcher ?? this.researcher,
      advisor: advisor ?? this.advisor,
      coAdvisor: coAdvisor ?? this.coAdvisor,
      members: members ?? this.members,
      financier: financier ?? this.financier,
    );
  }
}

enum SearchState {
  inProgress,
  completed;

  String get portuguese {
    switch (this) {
      case SearchState.inProgress:
        return 'Em andamento';
      case SearchState.completed:
        return 'Concluída';
    }
  }

  static SearchState? fromPortuguese(String portuguese) {
    switch (portuguese) {
      case 'Em andamento':
        return SearchState.inProgress;
      case 'Concluída':
        return SearchState.completed;
    }
    return null;
  }
}
