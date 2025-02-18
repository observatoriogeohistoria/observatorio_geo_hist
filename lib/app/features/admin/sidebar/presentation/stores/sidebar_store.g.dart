// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sidebar_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SidebarStore on SidebarStoreBase, Store {
  late final _$isCollapsedAtom =
      Atom(name: 'SidebarStoreBase.isCollapsed', context: context);

  @override
  bool get isCollapsed {
    _$isCollapsedAtom.reportRead();
    return super.isCollapsed;
  }

  @override
  set isCollapsed(bool value) {
    _$isCollapsedAtom.reportWrite(value, super.isCollapsed, () {
      super.isCollapsed = value;
    });
  }

  late final _$selectedItemAtom =
      Atom(name: 'SidebarStoreBase.selectedItem', context: context);

  @override
  SidebarItem get selectedItem {
    _$selectedItemAtom.reportRead();
    return super.selectedItem;
  }

  @override
  set selectedItem(SidebarItem value) {
    _$selectedItemAtom.reportWrite(value, super.selectedItem, () {
      super.selectedItem = value;
    });
  }

  late final _$SidebarStoreBaseActionController =
      ActionController(name: 'SidebarStoreBase', context: context);

  @override
  void toggleCollapse() {
    final _$actionInfo = _$SidebarStoreBaseActionController.startAction(
        name: 'SidebarStoreBase.toggleCollapse');
    try {
      return super.toggleCollapse();
    } finally {
      _$SidebarStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectItem(SidebarItem item) {
    final _$actionInfo = _$SidebarStoreBaseActionController.startAction(
        name: 'SidebarStoreBase.selectItem');
    try {
      return super.selectItem(item);
    } finally {
      _$SidebarStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isCollapsed: ${isCollapsed},
selectedItem: ${selectedItem}
    ''';
  }
}
