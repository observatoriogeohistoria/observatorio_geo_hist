# Tarefas da 019. Colabore

Legenda: `- [ ]` a fazer, `- [x]` feita.

## Grupo A: caixa lateral compartilhada
- [ ] **A1.** Extrair `MailAsideCard(title, children)` e `MailAsideItem(label, children)` do `ContactInfoCard` (moldura em superfície, raio 18, padding por faixa, título `h2` semântico em `stateTitle`, rótulo em `label` caixa alta `inkSecondary`) e passar o `ContactInfoCard` a usá-los, sem mudar o que mostra. Arquivos: `core/components/form/mail_aside_card.dart`, `features/home/presentation/components/contact/contact_info_card.dart`. Atende: critérios 6, 11, 12.

## Grupo B: página
- [ ] **B1.** `CollaborateGuideCard` ("Antes de enviar"): seis itens com os textos da spec em `regular`/`ink`; "Licença" com `InlineLink` "Conheça as licenças Creative Commons" para `AppStrings.creativeCommonsUrl`, nome acessível dizendo que abre em outra aba; "E-mail" com `InlineLink` para `AppStrings.emailUrl`. Arquivo: `features/posts/presentation/components/collaborate/collaborate_guide_card.dart`. Atende: critérios 6, 7, 8.
- [ ] **B2.** Reescrever `CollaboratePage`: `ReadingPageScaffold` com `PageHeader` ("Início › Colabore", `h1` "Colabore", lead da spec), `PageContent` com `MailForm` (flex 3, `GlobalKey`) e `CollaborateGuideCard` (flex 2) lado a lado no desktop e empilhados no celular e no tablet, `PartnersSection` em `beforeFooter`. `MailForm` com os cinco campos (rótulos, regras, mensagens, teclados e `autofillHints` da spec; Instituição sem validador), texto de apoio sobre anexos, `MailConfirmationTexts` com a mensagem sobre anexos e `buildDraft` com assunto "Colaboração: [título]" e corpo "texto, linha em branco, nome, instituição (se houver), e-mail". Sem foto, sem `num_extension`. Arquivo: `features/posts/presentation/pages/collaborate_page.dart`. Atende: critérios 1, 2, 3, 4, 5, 7, 9.

## Grupo C: documentação e verificação do código
- [ ] **C1.** `docs/arquitetura.md`: `MailAsideCard`/`MailAsideItem` em "Formulários por e-mail" e Colabore com `CollaborateGuideCard`. Atende: critério 11.
- [ ] **C2.** `fvm dart format` nos `.dart` alterados; `fvm flutter analyze` numa cópia em caminho ASCII sem problemas novos; `fvm flutter build web --release` sem erro; busca por cor, fonte e espaço soltos, `num_extension`, `GestureDetector` e rota solta nos arquivos novos e alterados; `git diff` sem mudança em `app_router.dart`, `app_routes.dart`, `posts_page.dart`, `category_model.dart`, `mail_form.dart`, `mail_confirmation.dart`, `form_text_field.dart`, `form_validators.dart`, `mail_draft.dart`, `pubspec.yaml` e painel. Atende: critérios 10, 11, 12.

## Grupo D: conferência no app
- [ ] **D1.** Rodar o app: `fvm flutter build web --release`, servir `build/web` com fallback de SPA num servidor Python próprio e abrir `/colaborar` no navegador embutido em **390, 768 e 1280 px**: cabeçalho e migalhas, sem foto; formulário vazio; envio vazio (quatro erros, nenhum em Instituição, foco em Nome completo, nada aberto); correção de cada campo (erro some); Instituição vazia e preenchida; textos muito longos; envio válido (endereço `mailto:` interceptado com assunto "Colaboração: …", corpo e assinatura com e sem instituição, acentos, `&`, `?`, `#`, `%`, emoji e quebras de linha inteiros); confirmação com o texto sobre anexos, foco e anúncio; "Copiar mensagem" (texto copiado); "Voltar ao formulário" e novo envio; "Antes de enviar" com os seis itens, link das licenças em outra aba e link do e-mail; ordem de Tab e foco visível; árvore semântica (rótulos, "(opcional)", erros, `h1`/`h2`); "Realização e apoio" antes do rodapé; sem rolagem horizontal; rodapé na base. Abrir `/contato` em 390 e 1280 e conferir "Outros meios" igual ao da 018. Abrir uma categoria com `hasCollaborateOption` e seguir "Colabore com esta categoria" até `/colaborar`, e uma sem a opção (sem o botão); se o ambiente não tiver categoria com a opção, registrar. Depois, `fvm flutter run -d web-server --web-port <porta>` na cópia ASCII (**modo debug**) em 390, 768 e 1280, com erros e confirmação, sem `overflow` nem asserção no console. Painel: só com credenciais de teste; sem elas, "não conferido no app". Voltar o navegador ao preset desktop e parar os servidores. Atende: critérios 1 a 11.

## Critérios × tarefas
| Critério | Tarefas |
|---|---|
| 1. Estrutura da página | B2, D1 |
| 2. Campos, botão e apoio | B2, D1 |
| 3. Validação | B2, D1 |
| 4. Abertura do e-mail | B2, D1 |
| 5. Confirmação | B2, D1 |
| 6. Antes de enviar | A1, B1, D1 |
| 7. Conteúdo atual preservado | B1, B2, D1 |
| 8. Acessibilidade | B1, D1 |
| 9. Responsivo, release e debug | B2, D1 |
| 10. Botão da categoria | C2, D1 |
| 11. Contato, rota, modelo e painel sem mudança | A1, C1, C2, D1 |
| 12. Tokens, analyze e build | A1, C2 |
