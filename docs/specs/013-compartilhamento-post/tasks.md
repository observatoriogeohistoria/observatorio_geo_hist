# Tarefas da 013. Compartilhamento ampliado do post

Legenda: `- [ ]` a fazer, `- [x]` feita.

## Grupo A: base
- [ ] **A1.** Criar os seis SVGs de traço (`share_whatsapp`, `share_facebook`, `share_x`, `share_linkedin`, `share_telegram`, `share_email`) a partir dos símbolos do protótipo. Arquivos: `assets/icons/share_*.svg`. Atende: critérios 1 e 9 (conferir que aparecem num build).
- [ ] **A2.** Links novos e renome: `shareOnLinkedin`, `shareOnTelegram`, `shareOnTwitter` → `shareOnX` (atualizar `social_icons.dart`). Arquivos: `app_strings.dart`, `social_icons.dart`. Atende: critério 2.
- [ ] **A3.** Tokens do compartilhar (`shareLabelGap`, `shareCopyGap`, `shareRowGap`, `shareFeedbackDuration`). Arquivos: `app_dimensions.dart`. Atende: critério 12.
- [ ] **A4.** `native_share` com exportação condicional: `canNativeShare()` e `nativeShare()` com resultado `shared`/`cancelled`/`failed`; stub sem suporte. Arquivos: `lib/app/core/utils/browser/native_share*.dart`. Atende: critério 7. Conferir: `analyze` limpo.
- [ ] **A5.** `AppButtonBase` e `SecondaryButton` com `leadingIcon` e `reserveTexts` opcionais, sem mudar o caminho atual. Arquivos: `app_button_base.dart`, `secondary_button.dart`. Atende: critério 4 (largura estável). Conferir: botões da Home iguais.

## Grupo B: componente
- [ ] **B1.** `PostShare` em tablet/desktop: grupo "Compartilhar", rótulo "COMPARTILHAR", seis `_ShareIconButton` (nome, dica, foco, hover laranja sobre laranja suave, cor `muted`) na ordem da spec e "Copiar link" secundário pequeno com ícone. Lista única de opções com os links (e-mail na mesma aba). Arquivos: `post_share.dart`. Atende: critérios 1, 2, 3, 8 e 9.
- [ ] **B2.** Copiar link: `Clipboard.setData` com `try`, texto "Link copiado"/"Não foi possível copiar" com ícone por `shareFeedbackDuration`, `Timer` reiniciado por clique e cancelado no `dispose`, anúncio ao leitor de tela, `reserveTexts`. Arquivos: `post_share.dart`. Atende: critérios 4 e 5.
- [ ] **B3.** Layout do celular: "Compartilhar" nativo (só com `canNativeShare()`), "Copiar link", WhatsApp e "Mais" (`expanded`), linha das outras cinco abaixo quando aberto; cancelado não faz nada, falha abre "Mais". Arquivos: `post_share.dart`. Atende: critérios 6, 7 e 8.

## Grupo C: integração
- [ ] **C1.** `_Byline` usa `PostShare`; tablet/desktop com `Wrap(alignment: spaceBetween)` para o compartilhar descer quando não couber; celular continua abaixo do autor. Arquivos: `article_header.dart`. Atende: critérios 1, 6 e 10.
- [ ] **C2.** Linha em `docs/arquitetura.md` sobre o `PostShare` e o uso previsto na Fase 5. Arquivos: `docs/arquitetura.md`. Atende: critério 12.
- [ ] **C3.** `fvm flutter analyze` na cópia ASCII e `fvm flutter build web --release` sem erro; conferir no código que não há cor, tamanho ou espaçamento solto nem `num_extension` em `post_share.dart` e `native_share*`. Atende: critério 12.

## Grupo D: conferência
- [ ] **D1.** Conferência rodando o app (build `APP_ENV=prod` só leitura, servidor Python próprio com fallback de SPA, navegador embutido) em **390, 768 e 1280 px**: num artigo real, opções e ordem por faixa (1, 6); links gerados de cada rede e do e-mail, com título acentuado, aspas e "&" (2, 3; título injetado num build temporário se não houver no banco); cópia, texto, largura estável e anúncio (4, 5; falha com erro injetado temporário); "Mais" por clique, Enter e Espaço e estado `expanded` (6); botão nativo presente ou ausente conforme o suporte do navegador e ausente em 768/1280 (7); Tab e foco visível em todas as opções e nas reveladas (8); contraste dos ícones e do rótulo e ausência de PNG/"Twitter" (9); `scrollWidth` = largura da janela, sem `overflow` no console, com "Mais" aberto e com autores longos (10); um post de outro tipo abre sem compartilhar e sem erro (11); um botão da Home e a caixa de erro sem mudança visual (A5). Desfazer qualquer injeção, voltar o navegador ao preset desktop e parar os servidores. Atende: critérios 1 a 11.
