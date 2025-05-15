import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_dropdown_field.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/event_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/form_dialog.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

void showCreateOrUpdateEventDialog(
  BuildContext context, {
  required void Function(PostModel post) onCreateOrUpdate,
  required PostModel post,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => CreateOrUpdateEventDialog(
      onCreateOrUpdate: onCreateOrUpdate,
      post: post,
    ),
  );
}

class CreateOrUpdateEventDialog extends StatefulWidget {
  const CreateOrUpdateEventDialog({
    required this.onCreateOrUpdate,
    required this.post,
    super.key,
  });

  final void Function(PostModel post) onCreateOrUpdate;
  final PostModel post;

  @override
  State<CreateOrUpdateEventDialog> createState() => _CreateOrUpdateEventDialogState();
}

class _CreateOrUpdateEventDialogState extends State<CreateOrUpdateEventDialog> {
  late final EventModel? _initialBody = widget.post.body as EventModel?;

  late final _titleController = TextEditingController(text: _initialBody?.title);
  late final _imageController = TextEditingController(text: _initialBody?.image);
  late final _linkController = TextEditingController(text: _initialBody?.link);
  late final _locationController = TextEditingController(text: _initialBody?.location);
  late final _cityController = TextEditingController(text: _initialBody?.city);
  late final _dateController = TextEditingController(text: _initialBody?.date);
  late final _timeController = TextEditingController(text: _initialBody?.time ?? '');
  late final _detailsController = TextEditingController(text: _initialBody?.details ?? '');

  late EventScope? _selectedScope = _initialBody?.scope;

  bool get _isUpdate => widget.post.id != null;

  @override
  Widget build(BuildContext context) {
    return FormDialog(
      onSubmit: _onCreateOrUpdate,
      isUpdate: _isUpdate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTitle.medium(
            text: _isUpdate ? 'Atualizar evento' : 'Criar evento',
            color: AppTheme.colors.orange,
          ),
          SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
          AppTextField(
            controller: _titleController,
            labelText: 'Título/Nome do evento',
            validator: Validators.isNotEmpty,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppDropdownField<EventScope>(
            hintText: 'Abrangência',
            items: EventScope.values,
            itemToString: (value) => value.portuguese,
            value: _selectedScope,
            onChanged: (value) {
              if (value == null) return;

              EventScope? selected = EventScope.fromPortuguese(value);
              setState(() => _selectedScope = selected);
            },
            validator: Validators.isNotEmpty,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _imageController,
            labelText: 'URL da imagem',
            hintText: 'https://',
            validator: Validators.isValidUrl,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _linkController,
            labelText: 'Link do evento',
            hintText: 'https://',
            validator: Validators.isValidUrl,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _locationController,
            labelText: 'Local',
            validator: Validators.isNotEmpty,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _cityController,
            labelText:
                'Cidade (Cidade/UF (para evento no Brasil) ou Cidade – País (para evento fora do Brasil))',
            validator: Validators.isNotEmpty,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _dateController,
            labelText: 'Data (Ex.: 1º de janeiro de 2020 a 10 de janeiro de 2020)',
            hintText: 'DD/MM/AAAA',
            validator: Validators.isNotEmpty,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _timeController,
            labelText: 'Horário',
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _detailsController,
            labelText: 'Detalhes',
            minLines: 8,
            maxLines: 8,
          ),
        ],
      ),
    );
  }

  void _onCreateOrUpdate() {
    widget.onCreateOrUpdate(
      widget.post.copyWith(
        id: widget.post.id,
        type: PostType.event,
        createdAt: widget.post.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        isPublished: widget.post.isPublished,
        isHighlighted: widget.post.isHighlighted,
        body: EventModel(
          title: _titleController.text,
          scope: _selectedScope!,
          image: _imageController.text,
          link: _linkController.text,
          location: _locationController.text,
          city: _cityController.text,
          date: _dateController.text,
          time: _timeController.text.isEmpty ? null : _timeController.text,
          details: _detailsController.text.isEmpty ? null : _detailsController.text,
        ),
      ),
    );
  }
}
