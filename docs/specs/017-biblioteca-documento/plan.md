# Plano da 017. Biblioteca: detalhe do documento

- **Spec:** [spec.md](spec.md)
- **Criado em:** 2026-10-02

## Abordagem
A página `LibraryDocumentDetailedPage` é reescrita no lugar, sobre o `ReadingPageScaffold`, no padrão do `PostDetailedPage` (012): estados selados (inicial, carregando, sucesso, não encontrado, erro), esqueleto próprio, 404 com `PageNotFound` e `StateErrorBox` com "Tentar de novo". O estado sai do `LibraryStore` (singleton do painel, que não é tocado) para um store novo por página, `LibraryDocumentStore`, registrado como fábrica, com descarte de respostas velhas por número de requisição (como o `PostDetailStore`).

O conteúdo fica numa coluna de 920 px (`PostHeadFrame` serve de modelo, mas tem 820; a biblioteca ganha a própria moldura com token novo). De cima para baixo: `Breadcrumbs`, selo do tipo, `h1`, ficha, "Abrir documento" e o visualizador. Selo e etiqueta da linha da lista (016) saem de `library_document_row.dart` para um arquivo compartilhado do feature, para o detalhe usar os mesmos.

O visualizador é reescrito com o `pdfx` que já está no projeto: baixa os bytes com `http` (como hoje), abre o `PdfDocument`, lê a proporção da primeira página e dá à área da página essa proporção, com largura até 560 px; um `PdfView` com controlador mostra uma página por vez, e a barra usa `pageListenable`/`pagesCount`. Os estados (carregando, erro com "Tentar de novo", sem arquivo) ficam dentro da caixa, sem afetar a ficha.

Endereço robusto, sem mudar rota nem dados: uma função única monta o trecho do endereço do documento (slug codificado ou, se o slug não servir, o identificador). A linha da lista passa a usá-la. No detalhe, o repositório procura pelo slug e, sem resultado, lê `library/{trecho}` direto; nenhum dos dois devolve "não encontrado" (falha própria), distinto de falha de rede. A rota passa a validar a área (`DocumentArea.fromRouteKey`), como a da lista.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/app/theme/app_dimensions/app_dimensions.dart` | Tokens do detalhe: `libraryDetailMaxWidth` 920; `libraryDetailBadgeTop` 22, `libraryDetailTitleTop` 12; ficha (`libraryFactsTop` 24, `libraryFactsPaddingV` 20, vão 14/28, coluna mínima 170, vão rótulo/valor 2); `libraryDetailActionTop` 22; visualizador (`libraryViewerMarginTop` 32, `libraryViewerMarginBottom` 64 por faixa, raio 16, barra padding 8/14, botão 32, página máx. 560, largura relativa no celular 0,86, margem da folha 24, proporção A4 1,414); esqueleto do detalhe (alturas e larguras das barras). Valores do protótipo (aba "Documento") |
| Alterar | `lib/app/theme/app_typography/app_text_styles.dart` | `libraryDetailTitle` (Bricolage 800, 1,8 a 2,8 rem por faixa); `libraryFactValue` (Figtree 400, 16). Rótulo usa `label` existente; barra usa `small` |
| Alterar | `lib/app/features/library/infra/datasources/library_datasource.dart` | `fetchDocumentById(String id)` (`doc(id).get()`, `null` se não existe ou se o id tem `/`; inclui `id: doc.id`). `fetchDocumentBySlug` e o resto não mudam |
| Alterar | `lib/app/features/library/infra/repositories/library_repository.dart` e `infra/errors/failures.dart` | `fetchDocumentByAddress(String key)`: slug e, sem resultado, id; `LibraryDocumentNotFoundFailure` quando nenhum acha; `FetchLibraryFailure` para falhas. `fetchDocumentBySlug` (do `LibraryStore`) não muda |
| Criar | `lib/app/features/library/infra/models/library_document_address.dart` | `libraryDocumentKey(LibraryDocumentModel)`: slug aparado e codificado (`Uri.encodeComponent`) ou, se tiver espaço/quebra de linha, `/` ou mais de 200 caracteres, o id; `null` sem os dois. Extensão, sem tocar no modelo |
| Criar | `lib/app/features/library/presentation/stores/library_document_store.dart` (+ `.g.dart`) e `stores/states/library_document_states.dart` | `LibraryDocumentStore.fetch(key)`, `retry()`; estados selados; descarte de resposta velha |
| Alterar | `lib/app/features/library/library_setup.dart` | `registerFactory<LibraryDocumentStore>` (o `LibraryStore` continua) |
| Criar | `lib/app/features/library/presentation/components/library_labels.dart` | `LibraryTypeBadge` e `LibraryCategoryTag`, extraídos sem mudança visual de `library_document_row.dart` |
| Alterar | `lib/app/features/library/presentation/components/listing/library_document_row.dart` | Usa `libraryDocumentKey` para o endereço (sem chave, sem link, como hoje) e os componentes extraídos |
| Alterar (reescrever) | `lib/app/features/library/presentation/pages/library_document_detailed_page.dart` | Recebe `area` e `documentKey`; `ReadingPageScaffold`, estados, migalhas com a área do documento; `didUpdateWidget` refaz a busca ao trocar de endereço |
| Criar | `lib/app/features/library/presentation/components/document/library_document_header.dart` | Selo, `h1`, ficha (`Wrap`/grade por largura com pares lidos juntos), "Abrir documento" (`PrimaryButton` com ícone externo, `Semantics` "Abrir documento em outra aba", `openUrl`) |
| Criar | `lib/app/features/library/presentation/components/document/library_document_pdf_viewer.dart` | Visualizador novo: estados internos (carregando, pronto, erro, sem arquivo), barra com "Página X de N" e `IconButton`s do Material com `AppFocusRing`, região semântica, anúncio da página, proporção da 1ª página, sem animação com `disableAnimations` |
| Criar | `lib/app/features/library/presentation/components/document/library_document_skeleton.dart` | Esqueleto parado do selo, título, ficha e botão, com `Semantics(label: 'Carregando')` |
| Alterar | `lib/app/router/app_router.dart` | Builder de `libraryDocumentPattern` valida a área (inválida → `PageNotFound`) e passa `area` e `slug` à página. Caminho não muda |
| Manter | `components/document/library_document_content.dart`, `library_document_metadata.dart`, `library_document_viewer.dart` | Ficam sem uso, para a limpeza da Fase 7 (o painel não os usa) |
| Alterar | `docs/arquitetura.md` | Seção "Biblioteca": detalhe com store próprio, endereço por slug ou id, visualizador |

## Decisões técnicas
- **Store novo em vez do `LibraryStore`.** O `LibraryStore` é singleton e o painel depende dele (lista, criar, excluir); mudar `fetchDocumentBySlug` ou o estado mexeria no painel. Mesmo caminho da 016.
- **Busca por slug e depois por id no repositório**, num método novo. Assim o datasource fica com leituras simples e a regra de fallback num lugar só. A leitura por id é `doc(id).get()`: sem índice, 1 leitura. Um id com `/` faria o Firestore interpretar como caminho; o datasource devolve `null` nesse caso, sem chamar.
- **"Não encontrado" como falha própria** (`LibraryDocumentNotFoundFailure`), como a 012 fez com posts, para a página mostrar 404 só quando de fato não existe e a caixa de erro quando falhou.
- **Codificar o slug** com `Uri.encodeComponent`. Conferido no `go_router` 17.3.0: o casamento usa o caminho codificado e os parâmetros são decodificados (`Uri.decodeComponent` em `match.dart`), então `?`, `#`, `/` e `%` chegam inteiros. Slug comum (letras, números e hífen) não muda de forma, mantendo os endereços.
- **Limite de 200 caracteres e espaço como gatilho do id.** Além do caso de prod, evita a igualdade em strings acima de 1.500 bytes, que o Firestore só compara pelo começo.
- **Área da URL só valida, não filtra.** O documento é buscado pelo trecho; as migalhas usam `document.area`. Assim links antigos com área errada continuam abrindo.
- **Visualizador com `PdfView` simples e altura calculada.** O `PdfView` precisa de altura definida; a altura sai da largura × proporção da 1ª página (lida com `getPage(1)` antes de fechar a página), com A4 como reserva. `physics: NeverScrollableScrollPhysics` (como hoje), para a rolagem da página do site não virar troca de página; a troca é só pelos botões (`animateToPage` ou `jumpToPage` com movimento reduzido).
- **Sem `Baixar`.** O `FileSaver` e o `fetchUrl` deixam de ser usados pelo site; o pacote fica (limpeza da Fase 7).
- **Componentes antigos do detalhe ficam no repositório** sem uso, como a 016 manteve o que a Fase 7 limpa; não são usados pelo painel.

## Dependências e geração de código
- Sem pacote novo, sem asset novo (`pdfx`, `http` e `url_launcher` já estão).
- `fvm dart run build_runner build --delete-conflicting-outputs` depois de criar o `LibraryDocumentStore`.
- `library_setup.dart`: fábrica do store novo.
- Rotas: nenhum caminho novo; o builder de `libraryDocumentPattern` passa a validar a área.

## Riscos e cuidados
- **Causa do erro do documento de prod.** A spec deduz que o corte do endereço por `?`, `#` ou `/` impede a busca; pode haver outra causa (ex.: valor que o `fromJson` não lê, como data fora do formato). A primeira tarefa reproduz o caso em prod só leitura e registra a causa; se for o `fromJson`, o tratamento fica no datasource (ignorar o campo ilegível) sem mudar o modelo, ou vira ressalva se exigir mudar o modelo.
  - **Causa conferida (2026-10-02, prod só leitura).** São 12 documentos (8 de Geografia, 4 de História), não um: todos têm o resumo no slug (385 a 923 bytes), com espaços, e **terminam com espaço**. A linha da lista apara o slug (`trim`) ao montar o endereço, então a busca por igualdade não acha nada, mesmo sem `/` no texto (reproduzido com "O lugar do ensino de Geografia…", sem `/`). Em 5 deles há também `/` (ex.: "Uberlândia/MG"), que quebra a rota. Não há `?`, `#` nem `%`; `createdAt` e os demais campos são lidos pelo `fromJson` sem erro. O critério do identificador (slug com espaço) cobre os 12; a verificação de espaço é feita no slug cru, antes de aparar. Nada muda no modelo.
- **CORS do Storage.** O visualizador baixa o PDF pelo navegador; já funciona hoje com o mesmo `http.get`. Conferir em prod.
- **PDF grande.** 300+ páginas baixam o arquivo inteiro antes da primeira página, como hoje; o estado "Carregando documento…" cobre a espera.
- **Linha da lista (016).** A troca do endereço não pode mudar os endereços de slugs comuns: conferir que um documento comum abre com o mesmo endereço de antes e que voltar leva à lista.
- **Painel.** Conferir no diff que `library_store.dart`, `library_list_page.dart`, `library_document_card.dart`, `filters.dart`, o diálogo, `filter_documents_store.dart` e `fetchDocumentBySlug` não mudaram. O card do painel continua indo ao detalhe com o slug cru; o detalhe novo trata como antes (slug) e mostra 404 em vez de erro quando o endereço cortado não acha nada. Painel no app só com credenciais de teste.
- **Componentes compartilhados** (`Breadcrumbs`, `StateErrorBox`, `ReadingPageScaffold`, `PrimaryButton`, `PageNotFound`) não mudam. A extração de selo e etiqueta muda a lista da 016: conferir a lista sem mudança visual.
- **Asserções de layout** (ficha em `Wrap`/grade, `PdfView` com altura) só aparecem em debug: abrir em debug.

## Como conferir
- `fvm dart format` nos `.dart` alterados e `fvm flutter analyze` numa cópia em caminho ASCII.
- `fvm flutter build web --release --dart-define=APP_ENV=prod` (só leitura), servir `build/web` com fallback de SPA e abrir em 390, 768 e 1280: detalhe de um documento comum (Geografia e História), o documento com o resumo no slug (a partir da lista), endereço inexistente, área inválida, área trocada, documento sem arquivo e falhas (injetadas num build de debug não commitado).
- `fvm flutter run -d web-server` na cópia ASCII (debug), sem `overflow` nem asserção no console.
- Lista da área (016) sem mudança visual.
