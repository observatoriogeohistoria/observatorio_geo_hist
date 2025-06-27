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

  late final _$highlightsDialogWasShownAtom = Atom(
      name: 'FetchHighlightsStoreBase.highlightsDialogWasShown',
      context: context);

  @override
  bool get highlightsDialogWasShown {
    _$highlightsDialogWasShownAtom.reportRead();
    return super.highlightsDialogWasShown;
  }

  @override
  set highlightsDialogWasShown(bool value) {
    _$highlightsDialogWasShownAtom
        .reportWrite(value, super.highlightsDialogWasShown, () {
      super.highlightsDialogWasShown = value;
    });
  }

  late final _$highlightsDialogIsOpenAtom = Atom(
      name: 'FetchHighlightsStoreBase.highlightsDialogIsOpen',
      context: context);

  @override
  bool get highlightsDialogIsOpen {
    _$highlightsDialogIsOpenAtom.reportRead();
    return super.highlightsDialogIsOpen;
  }

  @override
  set highlightsDialogIsOpen(bool value) {
    _$highlightsDialogIsOpenAtom
        .reportWrite(value, super.highlightsDialogIsOpen, () {
      super.highlightsDialogIsOpen = value;
    });
  }

  late final _$fetchHighlightsAsyncAction =
      AsyncAction('FetchHighlightsStoreBase.fetchHighlights', context: context);

  @override
  Future<void> fetchHighlights(List<CategoryModel> categories) {
    return _$fetchHighlightsAsyncAction
        .run(() => super.fetchHighlights(categories));
  }

  late final _$FetchHighlightsStoreBaseActionController =
      ActionController(name: 'FetchHighlightsStoreBase', context: context);

  @override
  void showHighlights() {
    final _$actionInfo = _$FetchHighlightsStoreBaseActionController.startAction(
        name: 'FetchHighlightsStoreBase.showHighlights');
    try {
      return super.showHighlights();
    } finally {
      _$FetchHighlightsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void hideHighlights() {
    final _$actionInfo = _$FetchHighlightsStoreBaseActionController.startAction(
        name: 'FetchHighlightsStoreBase.hideHighlights');
    try {
      return super.hideHighlights();
    } finally {
      _$FetchHighlightsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
highlights: ${highlights},
state: ${state},
highlightsDialogWasShown: ${highlightsDialogWasShown},
highlightsDialogIsOpen: ${highlightsDialogIsOpen}
    ''';
  }
}
