# Tarefas da 016. Biblioteca: entrada por área e lista com filtros

Legenda: `- [ ]` a fazer, `- [x]` feita.

## Grupo A: dados
- [ ] **A1.** Datasource: `LibrarySearchField`, `LibraryListingQuery`, `fetchListing` (sem busca: `createdAt` desc; com busca: intervalo e ordem pelo campo; `limite + 1` e `hasMore` real) e `countListing` (mesma consulta, `.count()`); corrigir `countByType`/`countByCategory` (`.value`, `Future.wait`). Sem mexer em `_fetchDocuments`, `_applyFilters` e `LibraryDocumentsQuery`. Arquivo: `infra/datasources/library_datasource.dart`. Atende: critérios 9, 11, 15. Conferir: analyze limpo; diff sem mudança nos métodos do painel.
- [ ] **A2.** Repositório e falhas: `fetchListing`, `countListing`, `countByType`, `countByCategory` com `Either`; `CountLibraryFailure`. Arquivos: `infra/repositories/library_repository.dart`, `infra/errors/failures.dart`. Atende: critério 14.

## Grupo B: stores
- [ ] **B1.** `LibraryIndexStore` (contagens por área e tipo, status) e registro como fábrica. Arquivos: `stores/library_index_store.dart` (+ `.g.dart`), `library_setup.dart`. Atende: critérios 2, 12, 14.
- [ ] **B2.** `LibraryListingStore` e estados: filtros, busca (trim, inicial maiúscula se tudo minúsculo, troca de campo refaz), lista paginada de 20, "ver mais" com falha própria, total e contagens (nulos se falharem), vazio da área × sem resultado, `visibleCategories` (alfabéticas, sem zeradas, todas sem contagem), descarte de respostas velhas; registro como fábrica; `build_runner`. Arquivos: `stores/library_listing_store.dart` (+ `.g.dart`), `stores/states/library_listing_states.dart`, `library_setup.dart`. Atende: critérios 4, 5, 6, 7, 8, 9, 11, 13, 14.

## Grupo C: tema
- [ ] **C1.** Tokens e estilos de texto da entrada e da lista (valores do plano). Arquivos: `theme/app_dimensions/app_dimensions.dart`, `theme/app_typography/app_text_styles.dart`. Atende: critério 18.

## Grupo D: entrada
- [ ] **D1.** `LibraryAreaTile` (link, foco, ícone, `h2`, descrição, números com esqueleto e ocultos no erro, "Explorar [área]", hover sem subida com movimento reduzido). Arquivo: `components/index/library_area_tile.dart`. Atende: critérios 2, 12, 14, 16.
- [ ] **D2.** Reescrever `LibraryPage` (`ReadingPageScaffold`, `PageHeader` com migalhas e texto da spec, grade de 1/2 colunas); apagar `LibraryHeader` e `LibraryCollectionCard`. Arquivos: `pages/library_page.dart`, `components/library/*`. Atende: critérios 1, 2, 17.

## Grupo E: lista
- [ ] **E1.** `LibraryFilterSelect` (`MenuAnchor`, 42 px, rótulo com valor, opções com quantidade, nome acessível) e `LibraryYearField`. Arquivos: `components/listing/library_filter_select.dart`, `components/listing/library_year_field.dart`. Atende: critérios 5, 6, 16.
- [ ] **E2.** `LibrarySearchBar` ("Buscar em" + `SearchField` com ajuda por campo; empilhado no celular). Arquivo: `components/listing/library_search_bar.dart`. Atende: critério 4.
- [ ] **E3.** `LibraryCategoryFilter` (botão com selo e estado, painel com caixas e quantidades, "Selecione quantas quiser", "Limpar", foco na primeira caixa ao abrir, Esc devolve ao botão, fecha com clique fora e Tab, largura no celular). Arquivo: `components/listing/library_category_filter.dart`. Atende: critérios 7, 16.
- [ ] **E4.** `LibraryActiveFilters` (chips removíveis e "Limpar tudo"). Arquivo: `components/listing/library_active_filters.dart`. Atende: critério 8.
- [ ] **E5.** `LibraryDocumentRow` (link com nome "[título], [tipo], [detalhes]", 3 linhas, detalhes sem vazios, 2 etiquetas + "+N", selo e seta, hover, foco; sem slug sem link; coluna em tela estreita) e `LibraryListingSkeleton`. Arquivos: `components/listing/library_document_row.dart`, `components/listing/library_listing_skeleton.dart`. Atende: critérios 10, 12.
- [ ] **E6.** `LibraryListing` (busca, filtros, chips, contagem com `liveRegion`, linhas, "Ver mais documentos" com "Carregando…" e erro abaixo, estados de vazio da área, sem resultado com "Limpar filtros" e erro com "Tentar de novo"). Arquivo: `components/listing/library_listing.dart`. Atende: critérios 9, 11, 13, 14.
- [ ] **E7.** `LibraryAreaPage` (`PageHeader` com migalhas "Início › Biblioteca › [Área]" e texto da spec, `LibraryListing`, troca de área reinicia filtros) e rota pública `libraryAreaPattern` → `LibraryAreaPage` (painel continua em `LibraryListPage`). Arquivos: `pages/library_area_page.dart`, `router/app_router.dart`. Atende: critérios 3, 15.

## Grupo F: documentação
- [ ] **F1.** `docs/arquitetura.md`: seção "Biblioteca" (página pública × painel, stores por página, consultas e contagens). `docs/deploy-ambientes.md`: índices que faltarem (se a conferência achar). Atende: critério 18.

## Grupo G: conferência
- [ ] **G1.** Qualidade: `fvm dart format` nos `.dart` alterados e `fvm flutter analyze` na cópia ASCII, sem problemas novos; `grep` sem `num_extension`, `GestureDetector`, cor, fonte ou espaço soltos nos arquivos novos; rotas só por `AppRoutes`; diff sem mudança em `library_list_page.dart`, `filters.dart`, `library_document_card.dart`, `create_or_update_document_dialog.dart`, `library_store.dart`, `filter_documents_store.dart`, `_fetchDocuments`, `_applyFilters` e `LibraryDocumentsQuery`. Atende: critérios 15, 18.
- [ ] **G2.** Rodar o app: `fvm flutter build web --release --dart-define=APP_ENV=prod` (só leitura), servir `build/web` com fallback de SPA e conferir no navegador embutido em **390, 768 e 1280 px**: `/biblioteca` (cabeçalho, migalhas, números de cada área, cartão por clique e Enter, hover, foco); `/biblioteca/geografia` e `/biblioteca/historia` (migalhas e "Biblioteca" voltando à entrada; busca nos três campos, minúsculas, Enter, "Limpar"; tipo com números; ano com 4 dígitos e vazio; painel de categorias com números, ordem, seleção múltipla, "Limpar", Esc, clique fora, Tab; chips e "Limpar tudo"; contagem; linhas abrindo o detalhe; "Ver mais documentos" até acabar; combinações tipo + categoria, tipo + busca, categoria + busca, ano + tipo — o que pedir índice cai no erro tratado e vai para F1); `/biblioteca/xyz` (404); ordem de Tab; sem rolagem horizontal; rodapé na base. Estados de vazio da área, falha no "Ver mais", falha nas contagens e documento sem slug com dados ou falhas injetados num build de **debug** não commitado. Depois, `fvm flutter run -d web-server` na cópia ASCII (**debug**) em 390, 768 e 1280 nas duas telas, sem `overflow` nem asserção no console. Conferir sem mudança visual: Manifesto, uma categoria, `/publicacoes` e o detalhe do documento. Painel: só com credenciais de teste; sem elas, marcar "não conferido no app". Voltar o navegador ao preset desktop e parar os servidores. Atende: critérios 1 a 17.

## Ligação critério → tarefa
| Critério | Tarefas |
|---|---|
| 1 | D2, G2 |
| 2 | B1, D1, D2, G2 |
| 3 | E7, G2 |
| 4 | B2, E2, G2 |
| 5 | B2, E1, G2 |
| 6 | B2, E1, G2 |
| 7 | B2, E3, G2 |
| 8 | B2, E4, G2 |
| 9 | A1, B2, E6, G2 |
| 10 | E5, G2 |
| 11 | A1, B2, E6, G2 |
| 12 | B1, D1, E5, G2 |
| 13 | B2, E6, G2 |
| 14 | A2, B1, B2, D1, E6, G2 |
| 15 | A1, E7, G1, G2 |
| 16 | D1, E1, E3, G2 |
| 17 | D2, G2 |
| 18 | C1, F1, G1 |
