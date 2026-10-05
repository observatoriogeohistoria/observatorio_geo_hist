# Plano da 018. Fale com a gente

- **Spec:** [spec.md](spec.md)
- **Criado em:** 2026-10-05

## Abordagem
A `ContactUsPage` é reescrita no lugar sobre o `ReadingPageScaffold`, com `PageHeader` (migalhas, `h1`, lead) e o corpo num `PageContent` (1120 px): formulário e "Outros meios" lado a lado no desktop (flex 3:2) e empilhados no celular e no tablet, pela `Breakpoint` de `ScreenUtils`.

O formulário, a validação e a confirmação saem como peças de `core/`, sem nada de "contato" dentro, para a 019 montar o Colabore só trocando campos e textos:
- `MailForm` recebe a lista de campos (`MailFormFieldSpec`: rótulo, tipo, validador, sugestão do navegador), o texto do botão, o texto de apoio, o destinatário e uma função que monta o rascunho (`MailDraft`) a partir dos valores. Cuida do `Form`, da validação no envio e depois dela ao digitar, do foco no primeiro inválido, da abertura do `mailto:` e da troca para a confirmação e de volta, mantendo os valores.
- `MailConfirmation` mostra ícone, título, textos, o link do destinatário e os botões "Copiar mensagem" e "Voltar ao formulário", com o retorno de cópia no padrão do `PostShare` (013).
- `FormTextField` é o campo do site novo (rótulo acima, borda, erro abaixo), separado do `AppTextField`, que segue no painel.
- `FormValidators` traz as regras (obrigatório, e-mail, tamanho mínimo) com mensagem recebida de fora e espaços aparados; o `Validators` do painel e do login não muda.
- `MailDraft` monta o endereço `mailto:` e o texto copiado.

"Outros meios" é um componente da feature `home` (`ContactInfoCard`), com links feitos por um `InlineLink` novo de `core/components/buttons/` (acento, sublinhado, `InkWell` + `AppFocusRing`, nome acessível).

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/app/theme/app_colors/app_colors.dart` | `fieldBorder` (#8A8178, 3,8:1 no branco) para a borda do campo; a `line` do protótipo (1,3:1) não basta como único contorno |
| Alterar | `lib/app/theme/app_dimensions/app_dimensions.dart` | Tokens do formulário (altura 48, borda 1,5, anel de foco 4, raio 12, padding 14/12, vão entre campos 18, rótulo/campo 6, linhas da mensagem 6 a 12, apoio no topo 12 e largura máx. 480), da confirmação (padding 48/24, vão 10, ícone 56 e glifo 26, raio 18, vão dos botões 10) e da página (respiro 40/72, vão entre colunas 28/48/72 por faixa, caixa "Outros meios" com padding 20/28 por faixa e raio 18, vão rótulo/valor 2 e entre itens 14). Valores da aba "Contato" |
| Alterar | `lib/app/theme/app_typography/app_text_styles.dart` | `formLabel` (Figtree 600, 15), `formError` (Figtree 500, 14), `confirmationTitle` (Bricolage 700, 1,4 a 1,6 rem). Apoio usa `small`; título de "Outros meios" usa `stateTitle`; rótulos usam `label` |
| Criar | `lib/app/core/utils/validators/form_validators.dart` | `FormValidators.required(msg)`, `.email(msg)`, `.minLength(n, msg)`: devolvem `String? Function(String?)`, aparam espaços. E-mail: `^[^\s@]+@[^\s@]+\.[^\s@]+$` (do protótipo) |
| Criar | `lib/app/core/utils/url/mail_draft.dart` | `MailDraft(to, subject, body)` com `mailtoUrl` (assunto e corpo com `Uri.encodeComponent`) e `copyText` ("Para:", "Assunto:", corpo) |
| Criar | `lib/app/core/components/form/form_text_field.dart` | `FormTextField`: rótulo visível ligado ao campo, `TextFormField` com `fieldBorder`/acento/erro, anel suave no foco, erro abaixo (`errorMaxLines`), linha simples ou várias linhas com mínimo e máximo, `textInputAction`, `autofillHints`, `focusNode` |
| Criar | `lib/app/core/components/form/mail_form.dart` | `MailForm` e `MailFormFieldSpec` (ver "Abordagem"); `AutofillGroup`; foco no primeiro inválido; `AutovalidateMode.always` depois da primeira tentativa; `openUrl(draft.mailtoUrl, sameTab: true)`; troca imediata para a `MailConfirmation` e volta com valores mantidos e foco no primeiro campo |
| Criar | `lib/app/core/components/form/mail_confirmation.dart` | `MailConfirmation`: caixa com borda, ícone de envelope em `successSurface`/`success`, título com foco e `liveRegion`, textos (com **Enviar** em negrito), link `mailto:` do destinatário, `SecondaryButton` "Copiar mensagem" (`reserveTexts` "Mensagem copiada"/"Erro ao copiar", `Clipboard`, `shareFeedbackDuration`, anúncio) e `AppTextButton` "Voltar ao formulário" |
| Criar | `lib/app/core/components/buttons/inline_link.dart` | `InlineLink(text, url, semanticLabel?)`: texto em acento sublinhado, `InkWell` + `AppFocusRing`, `openUrl(sameTab: true)` para `mailto:`/`tel:` |
| Alterar | `lib/app/core/components/buttons/primary_button.dart` | `leadingIcon` opcional, repassado ao `AppButtonBase` (que já o aceita). Padrão nulo: nenhuma tela muda |
| Criar | `lib/app/features/home/presentation/components/contact/contact_info_card.dart` | "Outros meios": título, pares rótulo/valor (E-mail, Telefones, Endereço) com `InlineLink`; constantes de `AppStrings` |
| Alterar (reescrever) | `lib/app/features/home/presentation/pages/contact_us_page.dart` | Página nova: `ReadingPageScaffold`, `PageHeader`, layout em colunas, `MailForm` com os quatro campos e textos da spec, `ContactInfoCard`. Sem `num_extension` |
| Alterar | `docs/arquitetura.md` | `core/components/form/` (peças de formulário por e-mail, para Contato e Colabore) e `InlineLink` na tabela do Core |

Não mudam: `app_router.dart`, `AppRoutes`, `AppTextField`, `Validators`, `CollaboratePage`, rodapé, `ContactCallSection`, painel.

## Decisões técnicas
- **Peças em `core/` com campos por especificação** em vez de um formulário fixo de contato. A 019 terá campos e textos próprios; com `MailFormFieldSpec` e a função de rascunho, ela não precisa mexer no `MailForm`. Alternativa (copiar o formulário para a 019) duplicaria validação, foco e confirmação.
- **`FormTextField` novo, sem mexer no `AppTextField`.** O `AppTextField` está em 20 telas do painel e usa `num_extension`; mudá-lo alteraria o painel, que está fora do escopo.
- **`FormValidators` novo, sem mexer no `Validators`.** O `isValidEmail` atual é usado no login e tem outra mensagem e regra.
- **Erro pelo próprio `TextFormField`** (`validator` + `errorStyle`): o texto aparece abaixo do campo e o leitor de tela o lê junto com o campo, sem `Semantics` manual. O rótulo visível fica fora do `InputDecoration` (o protótipo tem rótulo acima, não dentro); para ligá-lo ao campo, o `FormTextField` passa o rótulo como `Semantics(label:)` do campo e exclui o `Text` visível da árvore semântica.
- **Borda e anel de foco** como no `SearchField`: a borda fica na decoração do campo (`OutlineInputBorder` com `fieldBorder`, acento no foco, `error` com erro) e o anel `accentSoft` de 4 px num contêiner ao redor, só com foco.
- **Validação depois da primeira tentativa com `AutovalidateMode.always`** no `Form`: `onUserInteraction` só confere campos já tocados, e a spec pede o erro sumindo ao corrigir qualquer campo. Antes da primeira tentativa, `disabled`.
- **Foco no primeiro inválido:** depois do `validate()`, o `MailForm` percorre os campos na ordem e chama `requestFocus` no primeiro cujo validador falha.
- **`mailto:` com `Uri.encodeComponent`**, montado à mão. `Uri(queryParameters:)` troca espaço por `+`, que alguns programas de e-mail mostram literalmente. Abre com `sameTab: true` (sem aba em branco), como os links `mailto:` do rodapé.
- **Confirmação sem animação.** A troca é um `if` simples; atende movimento reduzido sem checagem extra.
- **Foco na confirmação e na volta** com `FocusNode` e `addPostFrameCallback` (o widget só existe depois do quadro). O título da confirmação é `Focus` + `Semantics(liveRegion: true)` para ser anunciado.
- **Retorno de cópia igual ao do `PostShare`:** mesmos textos de falha ("Erro ao copiar"), mesma duração (`shareFeedbackDuration`) e `reserveTexts` para não mudar a largura. A lógica é repetida no `MailConfirmation` em vez de extraída do `PostShare`, para não mexer no post.
- **`leadingIcon` no `PrimaryButton`**: o protótipo põe o envelope à esquerda; o `AppButtonBase` já desenha ícone à esquerda.

## Dependências e geração de código
- Sem pacote novo, sem asset novo (`url_launcher` e `flutter/services` já estão).
- Sem `build_runner`: nenhum store MobX nem modelo Freezed (o estado do formulário é local do `MailForm`).
- Sem rota nova nem registro em `*_setup.dart`.

## Riscos e cuidados
- **Rótulo e erro no leitor de tela.** `Semantics(label:)` em volta do `TextFormField` pode duplicar ou perder o nome no web. Conferir na árvore semântica (via `read_page` do navegador) que cada campo é lido com o rótulo e o erro; se duplicar, usar `InputDecoration.label` escondido ou `MergeSemantics`.
- **Autofill no web.** `autofillHints` só funciona dentro de `AutofillGroup`; conferir que o navegador sugere nome e e-mail.
- **`mailto:` no web.** O navegador não informa se abriu; `canLaunchUrl` costuma devolver verdadeiro. A confirmação aparece sempre, então não depende disso. No navegador embutido sem programa de e-mail, conferir só que não há erro e que o endereço gerado está certo (log ou interceptação em debug).
- **Clipboard no web** exige contexto seguro (`localhost` vale) e gesto do usuário; fora disso cai em "Erro ao copiar".
- **Textos longos.** Rótulo, erro e valores precisam quebrar linha em 390 px (`errorMaxLines`, `Wrap` nos botões da confirmação); conferir em debug, que mostra `overflow` escondido no release.
- **Componentes compartilhados.** `PrimaryButton` ganha um parâmetro opcional: conferir Home (chamada para contato), Manifesto e detalhe da biblioteca sem mudança. `PageHeader`, `ReadingPageScaffold`, `SecondaryButton` e `AppTextButton` não mudam.
- **Painel e Colabore.** Conferir no `git diff` que `app_text_field.dart`, `validators.dart`, `collaborate_page.dart` e o painel não mudaram.

## Como conferir
- `fvm dart format` nos `.dart` alterados e `fvm flutter analyze` numa cópia em caminho ASCII.
- `fvm flutter build web --release`, servir `build/web` com fallback de SPA e abrir `/contato` em 390, 768 e 1280: formulário vazio, envio vazio (erros e foco), correção (erro some), e-mail inválido, textos longos, envio válido (confirmação, foco, link), "Copiar mensagem" (conferir o texto copiado), "Voltar ao formulário" (campos mantidos), Tab e foco visível, links de "Outros meios".
- `fvm flutter run -d web-server` na cópia ASCII (debug), sem `overflow` nem asserção no console.
- Home, Manifesto e detalhe da biblioteca sem mudança no botão principal.
