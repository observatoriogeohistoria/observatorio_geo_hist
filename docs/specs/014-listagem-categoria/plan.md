# Plano da 014. Listagem de categoria e card de post

- **Spec:** [spec.md](spec.md)
- **Criado em:** 2026-10-02

## Abordagem
A página da categoria é reescrita sobre o `ReadingPageScaffold` (010/011), com o cabeçalho de página da 010 e uma **listagem genérica de posts** que não sabe de categoria: recebe um store próprio e uma função que monta a rota de cada post. A 015 vai montar a mesma listagem em `/publicacoes` só trocando o escopo do store.

O estado sai do `FetchPostsStore` (singleton, ordem dos blocos aleatória, busca sem cursor) e vai para um `PostsListingStore` novo, registrado como fábrica (um por página), no mesmo padrão do `PostDetailStore` da 012. Ele carrega a primeira página de cada tipo e as contagens em paralelo, guarda um bloco por tipo (itens, cursor, "tem mais", carregando mais, falha no "ver mais") e descarta respostas velhas (troca de busca ou de categoria no meio da carga) por um número de requisição.

O datasource ganha três ajustes sem mudar modelo nem índice: categoria opcional (para a 015), cursor também na busca e "tem mais" sem página vazia (pede `limite + 1`). Ganha também `countPosts`, contagem agregada com os mesmos filtros da listagem por tipo (a busca vira `>=`/`<` em `body.title_lower`, equivalente ao `startAt`/`endAt` de hoje).

O card de post é um só (`PostCard`), com imagem 16:10, rótulo, título, resumo opcional e detalhes. O resumo e os detalhes de cada tipo saem de uma função pura (`postCardInfo`), num ponto só. O "Leia também" passa a usar o card (sem resumo) e a mesma grade (`PostCardGrid`), e o `RelatedPostCard` é apagado.

Componentes que a Fase 4 (biblioteca) também vai querer ficam no core: campo de busca, chip de filtro e caixa de estado genérica (a `StateErrorBox` passa a usá-la, sem mudar a aparência).

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/app/theme/app_dimensions/app_dimensions.dart` | Renomear `related*` → `postCard*` (`postCardMinWidth` 300, `postCardGapH` 28, `postCardGapV` 36, `postCardInnerGap` 14, `postCardThumbAspect` 16/10, `postCardThumbLift` 4, `postCardTitleMaxLines` 3, `postCardTitleGap` 4, `postCardAnimation` 250 ms) e criar `postCardSummaryMaxLines` 2, `postCardMaxColumns` 3; busca (`searchFieldHeight` 48, `searchFieldMaxWidth` 520, `searchFieldIconInset` 14, `searchFieldPaddingStart` 44, `searchFieldPaddingEnd` 84, `searchFieldFocusRing` 4); chips (`chipPaddingH` 14, `chipPaddingV` 7, `chipGap` 8, `chipCountGap` 6); listagem (`listingToolbarPaddingTop` 24, `listingToolbarPaddingBottom` 8, `listingToolbarGap` 16, `listingCountPaddingTop` 4, `listingCountPaddingBottom` 20, `listingBlockPaddingTop` 20, `listingBlockPaddingBottom` 12, `listingBlockTitleGap` 20, `listingBlockCountGap` 10, `listingMorePaddingTop` 28, `listingMorePaddingBottom` 56, `listingMoreErrorGap` 12, `listingEmptyPaddingVertical` 56); `pageHeadActionGap` 22; esqueleto do card e do cabeçalho (`postCardSkeleton*`). Valores do protótipo (`.cards`, `.card`, `.search`, `.chip`, `.toolbar-row`, `.count`, `.type-block`, `.more`, `.empty`) |
| Alterar | `lib/app/theme/app_typography/app_text_styles.dart` | `relatedCardTitle` → `postCardTitle`; novos `postCardSummary` (Figtree 400, 15,5, altura 1,55), `listingBlockTitle` (Bricolage 700, 24, altura 1,12), `chip` (Figtree 600, 14, altura 1,2) |
| Alterar | `lib/app/features/posts/infra/datasources/fetch_posts_datasource.dart` | `fetchPosts(CategoryModel? category, …)`: sem categoria, sem filtro de `categoryId`/`areas`; busca com `trim()` e `startAfterDocument`; pede `limit + 1` e devolve `limit` com `hasMore` real; `countPosts({category, postType, searchText})` com `.count().get()` |
| Alterar | `lib/app/features/posts/infra/repositories/fetch_posts_repository.dart` e `infra/errors/failures.dart` | Assinaturas novas e `countPosts` → `Either<CountPostsFailure, int>` |
| Alterar | `lib/app/features/posts/presentation/stores/post_detail_store.dart` | Ajustar a chamada de `fetchPosts` à assinatura nova (Leia também continua com 4 e filtra o atual) |
| Criar | `lib/app/features/posts/presentation/stores/posts_listing_store.dart` (+ `.g.dart`) e `states/posts_listing_states.dart` | `PostsListingStore`: `scope` (categoria opcional + tipos), `status` (inicial, carregando, sucesso, vazio, erro), `blocks` por tipo, `counts` (`null` se a contagem falhou), `selectedType`, `searchText`; ações `load(scope)`, `search(text)`, `clearSearch()`, `selectType(type?)`, `loadMore(type)`, `retry()`; derivados `visibleBlocks`, `typesWithPosts`, `totalCount`; tamanho de página 12 |
| Alterar | `lib/app/features/posts/posts_setup.dart` | `registerFactory<PostsListingStore>`; remover `FetchPostsStore` |
| Apagar | `lib/app/features/posts/presentation/stores/fetch_posts_store.dart` (+ `.g.dart`) e `states/fetch_posts_states.dart` | Sem uso depois da troca (o detalhe já tem store próprio) |
| Criar | `lib/app/core/utils/strings/plain_text.dart` | `plainTextFromRich(String)`: delta do Quill → texto simples (`Document.fromJson(...).toPlainText()`), espaços compactados; texto que não é delta volta como veio |
| Criar | `lib/app/features/posts/presentation/components/card/post_card_info.dart` | `postCardInfo(PostModel) → ({label, title, summary, meta})` com a tabela de tipos da spec (usa `joinNames`, `formatMonthYear`, `plainTextFromRich`) |
| Alterar (reescrever) | `lib/app/features/posts/presentation/components/card/post_card.dart` | `PostCard(post, route, showSummary)`: `Semantics(link, label, linkUrl)` + `AppFocusRing` + `InkWell`, imagem 16:10 `cover` com `PostImagePlaceholder`, hover com subida e título `accent`, sem movimento com `disableAnimations` (base no `RelatedPostCard`) |
| Criar | `lib/app/features/posts/presentation/components/card/post_card_grid.dart` | `PostCardGrid(children)`: colunas de ≥ 300 px, máximo 3, linhas com `Row`/`Expanded` (lógica tirada do `RelatedPostsSection`) |
| Criar | `lib/app/features/posts/presentation/components/card/post_card_skeleton.dart` | Cards-esqueleto (16:10 + três barras), quantidade = colunas da largura, `Semantics(label: 'Carregando')` |
| Alterar | `lib/app/features/posts/presentation/components/post/related_posts_section.dart` | Usar `PostCard(showSummary: false)` e `PostCardGrid` |
| Apagar | `lib/app/features/posts/presentation/components/post/related_post_card.dart` | Substituído pelo `PostCard` |
| Criar | `lib/app/core/components/field/search_field.dart` | `SearchField(controller, hint, semanticLabel, onChanged debounced 400 ms, onSubmitted, onClear)`: 48 px, lupa, "Limpar" (nome "Limpar busca") só com texto, borda `line` → `accent` com anel `accentSoft` no foco |
| Criar | `lib/app/core/components/chips/filter_chip_button.dart` | `FilterChipButton(label, count?, selected, onPressed, semanticLabel)`: pílula, `Semantics(button, toggled)`, foco visível; marcado `ink`/`page` |
| Criar | `lib/app/core/components/error_content/state_message_box.dart` | Caixa genérica (ícone, título, texto, ação opcional, tom neutro ou de erro, `liveRegion`) |
| Alterar | `lib/app/core/components/error_content/state_error_box.dart` | Passa a montar a `StateMessageBox` (mesma aparência e textos) |
| Alterar | `lib/app/core/components/reading/page_header.dart` | Parâmetro opcional `action` (widget abaixo do lead, com `pageHeadActionGap`); sem ele, nada muda |
| Criar | `lib/app/features/posts/presentation/components/listing/posts_listing.dart` | Listagem genérica: observa o store; barra (busca + chips), contagem com `liveRegion`, blocos (`listing_type_block.dart`), estados (esqueleto, vazio da categoria, busca vazia, erro) |
| Criar | `lib/app/features/posts/presentation/components/listing/listing_toolbar.dart` | `Wrap` com busca (até 520) e chips; contagem |
| Criar | `lib/app/features/posts/presentation/components/listing/listing_type_block.dart` | Título `h2` "Artigos" + quantidade, `PostCardGrid`, "Ver mais artigos" (`SecondaryButton`, "Carregando…" desativado, `reserveTexts`), mensagem de erro do "ver mais" |
| Criar | `lib/app/features/posts/presentation/components/listing/category_page_skeleton.dart` | Esqueleto do cabeçalho (migalhas, título, duas linhas) + `PostCardSkeleton` |
| Alterar (reescrever) | `lib/app/features/posts/presentation/pages/posts_page.dart` | `ReadingPageScaffold` + `PageHeader` (migalhas, título, descrição, `action` Colabore) + `PostsListing`; categorias carregando → esqueleto; erro → `StateErrorBox` refazendo `fetchCategories`; categoria inexistente → `PageNotFound`; troca de categoria → `store.load` novo escopo e rola ao topo |
| Alterar | `lib/app/router/app_router.dart` | Só o builder de `categoryPattern`: `PostsAreas.tryFromKey`, área inválida → `PageNotFound`. Caminho não muda |
| Apagar | `posts/presentation/components/posts_section_list.dart`, `components/header/category_header.dart`, `components/header/actions_header.dart` | Usados só pela página antiga |
| Alterar | `docs/arquitetura.md` | Seção "Listagem de posts": store por página, escopo, card único com `postCardInfo`, grade, reuso pela 015 |

## Decisões técnicas
- **Store novo em vez de remendar o `FetchPostsStore`.** O antigo é singleton, mistura detalhe e listagem e não tem estados por bloco. A fábrica por página repete o padrão da 012 e deixa a 015 ter o seu.
- **Escopo sem categoria já no datasource.** Custa um `if` agora e evita a 015 mexer na assinatura. Sem categoria, a consulta pode pedir índice novo; isso fica para a 015 conferir.
- **Contagem por tipo e soma.** `count()` com os mesmos filtros de igualdade da listagem (e o intervalo do título na busca) cabe nos índices atuais. Uma contagem só, sem tipo, exigiria índice sem `type`. Uma leitura de agregação custa 1 leitura a cada 1000 itens.
- **`limit + 1` para "tem mais".** Evita o clique que traz página vazia sem uma contagem extra; a contagem pode falhar e o botão não pode depender dela.
- **Primeira carga em paralelo, tudo ou nada.** Se qualquer tipo falhar, mostra o erro da lista (mais simples e honesto que blocos faltando); contagem falha à parte.
- **Respostas velhas descartadas** por número de requisição: digitar rápido ou trocar de categoria não mistura resultados.
- **Card no feature `posts`, não no core.** Depende de `PostModel` e das rotas de post; a 015 é do mesmo feature. Busca, chip e caixa de estado vão para o core porque a biblioteca (Fase 4) também usa.
- **Texto do editor no resumo** via `Document.fromJson(...).toPlainText()` do `flutter_quill` (já é dependência), com fallback para o texto cru.
- **Esqueleto parado** com o `Skeleton` atual (sem animação), como na 011/012, o que já cumpre o movimento reduzido.
- **Página continua `PostsPage`** (mesmo arquivo e classe) para não mexer no roteador além da validação da área.

## Dependências e geração de código
- Sem pacote novo, sem asset novo.
- `fvm dart run build_runner build --delete-conflicting-outputs` depois de criar o `PostsListingStore` e apagar o `FetchPostsStore`.
- `posts_setup.dart`: fábrica do `PostsListingStore`, sai o `FetchPostsStore`.
- Rotas: nenhum caminho novo; só a validação da área no builder de `categoryPattern`.

## Riscos e cuidados
- **Índice da contagem com busca:** `count()` com `>=`/`<` em `body.title_lower` deve usar o índice da busca atual (mesmos campos). Se o Firestore pedir índice, a contagem falha e só os números somem (comportamento previsto na spec). Registrar como ressalva, sem criar índice (fora do escopo).
- **Dados de teste:** o Firebase dev tem só um post (pesquisa). Conferir em build `APP_ENV=prod` só leitura, como na 012. Imagem com falha, título longo, 13+ itens e tipos raros podem exigir build temporário com dados injetados (não commitado).
- **`PageHeader` e `StateErrorBox` são compartilhados** (Manifesto, Nossa história, Pessoa, Post): conferir que não mudaram.
- **"Leia também"** troca de cartão: conferir post de artigo (mesma aparência, 3 colunas, foco e hover).
- **Navbar:** a página antiga reagia a `selectedCategory`; a nova reage aos parâmetros da rota (`didUpdateWidget`) e chama `setSelectedCategory` como o detalhe. Conferir troca de categoria pelo menu no desktop e no celular.
- **Busca com acentos** continua limitada ao `title_lower` (spec, fora do escopo).
- **Asserções de layout** (`Wrap` com campo de largura máxima, `Row`/`Expanded` na grade) só aparecem em debug: abrir em debug.

## Como conferir
- `fvm flutter analyze` (numa cópia em caminho ASCII) e `fvm dart format` nos arquivos alterados.
- `fvm flutter build web --release --dart-define=APP_ENV=prod`, servir `build/web` com fallback de SPA e abrir no navegador embutido em 390, 768 e 1280: categoria com vários tipos, com um tipo, com `hasCollaborateOption` e sem, categoria inexistente, área inválida, busca com e sem resultado, chips, "Ver mais", rede bloqueada.
- `fvm flutter run -d web-server` na cópia ASCII para ver o console em debug (sem `overflow` nem asserções).
- Post de artigo (Leia também), Manifesto, Nossa história e Pessoa da equipe sem mudança visual.
