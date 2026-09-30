# Plano da 007. Home: resumo de Nossa história

- **Spec:** [spec.md](spec.md)
- **Criado em:** 2026-09-26

## Abordagem
O bloco antigo `OurHistory` sai da Home e dá lugar a `OurHistorySummarySection`, estática, montada junto com a página (sem `deferred`), no mesmo padrão de `WhoWeAreSection`: `ColoredBox(surface)` → `PageContent` → respiro de seção (`sectionPaddingVertical`) → coluna limitada a 720 px alinhada à esquerda. Reaproveita o `ArrowLink` da 006 para "Ler a história completa" e cria um selo pequeno (`MilestoneBadge`) para o marco da FAPEMIG.

O texto completo vai para uma página nova, `OurHistoryPage`, em `/nossa-historia`. Ela segue o esqueleto do `ManifestPage` (`CustomScrollView` com `NavbarSliver`, conteúdo, `SliverFillRemaining` e `Footer`), mas com tokens novos e sem `num_extension`: faixa de cabeçalho de superfície com o `h1` e linha na base, e a coluna de leitura de 680 px centralizada com os três parágrafos atuais, copiados sem alteração de `our_history.dart`.

A rota entra em `app_router.dart` como uma `GoRoute` nova (as existentes não mudam), com o caminho em `AppRoutes.ourHistory`. O rodapé ganha o link "Nossa história" na coluna "Institucional".

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/app/theme/app_dimensions/app_dimensions.dart` | Em `ComponentSizes`: largura do resumo (`ourHistorySummaryMaxWidth` 720, `.narrow`), vãos rótulo→título (10), título→selo (20), selo→texto (22), texto→link (22), entre parágrafos (`readingParagraphGap`, 1,1 em ≈ 20); selo: preenchimento 8 × 16, vão ícone→texto 10, ícone 16; página: coluna de leitura (`readingMaxWidth` 680), preenchimento do cabeçalho por faixa (28/40/56 no topo e na base, `.page-head .wrap`) |
| Alterar | `lib/app/theme/app_typography/app_text_styles.dart` | `badge` (texto do selo: 14,5, peso 600, altura 1,35; `.fact`), se nenhum estilo existente servir |
| Alterar | `lib/app/core/routes/app_routes.dart` | Constante `ourHistory = '/nossa-historia'` |
| Criar | `lib/app/features/home/presentation/components/our_history/milestone_badge.dart` | Selo: fundo `accentSoft`, raio `r20`, ícone `Icons.schedule_outlined` decorativo e texto `accentStrong` que quebra linha (`Flexible`) |
| Criar | `lib/app/features/home/presentation/components/our_history/our_history_summary_section.dart` | Resumo da Home: rótulo, título `splitTitle` com `Semantics(header)`, selo, dois parágrafos `reading` em `ink`, `ArrowLink` → `AppRoutes.ourHistory` |
| Apagar | `lib/app/features/home/presentation/components/our_history.dart` | Bloco antigo; o texto passa para a página nova |
| Criar | `lib/app/features/home/presentation/pages/our_history_page.dart` | Página provisória: navbar, cabeçalho de superfície com `h1` (`Semantics(header)`) e linha `line`, três parágrafos atuais em `reading`/`ink` numa coluna de 680 px, `SliverFillRemaining` e `Footer` |
| Alterar | `lib/app/router/app_router.dart` | `GoRoute(path: AppRoutes.ourHistory)` → `OurHistoryPage`, depois de `/manifest` |
| Alterar | `lib/app/features/home/presentation/pages/home_page.dart` | Sliver de Nossa história com `OurHistorySummarySection` (sem `FutureBuilder`); remover o `AppDivider` entre ele e a Equipe e o import `deferred` sem uso |
| Alterar | `lib/app/core/components/footer/footer.dart` | Link "Nossa história" entre "Manifesto" e "Equipe" → `AppRoutes.ourHistory` |
| Alterar | `docs/arquitetura.md` | Rota nova na lista e resumo de Nossa história na seção "Home" |
| Alterar | `docs/redesign/planejamento.md` | T-03: rota atual `/nossa-historia` (provisória, redesenho na Fase 2) |

## Decisões técnicas
- **Nenhum pacote novo, nenhum asset novo, sem `build_runner`.** Ícones Material: `Icons.schedule_outlined` (relógio) e a seta do `ArrowLink`.
- **Página em `features/home`.** Manifesto e Membro da equipe já são páginas da feature `home`; a página nova segue o mesmo lugar. Não precisa de store nem de registro em `home_setup.dart`.
- **Texto da página sem alteração.** Os três parágrafos são copiados literalmente das constantes de `our_history.dart` (incluindo "GEPEGH/UFU" com travessão e as aspas curvas). O segundo bloco atual tem dois parágrafos separados por linha em branco: viram dois `Text` separados pelo vão de parágrafo. Conferir com `diff` do texto antes de apagar o arquivo antigo.
- **Selo que quebra linha.** `Row(mainAxisSize: min)` com ícone e `Flexible(Text)`, dentro de um `Container` com raio `r20` (em uma linha, com ≈ 38 px de altura, fica igual a uma pílula; em duas, vira retângulo arredondado sem cortar o texto nos cantos, o que aconteceria com `pill`). Ícone alinhado ao topo da primeira linha.
- **Estilo do texto do resumo e da página.** `reading` (17/18/18, altura 1,75) em `ink`: o protótipo usa `#2B2622` na `.prose`, próximo de `ink` e sem token próprio; não vale criar uma cor só para isso.
- **Divisória.** Só sai o `AppDivider` entre Nossa história e Equipe; o que fica entre Equipe e Realização e apoio é da 008/009.
- **Rodapé fixo na base.** `SliverFillRemaining(hasScrollBody: false)` antes do `Footer`, igual ao `ManifestPage` (critério 12).
- **Navbar.** `NavbarLocation` não muda: `/nossa-historia` cai no `default` (nenhum item ativo), como `/manifest`.

## Dependências e geração de código
- Rota nova em `app_router.dart` (só acréscimo). Nenhuma mudança em `*_setup.dart`, modelos ou Firebase.

## Riscos e cuidados
- **Rodapé é compartilhado.** Aparece em todas as páginas públicas: conferir a coluna "Institucional" em 390, 768 e 1280 px (quatro links sem quebrar o layout em colunas) e o foco por Tab.
- **Rotas existentes.** Conferir por `git diff` que nenhuma `GoRoute` existente mudou e abrir `/manifest` e `/contato` depois da mudança.
- **Acesso direto a `/nossa-historia`.** O servidor de teste precisa do fallback de SPA; no site publicado isso já vale para as demais rotas.
- **Transições de fundo.** Vídeo (branco) → resumo (superfície) → Equipe (ainda no visual antigo, com faixa própria). Conferir que a junção resumo/Equipe não fica sem respiro após tirar a divisória.

## Como conferir
- `fvm flutter analyze` numa cópia em caminho ASCII no scratchpad (rsync sem `build/` e `.dart_tool/`, `fvm flutter pub get`) e `fvm flutter build web --release`.
- Build servido por Python com fallback de SPA, no navegador embutido em 390, 768 e 1280 px: Home (resumo, link, sem divisória), `/nossa-historia` (clique, Enter, acesso direto, voltar), rodapé, texto ampliado a 200 %, `scrollWidth` igual à largura, console sem `overflow`. Voltar o navegador ao preset desktop e parar os servidores no fim.
