# Plano da 010. Layout de leitura compartilhado e Manifesto

- **Spec:** [spec.md](spec.md)
- **Criado em:** 2026-10-01

## Abordagem
A base de leitura vira uma pasta compartilhada, `lib/app/core/components/reading/`, porque será usada por páginas de `home` (Manifesto, Nossa história, Pessoa da equipe) e de `posts` (012). São peças pequenas e independentes, para que cada página monte só o que usa:

- `ReadingPageScaffold`: `Scaffold` com `CustomScrollView` → `NavbarSliver` → cabeçalho opcional → corpo → `SliverFillRemaining(hasScrollBody: false)` com `Spacer` e `Footer` (o padrão que a 007 provou deixar o rodapé na base da janela).
- `PageHeader`: faixa de superfície com linha na base, dentro de `PageContent`: `Breadcrumbs`, título `h1` e texto de apoio opcional.
- `Breadcrumbs`: lista de `BreadcrumbItem(label, route)`; o último é a página atual, sem link. Suporta dois ou três níveis (e mais, por quebra de linha).
- `ReadingColumn`: `PageContent` → coluna de até 680 px centralizada, com respiro acima e abaixo. Pode ser usada sem `PageHeader` (Pessoa da equipe e post).
- Blocos: `ReadingLead`, `ReadingParagraph`, `ReadingNumberedList`, `ReadingQuote`. O espaçamento entre blocos fica nos próprios blocos (margens do protótipo), para a página só empilhar.

O `ManifestPage` é reescrito com essas peças e o texto da spec, como `StatelessWidget`, sem `num_extension` e sem os componentes de texto antigos. Nenhuma rota muda: a `GoRoute` de `/manifesto` continua apontando para `ManifestPage`.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/app/theme/app_dimensions/app_dimensions.dart` | Em `ComponentSizes`, com comentário de origem: cabeçalho (`pageHeadPaddingTop` 28, `pageHeadPaddingBottom(bp)` 32/46/56, `pageHeadTitleGap` 22, `pageHeadLeadGap` 14); migalhas (`breadcrumbGap` 6, `breadcrumbIcon` 13); coluna (`readingPaddingTop` 40, `readingPaddingBottom(bp)` 40/56/64); lista numerada (`readingListNumberDiameter` 30, `readingListNumberColumn` 34, `readingListNumberGap` 14, `readingListItemGap` 14, `readingListNumberTopOffset` 3, `readingListMarginVertical` 25); destaque (`readingQuoteBar` 3, `readingQuotePaddingLeft` 22, `readingQuotePaddingVertical` 4, `readingQuoteMarginVertical` 29). `pageHeadPaddingVertical` continua (usado pela página provisória de Nossa história) |
| Alterar | `lib/app/theme/app_typography/app_text_styles.dart` | `readingListItem` (Figtree 400, 17/17,5/17,5, altura 1,65; `.manifest-list li`), `readingListNumber` (Figtree 700, 14, altura 1), `readingQuote` (Bricolage 500, 20/22,4/22,4, altura 1,35, -0,02 em; `.prose blockquote`). Abertura usa `lead`; migalhas usam `small` |
| Criar | `lib/app/core/components/reading/reading_page_scaffold.dart` | Esqueleto da página de leitura (navbar, cabeçalho opcional, corpo, rodapé na base) |
| Criar | `lib/app/core/components/reading/page_header.dart` | Cabeçalho de página com migalhas, título (`Semantics(header)`) e apoio opcional |
| Criar | `lib/app/core/components/reading/breadcrumbs.dart` | `Breadcrumbs` e `BreadcrumbItem`: `Wrap`, link com `InkWell` + `AppFocusRing` + `Semantics(link)`, seta `Icons.chevron_right` decorativa presa ao item seguinte, item atual não focável |
| Criar | `lib/app/core/components/reading/reading_column.dart` | Coluna de 680 px centralizada com respiro |
| Criar | `lib/app/core/components/reading/reading_blocks.dart` | `ReadingLead`, `ReadingParagraph`, `ReadingNumberedList`, `ReadingQuote` |
| Alterar | `lib/app/features/home/presentation/pages/manifest_page.dart` | Reescrita com a base de leitura e o texto da spec; botão `PrimaryButton.medium("Fale com a gente", trailingIcon: Icons.arrow_forward)` → `go(AppRoutes.contact)` |
| Alterar | `docs/arquitetura.md` | `reading` na tabela de `core/components/` e parágrafo curto de como montar uma página de leitura |

## Decisões técnicas
- **Pasta em `core/components/reading/`**, não em `features/home`: a 012 (posts) também usa a coluna. Alternativa descartada: um único widget "página de leitura" com parâmetros para tudo, que travaria a 011 e a 012 (Pessoa e post têm cabeçalho próprio).
- **Rodapé.** Igual à 007: `Footer` dentro do `SliverFillRemaining` depois de um `Spacer`. O padrão antigo do Manifesto (sliver vazio + rodapé fora) deixava vão em branco na janela alta.
- **Lista numerada.** `Row` com `crossAxisAlignment.start`: círculo de `readingListNumberDiameter × textScaler.scale(1)` (cresce com o texto), deslocado `readingListNumberTopOffset` do topo, numa coluna de `readingListNumberColumn` escalada; texto em `Expanded`. Semântica: `Semantics(role: SemanticsRole.list)` no grupo e `SemanticsRole.listItem` em cada item (existem no Flutter 3.44), com `label` "N. texto" e `excludeSemantics` no conteúdo, para o número ser lido junto e o círculo não ser lido separado. Cores: círculo `accentSoft`, número `accentStrong`.
- **Destaque.** `Container` com `Border(left: accent, readingQuoteBar)` e preenchimento; texto `readingQuote` em `ink`. A barra é decoração, sem semântica.
- **Migalhas.** Grupo `Semantics(container: true, label: 'Você está em')`. O Flutter não tem `aria-current`: o item atual recebe `semanticsLabel` "Manifesto, página atual". Links em `inkSecondary`, `accentStrong` com sublinhado no hover; atual em `ink`, peso 600. Cada item é um `Row(min)` [seta, texto] a partir do segundo, para a seta não ficar sozinha no fim da linha.
- **Abertura.** `lead` (17/20/20, altura 1,55) em `ink`: o protótipo usa 1,25 rem/1,6, perto do `lead` já existente; não vale um estilo só para isso.
- **Respiro abaixo da coluna.** 40/56/64 px em vez dos 24 px de `.article`: no protótipo a coluna do post continua em "Leia também"; no Manifesto o botão fica colado no rodapé escuro. Ajuste visual, sem mudar comportamento da spec.
- **Texto.** Constantes na própria `ManifestPage` (lista de strings), como a 007.
- **Componentes antigos.** `AppHeadline`, `AppBody`, `AppDivider` e `num_extension` deixam de ser importados pelo Manifesto, mas não são apagados (Fase 7).

## Dependências e geração de código
Nenhum pacote, asset ou `build_runner`. Nenhuma mudança em `app_router.dart`, `app_routes.dart` ou `*_setup.dart`.

## Riscos e cuidados
- **Base usada por 011 e 012.** Se a API ficar estreita, essas specs terão de mexer aqui. Conferir na tarefa de documentação que migalhas de três níveis, apoio opcional e coluna sem cabeçalho funcionam (criterio 13), montando um caso de teste temporário que não é commitado, ou lendo o código.
- **`SemanticsRole` no web.** Se `list`/`listItem` gerarem aviso ou erro de semântica em tempo de execução, cair para o `label` "N. texto" sem `role` e registrar na spec.
- **Rodapé compartilhado.** Não muda; só conferir o Manifesto com a janela alta e curta.
- **Links para o Manifesto.** Hero, Quem somos e rodapé continuam usando `AppRoutes.manifesto`; conferir os três.

## Como conferir
- `fvm flutter analyze` numa cópia em caminho ASCII no scratchpad (rsync sem `build/` e `.dart_tool/`, `fvm flutter pub get`) e `fvm flutter build web --release`.
- Build servido por servidor Python próprio com fallback de SPA, no navegador embutido em 390, 768 e 1280 px: `/manifesto` (texto, lista, destaque, botão → `/contato`, migalha Início → Home, Tab + Enter), `/manifest` redirecionando, acesso direto, janela alta, `scrollWidth` igual à largura, console sem `overflow`, árvore de semântica. Voltar o navegador ao preset desktop e parar os servidores no fim.
