# Tarefas da 007. Home: resumo de Nossa história

Legenda: `- [ ]` a fazer, `- [x]` feita.

Cada tarefa termina com `fvm flutter analyze` limpo (rodado na cópia em caminho ASCII do scratchpad). Critérios numerados na ordem da spec (1 = posição na Home, 14 = tokens/analyze/build).

## Grupo A: Tokens e rota
- [ ] **A1.** Tokens do resumo, do selo e da página listados no plano (`ComponentSizes`, com comentário de origem no protótipo) e, se preciso, o estilo `badge`. Arquivos: `app_dimensions.dart`, `app_text_styles.dart`. Conferir: valores iguais ao plano. Atende: critérios 8, 9 e 14.
- [ ] **A2.** `AppRoutes.ourHistory = '/nossa-historia'`. Arquivo: `core/routes/app_routes.dart`. Atende: critério 4.

## Grupo B: Página Nossa história
- [ ] **B1.** `OurHistoryPage`: `NavbarSliver`; cabeçalho de superfície dentro de `PageContent` com "Nossa história" em `h1`/`ink` (`Semantics(header)`) e linha `line` na base; coluna de 680 px centralizada com os três parágrafos atuais copiados literalmente de `our_history.dart`, em `reading`/`ink`, com `readingParagraphGap`; `SliverFillRemaining(hasScrollBody: false)` e `Footer`. Arquivo: `pages/our_history_page.dart`. Conferir: texto idêntico ao atual (comparar as strings). Atende: critérios 4, 8, 10, 11, 12 e 13.
- [ ] **B2.** Rota nova `GoRoute(path: AppRoutes.ourHistory)` → `OurHistoryPage`, sem tocar nas rotas existentes. Arquivo: `router/app_router.dart`. Conferir: `git diff` só com acréscimo. Atende: critérios 4, 5 e 7.

## Grupo C: Resumo na Home
- [ ] **C1.** `MilestoneBadge`: fundo `accentSoft`, raio `r20`, preenchimento 8 × 16, ícone `schedule_outlined` decorativo (`ExcludeSemantics`) em `accentStrong`, texto que quebra linha em `accentStrong`. Arquivo: `components/our_history/milestone_badge.dart`. Atende: critérios 2, 9, 10 e 11.
- [ ] **C2.** `OurHistorySummarySection`: fundo `surface`, `PageContent`, respiro de seção, coluna de até 720 px à esquerda; rótulo "NOSSA HISTÓRIA" (`label`, `accentStrong`), título `splitTitle` com `Semantics(header)`, selo "Projeto financiado pela FAPEMIG · 2016–2018", dois parágrafos da spec em `reading`/`ink`, `ArrowLink("Ler a história completa")` → `go(AppRoutes.ourHistory)`. Arquivo: `components/our_history/our_history_summary_section.dart`. Atende: critérios 2, 3, 8, 10, 11 e 13.
- [ ] **C3.** `HomePage`: sliver de Nossa história com `OurHistorySummarySection` direto (sem `FutureBuilder`), remover o `AppDivider` entre ele e a Equipe e o import `deferred` de `our_history`; apagar `components/our_history.dart` só depois de conferida a cópia do texto na B1. Arquivos: `pages/home_page.dart`, `components/our_history.dart` (apagar). Conferir: ordem vídeo → Nossa história → Equipe. Atende: critério 1.

## Grupo D: Rodapé e documentação
- [ ] **D1.** Rodapé: `_FooterLinkData('Nossa história', ...)` entre "Manifesto" e "Equipe", com `go(AppRoutes.ourHistory)`. Arquivo: `core/components/footer/footer.dart`. Conferir: coluna "Institucional" com quatro links em 390, 768 e 1280 px em outra página que use o rodapé (ex.: `/manifest`, `/biblioteca`). Atende: critérios 6, 10 e 13.
- [ ] **D2.** Documentação: rota `/nossa-historia` na lista de `docs/arquitetura.md` e resumo de Nossa história na seção "Home"; em `docs/redesign/planejamento.md`, T-03 com a rota `/nossa-historia` (provisória, redesenho na Fase 2). Atende: documentação.

## Grupo E: Conferência
- [ ] **E1.** `fvm flutter analyze` (cópia ASCII) e `fvm flutter build web --release` sem erro; busca por `.scale`, `.fontSize`, `.verticalSpacing`, `Color(0x` e números de tamanho soltos nos arquivos novos sem ocorrências; `git diff lib/app/router/app_router.dart` só com acréscimo. Atende: critérios 7 e 14.
- [ ] **E2.** Rodar o app real (build servido por Python com fallback de SPA) no navegador embutido em **390, 768 e 1280 px**: Home com o resumo abaixo do vídeo, sem divisória antes da Equipe e textos exatos; selo em duas linhas a 390 px sem `overflow`; "Ler a história completa" por clique e por Tab + Enter abre `/nossa-historia` no topo; voltar do navegador retorna à Home; atualizar em `/nossa-historia` abre a página; texto da página idêntico ao antigo; rodapé na base da janela com a página curta (janela alta); link "Nossa história" do rodapé por clique e Enter; `/manifest`, `/contato` e `/biblioteca` continuam abrindo; árvore de semântica com os dois títulos como cabeçalho e ícones ignorados; texto a 200 % sem sobreposição; `scrollWidth` igual à largura; console sem `overflow`; contraste calculado (rótulo/link sobre superfície, selo, parágrafos). Voltar o navegador ao preset desktop, parar os servidores e confirmar com `git status` que nada de teste entrou no repositório. Painel admin: não se aplica (nada no painel muda). Atende: critérios 1 a 13.

## Critérios × tarefas
| Critério | Tarefas |
|---|---|
| 1 | C3, E2 |
| 2 | C1, C2, E2 |
| 3 | C2, E2 |
| 4 | A2, B1, B2, E2 |
| 5 | B2, E2 |
| 6 | D1, E2 |
| 7 | B2, E1, E2 |
| 8 | A1, B1, C2, E2 |
| 9 | A1, C1, E2 |
| 10 | B1, C1, C2, D1, E2 |
| 11 | B1, C1, C2, E2 |
| 12 | B1, E2 |
| 13 | B1, C2, D1, E2 |
| 14 | A1, E1 |
