// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MediaStore on MediaStoreBase, Store {
  late final _$itemsAtom = Atom(name: 'MediaStoreBase.items', context: context);

  @override
  ObservableList<MediaModel> get items {
    _$itemsAtom.reportRead();
    return super.items;
  }

  @override
  set items(ObservableList<MediaModel> value) {
    _$itemsAtom.reportWrite(value, super.items, () {
      super.items = value;
    });
  }

  late final _$stateAtom = Atom(name: 'MediaStoreBase.state', context: context);

  @override
  CrudState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(CrudState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$getItemsAsyncAction =
      AsyncAction('MediaStoreBase.getItems', context: context);

  @override
  Future<void> getItems() {
    return _$getItemsAsyncAction.run(() => super.getItems());
  }

  late final _$createOrUpdateItemAsyncAction =
      AsyncAction('MediaStoreBase.createOrUpdateItem', context: context);

  @override
  Future<void> createOrUpdateItem(MediaModel item, {dynamic extra}) {
    return _$createOrUpdateItemAsyncAction
        .run(() => super.createOrUpdateItem(item, extra: extra));
  }

  late final _$deleteItemAsyncAction =
      AsyncAction('MediaStoreBase.deleteItem', context: context);

  @override
  Future<void> deleteItem(MediaModel item) {
    return _$deleteItemAsyncAction.run(() => super.deleteItem(item));
  }

  @override
  String toString() {
    return '''
items: ${items},
state: ${state}
    ''';
  }
}
