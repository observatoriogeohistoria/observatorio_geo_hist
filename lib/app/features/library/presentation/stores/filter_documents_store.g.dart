// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_documents_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FilterDocumentsStore on FilterDocumentsStoreBase, Store {
  late final _$typeAtom =
      Atom(name: 'FilterDocumentsStoreBase.type', context: context);

  @override
  DocumentType? get type {
    _$typeAtom.reportRead();
    return super.type;
  }

  @override
  set type(DocumentType? value) {
    _$typeAtom.reportWrite(value, super.type, () {
      super.type = value;
    });
  }

  late final _$categoriesAtom =
      Atom(name: 'FilterDocumentsStoreBase.categories', context: context);

  @override
  List<DocumentCategory> get categories {
    _$categoriesAtom.reportRead();
    return super.categories;
  }

  @override
  set categories(List<DocumentCategory> value) {
    _$categoriesAtom.reportWrite(value, super.categories, () {
      super.categories = value;
    });
  }

  late final _$titleAtom =
      Atom(name: 'FilterDocumentsStoreBase.title', context: context);

  @override
  String? get title {
    _$titleAtom.reportRead();
    return super.title;
  }

  @override
  set title(String? value) {
    _$titleAtom.reportWrite(value, super.title, () {
      super.title = value;
    });
  }

  late final _$authorAtom =
      Atom(name: 'FilterDocumentsStoreBase.author', context: context);

  @override
  String? get author {
    _$authorAtom.reportRead();
    return super.author;
  }

  @override
  set author(String? value) {
    _$authorAtom.reportWrite(value, super.author, () {
      super.author = value;
    });
  }

  late final _$institutionAtom =
      Atom(name: 'FilterDocumentsStoreBase.institution', context: context);

  @override
  String? get institution {
    _$institutionAtom.reportRead();
    return super.institution;
  }

  @override
  set institution(String? value) {
    _$institutionAtom.reportWrite(value, super.institution, () {
      super.institution = value;
    });
  }

  late final _$yearAtom =
      Atom(name: 'FilterDocumentsStoreBase.year', context: context);

  @override
  int? get year {
    _$yearAtom.reportRead();
    return super.year;
  }

  @override
  set year(int? value) {
    _$yearAtom.reportWrite(value, super.year, () {
      super.year = value;
    });
  }

  late final _$FilterDocumentsStoreBaseActionController =
      ActionController(name: 'FilterDocumentsStoreBase', context: context);

  @override
  void reset() {
    final _$actionInfo = _$FilterDocumentsStoreBaseActionController.startAction(
        name: 'FilterDocumentsStoreBase.reset');
    try {
      return super.reset();
    } finally {
      _$FilterDocumentsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setType(DocumentType? type) {
    final _$actionInfo = _$FilterDocumentsStoreBaseActionController.startAction(
        name: 'FilterDocumentsStoreBase.setType');
    try {
      return super.setType(type);
    } finally {
      _$FilterDocumentsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCategories(List<DocumentCategory> categories) {
    final _$actionInfo = _$FilterDocumentsStoreBaseActionController.startAction(
        name: 'FilterDocumentsStoreBase.setCategories');
    try {
      return super.setCategories(categories);
    } finally {
      _$FilterDocumentsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTitle(String? title) {
    final _$actionInfo = _$FilterDocumentsStoreBaseActionController.startAction(
        name: 'FilterDocumentsStoreBase.setTitle');
    try {
      return super.setTitle(title);
    } finally {
      _$FilterDocumentsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAuthor(String? author) {
    final _$actionInfo = _$FilterDocumentsStoreBaseActionController.startAction(
        name: 'FilterDocumentsStoreBase.setAuthor');
    try {
      return super.setAuthor(author);
    } finally {
      _$FilterDocumentsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setInstitution(String? institution) {
    final _$actionInfo = _$FilterDocumentsStoreBaseActionController.startAction(
        name: 'FilterDocumentsStoreBase.setInstitution');
    try {
      return super.setInstitution(institution);
    } finally {
      _$FilterDocumentsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setYear(int? year) {
    final _$actionInfo = _$FilterDocumentsStoreBaseActionController.startAction(
        name: 'FilterDocumentsStoreBase.setYear');
    try {
      return super.setYear(year);
    } finally {
      _$FilterDocumentsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
type: ${type},
categories: ${categories},
title: ${title},
author: ${author},
institution: ${institution},
year: ${year}
    ''';
  }
}
