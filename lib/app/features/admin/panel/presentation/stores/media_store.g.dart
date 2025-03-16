// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MediaStore on MediaStoreBase, Store {
  late final _$mediasAtom =
      Atom(name: 'MediaStoreBase.medias', context: context);

  @override
  ObservableList<MediaModel> get medias {
    _$mediasAtom.reportRead();
    return super.medias;
  }

  @override
  set medias(ObservableList<MediaModel> value) {
    _$mediasAtom.reportWrite(value, super.medias, () {
      super.medias = value;
    });
  }

  late final _$stateAtom = Atom(name: 'MediaStoreBase.state', context: context);

  @override
  ManageMediaState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(ManageMediaState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$getMediasAsyncAction =
      AsyncAction('MediaStoreBase.getMedias', context: context);

  @override
  Future<void> getMedias() {
    return _$getMediasAsyncAction.run(() => super.getMedias());
  }

  late final _$createMediaAsyncAction =
      AsyncAction('MediaStoreBase.createMedia', context: context);

  @override
  Future<void> createMedia(MediaModel media) {
    return _$createMediaAsyncAction.run(() => super.createMedia(media));
  }

  late final _$deleteMediaAsyncAction =
      AsyncAction('MediaStoreBase.deleteMedia', context: context);

  @override
  Future<void> deleteMedia(MediaModel media) {
    return _$deleteMediaAsyncAction.run(() => super.deleteMedia(media));
  }

  @override
  String toString() {
    return '''
medias: ${medias},
state: ${state}
    ''';
  }
}
