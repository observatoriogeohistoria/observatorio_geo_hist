# Tarefas da 020. Estados especiais

Legenda: `- [ ]` a fazer, `- [x]` feita.

## Grupo A: tokens
- [ ] **A1.** Tokens `skeletonBase` e `skeletonHighlight` (cores), `skeletonShimmer` (1,4 s), `notFoundActionsGap` e `notFoundCodeGap` (dimensões) e estilo `notFoundCode` (64/92/112 px, Bricolage 800). Arquivos: `theme/app_colors/app_colors.dart`, `theme/app_dimensions/app_dimensions.dart`, `theme/app_typography/app_text_styles.dart`. Atende: critério 12.

## Grupo B: esqueleto com brilho
- [x] **B1.** `Skeleton` com `AnimationController` em repetição (`skeletonShimmer`), gradiente base/claro/base deslizando por `GradientTransform`, `RepaintBoundary`, controlador parado e cor base única com `MediaQuery.disableAnimationsOf`; cores do tema; mesma assinatura. Arquivo: `core/components/skeleton/skeleton.dart`. Atende: critérios 6, 7, 12.
  - Nota: pintado por `CustomPainter` com `repaint` no controlador, sem reconstruir o widget; o `Container` filho mantém o tamanho de antes.

## Grupo C: caixas de estado
- [ ] **C1.** `StateMessageBox`: `leading` opcional no lugar do ícone (`icon` opcional, assert de um dos dois) e `titleHeadingLevel` opcional (título com `header` e `headingLevel`); padrão igual ao de hoje. Arquivo: `core/components/error_content/state_message_box.dart`. Atende: critérios 5, 9.
- [ ] **C2.** `StateErrorInline(message:, onRetry:)` com o desenho atual da faixa de erro da Home; Destaques e Equipe passam a usá-la e perdem o `_Error` local, sem mudança de texto. Arquivos: `core/components/error_content/state_error_inline.dart`, `features/home/presentation/components/highlights/highlights_section.dart`, `features/home/presentation/components/team/team_section.dart`. Atende: critério 8.
- [ ] **C3.** Remover `EmptyContent` e `PageErrorContent` depois de conferir com `grep` que não há uso (painel inclusive). Arquivos: `core/components/error_content/empty_content.dart`, `core/components/error_content/page_error_content.dart`. Atende: critério 10.

## Grupo D: página 404
- [ ] **D1.** Reescrever `PageNotFound`: `ReadingPageScaffold` com corpo em `PageContent`, respiro `listingStatePaddingTop` em cima e `readingPaddingBottom` embaixo; `StateMessageBox` com `leading` "404" (`notFoundCode`, `accent`), título "Não encontramos esta página" como `h1`, texto "O endereço pode ter mudado ou o conteúdo foi removido." e `Wrap` centralizado com `PrimaryButton.medium` "Ir para o início" (`AppRoutes.root`) e `SecondaryButton.medium` "Explorar a biblioteca" (`AppRoutes.library`). Sem `num_extension`. Arquivo: `router/page_not_found.dart`. Atende: critérios 1, 2, 3, 5, 12.

## Grupo E: documentação e verificação do código
- [ ] **E1.** `docs/arquitetura.md`: `error_content` com `StateErrorInline` e as opções novas da `StateMessageBox`; `skeleton` com brilho e movimento reduzido; 404 no desenho de estado em `router/`. Atende: critério 10.
- [ ] **E2.** `fvm dart format` nos `.dart` alterados; `fvm flutter analyze` numa cópia em caminho ASCII sem problemas novos; `fvm flutter build web --release` sem erro; busca por cor, fonte e espaço soltos, `num_extension`, `GestureDetector` e rota solta nos arquivos novos e alterados; `grep` sem `CircularProgressIndicator`/`CircularLoading`/`LoadingContent` como estado de dados fora do painel; `git diff` sem mudança em `app_router.dart`, `app_routes.dart`, modelos, `pubspec.yaml`, painel e Geoensine. Atende: critérios 10, 11, 12.

## Grupo F: conferência no app
- [ ] **F1.** Rodar o app: `fvm flutter build web --release`, servir `build/web` com fallback de SPA num servidor Python próprio e abrir no navegador embutido (ou Chrome headless por CDP) em **390, 768 e 1280 px**:
  - 404 em `/nao-existe` (estrutura, textos, "404" em acento, nenhum item da navbar marcado, rodapé na base, botões empilhados só no celular), "Ir para o início" e "Explorar a biblioteca" por clique e por Tab/Enter, árvore semântica (`h1`, "404" lido antes), foco visível; mesma 404 em `/publicacoes/xyz/abc`, categoria inexistente, post inexistente, documento inexistente, `/membro/<id inexistente>` e membro sem descrição (se o ambiente tiver); endereço muito longo.
  - Esqueletos com rede lenta (limitação do CDP): Home (destaques, equipe), menu de categorias, categoria, `/publicacoes`, post, pessoa, biblioteca (índice e lista) e documento com o brilho correndo e as mesmas formas; com `prefers-reduced-motion: reduce` emulado, parados.
  - Erro com `firestore.googleapis.com` bloqueado: Destaques e Equipe com a faixa discreta e "Tentar de novo" (e sucesso depois de desbloquear); caixa de erro numa listagem e no post. Vazio e sem resultados de busca na categoria e na lista da biblioteca com os textos de hoje.
  - Sem rolagem horizontal em nenhuma.

  Depois, `fvm flutter run -d web-server --web-port <porta>` na cópia ASCII (**modo debug**) em 390, 768 e 1280 com a 404, os esqueletos e uma caixa de estado, sem `overflow` nem asserção no console. Painel: só com credenciais de teste; sem elas, "não conferido no app". Voltar o navegador ao preset desktop e parar os servidores. Atende: critérios 1 a 11.

## Critérios × tarefas
| Critério | Tarefas |
|---|---|
| 1. 404 em endereço desconhecido | D1, F1 |
| 2. Botões da 404 | D1, F1 |
| 3. Mesma 404 em todos os casos | D1, F1 |
| 4. 404 responsiva, release e debug | D1, F1 |
| 5. Acessibilidade da 404 | C1, D1, F1 |
| 6. Brilho e movimento reduzido | B1, F1 |
| 7. Formas dos esqueletos iguais | B1, F1 |
| 8. Erro discreto da Home compartilhado | C2, F1 |
| 9. Caixas de estado sem mudança | C1, F1 |
| 10. Componentes antigos removidos, sem círculo girando | C3, E1, E2, F1 |
| 11. Rotas, modelos, painel e Geoensine sem mudança | E2, F1 |
| 12. Tokens, analyze e build | A1, B1, D1, E2 |
