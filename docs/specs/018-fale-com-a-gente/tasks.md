# Tarefas da 018. Fale com a gente

Legenda: `- [ ]` a fazer, `- [x]` feita.

## Grupo A: tema e utilitários
- [ ] **A1.** Tokens do formulário, da confirmação e da página: cor `fieldBorder`; dimensões listadas no plano; estilos `formLabel`, `formError` e `confirmationTitle`. Arquivos: `app_colors.dart`, `app_dimensions.dart`, `app_text_styles.dart`. Atende: critérios 9, 12.
- [ ] **A2.** `FormValidators` (`required`, `email`, `minLength`, com mensagem de fora e espaços aparados) e `MailDraft` (`mailtoUrl` com `Uri.encodeComponent`, `copyText`). Conferir à mão (num `main` descartável ou no console de debug) que acentos, `&`, `?`, `#`, `%`, emojis e quebras de linha saem codificados e que "  a@b.co " é válido. Arquivos: `core/utils/validators/form_validators.dart`, `core/utils/url/mail_draft.dart`. Atende: critérios 3, 4, 6, 11.

## Grupo B: componentes compartilhados
- [ ] **B1.** `leadingIcon` opcional no `PrimaryButton`, repassado ao `AppButtonBase`. Arquivo: `core/components/buttons/primary_button.dart`. Atende: critério 2.
- [ ] **B2.** `InlineLink` (acento sublinhado, `InkWell` + `AppFocusRing`, nome acessível, `openUrl` com `sameTab` para `mailto:`/`tel:`). Arquivo: `core/components/buttons/inline_link.dart`. Atende: critérios 5, 8.
- [ ] **B3.** `FormTextField`: rótulo visível acima e ligado ao campo, borda `fieldBorder`/acento/erro, anel no foco, erro abaixo com `errorMaxLines`, linha simples ou várias linhas (6 a 12), `textInputAction`, `autofillHints`, teclado de e-mail. Arquivo: `core/components/form/form_text_field.dart`. Atende: critérios 2, 3, 9.
- [ ] **B4.** `MailConfirmation`: ícone, título focável e anunciado, textos com **Enviar** em negrito, "Não abriu?" com `InlineLink` do destinatário, "Copiar mensagem" (`SecondaryButton` com `reserveTexts`, `Clipboard`, "Mensagem copiada"/"Erro ao copiar" por `shareFeedbackDuration`, anúncio) e "Voltar ao formulário" (`AppTextButton`); botões em `Wrap` centralizado. Textos recebidos de fora. Arquivo: `core/components/form/mail_confirmation.dart`. Atende: critérios 5, 6, 9, 11.
- [ ] **B5.** `MailForm` + `MailFormFieldSpec`: campos na ordem, `AutofillGroup`, Enter passa de campo nas linhas simples, validação só no envio e depois `AutovalidateMode.always`, foco no primeiro inválido, `openUrl(draft.mailtoUrl, sameTab: true)`, troca imediata para a confirmação (foco no título) e volta com valores mantidos, sem erros e foco no primeiro campo; botão principal com `leadingIcon` (largura toda no celular) e texto de apoio abaixo. Arquivo: `core/components/form/mail_form.dart`. Atende: critérios 2, 3, 4, 5, 7, 11.

## Grupo C: página
- [ ] **C1.** `ContactInfoCard` ("Outros meios": E-mail, Telefones e Endereço do rodapé com `InlineLink`; rótulos em `label`, sem redes sociais). Arquivo: `features/home/presentation/components/contact/contact_info_card.dart`. Atende: critério 8.
- [ ] **C2.** Reescrever `ContactUsPage`: `ReadingPageScaffold`, `PageHeader` ("Início › Fale com a gente", `h1`, lead da spec), `PageContent` com formulário (flex 3) e `ContactInfoCard` (flex 2) lado a lado no desktop e empilhados no celular e no tablet; `MailForm` com Nome, E-mail, Assunto e Mensagem, regras e mensagens da tabela da spec, corpo "mensagem, linha em branco, nome, e-mail" e textos da confirmação. Sem `num_extension`. Arquivo: `features/home/presentation/pages/contact_us_page.dart`. Atende: critérios 1, 2, 3, 4, 5, 10.

## Grupo D: documentação e verificação do código
- [ ] **D1.** `docs/arquitetura.md`: `core/components/form/` (`MailForm`, `MailFormFieldSpec`, `FormTextField`, `MailConfirmation`), `FormValidators`, `MailDraft` e `InlineLink`, dizendo que servem a Contato e Colabore. Atende: critério 11.
- [ ] **D2.** `fvm dart format` nos `.dart` alterados; `fvm flutter analyze` numa cópia em caminho ASCII sem problemas novos; `fvm flutter build web --release` sem erro; busca por cor, fonte e espaço soltos, `num_extension`, `GestureDetector` e rota solta nos arquivos novos; `git diff` sem mudança em `app_text_field.dart`, `validators.dart`, `collaborate_page.dart`, `app_router.dart`, `app_routes.dart` e painel. Atende: critérios 11, 12.

## Grupo E: conferência no app
- [ ] **E1.** Rodar o app: `fvm flutter build web --release`, servir `build/web` com fallback de SPA num servidor Python próprio e abrir `/contato` no navegador embutido em **390, 768 e 1280 px**: cabeçalho e migalhas; formulário vazio; envio vazio (quatro erros, foco no Nome, nada aberto); correção de cada campo (erro some); e-mail inválido e com espaço no fim; Enter nas linhas simples e na mensagem; textos muito longos; envio válido (endereço `mailto:` gerado conferido, confirmação com foco e anúncio); "Copiar mensagem" (texto copiado no formato da spec e retorno sem mudar de largura); "Voltar ao formulário" (campos mantidos, foco no Nome) e novo envio; links de "Outros meios"; ordem de Tab e foco visível; árvore semântica dos campos (rótulo e erro); sem rolagem horizontal; rodapé na base. Depois, `fvm flutter run -d web-server --web-port <porta>` na cópia ASCII (**modo debug**) nas mesmas larguras, com erros e confirmação, sem `overflow` nem asserção no console. Conferir Home (chamada para contato), Manifesto e detalhe da biblioteca com o botão principal igual. Painel: só com credenciais de teste; sem elas, "não conferido no app". Voltar o navegador ao preset desktop e parar os servidores. Atende: critérios 1 a 10.

## Critérios × tarefas
| Critério | Tarefas |
|---|---|
| 1. Estrutura da página | C2, E1 |
| 2. Campos, botão e apoio | B1, B3, B5, C2, E1 |
| 3. Validação | A2, B3, B5, C2, E1 |
| 4. Abertura do e-mail | A2, B5, C2, E1 |
| 5. Confirmação | B2, B4, B5, C2, E1 |
| 6. Copiar mensagem | A2, B4, E1 |
| 7. Voltar ao formulário | B5, E1 |
| 8. Outros meios | B2, C1, E1 |
| 9. Acessibilidade | A1, B3, B4, E1 |
| 10. Responsivo, release e debug | C2, E1 |
| 11. Peças compartilhadas, sem mudar Colabore/painel | A2, B4, B5, D1, D2 |
| 12. Tokens, analyze e build | A1, D2 |
