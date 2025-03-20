import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/loading/loading.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/utils/messenger/messenger.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/errors/auth_failure.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/cards/media_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/create_media_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/media_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/states/media_states.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class MediaSection extends StatefulWidget {
  const MediaSection({super.key});

  @override
  State<MediaSection> createState() => _MediaSectionState();
}

class _MediaSectionState extends State<MediaSection> {
  late final MediaStore mediaStore = PanelSetup.getIt<MediaStore>();
  late final AuthStore authStore = PanelSetup.getIt<AuthStore>();

  List<ReactionDisposer> _reactions = [];

  @override
  void initState() {
    super.initState();

    mediaStore.getMedias();

    _reactions = [
      reaction((_) => mediaStore.state, (state) {
        if (state is ManageMediaErrorState) {
          final error = state.failure;
          Messenger.showError(context, error.message);

          if (error is Forbidden) authStore.logout();
        }

        if (state is ManageMediaSuccessState) {
          if (state.message.isNotEmpty) {
            Messenger.showSuccess(context, state.message);
          }
        }
      }),
    ];
  }

  @override
  void dispose() {
    for (var reaction in _reactions) {
      reaction.reaction.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppHeadline.big(
          text: 'Mídias',
          color: AppTheme.colors.orange,
        ),
        SizedBox(height: AppTheme.dimensions.space.xlarge),
        Align(
          alignment: Alignment.centerRight,
          child: SecondaryButton.medium(
            text: 'Criar mídia',
            onPressed: () {
              showCreateMediaDialog(
                context,
                onCreate: (media) => mediaStore.createMedia(media),
              );
            },
          ),
        ),
        SizedBox(height: AppTheme.dimensions.space.large),
        Expanded(
          child: Observer(
            builder: (context) {
              if (mediaStore.state is ManageMediaLoadingState) {
                return const Center(child: Loading());
              }

              final medias = mediaStore.medias;

              return ListView.separated(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.only(
                  bottom: AppTheme.dimensions.space.large,
                ),
                separatorBuilder: (context, index) {
                  final isLast = index == medias.length - 1;

                  return isLast
                      ? const SizedBox()
                      : SizedBox(height: AppTheme.dimensions.space.medium);
                },
                itemCount: medias.length,
                itemBuilder: (context, index) {
                  final media = medias[index];

                  return MediaCard(
                    media: media,
                    index: index + 1,
                    onDelete: () => mediaStore.deleteMedia(media),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
