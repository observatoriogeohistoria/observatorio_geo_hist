# Plano da 016. Biblioteca: entrada por área e lista com filtros

- **Spec:** [spec.md](spec.md)
- **Criado em:** 2026-10-02

## Abordagem
A rota pública `/biblioteca/:area` deixa de usar a `LibraryListPage` e passa a montar uma página nova, `LibraryAreaPage`, sobre o `ReadingPageScaffold` com o `PageHeader` da 010. A rota do painel (`/painel/biblioteca/:area`) continua apontando para a `LibraryListPage`, que não é tocada, assim como `Filters`, `LibraryDocumentCard`, o diálogo de documento, `LibraryStore` e `FilterDocumentsStore`. A `LibraryPage` (`/biblioteca`) é reescrita no lugar.

O estado da lista pública vai para um store novo, `LibraryListingStore`, registrado como fábrica (um por página), no padrão do `PostsListingStore` da 014: filtros (campo de busca, termo, tipo, ano, categorias), itens, cursor, "tem mais", carregando mais, falha no "ver mais", total do filtro e contagens por tipo e categoria (nulas se falharem), com descarte de respostas velhas por número de requisição. A entrada usa um store pequeno, `LibraryIndexStore`, com as contagens por área e tipo.

O datasource ganha métodos **novos** para o site, sem mudar o `_fetchDocuments` que o painel usa: `fetchListing` (ordem por `createdAt` desc sem busca; com busca, intervalo e ordem pelo campo buscado; pede `limite + 1`) e `countListing` (mesma consulta com `.count()`). `countByType` e `countByCategory`, hoje sem uso, são corrigidos (comparar com `.value`) e passam a rodar as contagens em paralelo. O repositório expõe os quatro com `Either`.

Na tela, reaproveita do core: `PageHeader`, `Breadcrumbs`, `SearchField`, `StateMessageBox`, `StateErrorBox`, `Skeleton`, `SecondaryButton`, `ArrowLink`, `AppFocusRing`. Componentes novos de filtro (seletor compacto, campo de ano, botão com painel de categorias e chip removível) ficam no feature `library`, porque só a biblioteca usa; os campos do core (`AppDropdownField`, `AppMultiSelectField`, `AppTextField`) são do painel e não mudam.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/app/theme/app_dimensions/app_dimensions.dart` | Tokens da entrada (`areaTile*`: padding 24/36 por faixa, raio 20, ícone 52 e raio 14, gap 14, subida 3, vão da grade 20, padding da faixa 40/72) e da lista (`libraryFilter*`: altura 42, raio 10, padding 14/38, vão 10, topo 16; `libraryPanel*`: largura máx. 360, altura máx. 400, padding 10, raio 14; `libraryActiveRow*`: topo 14, vão 8; `libraryDoc*`: padding 22/16, raio 12, vão 8/24, etiqueta padding 2/8 raio 6, selo padding 4/10; `libraryPageSize` 20; `librarySkeletonRows` 5; `libraryYearFieldWidth` 96). Valores do protótipo (`.area-tile`, `.filters`, `.select`, `.btn-filter`, `.ms-panel`, `.active-row`, `.doc`, `.badge`, `.cat`) |
| Alterar | `lib/app/theme/app_typography/app_text_styles.dart` | `areaTileTitle` (Bricolage 800, 2,1 rem desktop, menor no celular), `libraryDocTitle` (Bricolage 650, 19,2, altura 1,3), `libraryFilter` (Figtree 600, 14,5), `libraryTag` (Figtree 500/700, 12,5) |
| Alterar | `lib/app/features/library/infra/datasources/library_datasource.dart` | Novos `fetchListing(LibraryListingQuery)` e `countListing(LibraryListingQuery)`; `LibraryListingQuery` (área, tipo, ano, categorias, campo e termo de busca, cursor, limite); `LibrarySearchField` (título, autor, instituição → `title`, `author`, `institution`); corrigir `countByType`/`countByCategory` (`.value`, `Future.wait`). `_fetchDocuments`, `_applyFilters` e `LibraryDocumentsQuery` não mudam |
| Alterar | `lib/app/features/library/infra/repositories/library_repository.dart` e `infra/errors/failures.dart` | `fetchListing`, `countListing`, `countByType`, `countByCategory` com `Either`; `CountLibraryFailure` |
| Criar | `lib/app/features/library/presentation/stores/library_index_store.dart` (+ `.g.dart`) | Contagens por área e tipo (`Map<DocumentArea, Map<DocumentType, int>>?`), status carregando/sucesso/erro |
| Criar | `lib/app/features/library/presentation/stores/library_listing_store.dart` (+ `.g.dart`) e `stores/states/library_listing_states.dart` | `LibraryListingStore`: `load(area)`, `setSearchField`, `search(text)` (trim, inicial maiúscula se tudo minúsculo), `setType`, `setYear`, `toggleCategory`, `clearCategories`, `removeFilter`, `clearAll`, `loadMore`, `retry`; status inicial/carregando/sucesso/vazio da área/sem resultado/erro; `total`, `typeCounts`, `categoryCounts`; derivados `hasFilters`, `visibleCategories` (alfabéticas, sem zeradas; todas sem contagem) |
| Alterar | `lib/app/features/library/library_setup.dart` | `registerFactory` dos dois stores novos (os antigos continuam) |
| Alterar (reescrever) | `lib/app/features/library/presentation/pages/library_page.dart` | `ReadingPageScaffold` + `PageHeader` + grade de `LibraryAreaTile`; sem `LibraryHeader`, `LibraryCollectionCard` e `PartnersSection` |
| Criar | `lib/app/features/library/presentation/components/index/library_area_tile.dart` | Cartão-link: `Semantics(link)` + `AppFocusRing` + `InkWell`, ícone, `h2`, descrição, números (esqueleto/ocultos), "Explorar [área]" com seta, hover com borda, sombra e subida (sem subida com `disableAnimations`) |
| Criar | `lib/app/features/library/presentation/pages/library_area_page.dart` | Página pública da área: `PageHeader` (migalhas com "Biblioteca" link) + `LibraryListing`; troca de área via `didUpdateWidget` → `store.load` |
| Criar | `lib/app/features/library/presentation/components/listing/library_listing.dart` | Observa o store: barra de busca, filtros, chips ativos, contagem (`liveRegion`), linhas, "Ver mais documentos" e estados |
| Criar | `lib/app/features/library/presentation/components/listing/library_search_bar.dart` | Seletor "Buscar em" + `SearchField` (texto de ajuda por campo); empilhado no celular |
| Criar | `lib/app/features/library/presentation/components/listing/library_filter_select.dart` | Seletor compacto (42 px) com `MenuAnchor` do Material: rótulo "Tipo: todos", opções com quantidade, foco e nome acessível; usado também pelo "Buscar em" |
| Criar | `lib/app/features/library/presentation/components/listing/library_year_field.dart` | Campo "Ano" (só dígitos, até 4), dispara com 4 dígitos ou vazio |
| Criar | `lib/app/features/library/presentation/components/listing/library_category_filter.dart` | Botão "Categoria" com selo + painel (`MenuAnchor`/`OverlayPortal`) com `CheckboxListTile` compactos, quantidades, "Selecione quantas quiser" e "Limpar"; Esc devolve o foco ao botão |
| Criar | `lib/app/features/library/presentation/components/listing/library_active_filters.dart` | Chips removíveis ("×" com nome "Remover filtro …") e "Limpar tudo" |
| Criar | `lib/app/features/library/presentation/components/listing/library_document_row.dart` | Linha-link do documento: título (3 linhas), detalhes, etiquetas (2 + "+N"), selo e seta; sem slug, sem link; layout em coluna abaixo de 560 px |
| Criar | `lib/app/features/library/presentation/components/listing/library_listing_skeleton.dart` | 5 linhas-esqueleto paradas com `Semantics(label: 'Carregando')` |
| Alterar | `lib/app/router/app_router.dart` | Só o builder de `libraryAreaPattern` passa a devolver `LibraryAreaPage`. Caminhos não mudam; `panelLibraryAreaPattern` continua com `LibraryListPage` |
| Apagar | `lib/app/features/library/presentation/components/library/library_header.dart` e `library_collection_card.dart` | Usados só pela entrada antiga (o painel tem o próprio `LibrarySection`) |
| Alterar | `docs/arquitetura.md` | Seção "Biblioteca": página pública separada da do painel, stores por página, consultas novas, contagens |
| Alterar (se preciso) | `docs/deploy-ambientes.md` | Índices que a lista ou a contagem pedirem, na seção "Índices do Firestore" |

## Decisões técnicas
- **Página pública nova em vez de remendar a `LibraryListPage`.** A página atual é do painel também (auth, criar, editar, excluir, `AppBar`). Separar a rota pública é a única forma de redesenhar sem mudar o painel.
- **Métodos novos no datasource.** O `_fetchDocuments` do painel ordena por `createdAt` mesmo com busca e devolve página vazia no fim; mudar isso mudaria o painel. Os novos reaproveitam só a ideia dos filtros; com busca, ordenam pelo campo buscado (o Firestore exige ordenar primeiro pelo campo do intervalo), como na 014.
- **Contagem com a mesma consulta da lista.** Na 014, `count()` sem a ordenação falhou em prod; aqui a contagem do total usa os mesmos filtros e ordem da lista. As contagens por tipo e categoria são só por área + igualdade/`arrayContains`, sem ordem.
- **Contagens em paralelo.** `countByType` e `countByCategory` faziam uma contagem por vez (18 em série); com `Future.wait` a entrada e o painel de categorias carregam mais rápido. Custo: 1 leitura por contagem (até 1000 itens).
- **"Tem mais" com `limite + 1`**, como na 014: nada de clique que traz página vazia.
- **Vazio da área** = primeira página sem filtros e sem busca vazia. Com filtros, vazio é "sem resultado".
- **Seletores com `MenuAnchor`/`MenuItemButton` do Material**: foco, teclado e semântica prontos, sem `GestureDetector`. Painel de categorias com `MenuAnchor` contendo caixas de seleção que não fecham o menu ao marcar (`closeOnActivate: false`).
- **Inicial maiúscula** no store, num ponto só (`search`), para valer nos três campos.
- **Componentes no feature `library`.** Só a biblioteca usa; se a busca geral (ideia futura) precisar, sobem para o core depois.

## Dependências e geração de código
- Sem pacote novo, sem asset novo.
- `fvm dart run build_runner build --delete-conflicting-outputs` depois de criar `LibraryIndexStore` e `LibraryListingStore`.
- `library_setup.dart`: fábricas dos stores novos.
- Rotas: nenhum caminho novo; só o builder de `libraryAreaPattern` troca de página.

## Riscos e cuidados
- **Índices.** Combinações como área + tipo + categorias + ano + ordem por data, ou com intervalo no título/autor/instituição, podem pedir índice composto que não existe. Na conferência, testar cada filtro sozinho e combinações comuns (tipo + categoria, tipo + busca, categoria + busca, ano + tipo) em prod só leitura; o que falhar deve cair no erro tratado e o índice vai para `docs/deploy-ambientes.md` (ressalva para a pessoa publicar). A spec não pôde conferir os dados antes: a leitura direta do Firebase foi bloqueada nesta sessão.
- **Painel.** Conferir no diff que `library_list_page.dart`, `filters.dart`, `library_document_card.dart`, `create_or_update_document_dialog.dart`, `library_store.dart`, `filter_documents_store.dart`, `_fetchDocuments`, `_applyFilters` e `LibraryDocumentsQuery` não mudaram, e que `/painel/biblioteca/:area` continua na `LibraryListPage`. Entrar no painel só com credenciais de teste; sem elas, fica "não conferido no app".
- **Detalhe do documento** (`LibraryDocumentDetailedPage`) usa o `LibraryStore` singleton; não muda. Conferir que a linha abre o detalhe certo e que voltar do detalhe leva à lista.
- **`PageHeader` e `SearchField` são compartilhados** (Manifesto, Nossa história, Pessoa, categoria, `/publicacoes`): não mudam; conferir uma tela de cada.
- **Painel de categorias no celular**: largura da tela menos margens e altura máxima com rolagem; conferir em 390 sem `overflow` e com teclado (Esc, Tab).
- **Dados de teste**: o Firebase dev pode não ter documentos na biblioteca; conferir em build `APP_ENV=prod` só leitura (como 014/015). Vazio da área, 21+ itens, sem slug, falha no "ver mais" e nas contagens podem exigir dados ou falhas injetados num build de debug não commitado.
- **Asserções de layout** (`Wrap` com seletores, `MenuAnchor` em `Row`) só aparecem em debug: abrir em debug.

## Como conferir
- `fvm dart format` nos `.dart` alterados e `fvm flutter analyze` numa cópia em caminho ASCII.
- `fvm flutter build web --release --dart-define=APP_ENV=prod`, servir `build/web` com fallback de SPA e abrir no navegador embutido em 390, 768 e 1280: `/biblioteca`, `/biblioteca/geografia`, `/biblioteca/historia`, `/biblioteca/xyz` (404), filtros e combinações, busca nos três campos, "Ver mais", estados.
- `fvm flutter run -d web-server` na cópia ASCII (debug) nas duas telas, sem `overflow` nem asserção no console.
- Manifesto, categoria e `/publicacoes` sem mudança visual.
