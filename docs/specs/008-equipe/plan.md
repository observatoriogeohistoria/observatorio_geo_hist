# Plano da 008. Home: equipe

- **Spec:** [spec.md](spec.md)
- **Criado em:** 2026-09-27

## Abordagem
O `FetchTeamStore` ganha um estado selado (inicial, carregando, sucesso, erro), como o `FetchHighlightsStore`, e passa a guardar a lista já em ordem alfabética. A lista observável `team` e `getTeamMemberById` continuam iguais, então a `TeamMemberPage` não muda. A Home só busca a equipe se o estado for inicial ou erro (mesma correção da 005), o que evita o esqueleto piscar ao voltar.

O carrossel `Team` sai e dá lugar a `TeamSection` (carregamento adiado, como hoje), no padrão de `HighlightsSection`: `Observer` sobre o estado; carregando → título + esqueleto; erro → título + quadro com "Tentar de novo"; sucesso com 0 → `SizedBox.shrink()`; sucesso → título + `TeamGrid`. A grade calcula as colunas pela largura disponível (`LayoutBuilder`): `max(1, floor((largura + 20) / (190 × ampliação + 20)))`, e monta linhas com `Row` de células `Expanded` alinhadas ao topo (colunas de mesma largura, alturas livres). O mesmo cálculo serve ao esqueleto (uma linha).

Cada célula é um `TeamMemberTile`: avatar de 76 px (`MemberAvatar`, foto com `Image.network` + `errorBuilder` e iniciais por baixo), nome e função. Com descrição, a célula é envolvida por `AppFocusRing` + `InkWell` + `Semantics(link)`; sem descrição, só o conteúdo, sem foco nem cursor. A linha divisória depois da equipe sai da `HomePage`.

Para conferir os estados sem dados reais (o Firebase de testes não tem membros), tudo roda numa cópia do projeto no scratchpad com um repositório falso, como na 005. Nada disso volta ao repositório.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Criar | `lib/app/features/home/presentation/stores/states/fetch_team_states.dart` | Estados selados: `FetchTeamInitialState`, `FetchTeamLoadingState`, `FetchTeamSuccessState`, `FetchTeamErrorState(message)` |
| Alterar | `lib/app/features/home/presentation/stores/fetch_team_store.dart` (+ `.g.dart` gerado) | `@observable state`; `fetchTeam` põe carregando, erro ou sucesso; sucesso ordena com `sortTeamByName`; getter `needsFetch` (inicial ou erro) |
| Criar | `lib/app/features/home/presentation/components/team/sort_team.dart` | `sortTeamByName` e `memberInitials`, funções puras (chave sem acentos e em minúsculas; desempate estável) |
| Criar | `lib/app/features/home/presentation/components/team/member_avatar.dart` | Círculo de 76 px: iniciais em `accentStrong` sobre `accentSoft`; foto por cima, `cover`, com `errorBuilder` devolvendo só as iniciais; `ExcludeSemantics` |
| Criar | `lib/app/features/home/presentation/components/team/team_member_tile.dart` | Avatar, nome (`memberName`, `ink`; `accent` no hover) e função (`memberRole`, `inkSecondary`); clicável só com descrição: `AppFocusRing` + `InkWell` + `Semantics(link, label: "Nome, Função")`, `context.go('/membro/$id')`, avatar `AnimatedScale` 1,05 no hover (sem animação com `disableAnimationsOf`) |
| Criar | `lib/app/features/home/presentation/components/team/team_grid.dart` | Colunas pela largura e pela ampliação do texto; linhas com `Row` + `Expanded`, `crossAxisAlignment.start`; recebe `itemCount`/`itemBuilder` (serve ao esqueleto) e expõe o cálculo de colunas |
| Criar | `lib/app/features/home/presentation/components/team/team_section.dart` | Seção: fundo `page`, `PageContent`, respiro de seção, título "Equipe" `h2` com `Semantics(header)`, estados carregando/erro/vazio/sucesso |
| Apagar | `lib/app/features/home/presentation/components/team.dart` | Carrossel antigo |
| Alterar | `lib/app/features/home/presentation/pages/home_page.dart` | Import adiado de `team_section`; sliver com `TeamSection(store, onRetry)` sem o `Observer` de lista vazia e sem `AppDivider`; `fetchTeam()` só se `needsFetch`; remover imports sem uso (`divider`, `team`) |
| Alterar | `lib/app/theme/app_dimensions/app_dimensions.dart` | Em `ComponentSizes`: `teamColumnMinWidth` 190, `teamColumnGap` 20, `teamRowGap` 28, `memberAvatar` 76, `memberAvatarGap` 10, `memberTextGap` 4, `memberAvatarHoverScale` 1,05, `memberSkeletonLineWidths` (ex.: 0,7 e 0,5 da coluna), com origem no protótipo (`.team`, `.member`, `.avatar`) |
| Alterar | `lib/app/theme/app_typography/app_text_styles.dart` | `memberName` (display, 17, 700, altura 1,3), `memberRole` (corpo, 14,5, 400, altura 1,45), `memberInitials` (display, 24, 700) |
| Alterar | `docs/arquitetura.md` | Seção "Home": equipe em grade com estados; store com estado |

## Decisões técnicas
- **Nenhum pacote novo, nenhum asset.** `carousel_slider` continua no projeto (usado por `highlights_dialog_carousel.dart`). `build_runner` só para o `fetch_team_store.g.dart`.
- **Colunas por largura, não por faixa.** Segue o `auto-fill` do protótipo e dá 5/3/1 nas larguras de referência; `MediaQuery.textScalerOf(context).scale(190)` como mínimo, para menos colunas com texto ampliado (spec, "Responsivo"). Alternativa (3/5 fixos por faixa) daria colunas de 176 px em 1024 px.
- **Grade com `Row` + `Expanded` em vez de `GridView`/`Wrap`.** `GridView` exige altura fixa por célula (nomes quebram); `Wrap` não garante colunas iguais. Linhas de `Row` com células vazias completando a última linha mantêm o alinhamento à esquerda.
- **Iniciais sempre por baixo da foto.** Enquanto a foto carrega ou quando falha, o círculo mostra as iniciais, sem deslocar nada. Não usa `AppNetworkImage` (tem esqueleto de altura em `num_extension` e placeholder próprio).
- **Iniciais:** primeira letra da primeira e da última palavra do nome (ignorando espaços extras), em maiúsculas; uma palavra → uma letra; nome vazio → círculo sem letra.
- **"Tem descrição":** `member.description?.trim().isNotEmpty ?? false`, num getter local da seção (o modelo não muda).
- **Ordenação no store**, para a Home e a página da pessoa verem a mesma lista; chave sem acentos por tabela de substituição de vogais acentuadas e `ç` (sem pacote).
- **Navegação:** `context.go('/membro/$id')`, como hoje, sem `extra` (a página não usa). Rota não muda.
- **Esqueleto:** `Skeleton` existente (parado), com círculo de 76 px e duas barras; `Semantics(label: 'Carregando equipe', excludeSemantics: true)`.
- **Erro:** mesmo quadro da `HighlightsSection` (fundo `surface`, borda `line`, `SecondaryButton.small('Tentar de novo')`). O quadro é copiado para a seção em vez de extraído, para não mexer na 005; extrair um componente comum fica para quando houver um terceiro uso.

## Dependências e geração de código
- `fvm dart run build_runner build --delete-conflicting-outputs` depois de mudar o store.
- Nenhuma mudança em rotas, `home_setup.dart` (o registro do store não muda), modelos ou Firebase.

## Riscos e cuidados
- **Dados reais não conferíveis no Firebase de testes (sem membros).** Todos os estados e casos (vazio, carregando, erro, 1 membro, 25 membros, com/sem foto, foto que falha, com/sem descrição, nome longo) são conferidos com dados simulados só na cópia do scratchpad: testes de widget temporários e uma entrada de pré-visualização `lib/main_equipe_preview.dart` que troca o `FetchTeamRepository` no GetIt por um falso escolhido por `?equipe=0|1|25|erro|lento|semfoto|falha|longo|misto`. Nada disso entra no repositório (conferir com `git status`).
- **`TeamMemberModel.fromJson` quebra com campo ausente** (`description`, `lattesUrl` como `String` obrigatória). Um documento antigo sem esses campos faz a busca inteira cair no estado de erro. Não se corrige aqui (modelo fora do escopo); registrar na verificação se aparecer.
- **`TeamMemberPage` usa o mesmo store.** Conferir que `/membro/:id` abre por clique na grade e por acesso direto (com o repositório falso) e que o estado novo não muda o comportamento dela.
- **Transição de fundos:** Nossa história (superfície) → Equipe (branco) → Parceiros (visual antigo, sem divisória). Conferir que não há vão estranho nem linha solta.
- **Hover que muda a cor do nome:** conferir que não altera a altura (mesmo estilo, só a cor).

## Como conferir
- `fvm flutter analyze` numa cópia em caminho ASCII no scratchpad (rsync sem `build/` e `.dart_tool/`, `fvm flutter pub get`) e `fvm flutter build web --release`.
- Testes de widget temporários na cópia (`test/team_section_test.dart`): 0, 1, 5, 25 membros × 390/768/1280 × texto 100 %/200 % (número de colunas, posições, ausência de `overflow`), ordem alfabética com acentos, esqueleto → erro → "Tentar de novo" → grade, foto que falha (iniciais, mesma altura), semântica (link "Nome, Função" só para quem tem descrição, foto ignorada), Tab pula quem não tem descrição, Enter navega com `GoRouter`, movimento reduzido.
- Pré-visualização com dados simulados servida por Python com fallback de SPA, no navegador embutido em 390, 768 e 1280 px; depois o build real (`main.dart`) para confirmar que, sem membros, a seção some sem sobra de linha. Voltar o navegador ao preset desktop e parar os servidores.
