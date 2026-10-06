# Tarefas da 022. Tipos de post: podcast, música, evento e pesquisa

Legenda: `- [ ]` a fazer, `- [x]` feita.

## Grupo A: peças compartilhadas
- [x] **A1.** Tokens e estilos do plano: `workSquareAspect`, `workDateBox`, `workDateColumn`, `workListen*` (padding 12/16, vão 14, `workListenPlay` 42), `workStatus*` (padding 4/12) e os estilos `workDateDay`, `workDateMonth`, `workListenTitle`, `workListenHost`, `workStatus`. Arquivos: `theme/app_dimensions/app_dimensions.dart`, `theme/app_typography/app_text_styles.dart`. Atende: critério 14. Os tokens podem entrar junto do primeiro uso (A2–B3), para o analyze não acusar nada sem uso. Entraram com podcast e música (`workSquareAspect`, `workListen*`) e com evento e pesquisa (`workDate*`, `workStatus*`); `workListenPlayIcon`, `workListenIcon` e `workDateMonthGap` somados para os ícones e o vão do mês.
- [x] **A2.** `FactSheet(wideFacts:)`: pares na largura toda abaixo da grade, mantendo quebras de linha, lidos em pares; sem o parâmetro, nada muda. Arquivo: `core/components/reading/fact_sheet.dart`. Atende: critérios 2, 13.
- [x] **A3.** `PostCover(semanticLabel:)` opcional para o nome sem legenda; artigo continua com "Imagem de capa do artigo". Arquivo: `post/post_cover.dart`. Atende: critérios 8, 11, 13.
- [x] **A4.** `eventDayOf(String)` com os formatos e validações do plano ("14/11/2026", "14/11", "14 de novembro de 2026", "1º de Janeiro…", "1 de marco", intervalo → primeira data; "32/13", "a definir", "" → nada). Arquivo: `post/work/event_day.dart`. Atende: critério 6. Conferir os exemplos num `dart run` descartável fora do repositório (não há `test/`). Conferido na cópia do scratchpad: todos os exemplos batem; "29/02" aceita, "30/02" e "5 a 7 de junho" ficam sem caixa.

## Grupo B: layout
- [x] **B1.** `WorkInfo`: `texts` em lista, `WorkImageKind.square`, `date`, `listen`, `status`, `wideFacts`, `figure`; `hasSheet` considera `wideFacts`; as cinco obras da 021 adaptadas sem mudança visual. Arquivos: `post/work/work_info.dart`, `post/work/work_body.dart` (só o necessário para compilar). Atende: critérios 2, 13. `WorkImageKind.square` entrou com podcast e música, onde passa a ter uso.
- [x] **B2.** `WorkDateBox`, `WorkListenButton` e `WorkStatusPill` conforme o plano (cores, nomes acessíveis, `InkWell` com foco visível, caixa de data decorativa); `WorkCover` com proporção. Arquivos: `post/work/work_extras.dart`, `post/work/work_image.dart`. Atende: critérios 3, 4, 6, 8, 11.
- [x] **B3.** `WorkBody`: coluna ao lado com imagem ou caixa de data (110 px no tablet/desktop, acima no celular); título `h1` num `Wrap` com a pílula; faixa "Ouvir" depois da ficha (conta como ação na regra da linha dupla); figura com `PostCover` depois do compartilhar; vários textos na `ReadingColumn`, cada um com seu subtítulo, pulando os vazios. Arquivo: `post/work/work_body.dart`. Atende: critérios 1, 3, 4, 5, 6, 7, 8, 9, 12.
- [x] **B4.** `workInfoOf` para podcast, música, evento e pesquisa (rótulos, textos, `eventDayOf`, host sem "www.", situação), `PostTypeContent` levando os quatro ao `WorkBody`; apagar `podcast_content.dart`, `music_content.dart`, `event_content.dart` e `search_content.dart`. Arquivos: `post/work/work_info.dart`, `post/post_type_content.dart`, `post_content/*`. Atende: critérios 1 a 8, 10, 14. `eventDayOf` passou a aceitar dias que dividem o mês ("06 a 10 de julho"), achados em três eventos do prod; ver o Histórico da spec.

## Grupo C: limpeza, documentação e verificação do código
- [x] **C1.** `grep` confirmando que nada importa `article_content.dart`, `social_icons.dart` e `view_quill.dart`; apagá-los (a pasta `post_content/` some). Arquivos: os três. Atende: critério 14.
- [x] **C2.** `docs/arquitetura.md`: os quatro tipos na "Página do post" (capa quadrada, caixa de data, faixa "Ouvir", pílula, figura, vários textos, `eventDayOf`), `FactSheet.wideFacts`, e tirar a menção ao `SocialIcons` sumir na Fase 7. Atende: critério 14.
- [x] **C3.** `fvm dart format` nos `.dart` alterados; `fvm flutter analyze` numa cópia em caminho ASCII sem problemas novos; `fvm flutter build web --release` sem erro; `grep` sem `num_extension`, cor/fonte/espaço soltos, `GestureDetector` e `AppNetworkImage` nos arquivos novos e alterados e sem `*_content.dart` em `features/posts/`; `git diff` sem mudança em modelos, `app_router.dart`, `app_routes.dart`, `pubspec.yaml`, regras do Firebase e painel. Atende: critério 14. Único `*_content.dart` que sobra é o `post_type_content.dart`, o despachante da 021, que não é conteúdo antigo e fica com o nome.

## Grupo D: conferência no app
- [ ] **D1.** Build `APP_ENV=prod` (só leitura), `build/web` servido com fallback de SPA num servidor Python próprio em segundo plano, navegador embutido ou Chrome sem janela por CDP, em **390, 768 e 1280 px**:
  - um **podcast, uma música, um evento e uma pesquisa** reais (achados pelos chips de tipo em `/publicacoes`): ordem da página, migalhas, `h1`, ficha, capa, faixa "Ouvir" e "Mais informações" abrindo em outra aba por clique e Enter, caixa de data, pílula, figura com legenda, subtítulos e textos, compartilhar, Apoio, Tab, árvore semântica (nomes, pares, "em outra aba", caixa de data fora), contraste e `scrollWidth` igual à largura;
  - num build temporário na cópia ASCII, com dados injetados no datasource fora do repositório (nunca commitados): datas "14/11/2026", "1º de janeiro de 2020 a 10 de janeiro de 2020", "32/13/2020" e "A definir"; capa vazia e URL quebrada; podcast sem link; link sem esquema; letra vazia e letra não-delta; evento sem horário e sem detalhes; pesquisa "Concluída", sem imagem, com imagem quebrada, sem nenhum campo de equipe e com integrantes longos em várias linhas; título longo com a pílula; erro de rede. Se a injeção não for possível, registrar esses casos como não conferidos;
  - esqueleto, 404 (id inexistente) e erro com o Firestore bloqueado num dos tipos;
  - sem mudança: um artigo, um livro, um filme, uma revista, um documento e uma produção acadêmica; detalhe e lista da biblioteca; Home (avatares e destaques).

  Depois, `fvm flutter run -d web-server --web-port <porta>` na cópia ASCII (**modo debug**) em 390, 768 e 1280 com ao menos os quatro tipos, sem `overflow` nem asserção no console. Nada é criado ou alterado pelo painel nem no Firestore; painel sem diff e sem credenciais de teste, "não conferido no app". Voltar o navegador ao preset desktop e parar os servidores. Atende: critérios 1 a 13.
- [ ] **D2.** Atualizar a spec: status `implementada`, "Histórico de mudanças" com divergências, ambiente e o que ficou sem conferir. Arquivo: `spec.md`. Atende: todos (registro).

## Critérios × tarefas
| Critério | Tarefas |
|---|---|
| 1. Estrutura e ordem da página | B3, B4, D1 |
| 2. Título e ficha por tipo, Integrantes | A2, B1, B4, D1 |
| 3. Capa quadrada com placeholder | B2, B3, B4, D1 |
| 4. Faixa "Ouvir" | B2, B3, B4, D1 |
| 5. Descrição e letra da música | B3, B4, D1 |
| 6. Caixa de data e "Data" na ficha | A4, B2, B3, B4, D1 |
| 7. "Mais informações" e "Detalhes" | B3, B4, D1 |
| 8. Pílula e figura da pesquisa | A3, B2, B3, B4, D1 |
| 9. Compartilhar | B3, D1 |
| 10. Esqueleto, 404 e erro | B4, D1 |
| 11. Acessibilidade | A3, B2, D1 |
| 12. Responsivo, debug sem `overflow` | B3, D1 |
| 13. Outros tipos, artigo, biblioteca e Home sem mudança | A2, A3, B1, D1 |
| 14. Tokens, limpeza, docs, analyze e build | A1, B4, C1, C2, C3 |
