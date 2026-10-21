// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panel_counts_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PanelCountsStore on PanelCountsStoreBase, Store {
  late final _$countsAtom = Atom(name: 'PanelCountsStoreBase.counts', context: context);

  @override
  PanelCounts get counts {
    _$countsAtom.reportRead();
    return super.counts;
  }

  @override
  set counts(PanelCounts value) {
    _$countsAtom.reportWrite(value, super.counts, () {
      super.counts = value;
    });
  }

  late final _$loadAsyncAction = AsyncAction('PanelCountsStoreBase.load', context: context);

  @override
  Future<void> load({required bool includeUsers}) {
    return _$loadAsyncAction.run(() => super.load(includeUsers: includeUsers));
  }

  late final _$refreshAsyncAction = AsyncAction('PanelCountsStoreBase.refresh', context: context);

  @override
  Future<void> refresh() {
    return _$refreshAsyncAction.run(() => super.refresh());
  }

  @override
  String toString() {
    return '''
counts: ${counts}
    ''';
  }
}
