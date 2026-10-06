import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/form/mail_form.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/breadcrumbs.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/page_header.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/reading_page_scaffold.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_strings.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/mail_draft.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/form_validators.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/contact/contact_info_card.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  // A troca entre coluna e linha remontaria o formulário e apagaria o que foi digitado.
  final _formKey = GlobalKey();

  static const _lead =
      'O Observatório é criado por e para professores, pesquisadores e estudantes. Envie suas contribuições, opiniões e sugestões.';

  static const _hint =
      'Vamos abrir o seu programa de e-mail com a mensagem já preenchida. Falta só você apertar **Enviar** por lá.';

  static final _fields = [
    MailFormFieldSpec(
      label: 'Nome',
      validator: FormValidators.required('Informe seu nome.'),
      autofillHints: const [AutofillHints.name],
      keyboardType: TextInputType.name,
    ),
    MailFormFieldSpec(
      label: 'E-mail',
      validator: FormValidators.email('Informe um e-mail válido, como nome@exemplo.com.'),
      autofillHints: const [AutofillHints.email],
      keyboardType: TextInputType.emailAddress,
    ),
    MailFormFieldSpec(
      label: 'Assunto',
      validator: FormValidators.required('Informe o assunto.'),
    ),
    MailFormFieldSpec(
      label: 'Mensagem',
      validator: FormValidators.minLength(10, 'Escreva uma mensagem com pelo menos 10 caracteres.'),
      multiline: true,
    ),
  ];

  static MailDraft _buildDraft(List<String> values) {
    final [name, email, subject, message] = values;
    return MailDraft(
      to: AppStrings.email,
      subject: subject,
      body: '$message\n\n$name\n$email',
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
    );
    const info = ContactInfoCard();

    return ReadingPageScaffold(
      header: const PageHeader(
        breadcrumbs: [
          BreadcrumbItem('Início', route: AppRoutes.root),
          BreadcrumbItem('Fale com a gente'),
        ],
        title: 'Fale com a gente',
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
                    Expanded(flex: components.contactInfoFlex, child: info),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [form, SizedBox(height: gap), info],
                ),
        ),
      ),
    );
  }
}
