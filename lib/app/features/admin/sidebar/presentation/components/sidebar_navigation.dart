import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/panel_counts.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/panel_counts_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/components/sidebar_group_label.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/components/sidebar_menu_item.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/enums/sidebar_item.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/labels/post_type_panel_labels.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/stores/sidebar_store.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({this.isDrawer = false, this.onNavigate, super.key});

  /// Na gaveta o foco vai para o item atual ao abrir.
  final bool isDrawer;

  /// Chamado depois de escolher um item, para a página fechar a gaveta.
  final VoidCallback? onNavigate;

  @override
  Widget build(BuildContext context) {
    final authStore = PanelSetup.getIt<AuthStore>();
    final sidebarStore = PanelSetup.getIt<SidebarStore>();
    final countsStore = PanelSetup.getIt<PanelCountsStore>();
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Seções do painel',
      child: Material(
        color: colors.page,
        child: Observer(
          builder: (context) {
            final canSeeUsers = authStore.user?.permissions.canAccessUsersSection ?? false;
            final selectedItem = sidebarStore.selectedItem;
            final selectedType = sidebarStore.selectedPostType ?? PostType.article;
            final counts = countsStore.counts;

            void open(SidebarItem item, {PostType? type}) {
              sidebarStore.selectItem(item);
              if (item == SidebarItem.posts) {
                final postType = type ?? PostType.article;
                sidebarStore.selectPostType(postType);
                GoRouter.of(context).go(AppRoutes.panelPosts(postType.value));
              } else {
                GoRouter.of(context).go(AppRoutes.panelTab(item.value));
              }
              onNavigate?.call();
            }

            Widget itemFor(SidebarItem item) {
              final isCurrent = selectedItem == item && item != SidebarItem.posts;
              return SidebarMenuItem(
                title: item.title,
                icon: item.icon,
                count: _countOf(item, counts),
                isCurrent: isCurrent,
                isParentOfCurrent: item == SidebarItem.posts && selectedItem == item,
                autofocus: isDrawer && isCurrent,
                onTap: () => open(item),
              );
            }

            Widget postTypes() {
              return Container(
                margin: EdgeInsets.only(left: components.panelNavSubIndent),
                padding: EdgeInsets.only(
                  left: components.panelNavSubPaddingStart,
                  top: components.panelNavSubPaddingTop,
                  bottom: components.panelNavSubPaddingBottom,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: colors.line, width: AppTheme.dimensions.stroke.small),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final type in SidebarItem.posts.subItems)
                      Padding(
                        padding: EdgeInsets.only(bottom: components.panelNavSubItemSpacing),
                        child: Builder(
                          builder: (context) {
                            final isCurrent =
                                selectedItem == SidebarItem.posts && selectedType == type;
                            return SidebarMenuItem(
                              title: type.panelPlural,
                              count: counts.posts(type),
                              isSubItem: true,
                              isCurrent: isCurrent,
                              autofocus: isDrawer && isCurrent,
                              onTap: () => open(SidebarItem.posts, type: type),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              );
            }

            List<Widget> group(SidebarGroup group, List<SidebarItem> items, {bool first = false}) {
              return [
                SidebarGroupLabel(title: group.title, isFirst: first),
                for (final item in items) ...[
                  Padding(
                    padding: EdgeInsets.only(bottom: components.panelNavItemSpacing),
                    child: itemFor(item),
                  ),
                  if (item == SidebarItem.posts) postTypes(),
                ],
              ];
            }

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    components.panelSidebarPaddingH,
                    components.panelSidebarPaddingV,
                    components.panelSidebarPaddingH,
                    0,
                  ),
                  sliver: SliverList.list(
                    children: [
                      ...group(
                        SidebarGroup.content,
                        [SidebarItem.posts, SidebarItem.categories, SidebarItem.library],
                        first: true,
                      ),
                      ...group(
                        SidebarGroup.filesAndPeople,
                        [SidebarItem.media, SidebarItem.team],
                      ),
                      if (canSeeUsers) ...group(SidebarGroup.administration, [SidebarItem.users]),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      components.panelSidebarPaddingH,
                      components.panelSidebarPaddingV,
                      components.panelSidebarPaddingH,
                      components.panelSidebarPaddingV,
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SidebarMenuItem(
                        title: 'Sair',
                        icon: Icons.logout,
                        isMuted: true,
                        onTap: authStore.logout,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  int? _countOf(SidebarItem item, PanelCounts counts) {
    return switch (item) {
      SidebarItem.posts => counts.postsTotal,
      SidebarItem.categories => counts.categories,
      SidebarItem.library => counts.libraryTotal,
      SidebarItem.team => counts.team,
      SidebarItem.users => counts.users,
      // O Storage não informa o total sem listar todos os arquivos.
      SidebarItem.media => null,
    };
  }
}
