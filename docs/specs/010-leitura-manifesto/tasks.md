# Tarefas da 010. Layout de leitura compartilhado e Manifesto

Legenda: `- [ ]` a fazer, `- [x]` feita.

Cada tarefa termina com `fvm flutter analyze` limpo (rodado na cópia em caminho ASCII do scratchpad). Critérios numerados na ordem da spec.

## Grupo A: Tokens
- [ ] **A1.** Tokens do cabeçalho, migalhas, coluna, lista numerada e destaque listados no plano, em `ComponentSizes`, com comentário de origem no protótipo. Arquivo: `theme/app_dimensions/app_dimensions.dart`. Conferir: valores iguais ao plano; `pageHeadPaddingVertical` mantido. Atende: critérios 8, 12 e 14.
- [ ] **A2.** Estilos `readingListItem`, `readingListNumber` e `readingQuote`, com linha na tabela do topo do arquivo. Arquivo: `theme/app_typography/app_text_styles.dart`. Atende: critérios 3, 4, 8 e 14.

## Grupo B: Base de leitura
- [ ] **B1.** `Breadcrumbs` e `BreadcrumbItem`: `Wrap`; link com `InkWell`, `AppFocusRing` e `Semantics(link)`, `inkSecondary` em repouso e `accentStrong` sublinhado no hover; seta `chevron_right` decorativa presa ao item seguinte; item atual em `ink` 600, não focável, com "página atual" no nome acessível; grupo "Você está em". Arquivo: `core/components/reading/breadcrumbs.dart`. Atende: critérios 5, 10, 11, 12 e 13.
- [ ] **B2.** `PageHeader`: faixa `surface` com linha `line` na base, `PageContent`, respiro 28 acima e 32/46/56 abaixo, migalhas, título `h1`/`ink` com `Semantics(header)` a 22 px, apoio opcional (`lead`, `inkSecondary`) a 14 px. Arquivo: `core/components/reading/page_header.dart`. Atende: critérios 1, 8, 10 e 13.
- [ ] **B3.** `ReadingColumn`: `PageContent` → coluna de até 680 px centralizada, respiro 40 acima e 40/56/64 abaixo, filhos esticados. Arquivo: `core/components/reading/reading_column.dart`. Atende: critérios 8 e 13.
- [ ] **B4.** Blocos `ReadingLead` (`lead`/`ink`), `ReadingParagraph` (`reading`/`ink`, vão `readingParagraphGap`), `ReadingNumberedList` (círculo que escala com o texto, número `accentStrong` sobre `accentSoft`, texto em `Expanded`, `SemanticsRole.list`/`listItem` com rótulo "N. texto") e `ReadingQuote` (barra `accent` à esquerda, `readingQuote`/`ink`). Arquivo: `core/components/reading/reading_blocks.dart`. Atende: critérios 3, 4, 10, 11 e 12.
- [ ] **B5.** `ReadingPageScaffold`: `Scaffold(page)` → `CustomScrollView` → `NavbarSliver`, cabeçalho opcional, corpo, `SliverFillRemaining(hasScrollBody: false)` com `Spacer` e `Footer`. Arquivo: `core/components/reading/reading_page_scaffold.dart`. Atende: critérios 1, 9 e 13.

## Grupo C: Manifesto
- [ ] **C1.** Reescrever `ManifestPage` (stateless) com `ReadingPageScaffold`, `PageHeader` (migalhas Início → `AppRoutes.root`, "Manifesto"), `ReadingColumn` e, na ordem, abertura, parágrafo, lista de 5 itens, parágrafo final, destaque e `PrimaryButton.medium("Fale com a gente", trailingIcon: Icons.arrow_forward)` → `go(AppRoutes.contact)` alinhado à esquerda. Textos exatamente os da spec. Sem `num_extension`, `AppHeadline`, `AppBody` e `AppDivider`. Arquivo: `features/home/presentation/pages/manifest_page.dart`. Conferir: comparar as strings com a spec por script e confirmar que toda frase do texto antigo está presente (salvo as correções listadas na spec). Atende: critérios 1, 2, 3, 4, 5 e 14.

## Grupo D: Documentação
- [ ] **D1.** `docs/arquitetura.md`: `reading` na tabela de `core/components/` e parágrafo curto de como montar uma página de leitura (cabeçalho opcional, migalhas de N níveis, coluna sem cabeçalho, blocos). Conferir no código que essas variações compilam e se comportam como descrito. Atende: critério 13.

## Grupo E: Conferência
- [ ] **E1.** `fvm flutter analyze` (cópia ASCII) e `fvm flutter build web --release` sem erro; busca por `.scale`, `.fontSize`, `.verticalSpacing`, `Color(0x` e números de tamanho soltos nos arquivos novos sem ocorrências (salvo `TextScaler.scale`); `git diff` de `app_router.dart` e `app_routes.dart` vazio. Atende: critérios 7 e 14.
- [ ] **E2.** Rodar o app real (build servido por servidor Python próprio com fallback de SPA, em background) no navegador embutido em **390, 768 e 1280 px**: `/manifesto` com cabeçalho, migalhas, título, texto completo e lista de 1 a 5 sem "1)"; texto quebrado do item alinhado ao texto; destaque com barra; botão abre `/contato` (clique e Tab + Enter); "Início" abre a Home (clique e Enter); acesso direto e `/manifest` redirecionando; hero, Quem somos e rodapé abrem o Manifesto; voltar do navegador; `/nossa-historia`, `/contato`, `/colaborar`, `/biblioteca` e um post abrem como antes; janela alta com rodapé na base; ordem de Tab e árvore de semântica (cabeçalho, "Você está em", itens com número); contraste calculado (migalhas repouso/hover, número, textos); texto a 200 % se o navegador permitir; `scrollWidth` igual à largura; console sem `overflow`. Voltar o navegador ao preset desktop, parar os servidores e confirmar com `git status` que nada de teste entrou no repositório. Painel admin: não se aplica. Atende: critérios 1 a 13.

## Critérios × tarefas
| Critério | Tarefas |
|---|---|
| 1 | B2, B5, C1, E2 |
| 2 | C1, E2 |
| 3 | A2, B4, C1, E2 |
| 4 | A2, B4, C1, E2 |
| 5 | B1, C1, E2 |
| 6 | E2 |
| 7 | E1, E2 |
| 8 | A1, A2, B2, B3, E2 |
| 9 | B5, E2 |
| 10 | B1, B2, B4, E2 |
| 11 | B1, B4, E2 |
| 12 | A1, B1, B4, E2 |
| 13 | B1, B2, B3, B5, D1, E2 |
| 14 | A1, A2, C1, E1 |
