# Plano da 012. Layout-base do post (tipo artigo) e seção Apoio

- **Spec:** [spec.md](spec.md)
- **Criado em:** 2026-10-01

## Abordagem
A `PostDetailedPage` é reescrita sobre o `ReadingPageScaffold` (010/011) e passa a ter um store próprio por página, com os estados que a spec pede (carregando, sucesso, não encontrado, erro) e a lista do "Leia também". Hoje ela usa o `FetchPostsStore` compartilhado com a página da categoria (`selectedPost`, `state`), o que mistura estados e não distingue "não encontrado" de falha. O store novo é registrado como fábrica: cada página tem o seu, e voltar para a categoria não encontra a lista alterada.

O conteúdo do post sai de um **ponto único** por tipo (`post_type_content.dart`): artigo → layout-base novo (`ArticleBody`); os outros 9 tipos → o `*_content.dart` atual, sem mudança. A Fase 5 troca tipo a tipo nesse ponto. Abaixo do conteúdo, a página põe o Leia também (só artigo) e o `Support` redesenhado (todos os tipos).

O texto do editor rico ganha um leitor próprio da base de leitura (`ReadingRichText`), com estilos dos tokens, tratamento de imagem embutida e limpeza das cores do editor. O `ViewQuill` antigo continua para os outros tipos.

O `Support` (usado só no post) é reescrito no lugar com o desenho do protótipo, o que cumpre o "Support antigo não aparece mais" sem arquivo novo. O compartilhar atual (`SocialIcons`) ganha nome acessível, dica, foco e tamanhos de token, e vai para a linha de autoria; a 013 o substitui.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/app/theme/app_dimensions/app_dimensions.dart` | Em `ComponentSizes`, com origem no protótipo: `postHeadMaxWidth` 820 (`.wrap.narrow`), `postTitleGap` 22, `postSubtitleGap` 14, `postBylineMarginTop` 26, `postBylinePaddingVertical` 18, `postBylineGap` 16, `postAuthorAvatar` 44, `postAuthorGap` 12, `postCoverMarginTop` 28, `postCoverAspect` 21/9, `postCoverCaptionGap` 10, `postBodyPaddingTop` 40, `shareIconButton` 38, `shareIcon` 22, `shareGap` 4, `readingImageMaxHeight` 560, `readingImageMarginVertical` 24, `readingImagePlaceholderAspect` 16/10, `postNoteMarginTop` 40, `postNotePaddingVertical` 20, `postNotePaddingHorizontal` 24, `postNoteLabelGap` 6, `relatedCardMinWidth` 300, `relatedCardGapH` 28, `relatedCardGapV` 36, `relatedCardInnerGap` 14, `relatedThumbAspect` 16/10, `relatedThumbLift` 4, `relatedTitleMaxLines` 3, `supportPaddingVertical` 48, `supportColumnsBreak` 820, `supportColumnGapH` 64, `supportColumnGapV` 32, `supportLabelGap` 14, `socialPillPaddingH` 14, `socialPillPaddingV` 9, `socialPillGap` 8, `postSkeleton*` (larguras das barras) |
| Alterar | `lib/app/theme/app_typography/app_text_styles.dart` | `postTitle` (Bricolage 800, 32/42/53, altura 1,12, -0,03 em; `.article-head h1`), `postSubtitle` (Figtree 400, 18/20/22,4, altura 1,45; `.sub`), `relatedCardTitle` (Bricolage 650→`w600`, 20, altura 1,2), `overline` (Figtree 700, 13, +0,09 em; rótulos "NOTA", "Acompanhe", "Apoio") se `label` não servir |
| Alterar | `lib/app/core/utils/enums/posts_areas.dart` | `tryFromKey` (retorna `null` em vez de lançar), para a rota mostrar a 404 |
| Alterar | `lib/app/router/app_router.dart` | Só o builder de `postPattern`: área inválida → `PageNotFound`. Caminho não muda |
| Alterar | `lib/app/core/utils/date/date.dart` | `formatMonthYear("03/2026")` → "março de 2026"; fora do formato, devolve o texto |
| Alterar | `lib/app/core/utils/strings/strings.dart` | `joinNames(["A","B","C"])` → "A, B e C"; `initialsOf(name)` movido de `sort_team.dart` (`memberInitials`) |
| Alterar | `lib/app/features/home/presentation/components/team/sort_team.dart` e quem usa `memberInitials` | Usar `initialsOf` do core |
| Alterar | `lib/app/core/components/reading/breadcrumbs.dart` | Item do meio sem `route` vira texto comum (`inkSecondary`, sem foco, sem "página atual"); só o último é a página atual |
| Criar | `lib/app/core/components/reading/reading_rich_text.dart` | `ReadingRichText(delta)`: `QuillEditor` só leitura, `DefaultStyles` dos tokens (paragraph `reading`, h1–h3 `readingSubtitle`, h4–h6 `reading` w700, lists, quote com barra `accent`, link `accentStrong` sublinhado), delta limpo de `color`/`background`/`font`, `embedBuilders` com imagem (largura da coluna, `BoxFit.contain`, altura máx., placeholder na falha), `unknownEmbedBuilder` vazio, `onLaunchUrl` → `openUrl` |
| Alterar | `lib/app/features/posts/infra/datasources/fetch_posts_datasource.dart` | `fetchPostById`: sem documento ou `isPublished == false` → `PostNotFoundException` |
| Alterar | `lib/app/features/posts/infra/errors/failures.dart` | `PostNotFoundFailure` |
| Alterar | `lib/app/features/posts/infra/repositories/fetch_posts_repository.dart` | Mapear `PostNotFoundException` → `PostNotFoundFailure`; demais erros continuam `FetchPostByIdFailure` |
| Criar | `lib/app/features/posts/presentation/stores/post_detail_store.dart` (+ `.g.dart`) e `states/post_detail_states.dart` | `PostDetailStore`: `state` (Initial, Loading, Success(post), NotFound, Error), `related` (lista) e `fetch(category, postId)`, `fetchRelated(category, post)` (repositório `fetchPosts` com `postType: article`, `limit: 4`, filtra o atual, fica com 3; falha → lista vazia) |
| Alterar | `lib/app/features/posts/posts_setup.dart` | `registerFactory<PostDetailStore>` |
| Alterar | `lib/app/features/posts/presentation/components/social_icons.dart` | `Tooltip` + `Semantics(button, label)` + `AppFocusRing`, tamanho `shareIconButton`/`shareIcon`, sem `num_extension`; mesmos links |
| Criar | `lib/app/features/posts/presentation/components/post/article_header.dart` | Migalhas, título `h1`, subtítulo, linha de autoria (`ArticleByline`: iniciais com 1 autor, `joinNames`, `formatMonthYear`, compartilhar à direita ou abaixo via `Wrap`) e `PostCover` |
| Criar | `lib/app/features/posts/presentation/components/post/post_cover.dart` | 21:9, `Image.network` com `cover`, fundo `surface` enquanto carrega, placeholder `accentSoft` na falha, legenda, nome acessível |
| Criar | `lib/app/features/posts/presentation/components/post/article_note.dart` | Quadro "NOTA" com `ReadingRichText` |
| Criar | `lib/app/features/posts/presentation/components/post/article_body.dart` | Cabeçalho (até 820) + `ReadingColumn` com texto e nota |
| Criar | `lib/app/features/posts/presentation/components/post/post_type_content.dart` | Ponto único: `switch (post.type)` → `ArticleBody` ou o `*_content` atual |
| Criar | `lib/app/features/posts/presentation/components/post/related_posts_section.dart` e `related_post_card.dart` | Leia também (título, `ArrowLink` "Mais em …", grade auto-fill ≥ 300 px, até 3) e cartão-link |
| Criar | `lib/app/features/posts/presentation/components/post/post_page_skeleton.dart` | Esqueleto parado no formato do artigo, com `Skeleton` e `Semantics(label: 'Carregando')` |
| Alterar | `lib/app/core/components/support/support.dart` | Reescrito: faixa `surface` com linha no topo, "Acompanhe" + `SocialPills`, "Apoio" + `PartnerLogoGrid(minColumnWidth: partnerColumnMinWidthSmall)`, duas colunas ≥ `supportColumnsBreak` |
| Alterar | `lib/app/core/components/buttons/social_buttons.dart` | `SocialPills`: pílulas ícone SVG + nome (Instagram, Facebook, YouTube), borda `line`, hover `accent`, foco, abrem em outra aba |
| Alterar | `lib/app/features/posts/presentation/pages/post_detailed_page.dart` | Reescrita: `ReadingPageScaffold`, store próprio, reação às categorias, `didUpdateWidget` refaz a busca quando muda o id/categoria, estados, `PostTypeContent`, Leia também, `Support` |
| Alterar | `docs/arquitetura.md` | Seção de leitura: `ReadingRichText`, migalha sem link; página do post e o ponto único por tipo |

## Decisões técnicas
- **Store por página (`registerFactory`)**, em vez de estender o `FetchPostsStore`: ele é singleton e guarda a lista da categoria; o Leia também usaria `fetchPostsByType` e apagaria essa lista (critério 10). O `fetchPostById`/`selectedPost` antigos ficam sem uso pela página, mas não são apagados (Fase 7).
- **Não encontrado no datasource**: a consulta continua igual (`collectionGroup` por `id`); só o resultado vazio ou não publicado vira exceção própria. Sem mudar modelo nem regras. Alternativa (filtrar `isPublished` na consulta) pediria índice novo.
- **Leia também com `postType: article`**: reaproveita a consulta da listagem por tipo, já indexada (`isPublished`, `categoryId`, `areas`, `type`, `createdAt desc`). Sem `postType` a ordenação por `createdAt` pode pedir índice novo. `limit: 4` para sobrar 3 sem o atual.
- **Fluxo da página**: `initState` cria o store; uma `reaction` em `FetchCategoriesStore.state` chama `_load()` quando as categorias chegam. `_load()`: categorias em erro → estado de erro da página; sucesso e categoria nula → não encontrado; categoria ok → `store.fetch`. "Tentar de novo" chama `fetchCategories()` se elas falharam, senão `_load()`. `didUpdateWidget` com outro `postId` zera e refaz (`Leia também` → outro post na mesma rota). `setSelectedCategory` continua sendo chamado (comportamento atual da navbar).
- **`ReadingRichText` com Quill**, não um conversor próprio de delta para widgets: mantém tudo o que o editor gera (alinhamento, listas aninhadas) com menos código. A limpeza das cores é feita no JSON antes do `Document.fromDelta`. Imagem com `BoxFit.contain` dentro de `ConstrainedBox(maxHeight)`; falha → placeholder 16:10.
- **Cabeçalho do artigo fora do `PageHeader`**: o post não tem faixa de superfície (protótipo `.article-head` em fundo branco) e tem autoria e capa; reaproveita `Breadcrumbs` e `PageContent`.
- **`Support` reescrito no lugar** (só o post o usa): evita arquivo novo e um antigo órfão. `SocialButtons` (rodapé) não muda; `SocialPills` é variante nova no mesmo arquivo.
- **Iniciais no core**: `memberInitials` vira `initialsOf` em `core/utils/strings` para o post não importar código da feature `home`.
- **Esqueleto** usa o `Skeleton` existente (já é parado), como a 011.

## Dependências e geração de código
- Nenhum pacote novo. `flutter_quill` já está no projeto (o `EmbedBuilder` de imagem é próprio; `flutter_quill_extensions` não é usado).
- `fvm dart run build_runner build --delete-conflicting-outputs` depois de criar o `PostDetailStore`.
- `posts_setup.dart`: registro do store. `app_router.dart`: só o builder do post (área inválida → 404). Nenhum caminho de rota muda.

## Riscos e cuidados
- **Migalhas compartilhadas**: a mudança do item do meio não pode alterar Manifesto, Nossa história e Pessoa (todos os itens do meio lá têm rota). Conferir as três.
- **Quill só leitura no web**: links podem não abrir sem `onLaunchUrl`/`linkActionPickerDelegate`; o `QuillEditor` pode pedir foco/cursor. Conferir clique e Enter num link, seleção de texto e que o editor não entra no Tab como campo editável.
- **Deltas reais**: conteúdo antigo pode ter atributos inesperados (`size`, `header` 4+, `indent`, `code-block`). Conferir com um artigo real e com um delta injetado com imagem e embed desconhecido.
- **Outros tipos**: continuam com `num_extension` e o compartilhar antigo dentro da página nova; conferir ao menos um de outro tipo em 390/768/1280 sem `overflow`.
- **Página da categoria**: usa `FetchPostsStore`; conferir que listar, buscar e voltar de um post continuam iguais.
- **Banco de dev sem posts**: se não houver artigo no Firebase dev, conferir com build `--dart-define=APP_ENV=prod` (só leitura, sem login), registrando na verificação.
- **Contraste**: rótulos em `accentStrong`/`inkSecondary`, nunca `accent` em texto pequeno sobre `surface`.

## Como conferir
- `fvm flutter analyze` numa cópia em caminho ASCII no scratchpad (rsync sem `build/` e `.dart_tool/`, `fvm flutter pub get`) e `fvm flutter build web --release`.
- Build servido por servidor Python próprio com fallback de SPA, no navegador embutido em 390, 768 e 1280 px: um artigo real (cabeçalho, autoria, compartilhar, capa, texto, nota, Leia também, Apoio, Tab, contraste, `scrollWidth`), um post de outro tipo, 404 (área, categoria, id inexistente), erro (requisições do Firestore bloqueadas ou falha injetada temporária) e esqueleto, Manifesto, Nossa história, Pessoa e página da categoria. Console sem `overflow`. Voltar o navegador ao preset desktop e parar os servidores no fim.
