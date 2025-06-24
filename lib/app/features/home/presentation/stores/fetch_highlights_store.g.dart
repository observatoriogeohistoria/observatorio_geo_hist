// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_highlights_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FetchHighlightsStore on FetchHighlightsStoreBase, Store {
  late final _$highlightsAtom =
      Atom(name: 'FetchHighlightsStoreBase.highlights', context: context);

  @override
  ObservableList<PostModel> get highlights {
    _$highlightsAtom.reportRead();
    return super.highlights;
  }

  @override
  set highlights(ObservableList<PostModel> value) {
    _$highlightsAtom.reportWrite(value, super.highlights, () {
      super.highlights = value;
    });
  }

  late final _$stateAtom =
      Atom(name: 'FetchHighlightsStoreBase.state', context: context);

  @override
  FetchHighlightsState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(FetchHighlightsState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$fetchHighlightsAsyncAction =
      AsyncAction('FetchHighlightsStoreBase.fetchHighlights', context: context);

  @override
  Future<void> fetchHighlights() {
    return _$fetchHighlightsAsyncAction.run(() => super.fetchHighlights());
  }

  @override
  String toString() {
    return '''
highlights: ${highlights},
state: ${state}
    ''';
  }
}
