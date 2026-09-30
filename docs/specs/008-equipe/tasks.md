# Tarefas da 008. Home: equipe

Legenda: `- [ ]` a fazer, `- [x]` feita.

Cada tarefa termina com `fvm flutter analyze` limpo (rodado na cópia em caminho ASCII do scratchpad). Critérios numerados na ordem da spec (1 = posição e título, 17 = tokens/analyze/build).

## Grupo A: Tokens e store
- [x] **A1.** Tokens da grade, do membro e do esqueleto em `ComponentSizes` e estilos `memberName`, `memberRole` e `memberInitials`, com comentário de origem no protótipo. Arquivos: `app_dimensions.dart`, `app_text_styles.dart`. Conferir: valores iguais ao plano. Atende: critérios 3, 4 e 17.
  - Também `memberAnimation` (150 ms, `.avatar` `transition`) e `memberSkeletonBarHeight` (14), que o plano não listava.
- [x] **A2.** `sortTeamByName` (sem acentos e sem caixa, desempate estável) e `memberInitials`. Arquivo: `components/team/sort_team.dart`. Conferir: teste temporário na cópia com "Álvaro", "alvaro", "Bruna", "Érica", "Zé", nome de uma palavra, espaços extras e nome vazio. Atende: critérios 2 e 5.
  - Feito com tabela de vogais acentuadas, `ç` e `ñ` (sem pacote); desempate pela posição original.
- [x] **A3.** Estados `FetchTeam*State` e store com `state`, ordenação no sucesso, erro guardado e `needsFetch`; rodar `build_runner`. Arquivos: `stores/states/fetch_team_states.dart`, `stores/fetch_team_store.dart`, `stores/fetch_team_store.g.dart`. Conferir: `team` e `getTeamMemberById` com a mesma assinatura; `team_member_page.dart` compila sem mudança. Atende: critérios 2, 8, 9, 11 e 16.
  - `.g.dart` gerado na cópia ASCII e trazido de volta; `team_member_page.dart` sem mudança.

## Grupo B: Componentes
- [x] **B1.** `MemberAvatar`: círculo de 76 px, iniciais `memberInitials` em `accentStrong` sobre `accentSoft`, foto `cover` por cima com `errorBuilder` → só iniciais, `ExcludeSemantics`. Arquivo: `components/team/member_avatar.dart`. Atende: critérios 4, 5, 13 e 14.
  - Iniciais com `TextScaler.noScaling`: o círculo tem tamanho fixo e as letras vazariam com texto ampliado.
- [x] **B2.** `TeamMemberTile`: avatar, nome e função com os vãos do plano; com descrição (`trim` não vazio) → `AppFocusRing` + `InkWell` + `Semantics(link, label: "Nome, Função")`, `go('/membro/$id')`, hover com nome `accent` e avatar 1,05 (sem animação com movimento reduzido), altura de toque ≥ 44 px; sem descrição → sem foco, cursor, hover nem toque. Arquivo: `components/team/team_member_tile.dart`. Atende: critérios 4, 6, 7, 12, 13 e 14.
- [x] **B3.** `TeamGrid`: colunas por `floor((largura + 20) / (190 × ampliação + 20))`, mínimo 1; linhas `Row` + `Expanded` alinhadas ao topo, 20 px entre colunas e 28 px entre linhas, última linha completada com espaços vazios. Arquivo: `components/team/team_grid.dart`. Atende: critérios 3, 12 e 15.
- [x] **B4.** `TeamSection`: fundo `page`, `PageContent`, respiro de seção, "Equipe" `h2`/`ink` com `Semantics(header)`; carregando → esqueleto de uma linha (círculo + duas barras, rótulo "Carregando equipe"); erro → "Não foi possível carregar a equipe." + "Tentar de novo" (`onRetry`); 0 → some; sucesso → `TeamGrid` de `TeamMemberTile`. Arquivo: `components/team/team_section.dart`. Atende: critérios 1, 8, 9 e 10.

## Grupo C: Home e documentação
- [x] **C1.** `HomePage`: import adiado de `team_section`, sliver com `TeamSection(store: _fetchTeamStore, onRetry: _fetchTeamStore.fetchTeam)` sem `AppDivider`; `fetchTeam()` no `initState` só se `needsFetch`; apagar `components/team.dart` e imports sem uso. Arquivos: `pages/home_page.dart`, `components/team.dart` (apagar). Conferir: ordem Nossa história → Equipe → Parceiros; `git grep "components/team.dart"` sem resultado. Atende: critérios 1, 10 e 11.
- [x] **C2.** Documentação: seção "Home" de `docs/arquitetura.md` com a equipe em grade e o store com estado. Atende: documentação.

## Grupo D: Conferência
- [x] **D1.** `fvm flutter analyze` (cópia ASCII) e `fvm flutter build web --release` sem erro; busca por `.scale`, `.fontSize`, `.verticalSpacing`, `Color(0x` e números de tamanho soltos nos arquivos novos sem ocorrências (fora dos tokens); `git diff` sem mudança em `app_router.dart`, `team_model.dart`, `team_member_page.dart`, datasources e `features/admin`. Atende: critérios 16 e 17.
- [x] **D2.** Testes de widget **temporários, só na cópia do scratchpad** (`test/team_section_test.dart`), com o store real e um `FetchTeamRepository` falso: 0, 1, 5 e 25 membros × 390/768/1280 × texto 100 %/200 % (colunas 1/3/5 a 100 %, menos colunas a 200 %, nenhuma exceção de `overflow`, alinhamento ao topo e à esquerda); ordem alfabética com acentos; esqueleto → erro → "Tentar de novo" → grade; sem foto e foto que falha (iniciais, mesma altura); nome e função de 120 caracteres (quebram, sem reticências); semântica (link "Nome, Função" só com descrição, foto ignorada, cabeçalho "Equipe"); Tab pula quem não tem descrição; Enter e toque semântico navegam para `/membro/:id` com `GoRouter`; descrição só com espaços não é link; movimento reduzido sem animação; 0 membros sem altura. Anotar o número de testes. Atende: critérios 2 a 10, 12, 13 e 15.
  - 31 testes, todos passando (só na cópia do scratchpad).
- [x] **D3.** Rodar o app **com dados simulados** (só na cópia do scratchpad): `lib/main_equipe_preview.dart` igual ao `main.dart`, trocando no GetIt o `FetchTeamRepository` por um falso escolhido por `?equipe=0|1|25|erro|lento|semfoto|falha|longo|misto` (fotos geradas localmente: quadrada, larga, alta e pequena); `fvm flutter build web --release -t lib/main_equipe_preview.dart`, servido por Python com fallback de SPA, no navegador embutido em **390, 768 e 1280 px**: colunas 1/3/5, ordem, fotos recortadas no círculo, iniciais, esqueleto (`lento`), erro e "Tentar de novo", seção ausente e sem linha solta (`0`), hover e cursor só em quem tem descrição (`misto`), Tab/Enter e contorno de foco, clique abre `/membro/:id` e voltar retorna à Home sem esqueleto nem nova busca, acesso direto a `/membro/:id`, transição Nossa história → Equipe → Parceiros, `scrollWidth` igual à largura, console sem `overflow`, contraste calculado (nome, hover, função, iniciais). Atende: critérios 1 a 16.
  - Conferido: 1/3/5 colunas, ordem com acentos, fotos quadrada/larga/alta/pequena recortadas, iniciais sem foto e com falha, esqueleto (`lento`), erro → "Tentar de novo" → grade, seção ausente sem linha (`0`), hover e cursor só em quem tem descrição, clique abre `/membro/m1`, voltar não refaz a busca (1 chamada), `scrollWidth` igual à largura, console sem `overflow`. Tab/Enter e contorno de foco só nos testes de widget (o navegador embutido desloca as coordenadas com a largura emulada).
- [x] **D4.** Rodar o **app real** (build de `main.dart`) em **390, 768 e 1280 px** com o Firebase de testes: sem membros, a seção não aparece e não sobra linha entre Nossa história e Parceiros; `/manifest`, `/nossa-historia` e `/membro/qualquer-id` continuam abrindo como antes. Voltar o navegador ao preset desktop, parar os servidores e confirmar com `git status` na pasta original que nenhum arquivo de teste ou de pré-visualização entrou no repositório. Painel admin: não se aplica (nada muda nele; conferido pelo `git diff` da D1). Atende: critérios 1, 10, 15 e 16.
  - Conferido em 768 px (390 e 1280 com os dados simulados da D3). Sem membros no Firebase de testes a seção some e Nossa história encosta em Parceiros sem linha. `/manifest`, `/nossa-historia` e `/membro/qualquer-id` abrem como antes (esta última fica carregando, como já acontecia).

## Critérios × tarefas
| Critério | Tarefas |
|---|---|
| 1 | B4, C1, D3, D4 |
| 2 | A2, A3, D2, D3 |
| 3 | A1, B3, D2, D3 |
| 4 | A1, B1, B2, D2, D3 |
| 5 | A2, B1, D2, D3 |
| 6 | B2, D2, D3 |
| 7 | B2, D2, D3 |
| 8 | A3, B4, D2, D3 |
| 9 | A3, B4, D2, D3 |
| 10 | B4, C1, D2, D3, D4 |
| 11 | A3, C1, D3 |
| 12 | B2, B3, D2, D3 |
| 13 | B1, B2, D2, D3 |
| 14 | B1, B2, D3 |
| 15 | B3, D2, D3, D4 |
| 16 | A3, D1, D3, D4 |
| 17 | A1, D1 |
