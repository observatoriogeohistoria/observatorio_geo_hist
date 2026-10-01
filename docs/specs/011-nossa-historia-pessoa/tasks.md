# Tarefas da 011. Nossa história completa e Pessoa da equipe

Legenda: `- [ ]` a fazer, `- [x]` feita.

Cada tarefa termina com `fvm flutter analyze` limpo (rodado na cópia em caminho ASCII do scratchpad). Critérios numerados na ordem da spec.

## Grupo A: Tokens
- [ ] **A1.** Tokens de subtítulo, lista com marcadores, figura, página da pessoa e caixa de erro listados no plano, em `ComponentSizes`, com comentário de origem no protótipo; remover `pageHeadPaddingVertical` junto com a reescrita de Nossa história (C1) se o analyze acusar uso antes. Arquivo: `theme/app_dimensions/app_dimensions.dart`. Atende: critérios 13 e 17.
- [ ] **A2.** Estilos `readingSubtitle`, `memberPageName`, `memberPageInitials` e `stateTitle`, com linhas na tabela do topo. Arquivo: `theme/app_typography/app_text_styles.dart`. Atende: critérios 3, 5, 13 e 17.

## Grupo B: Base de leitura
- [x] **B1.** `ReadingSubtitle` (cabeçalho nível 2) e `ReadingBulletList` (lista semântica, marcador decorativo que escala com o texto, texto quebrado alinhado ao texto). Arquivo: `core/components/reading/reading_blocks.dart`. Atende: critérios 3 e 16.
- [x] **B2.** `ReadingFigure`: até 920 px centralizada, 21:9, `r16`, `cover` com alinhamento configurável, fundo `surface` até o primeiro quadro, placeholder `accentSoft` com ícone decorativo na falha, legenda opcional, `semanticLabel`. Parâmetro opcional `paddingTop` em `ReadingColumn`. Arquivos: `core/components/reading/reading_figure.dart`, `core/components/reading/reading_column.dart`. Atende: critérios 4 e 16. _Nota: o fundo `surface` fica sob a imagem (sem `frameBuilder`), o que dá o mesmo efeito até o primeiro quadro. Tokens e estilo `readingSubtitle` entraram aqui, junto do primeiro uso._
- [ ] **B3.** `StateErrorBox` (título, apoio, "Tentar de novo" primário pequeno, ícone decorativo, contraste ≥ 4,5:1). Arquivo: `core/components/error_content/state_error_box.dart`. Atende: critérios 9 e 12.

## Grupo C: Nossa história
- [ ] **C1.** Reescrever `OurHistoryPage` com `ReadingPageScaffold`, `PageHeader` (migalhas Início → `AppRoutes.root`, "Nossa história", `lead`), `ReadingFigure` (`our-history.webp`, `Alignment(0, -0.7)`, `cacheWidth`, legenda) e `ReadingColumn` com `MilestoneBadge` e os blocos na ordem da spec. Textos exatos da spec. Arquivo: `features/home/presentation/pages/our_history_page.dart`. Conferir: script que compara as frases do texto antigo (git) com as novas, aceitando só "e, por fim," e "2016–2018". Atende: critérios 1, 2, 3, 4, 16 e 17.

## Grupo D: Pessoa da equipe
- [ ] **D1.** `memberHasPage` em `sort_team.dart` e uso no `TeamMemberTile`. Arquivos: `features/home/presentation/components/team/sort_team.dart`, `team_member_tile.dart`. Atende: critério 10.
- [ ] **D2.** `MemberPortrait` (quadrado `r20`, iniciais por baixo, `cover`, falha mostra iniciais, nome acessível "Foto de [nome]" só com foto) e `MemberPageSkeleton` (mesmo layout, empilha < 700 px). Arquivos: `features/home/presentation/components/team/member_portrait.dart`, `member_page_skeleton.dart`. Atende: critérios 6, 8 e 13.
- [ ] **D3.** Reescrever `TeamMemberPage`: `ReadingPageScaffold(body:)`, 920 px, migalhas Início › Equipe › nome; foto | texto com `LayoutBuilder`; função `label`/`accentStrong` em caixa alta; nome `memberPageName` com `Semantics(header, headingLevel: 1)`; descrição em parágrafos; `SecondaryButton.medium('Currículo Lattes', trailingIcon: Icons.open_in_new)` só com `lattesUrl`; estados: carregando → esqueleto, erro → `StateErrorBox(onRetry: fetchTeam)`, sucesso sem página → `PageNotFound`. Manter a busca só no `initState` com `needsFetch`. Sem `num_extension`, `AppHeadline`, `AppBody`, `PageErrorContent`, `LoadingContent` e `Avatar`. Arquivo: `features/home/presentation/pages/team_member_page.dart`. Atende: critérios 5, 6, 7, 8, 9, 11, 13, 14 e 17.

## Grupo E: Documentação
- [ ] **E1.** `docs/arquitetura.md`: `ReadingSubtitle`, `ReadingBulletList`, `ReadingFigure` e `paddingTop` na seção "Páginas de leitura"; `StateErrorBox` na tabela de componentes. Atende: critério 16.

## Grupo F: Conferência
- [ ] **F1.** `fvm flutter analyze` (cópia ASCII) e `fvm flutter build web --release` sem erro; busca por `.scale`, `.fontSize`, `.verticalSpacing`, `Color(0x` e números soltos nos arquivos novos/alterados sem ocorrências (salvo `TextScaler.scale`); imports antigos ausentes nas duas páginas; `git diff` de `app_router.dart`, `app_routes.dart` e `home_setup.dart` vazio. Atende: critérios 15 e 17.
- [ ] **F2.** Rodar o app real (build servido por servidor Python próprio com fallback de SPA, em background) no navegador embutido em **390, 768 e 1280 px**:
  - `/nossa-historia`: cabeçalho, migalhas, apoio, foto 21:9 com rostos visíveis e legenda, selo, texto completo, subtítulos e lista; semântica (`h1`, dois `h2`, lista de 3 itens, nome da foto, "Você está em"); falha da foto forçada (bloqueando o asset na rede ou trocando o caminho só no build de teste, sem commitar); "Ler a história completa" (Home) e "Nossa história" (rodapé) abrem a página.
  - `/membro/<id com descrição>` vindo da Home (sem esqueleto, sem leitura nova) e por acesso direto (esqueleto, uma leitura); foto, rótulo, nome, descrição, Lattes (clique e Enter abrem outra aba), membro sem foto/sem Lattes se houver; ordem de Tab; empilhado em 390 e lado a lado em 768 e 1280.
  - `/membro/<id inexistente>` e `/membro/<id sem descrição>` (se houver): 404 com no máximo uma leitura de `team`, nenhuma em 10 s (requisições de rede).
  - Erro: requisições do Firestore bloqueadas → caixa de erro; "Tentar de novo" faz uma leitura por clique e, liberada a rede, mostra a pessoa.
  - Grade da Home: clicáveis são os com descrição.
  - Contraste calculado pelos tokens (rótulo, legenda, migalhas, iniciais, caixa de erro); janela alta (1280 × 2200) com rodapé na base nas duas páginas; `scrollWidth` igual à largura; console sem erros; `/manifesto` sem regressão; `/contato`, um post e `/biblioteca` abrem.
  - Voltar o navegador ao preset desktop, parar os servidores e confirmar com `git status` que nada de teste entrou no repositório. Painel admin: não se aplica. O que não puder ser conferido (ex.: sem membro sem descrição no banco) fica registrado na nota da tarefa.

  Atende: critérios 1 a 15.

## Critérios × tarefas
| Critério | Tarefas |
|---|---|
| 1 | C1, F2 |
| 2 | C1, F2 |
| 3 | A2, B1, C1, F2 |
| 4 | B2, C1, F2 |
| 5 | A2, D3, F2 |
| 6 | D2, D3, F2 |
| 7 | D3, F2 |
| 8 | D2, D3, F2 |
| 9 | B3, D3, F2 |
| 10 | D1, F2 |
| 11 | D3, F2 |
| 12 | B3, F2 |
| 13 | A1, A2, D2, D3, F2 |
| 14 | C1, D3, F2 |
| 15 | F1, F2 |
| 16 | B1, B2, C1, E1 |
| 17 | A1, A2, C1, D3, F1 |
