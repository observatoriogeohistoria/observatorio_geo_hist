// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_editor_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PostEditorStore on PostEditorStoreBase, Store {
  late final _$loadStateAtom =
      Atom(name: 'PostEditorStoreBase.loadState', context: context);

  @override
  CrudState get loadState {
    _$loadStateAtom.reportRead();
    return super.loadState;
  }

  @override
  set loadState(CrudState value) {
    _$loadStateAtom.reportWrite(value, super.loadState, () {
      super.loadState = value;
    });
  }

  late final _$isSavingAtom =
      Atom(name: 'PostEditorStoreBase.isSaving', context: context);

  @override
  bool get isSaving {
    _$isSavingAtom.reportRead();
    return super.isSaving;
  }

  @override
  set isSaving(bool value) {
    _$isSavingAtom.reportWrite(value, super.isSaving, () {
      super.isSaving = value;
    });
  }

  late final _$postAtom =
      Atom(name: 'PostEditorStoreBase.post', context: context);

  @override
  PostModel? get post {
    _$postAtom.reportRead();
    return super.post;
  }

  @override
  set post(PostModel? value) {
    _$postAtom.reportWrite(value, super.post, () {
      super.post = value;
    });
  }

  late final _$loadAsyncAction =
      AsyncAction('PostEditorStoreBase.load', context: context);

  @override
  Future<void> load(String categoryKey, String id) {
    return _$loadAsyncAction.run(() => super.load(categoryKey, id));
  }

  late final _$saveAsyncAction =
      AsyncAction('PostEditorStoreBase.save', context: context);

  @override
  Future<Either<Failure, PostModel>> save(
      PostModel post, CategoryModel? pastCategory) {
    return _$saveAsyncAction.run(() => super.save(post, pastCategory));
  }

  @override
  String toString() {
    return '''
loadState: ${loadState},
isSaving: ${isSaving},
post: ${post}
    ''';
  }
}
