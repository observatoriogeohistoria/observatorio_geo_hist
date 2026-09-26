# Tarefas da 005. Home: destaques

Legenda: `- [ ]` a fazer, `- [x]` feita.

Cada tarefa termina com `fvm flutter analyze` limpo (rodado na cópia em caminho ASCII do scratchpad). Critérios numerados na ordem da spec (1 = posição e título, 16 = tokens/analyze/build).

## Grupo A: Diagnóstico e tokens
- [ ] **A1.** Diagnosticar por que o bloco não aparece hoje: build atual servido localmente, aba de rede e console na Home; anotar aqui se a busca de destaques volta vazia ou com erro (e qual). Se for erro de configuração do Firebase (índice/isenção), registrar como ressalva na spec e seguir sem mexer no Firebase. Arquivos: nenhum. Atende: critérios 2 e 10 (base para saber o que o site real vai mostrar).
- [ ] **A2.** Tokens: cores `imageScrim`, `onImageAccent`, `onImageMuted`, `imagePlaceholder`; estilos `featureTitle` e `featureTitleSmall`; em `ComponentSizes` os tamanhos do plano (respiro de seção por faixa, vão até a grade, alturas da grade e dos cartões no celular, vão entre cartões, proporção 1,6 : 1, preenchimento do texto, vão entre textos, largura máxima do título principal em em, linhas máximas, opacidades e faixa do degradê, ícone "sem imagem"), com comentário de origem no protótipo. Arquivos: `app_colors.dart`, `app_text_styles.dart`, `app_dimensions.dart`. Conferir: valores iguais ao plano. Atende: critérios 13, 14 e 16.
- [ ] **A3.** Getter `shortDate` na extensão de datas ("12 mar 2026"). Arquivo: `core/utils/date/date.dart`. Conferir: `DateTime(2026, 3, 12).shortDate == '12 mar 2026'` (teste temporário na cópia). Atende: critério 7.

## Grupo B: Componentes
- [ ] **B1.** `selectHighlights` e `highlightArea`: ordena por `createdAt` decrescente (nulos no fim), descarta posts sem `body`, sem `id` ou sem área resolvível, limita a 3; área da categoria ou `post.areas.first`. Arquivo: `components/highlights/select_highlights.dart`. Conferir: teste temporário com 0, 1, 2, 3 e 5 posts, datas nulas e post incompleto. Atende: critérios 2, 6 e 8.
- [ ] **B2.** `HighlightCard` (variantes principal e menor): foto `cover` com placeholder escuro para sem URL, carregando e falha (ícone decorativo); degradê ancorado no texto (faixa de esmaecimento + bloco 0,72→0,88); rótulo "TIPO · ÁREA" em `onImageAccent`; título branco com `maxLines` 3 e reticências (principal limitado a 22 em); data em `onImageMuted` só no principal; hover com sublinhado do título; `InkWell` sem splash, `AppFocusRing` raio 16; `Semantics(link, onTap, label: "Título. Tipo, Área. data")` e imagem excluída da semântica; sem fade com movimento reduzido. Navega para `/posts/:area/:categoria/:id`. Arquivo: `components/highlights/highlight_card.dart`. Atende: critérios 7, 8, 9, 11, 12, 13 e 15.
- [ ] **B3.** `HighlightsGrid`: 1 cartão na largura toda; 2 em colunas 16:10 de flex; 3 com principal à esquerda e dois empilhados à direita; no celular, coluna com alturas 340/220; alturas fixas por faixa (400 tablet, 440 desktop); recebe um construtor de item para servir também ao esqueleto. Arquivo: `components/highlights/highlights_grid.dart`. Atende: critérios 3, 4, 5 e 14.
- [ ] **B4.** `HighlightsSection`: `Observer` no `FetchHighlightsStore`; sucesso com lista selecionada vazia → nada; inicial/carregando → título + esqueleto na disposição de três (Skeleton existente, `Semantics` "Carregando destaques", parado com movimento reduzido); erro → título + caixa "Não foi possível carregar os destaques." com `SecondaryButton.small("Tentar de novo")` que chama `onRetry`; sucesso → título (`h2`, `Semantics(header)`) + grade. Tudo em `PageContent` com o respiro de seção. Arquivo: `components/highlights/highlights_section.dart`. Atende: critérios 1, 2, 10, 12 e 15.

## Grupo C: Home
- [ ] **C1.** `HomePage`: sliver de destaques passa a carregar `HighlightsSection` (mantém `deferred`); apagar `components/highlights.dart`; em `initState`, buscar destaques quando as categorias já estão em sucesso ou erro e o store está no estado inicial; `onRetry` busca com as categorias atuais. Arquivos: `pages/home_page.dart`, `components/highlights.dart` (apagar). Conferir: seção entre o hero e "Quem somos"; voltar de outra página para a Home mostra os destaques. Atende: critérios 1, 2 e 10.
- [ ] **C2.** Atualizar a seção "Home" de `docs/arquitetura.md` (seleção dos destaques, cartão, estados, disparo da busca). Atende: documentação.

## Grupo D: Conferência
- [ ] **D1.** `fvm flutter analyze` (cópia ASCII) e `fvm flutter build web --release` sem erro; busca por `.scale`, `.fontSize`, `.verticalSpacing`, `Color(0x` e números de tamanho soltos nos arquivos novos sem ocorrências. Atende: critério 16.
- [ ] **D2.** Testes de widget **temporários, só na cópia do scratchpad** (`test/highlights_section_test.dart`, não entram no repositório), com o store real e um `FetchHighlightsRepository` falso: 0, 1, 2, 3 e 5 destaques em 390, 768 e 1280 px (quantidade e posição dos cartões, 5 → os três mais recentes), carregando (esqueleto), erro e "Tentar de novo" (volta a buscar e mostra os cartões), sem imagem e URL que falha (placeholder, mesma altura), título de 300 caracteres (3 linhas, nome acessível completo), texto a 200% sem exceção de `overflow`, ação de toque na semântica e navegação para `/posts/:area/:categoria/:id` com `GoRouter`, movimento reduzido (sem animação). Anotar o número de testes. Atende: critérios 2 a 12, 14 e 15.
- [ ] **D3.** Pré-visualização com dados simulados **só na cópia do scratchpad**: `lib/main_destaques_preview.dart` (igual ao `main.dart`, trocando no GetIt o `FetchHighlightsRepository` por um falso escolhido por `?destaques=0|1|2|3|5|erro|lento|semimagem|falha|branca|longo`), `fvm flutter build web --release -t lib/main_destaques_preview.dart`, servido por Python com fallback de SPA, no navegador embutido em **390, 768 e 1280 px**: disposição de cada cenário igual à tabela da spec, degradê só embaixo, contraste do texto sobre a foto branca (conferir as cores e calcular), esqueleto e erro, `scrollWidth` igual à largura, Tab/Enter e contorno de foco nos cartões, hover com sublinhado. Atende: critérios 1 a 15.
- [ ] **D4.** Rodar o app real (build de `main.dart` servido localmente) em **390, 768 e 1280 px** com os dados reais: seção presente ou ausente conforme o banco (bate com o diagnóstico da A1), transição hero → destaques → Quem somos sem vão nem faixa cinza, sem rolagem horizontal, clique num destaque abre o post (se houver destaque). Voltar o navegador ao preset desktop, parar os servidores e confirmar com `git status` na pasta original que nenhum arquivo de teste ou de pré-visualização entrou no repositório. Atende: critérios 1, 2, 8 e 14.

## Critérios × tarefas
| Critério | Tarefas |
|---|---|
| 1 | B4, C1, D3, D4 |
| 2 | A1, B1, B4, C1, D2, D3, D4 |
| 3 | B3, D2, D3 |
| 4 | B3, D2, D3 |
| 5 | B3, D2, D3 |
| 6 | B1, D2, D3 |
| 7 | A3, B2, D2, D3 |
| 8 | B1, B2, D2, D3, D4 |
| 9 | B2, D2, D3 |
| 10 | A1, B4, C1, D2, D3 |
| 11 | B2, D2, D3 |
| 12 | B2, B4, D2, D3 |
| 13 | A2, B2, D3 |
| 14 | A2, B3, D2, D3, D4 |
| 15 | B2, B4, D2, D3 |
| 16 | A2, D1 |
