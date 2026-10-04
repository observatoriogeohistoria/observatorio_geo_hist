// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_index_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LibraryIndexStore on LibraryIndexStoreBase, Store {
  late final _$statusAtom =
      Atom(name: 'LibraryIndexStoreBase.status', context: context);

  @override
  LibraryIndexStatus get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(LibraryIndexStatus value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  late final _$countsAtom =
      Atom(name: 'LibraryIndexStoreBase.counts', context: context);

  @override
  Map<DocumentArea, Map<DocumentType, int>>? get counts {
    _$countsAtom.reportRead();
    return super.counts;
  }

  @override
  set counts(Map<DocumentArea, Map<DocumentType, int>>? value) {
    _$countsAtom.reportWrite(value, super.counts, () {
      super.counts = value;
    });
  }

  late final _$loadAsyncAction =
      AsyncAction('LibraryIndexStoreBase.load', context: context);

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  @override
  String toString() {
    return '''
status: ${status},
counts: ${counts}
    ''';
  }
}
