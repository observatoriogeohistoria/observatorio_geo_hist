# Verificação da 008. Home: equipe

- **Data:** 2026-09-27
- **Resultado:** aprovada com ressalvas (nenhuma correção necessária; uma ressalva pré-existente na página do membro)

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | No issues found |
| `fvm flutter build web --release` (cópia ASCII) | concluído sem erro |
| Build de pré-visualização com `FetchTeamRepository` falso (`?equipe=misto\|longo\|25\|erro`), só no scratchpad | 390, 768 e 1280 px; `scrollWidth` igual à largura; console sem `overflow` |
| Build do app real (Firebase de testes, sem membros) | 390 e 1280 px (768 px já visto na implementação) |
| Build de pré-visualização do commit `3e0bd92` (antes da 008), mesmo repositório falso | comparação do laço em `/membro/<id inexistente>` |
| Teste de widget temporário, só no scratchpad (7 testes) | todos passaram: colunas, texto a 200 %, Tab, Enter e semântica |

Todas as tarefas do [tasks.md](tasks.md) estão marcadas. Revisão feita no código de `3e0bd92..120a849` (`67edb84` e `120a849`), não só no relatório da implementação. `git status` limpo ao fim: nada de teste ou pré-visualização entrou no repositório.

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Posição, título "Equipe" como cabeçalho, sem carrossel nem divisória | passou | `home_page.dart`: Nossa história → `TeamSection` → Parceiros, sem `AppDivider`; `team.dart` apagado. Tela a 768 e 1280 px |
| 2 | Todos de uma vez, ordem alfabética sem caixa e sem acento | passou | `sort_team.dart`; tela: "alvaro lima", "Álvaro Mendes", "Bruna Souza", "Carlos", …, "Érica Prado", …, "Zé Carvalho" |
| 3 | 5/3/1 colunas, vãos 20/28, topo e esquerda | passou | Teste de widget (1, 3 e 5 posições de x em 390/768/1280); tela a 390, 768 e 1280; tokens `teamColumnGap`/`teamRowGap` |
| 4 | Foto de 76 px recortada, nome como cadastrado, função secundária | passou | `member_avatar.dart` (`ClipOval` + `BoxFit.cover`); fotos quadrada, larga, alta e pequena recortadas no círculo |
| 5 | Iniciais sem foto ou com falha, mesmo tamanho | passou | "C" (sem foto) e "ÉP" (URL inexistente) no círculo laranja suave, alinhados aos demais |
| 6 | Com descrição abre `/membro/:id` por clique, Enter e leitor; hover | passou | Teste de widget: Tab + Enter → `/membro/1`; `Semantics(link, onTap)`; hover e cursor conferidos na implementação e no código (`AnimatedScale` 1,05, `accent`) |
| 7 | Sem descrição (ou só espaços) sem clique, cursor, hover e foco | passou | Teste de widget: Tab passa só por quem tem descrição; "Carla" (descrição `'  '`) sem rótulo de link |
| 8 | Carregando: título e esqueleto de uma linha | passou | `_Loading` com `TeamGrid.columnsFor`; visto na implementação (`lento`) |
| 9 | Erro, mensagem e "Tentar de novo" que mostra a grade | passou | 768 px, `?equipe=erro`: mensagem e botão; clique → grade de 10 membros |
| 10 | 0 membros: seção some sem linha | passou | App real a 390 e 1280 px: Nossa história encosta em Parceiros, sem título nem linha |
| 11 | Voltar à Home não refaz a busca | passou | `needsFetch` no `initState`; implementação contou 1 chamada ao voltar |
| 12 | Textos longos quebram; 200 % com menos colunas | passou | 1280 px, `?equipe=longo`: nome e função longos em várias linhas, sem reticências. Teste de widget a 200 % sem exceção em 390/768/1280 |
| 13 | Link "Nome, Função", foco visível na ordem, decorativos ignorados, movimento reduzido | passou | Teste de widget: rótulo "Bruna, Função 1", ordem de Tab da grade; `AppFocusRing`; `ExcludeSemantics` no avatar; `disableAnimationsOf` |
| 14 | Contrastes | passou | Tokens: `ink`, `accent #C94400` (4,9:1), `inkSecondary #5E5852` (≥ 7:1), `accentStrong #A33600` sobre `accentSoft #FFF0E6` (6,1:1) |
| 15 | Sem rolagem horizontal/sobreposição/`overflow` em 390/768/1280 | passou | `scrollWidth` = largura com 10 e 25 membros e no app real; console sem `overflow` |
| 16 | `/membro/:id` como antes; painel sem mudança | passou | `git diff 3e0bd92..HEAD` sem mudança em rotas, `infra/`, `team_member_page.dart` e `features/admin`. Ver ressalva |
| 17 | Só tokens, sem `num_extension`; analyze e build | passou | Busca por `.fontSize`, `.verticalSpacing`, `Color(0x`, `num_extension` e `GestureDetector` em `components/team`: nada |

## Problemas encontrados
- **`/membro/<id inexistente>` fica carregando e busca a equipe em laço** (ressalva, pré-existente, fora do escopo). A página chama `fetchTeam()` no `build` e numa reação a `team`; cada busca atribui uma lista nova, a reação dispara e busca de novo. Medido com repositório falso (300 ms): ~35 chamadas em 10 s **antes** da 008 (build de `3e0bd92`) e **depois** dela, mesmo ritmo. A 008 não piorou (a reação observa só `team`, não `state`). Não corrigido: a página é da Fase 2 (T-02) e a spec manda não mexer nela. Com o Firestore real, cada volta do laço é uma leitura da coleção: vale tratar na T-02 (buscar só se `needsFetch` e mostrar "não encontrado").
- **Iniciais não crescem com o texto ampliado** (detalhe, aceito). São decorativas (`ExcludeSemantics`) e repetem o nome, que vem logo abaixo e cresce normalmente; o círculo tem 76 px fixos e letras ampliadas vazariam. Não fere o critério de texto redimensionável de forma relevante.
- **Colunas no celular:** o protótipo usa `minmax(min(100%,190px),1fr)`; a 390 px sobram 350 px, então 1 coluna, como a spec decidiu.

## Não conferido
- Contorno de foco por teclado no navegador embutido (a largura emulada desloca as coordenadas); conferido por teste de widget e pelo uso de `AppFocusRing`.
- Painel admin: não se aplica (sem mudança no `git diff`).
