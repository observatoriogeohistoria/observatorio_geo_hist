import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/team_model.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/team/member_avatar.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Membro da equipe na grade da Home (spec 008): foto, nome e função.
///
/// Só quem tem descrição é link para `/membro/:id` (cursor de mão, nome
/// laranja e foto maior no hover, foco por teclado). Sem descrição, é só texto.
class TeamMemberTile extends StatefulWidget {
  const TeamMemberTile({super.key, required this.member});

  final TeamMemberModel member;

  @override
  State<TeamMemberTile> createState() => _TeamMemberTileState();
}

class _TeamMemberTileState extends State<TeamMemberTile> {
  bool _hovered = false;

  TeamMemberModel get _member => widget.member;

  bool get _isLink => _member.id != null && (_member.description?.trim().isNotEmpty ?? false);

  String get _path => '/membro/${_member.id}';

  void _open() => GoRouter.of(context).go(_path);

  @override
  Widget build(BuildContext context) {
    if (!_isLink) {
      return MergeSemantics(child: _content(context, hovered: false));
    }

    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r8);

    return Semantics(
      link: true,
      label: '${_member.name}, ${_member.role}',
      linkUrl: Uri.parse(_path),
      // Repete a ação do InkWell (excluído da semântica) para o leitor de tela ativar o membro.
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
