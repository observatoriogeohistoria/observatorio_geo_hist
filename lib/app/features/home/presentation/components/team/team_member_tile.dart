import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/team_model.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/team/member_avatar.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/team/sort_team.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Com descrição, leva à página da pessoa; sem descrição e com Lattes, abre o currículo.
class TeamMemberTile extends StatefulWidget {
  const TeamMemberTile({super.key, required this.member});

  final TeamMemberModel member;

  @override
  State<TeamMemberTile> createState() => _TeamMemberTileState();
}

class _TeamMemberTileState extends State<TeamMemberTile> {
  bool _hovered = false;

  TeamMemberModel get _member => widget.member;

  bool get _hasPage => memberHasPage(_member);

  String get _lattesUrl => _member.lattesUrl?.trim() ?? '';

  bool get _isLink => _hasPage || _lattesUrl.isNotEmpty;

  String get _target => _hasPage ? AppRoutes.member(_member.id!) : _lattesUrl;

  void _open() => _hasPage ? GoRouter.of(context).go(_target) : openUrl(_lattesUrl);

  @override
  Widget build(BuildContext context) {
    if (!_isLink) {
      return MergeSemantics(child: _content(context, hovered: false));
    }

    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r8);

    final link = Semantics(
      link: true,
      label: _hasPage
          ? '${_member.name}, ${_member.role}'
          : '${_member.name}, ${_member.role}, Currículo Lattes, abre em outra aba',
      linkUrl: Uri.parse(_target),
      onTap: _open,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: _open,
            onHover: (value) => setState(() => _hovered = value),
            borderRadius: radius,
            splashFactory: NoSplash.splashFactory,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            mouseCursor: SystemMouseCursors.click,
            child: _content(context, hovered: _hovered),
          ),
        ),
      ),
    );

    if (_hasPage) return link;
    return Tooltip(message: 'Abrir Currículo Lattes', excludeFromSemantics: true, child: link);
  }

  Widget _content(BuildContext context, {required bool hovered}) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedScale(
            scale: hovered && !reduceMotion ? components.memberAvatarHoverScale : 1,
            duration: reduceMotion ? Duration.zero : components.memberAnimation,
            child: MemberAvatar(name: _member.name, imageUrl: _member.image?.url),
          ),
          SizedBox(height: components.memberAvatarGap),
          Text(_member.name, style: styles.memberName.copyWith(color: hovered ? colors.accent : colors.ink)),
          SizedBox(height: components.memberTextGap),
          Text(_member.role, style: styles.memberRole.copyWith(color: colors.inkSecondary)),
        ],
      ),
    );
  }
}
