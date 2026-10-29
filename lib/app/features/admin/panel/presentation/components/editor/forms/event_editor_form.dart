import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/models/event_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_form.dart';

class EventEditorForm extends PostEditorForm {
  EventEditorForm(this.body);

  final EventModel? body;

  late final _title = input('Título/Nome do evento', body?.title, isTitle: true);
  late final _scope = choice(
      'Abrangência', EventScope.values, (value) => value.portuguese, body?.scope,
      placeholder: 'Escolha a abrangência', message: 'Escolha a abrangência.');
  late final _link = input('Link do evento', body?.link,
      validator: Validators.isValidUrl, hintText: 'https://', keyboardType: TextInputType.url);
  late final _location = input('Local', body?.location);
  late final _city = input(
      'Cidade (Cidade/UF (para evento no Brasil) ou Cidade – País (para evento fora do Brasil))',
      body?.city);
  late final _date = input('Data (Ex.: 1º de janeiro de 2020 a 10 de janeiro de 2020)', body?.date,
      hintText: 'DD/MM/AAAA');
  late final _time = input('Horário', body?.time, isOptional: true);
  late final _details = input('Detalhes', body?.details, isOptional: true, lines: 8);

  @override
  FocusNode get firstFocus => _title.focusNode;

  @override
  List<PostEditorField> get mainFields => [
        _title.field,
        _scope.field,
        _link.field,
        _location.field,
        _city.field,
        _date.field,
        _time.field,
        _details.field,
      ];

  @override
  List<Widget> buildMain(BuildContext context) => [
        PostEditorCard(
          children: [
            _title.build(context),
            _scope.build(context),
            _link.build(context),
          ],
        ),
        PostEditorCard(
          children: [
            _location.build(context),
            _city.build(context),
            _date.build(context),
            _time.build(context),
          ],
        ),
        PostEditorCard(
          children: [
            _details.build(context),
          ],
        ),
      ];

  @override
  PostBody buildBody(PostEditorImage image) => EventModel(
        title: _title.text,
        scope: _scope.value!,
        image: image.value,
        link: _link.text,
        location: _location.text,
        city: _city.text,
        date: _date.text,
        time: _time.text.isEmpty ? null : _time.text,
        details: _details.text.isEmpty ? null : _details.text,
      );
}
