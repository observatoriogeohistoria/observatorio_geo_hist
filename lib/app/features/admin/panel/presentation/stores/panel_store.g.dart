// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panel_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PanelStore on PanelStoreBase, Store {
  late final _$passwordVisibleAtom =
      Atom(name: 'PanelStoreBase.passwordVisible', context: context);

  @override
  bool get passwordVisible {
    _$passwordVisibleAtom.reportRead();
    return super.passwordVisible;
  }

  @override
  set passwordVisible(bool value) {
    _$passwordVisibleAtom.reportWrite(value, super.passwordVisible, () {
      super.passwordVisible = value;
    });
  }

  late final _$PanelStoreBaseActionController =
      ActionController(name: 'PanelStoreBase', context: context);

  @override
  void togglePasswordVisibility() {
    final _$actionInfo = _$PanelStoreBaseActionController.startAction(
        name: 'PanelStoreBase.togglePasswordVisibility');
    try {
      return super.togglePasswordVisibility();
    } finally {
      _$PanelStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
passwordVisible: ${passwordVisible}
    ''';
  }
}
