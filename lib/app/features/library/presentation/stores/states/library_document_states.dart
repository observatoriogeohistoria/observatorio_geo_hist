import 'package:equatable/equatable.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';

sealed class LibraryDocumentState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class LibraryDocumentInitialState extends LibraryDocumentState {}

final class LibraryDocumentLoadingState extends LibraryDocumentState {}

final class LibraryDocumentSuccessState extends LibraryDocumentState {
  LibraryDocumentSuccessState(this.document);

  final LibraryDocumentModel document;

  @override
  List<Object?> get props => [document];
}

final class LibraryDocumentNotFoundState extends LibraryDocumentState {}

final class LibraryDocumentErrorState extends LibraryDocumentState {}
