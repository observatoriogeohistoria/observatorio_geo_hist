import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/form/mail_confirmation.dart';
import 'package:observatorio_geo_hist/app/core/components/form/mail_form.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/core/components/partners/partners_section.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/breadcrumbs.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/page_header.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/reading_page_scaffold.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_strings.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/mail_draft.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/form_validators.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/collaborate/collaborate_guide_card.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class CollaboratePage extends StatefulWidget {
  const CollaboratePage({super.key});

  @override
  State<CollaboratePage> createState() => _CollaboratePageState();
}

class _CollaboratePageState extends State<CollaboratePage> {
  // A troca entre coluna e linha remontaria o formulário e apagaria o que foi digitado.
  final _formKey = GlobalKey();

  static const _lead =
      'O Observatório é uma plataforma colaborativa. Professores, pesquisadores e estudantes podem publicar artigos de opinião, relatos de experiência e produções acadêmicas, ou sugerir materiais.';

  static const _hint =
      'Vamos abrir o seu programa de e-mail com a mensagem já preenchida. Anexe seus arquivos por lá e aperte **Enviar**.';

  static const _confirmationTexts = MailConfirmationTexts(
    message:
        'Abrimos o seu programa de e-mail com a mensagem preenchida. Anexe seus arquivos e aperte **Enviar** por lá para concluir.',
  );

  static final _fields = [
    MailFormFieldSpec(
      label: 'Nome completo',
      validator: FormValidators.required('Informe seu nome completo.'),
      autofillHints: const [AutofillHints.name],
      keyboardType: TextInputType.name,
    ),
    MailFormFieldSpec(
      label: 'E-mail',
      validator: FormValidators.email('Informe um e-mail válido, como nome@exemplo.com.'),
      autofillHints: const [AutofillHints.email],
      keyboardType: TextInputType.emailAddress,
    ),
    const MailFormFieldSpec(
      label: 'Instituição (opcional)',
      autofillHints: [AutofillHints.organizationName],
    ),
    MailFormFieldSpec(
      label: 'Título da contribuição',
      validator: FormValidators.required('Informe o título da contribuição.'),
    ),
    MailFormFieldSpec(
      label: 'Sobre a contribuição',
      validator: FormValidators.minLength(
        10,
        'Conte um pouco sobre a contribuição, com pelo menos 10 caracteres.',
      ),
      multiline: true,
    ),
  ];

  static MailDraft _buildDraft(List<String> values) {
    final [name, email, institution, title, about] = values;
    final signature = [name, if (institution.isNotEmpty) institution, email].join('\n');
    return MailDraft(
      to: AppStrings.email,
      subject: 'Colaboração: $title',
      body: '$about\n\n$signature',
    );
  }

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final breakpoint = ScreenUtils.breakpointOf(context);
    final gap = components.contactColumnsGap(breakpoint);

    final form = MailForm(
      key: _formKey,
      fields: _fields,
      submitText: 'Abrir no meu e-mail',
      hint: _hint,
      buildDraft: _buildDraft,
      confirmationTexts: _confirmationTexts,
    );
    const guide = CollaborateGuideCard();

    return ReadingPageScaffold(
      header: const PageHeader(
        breadcrumbs: [
          BreadcrumbItem('Início', route: AppRoutes.root),
          BreadcrumbItem('Colabore'),
        ],
        title: 'Colabore',
        lead: _lead,
      ),
      body: PageContent(
        child: Padding(
          padding: EdgeInsets.only(
            top: components.contactPaddingTop,
            bottom: components.contactPaddingBottom,
          ),
          child: breakpoint == Breakpoint.desktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: components.contactFormFlex, child: form),
                    SizedBox(width: gap),
                    Expanded(flex: components.contactInfoFlex, child: guide),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [form, SizedBox(height: gap), guide],
                ),
        ),
      ),
      beforeFooter: const PartnersSection(),
    );
  }
}
