import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/models/search_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_form.dart';

class SearchEditorForm extends PostEditorForm {
  SearchEditorForm(this.body);

  final SearchModel? body;

  late final _title = input('Título da pesquisa', body?.title, isTitle: true);
  late final _state = choice(
      'Estado da pesquisa', SearchState.values, (value) => value.portuguese, body?.state,
      placeholder: 'Escolha o estado', message: 'Escolha o estado da pesquisa.');
  late final _coordinator = input('Coordenador(a)', body?.coordinator, isOptional: true);
  late final _researcher = input('Pesquisador(a)', body?.researcher, isOptional: true);
  late final _advisor = input('Orientador(a)', body?.advisor, isOptional: true);
  late final _coAdvisor = input('Coorientador(a)', body?.coAdvisor, isOptional: true);
  late final _description = input('Descrição', body?.description, lines: 8);
  late final _members = input('Integrantes', body?.members, isOptional: true);
  late final _financier = input('Financiador', body?.financier, isOptional: true);

  @override
  bool get hasCaption => true;

  @override
  FocusNode get firstFocus => _title.focusNode;

  @override
  List<PostEditorField> get mainFields => [
        _title.field,
        _state.field,
        _coordinator.field,
        _researcher.field,
        _advisor.field,
        _coAdvisor.field,
        _description.field,
        _members.field,
        _financier.field,
      ];

  @override
  List<Widget> buildMain(BuildContext context) => [
        PostEditorCard(
          children: [
            _title.build(context),
            _state.build(context),
          ],
        ),
        PostEditorCard(
          children: [
            _coordinator.build(context),
            _researcher.build(context),
            _advisor.build(context),
            _coAdvisor.build(context),
          ],
        ),
        PostEditorCard(
          children: [
            _description.build(context),
            _members.build(context),
            _financier.build(context),
          ],
        ),
      ];

  @override
  PostBody buildBody(PostEditorImage image) => SearchModel(
        title: _title.text,
        state: _state.value!,
        image: image.value,
        imageCaption: image.caption.text,
        coordinator: _coordinator.text,
        researcher: _researcher.text,
        advisor: _advisor.text,
        coAdvisor: _coAdvisor.text,
        description: _description.text,
        members: _members.text,
        financier: _financier.text,
      );
}
