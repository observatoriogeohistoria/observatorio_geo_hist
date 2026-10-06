# Plano da 019. Colabore

- **Spec:** [spec.md](spec.md)
- **Criado em:** 2026-10-05

## Abordagem
A `CollaboratePage` é reescrita no lugar, montada como a `ContactUsPage` da 018: `ReadingPageScaffold` com `PageHeader` (migalhas, `h1`, lead), corpo num `PageContent` com o `MailForm` e a caixa "Antes de enviar" lado a lado no desktop (flex 3:2) e empilhados no celular e no tablet, e a `PartnersSection` em `beforeFooter`.

O formulário não muda: a página passa os cinco `MailFormFieldSpec`, os textos de apoio e da confirmação (`MailConfirmationTexts` com a mensagem sobre anexos) e um `buildDraft` que monta o assunto com "Colaboração: " e a assinatura sem a linha da instituição quando vazia.

A caixa lateral usa o mesmo desenho de "Outros meios". Para não duplicar, a moldura (superfície, raio, padding por faixa, título de nível 2) e o par rótulo/conteúdo saem do `ContactInfoCard` para `core/components/form/` (`MailAsideCard` e `MailAsideItem`). O `ContactInfoCard` passa a usá-los sem mudar o que mostra, e a nova `CollaborateGuideCard` (feature `posts`) monta os seis itens.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Criar | `lib/app/core/components/form/mail_aside_card.dart` | `MailAsideCard(title, children)` e `MailAsideItem(label, children)`, extraídos do `ContactInfoCard` (tokens `contactInfo*` e `radii.r18`, rótulo em `label` caixa alta `inkSecondary`) |
| Alterar | `lib/app/features/home/presentation/components/contact/contact_info_card.dart` | Usar `MailAsideCard`/`MailAsideItem`; mesmo resultado visual e semântico |
| Criar | `lib/app/features/posts/presentation/components/collaborate/collaborate_guide_card.dart` | "Antes de enviar": seis itens com os textos da spec; "Licença" com `InlineLink` para `AppStrings.creativeCommonsUrl` (`semanticLabel` "Conheça as licenças Creative Commons, abre em outra aba"); "E-mail" com `InlineLink` para `AppStrings.emailUrl` |
| Alterar (reescrever) | `lib/app/features/posts/presentation/pages/collaborate_page.dart` | Página nova (ver "Abordagem"); `StatefulWidget` com `GlobalKey` no `MailForm`, como na `ContactUsPage`, para a troca coluna/linha não apagar o digitado. Sem `num_extension`, sem a foto |
| Alterar | `docs/arquitetura.md` | `MailAsideCard`/`MailAsideItem` na seção "Formulários por e-mail"; Colabore usando `CollaborateGuideCard`; trocar "A mesma seção aparece em Colabore" se o texto mudar de sentido |

Não mudam: `mail_form.dart`, `mail_confirmation.dart`, `form_text_field.dart`, `form_validators.dart`, `mail_draft.dart`, `app_router.dart`, `AppRoutes`, `posts_page.dart`, `category_model.dart`, painel. Sem token novo previsto: a página reaproveita os `contact*` (respiros, vão entre colunas, flex, padding da caixa), que são os do formulário por e-mail.

## Decisões técnicas
- **Tokens `contact*` reaproveitados sem renomear.** Colabore tem o mesmo layout de Contato; renomear para `mailPage*` mexeria na página verificada da 018 sem ganho visível. Se a revisão pedir, renomear numa limpeza (Fase 7).
- **Extrair a moldura da caixa lateral** em vez de copiar o `_InfoItem`: duas páginas com o mesmo desenho, e a extração é pequena. Alternativa (copiar) deixaria as duas caixas divergirem com o tempo. Custo: toca o `ContactInfoCard`; conferir `/contato` igual (critério 11).
- **Textos longos da caixa em `Text` com `styles.regular` e `ink`**, como o endereço de "Outros meios". O link das licenças fica numa linha própria abaixo do texto da licença, em vez de dentro da frase, para o foco e o nome acessível ficarem simples.
- **Instituição sem validador** (`validator: null`): o `MailForm` já trata campo sem regra. A linha some da assinatura quando o valor aparado é vazio (o `buildDraft` recebe valores aparados).
- **Assunto com prefixo fixo** montado no `buildDraft`, sem tratar título que já comece com "Colaboração:" (a spec aceita a repetição).
- **`autofillHints` de Instituição:** `AutofillHints.organizationName`; Nome completo usa `AutofillHints.name` e teclado `TextInputType.name`.
- **"Realização e apoio" em `beforeFooter`** do `ReadingPageScaffold`, que já põe o conteúdo acima do rodapé e o rodapé na base.

## Dependências e geração de código
- Sem pacote novo, sem asset novo (o `collaborate.webp` fica até a Fase 7).
- Sem `build_runner` (nenhum store MobX nem modelo Freezed).
- Sem rota nova; `app_router.dart` continua construindo `const CollaboratePage()`. Sem registro em `*_setup.dart`.

## Riscos e cuidados
- **Regressão em Fale com a gente** pela extração da caixa lateral: comparar `/contato` antes e depois em 390 e 1280 (título, rótulos, espaços, links, ordem de Tab).
- **Caixa lateral longa no desktop:** com seis itens, "Antes de enviar" pode ficar mais alta que o formulário; tudo alinhado no topo, sem problema de layout, mas conferir que não há `overflow` com a confirmação (mais curta) ao lado.
- **Textos longos da licença em 390 px:** conferir quebra de linha em debug.
- **`mailto:` longo:** assunto e corpo com acentos e caracteres especiais; conferir o endereço gerado por interceptação, como na 018.
- **Link externo:** `InlineLink` abre `https` em outra aba (`sameTab` só para `mailto:`/`tel:`); conferir que não navega na mesma aba.
- **Botão da categoria:** depende de haver no ambiente de testes uma categoria com `hasCollaborateOption`; sem ela, conferir pelo código que o `PostsPage` não mudou e registrar.

## Como conferir
- `fvm dart format` nos `.dart` alterados e `fvm flutter analyze` numa cópia em caminho ASCII.
- `fvm flutter build web --release`, servir `build/web` com fallback de SPA e abrir `/colaborar` e `/contato` em 390, 768 e 1280.
- `fvm flutter run -d web-server` na cópia ASCII (modo debug), sem `overflow` nem asserção no console.
- `git diff` sem mudança em rotas, modelos, peças do formulário e painel.
