# Tarefas da 017. Biblioteca: detalhe do documento

Legenda: `- [ ]` a fazer, `- [x]` feita.

## Grupo A: diagnóstico
- [ ] **A1.** Reproduzir em prod só leitura (`fvm flutter build web --release --dart-define=APP_ENV=prod`, servido localmente) o documento de Geografia com o resumo no slug: abrir pela lista, anotar o endereço gerado e a causa do "Erro ao carregar a página" (endereço cortado, busca sem resultado, exceção no `fromJson` ou na consulta). Registrar a causa no plano ("Riscos e cuidados"); se exigir mudar o modelo, registrar ressalva na spec. Nada é escrito no banco. Arquivos: `plan.md`. Atende: critério 9.

## Grupo B: dados e endereço
- [ ] **B1.** `fetchDocumentById` no datasource (`null` se não existe ou se o id tem `/`; preenche `id`). `fetchDocumentByAddress` no repositório (slug e, sem resultado, id), com `LibraryDocumentNotFoundFailure` e `FetchLibraryFailure`. `fetchDocumentBySlug` intacto. Se A1 achar campo ilegível, o datasource o ignora antes do `fromJson`. Arquivos: `infra/datasources/library_datasource.dart`, `infra/repositories/library_repository.dart`, `infra/errors/failures.dart`. Atende: critérios 8, 9.
- [ ] **B2.** `libraryDocumentKey`: slug aparado e codificado, ou o id quando o slug tem espaço/quebra de linha, `/` ou mais de 200 caracteres; `null` sem os dois. Arquivo: `infra/models/library_document_address.dart`. Atende: critério 9.
- [ ] **B3.** `LibraryDocumentStore` (fábrica) com estados selados (inicial, carregando, sucesso, não encontrado, erro), `fetch(key)`, `retry()` e descarte de resposta velha; `build_runner`; registro no setup. Arquivos: `stores/library_document_store.dart` (+ `.g.dart`), `stores/states/library_document_states.dart`, `library_setup.dart`. Atende: critérios 6, 7, 8, 11.

## Grupo C: tema e componentes
- [ ] **C1.** Tokens e estilos do detalhe (coluna 920, selo/título, ficha, ação, visualizador, esqueleto) em `app_dimensions.dart` e `app_text_styles.dart` (`libraryDetailTitle`, `libraryFactValue`). Atende: critério 14.
- [ ] **C2.** Extrair `LibraryTypeBadge` e `LibraryCategoryTag` de `library_document_row.dart` para `components/library_labels.dart`, sem mudança visual; a linha passa a usar `libraryDocumentKey` no endereço. Conferir a lista da área igual e um slug comum com o mesmo endereço. Arquivos: `components/library_labels.dart`, `components/listing/library_document_row.dart`. Atende: critérios 2, 9.
- [ ] **C3.** `LibraryDocumentHeader`: selo, `h1` em cor de tinta, ficha (rótulos em caixa alta, campos vazios omitidos, pares lidos juntos, categorias com todas as etiquetas na largura toda, 1/2–3/4 colunas por largura) e "Abrir documento" (`PrimaryButton` com ícone externo, nome "Abrir documento em outra aba", some sem arquivo, largura toda no celular). Arquivo: `components/document/library_document_header.dart`. Atende: critérios 1, 2, 3, 12.
- [ ] **C4.** `LibraryDocumentPdfViewer`: caixa com barra ("Página 1" → "Página X de N"), "Página anterior"/"Próxima página" (`IconButton` + `AppFocusRing`, dica, desativados nas pontas), página na proporção da 1ª página até 560 px, região "Visualizador do documento", página anunciada ao mudar, sem animação com movimento reduzido; estados: folha "Carregando documento…", erro "Não foi possível exibir o documento" com "Tentar de novo", sem arquivo "Arquivo indisponível" sem requisição. Arquivo: `components/document/library_document_pdf_viewer.dart`. Atende: critérios 4, 5, 12.
- [ ] **C5.** `LibraryDocumentSkeleton`: selo, duas linhas de título, quatro pares da ficha e botão, parado, com rótulo "Carregando". Arquivo: `components/document/library_document_skeleton.dart`. Atende: critério 6.

## Grupo D: página e rota
- [ ] **D1.** Reescrever `LibraryDocumentDetailedPage` sobre o `ReadingPageScaffold`: moldura de 920 px, `Breadcrumbs` "Início › Biblioteca › [área do documento] › Documento", esqueleto, `PageNotFound` no não encontrado, `StateErrorBox` com `retry`, cabeçalho e visualizador no sucesso; `didUpdateWidget` ao trocar de endereço. Sem "Voltar", sem a data, sem "Baixar". Arquivo: `pages/library_document_detailed_page.dart`. Atende: critérios 1, 6, 7, 8, 10.
- [ ] **D2.** Builder de `libraryDocumentPattern` valida a área (`DocumentArea.fromRouteKey`; inválida → `PageNotFound`) e passa área e trecho à página. Caminho não muda. Arquivo: `router/app_router.dart`. Atende: critérios 8, 10.

## Grupo E: documentação e verificação do código
- [ ] **E1.** `docs/arquitetura.md`, seção "Biblioteca": detalhe com `LibraryDocumentStore`, endereço por slug ou id (`libraryDocumentKey`), visualizador; o `LibraryStore` fica só no painel. Atende: critério 11.
- [ ] **E2.** `fvm dart format` nos `.dart` alterados; `fvm flutter analyze` numa cópia em caminho ASCII sem problemas novos; `fvm flutter build web --release` sem erro; busca por cor, fonte e espaço soltos, `num_extension`, `GestureDetector` e rota solta nos arquivos novos; `git diff` sem mudança em `library_store.dart`, `library_list_page.dart`, `library_document_card.dart`, `filters.dart`, diálogo, `filter_documents_store.dart` e `fetchDocumentBySlug`. Atende: critérios 11, 14.

## Grupo F: conferência no app
- [ ] **F1.** Rodar o app: `fvm flutter build web --release --dart-define=APP_ENV=prod` (só leitura), servir `build/web` com fallback de SPA num servidor Python próprio e conferir no navegador embutido (ou Chrome sem janela via CDP) em **390, 768 e 1280 px**: detalhe de um documento comum de Geografia e de História (migalhas e seus links, selo, título, ficha, "Abrir documento" por clique e Enter abrindo outra aba, visualizador com páginas, botões nas pontas, teclado, ordem de Tab, foco visível); o documento com o resumo no slug aberto pela lista; endereço inexistente e `/biblioteca/xyz/documento/a` (404); área trocada na URL (documento com a área dele nas migalhas); documento sem arquivo, falha na página e falha do visualizador (injetados num build de **debug** não commitado); rolagem horizontal ausente; rodapé na base no estado de erro. Depois, `fvm flutter run -d web-server --web-port <porta>` na cópia ASCII (**debug**) nas mesmas larguras, sem `overflow` nem asserção no console. Conferir a lista da área (016) sem mudança visual. Painel: só com credenciais de teste; sem elas, "não conferido no app". Voltar o navegador ao preset desktop e parar os servidores. Atende: critérios 1 a 13.

## Critérios × tarefas
| Critério | Tarefas |
|---|---|
| 1 | C3, D1, F1 |
| 2 | C2, C3, F1 |
| 3 | C3, F1 |
| 4 | C4, F1 |
| 5 | C4, F1 |
| 6 | B3, C5, D1, F1 |
| 7 | B3, D1, F1 |
| 8 | B1, B3, D1, D2, F1 |
| 9 | A1, B1, B2, C2, F1 |
| 10 | D1, D2, F1 |
| 11 | B3, E1, E2, F1 |
| 12 | C3, C4, F1 |
| 13 | F1 |
| 14 | C1, E2 |
