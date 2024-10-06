import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/team_model.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class TeamMemberPage extends StatelessWidget {
  const TeamMemberPage({
    required this.member,
    super.key,
  });

  final TeamMemberModel member;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Navbar(),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.2,
                vertical: 2 * AppTheme.dimensions.space.large,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      member.name.toUpperCase(),
                      style: AppTheme.typography.headline.large.copyWith(
                        color: AppTheme.colors.orange,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      member.role.toUpperCase(),
                      style: AppTheme.typography.headline.medium.copyWith(
                        color: AppTheme.colors.gray,
                      ),
                    ),
                  ),
                  SizedBox(height: AppTheme.dimensions.space.large),
                  Text(
                    member.description,
                    textAlign: TextAlign.justify,
                    style: AppTheme.typography.body.large.copyWith(
                      color: AppTheme.colors.black,
                    ),
                  ),
                  if (member.lattesUrl.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: AppTheme.dimensions.space.large),
                      child: PrimaryButton(
                        text: 'Currículo Lattes',
                        onPressed: () async {
                          final url = member.lattesUrl;
                          html.window.open(url, 'new tab');
                        },
                      ),
                    ),
                ],
              ),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
