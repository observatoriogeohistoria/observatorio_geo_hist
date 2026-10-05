# Tarefas da 021. Tipos de post: livro, filme, revista, documento e produção acadêmica

Legenda: `- [ ]` a fazer, `- [x]` feita.

## Grupo A: peças compartilhadas
- [ ] **A1.** Renomear tokens e estilos da ficha, do selo, das etiquetas e do título do detalhe para nomes neutros (`facts*`, `factLabelGap`, `tag*`, `badge*`, `factValue`, `tag`, `detailTitle`), mesmos valores, e atualizar todos os usos; criar os tokens `work*` do plano. Arquivos: `theme/app_dimensions/app_dimensions.dart`, `theme/app_typography/app_text_styles.dart`, arquivos da biblioteca que os usam. Atende: critérios 14, 15.
- [ ] **A2.** Mover `LibraryTypeBadge`/`LibraryCategoryTag` para `core/components/chips/labels.dart` (`TypeBadge`, `CategoryTag`) e a ficha (`_Facts`/`_Fact`) para `core/components/reading/fact_sheet.dart` (`FactSheet(facts:, tagsLabel:, tags:)`, linha de etiquetas larga opcional, sem nada quando vazia); biblioteca passa a usá-los; apagar `library_labels.dart`. Arquivos: `core/components/chips/labels.dart`, `core/components/reading/fact_sheet.dart`, `library_document_header.dart`, `library_document_row.dart`. Atende: critérios 3, 4, 14.
- [ ] **A3.** Mover `VideoPlayButton` para `core/components/buttons/play_pill_button.dart` (`PlayPillButton`, com `semanticLabel`); vídeo da Home usa-o com o nome de hoje. Arquivos: `play_pill_button.dart`, `presentation_video_section.dart`, apagar `video_play_button.dart`. Atende: critérios 5, 14.
- [ ] **A4.** `ReadingPlainText` (parágrafos nas quebras de linha, sem vazios) e `ReadingRichText.isDelta`. Arquivos: `core/components/reading/reading_blocks.dart`, `core/components/reading/reading_rich_text.dart`. Atende: critério 8.
- [ ] **A5.** `PostBreadcrumbs(area:, category:, typeLabel:)` e `ArticleHeader` usando-o, sem mudança no artigo. Arquivos: `post/post_breadcrumbs.dart`, `post/article_header.dart`. Atende: critérios 1, 13.

## Grupo B: layout das obras
- [ ] **B1.** `WorkInfo` e partes (`WorkImage` capa/cartaz/nenhuma, `WorkAction`, `WorkText`) e `workInfoOf` para livro, filme, revista, documento e produção acadêmica, com os rótulos, textos dos botões e subtítulos da tabela da spec; ano > 0; palavras-chave nas vírgulas. Arquivo: `post/work/work_info.dart`. Atende: critérios 2, 3, 4, 5, 8.
- [ ] **B2.** `WorkCover` (2:3, 180 px, raios 6/12, `shadows.soft`) e `WorkPoster` (16:9 com `PlayPillButton` "Assistir a [título] em outra aba" quando há link), `cover` sobre `surface`, placeholder sem URL e na falha, nomes "Capa de …"/"Cartaz de …". Arquivo: `post/work/work_image.dart`. Atende: critérios 5, 6, 7, 11.
- [ ] **B3.** `WorkBody`: `PostHeadFrame` com migalhas, bloco (empilhado no celular; capa fixa + dados ou cartaz + dados em flex no tablet/desktop), selo, `h1` com `detailTitle`, chamada com `postSubtitle`, `FactSheet`, `PrimaryButton.medium` (largura toda no celular, `Semantics` "… em outra aba"), linha de `PostShare` entre linhas finas; `ReadingColumn` com `ReadingSubtitle` + texto rico/simples (nada se vazio). Arquivo: `post/work/work_body.dart`. Atende: critérios 1, 2, 5, 8, 9, 11, 12.
- [ ] **B4.** `PostTypeContent` com `WorkBody(info: workInfoOf(post), …)` para os cinco tipos; apagar os cinco `*_content.dart` antigos e conferir por `grep` que nada mais os importa. Arquivos: `post/post_type_content.dart`, `post_content/{book,film,magazine,document,academic_production}_content.dart`. Atende: critérios 1, 10, 13, 15.

## Grupo C: documentação e verificação do código
- [ ] **C1.** `docs/arquitetura.md`: obras na "Página do post" (`WorkBody`, `workInfoOf`, o que a 022 acrescenta), `FactSheet`, `TypeBadge`/`CategoryTag` e `PlayPillButton` em `core`, `ReadingPlainText` nas páginas de leitura. Atende: critério 15.
- [ ] **C2.** `fvm dart format` nos `.dart` alterados; `fvm flutter analyze` numa cópia em caminho ASCII sem problemas novos; `fvm flutter build web --release` sem erro; `grep` sem nomes de tokens antigos, sem `num_extension`, cor/fonte/espaço soltos, `GestureDetector` e `AppNetworkImage` nos arquivos novos e alterados; `git diff` sem mudança em modelos, `app_router.dart`, `app_routes.dart`, `pubspec.yaml`, regras do Firebase e painel. Atende: critério 15.

## Grupo D: conferência no app
- [ ] **D1.** Build `APP_ENV=prod` (só leitura; o dev só tem um post de pesquisa), `build/web` servido com fallback de SPA num servidor Python próprio, navegador embutido (ou Chrome headless por CDP), em **390, 768 e 1280 px**:
  - um **livro, filme, revista e documento** reais (achados pelos chips de tipo em `/publicacoes`): ordem da página, migalhas (clique e Enter), selo, `h1`, chamada da revista, ficha, botão/"Assistir" abrindo em outra aba por clique e Enter, compartilhar, subtítulo e texto, Apoio, Tab, árvore semântica (nomes de imagem, pares da ficha, "em outra aba"), contraste e `scrollWidth` igual à largura;
  - num build temporário na cópia ASCII, com dados injetados fora do repositório (nunca commitados): **produção acadêmica** (ficha completa, palavras-chave com vírgulas sobrando e termo longo), imagem vazia e com URL quebrada (capa e cartaz), link vazio, ano 0, sinopse de filme não-delta, texto simples com várias linhas, título e categoria longos. Se a injeção não for possível, registrar esses casos como não conferidos;
  - esqueleto, 404 (id inexistente) e erro com o Firestore bloqueado num dos tipos;
  - sem mudança: um artigo, um podcast, uma música, um evento e a pesquisa do dev; detalhe e lista da biblioteca; vídeo da Home.

  Depois, `fvm flutter run -d web-server --web-port <porta>` na cópia ASCII (**modo debug**) em 390, 768 e 1280 com ao menos livro e filme, sem `overflow` nem asserção no console. Painel: sem diff e sem credenciais de teste, "não conferido no app". Nenhum conteúdo criado ou alterado pelo painel. Voltar o navegador ao preset desktop e parar os servidores. Atende: critérios 1 a 14.
- [ ] **D2.** Atualizar a spec: status `implementada`, "Histórico de mudanças" com divergências, ambiente e o que ficou sem conferir. Arquivo: `spec.md`. Atende: todos (registro).

## Critérios × tarefas
| Critério | Tarefas |
|---|---|
| 1. Estrutura e ordem da página | A5, B3, B4, D1 |
| 2. Selo, título `h1`, chamada | B1, B3, D1 |
| 3. Ficha por tipo | A2, B1, D1 |
| 4. Palavras-chave | A2, B1, D1 |
| 5. Ação principal e "Assistir" | A3, B1, B2, B3, D1 |
| 6. Capa e cartaz com proporção fixa | B2, D1 |
| 7. Placeholder sem imagem e na falha | B2, D1 |
| 8. Texto rico, não-delta e simples | A4, B1, B3, D1 |
| 9. Compartilhar | B3, D1 |
| 10. Esqueleto, 404 e erro | B4, D1 |
| 11. Acessibilidade | B2, B3, D1 |
| 12. Responsivo, debug sem `overflow` | B3, D1 |
| 13. Outros tipos e artigo sem mudança | A5, B4, D1 |
| 14. Biblioteca e Home sem mudança | A1, A2, A3, D1 |
| 15. Tokens, limpeza, docs, analyze e build | A1, B4, C1, C2 |
