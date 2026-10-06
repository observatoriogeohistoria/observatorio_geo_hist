# Plano da 022. Tipos de post: podcast, música, evento e pesquisa

- **Spec:** [spec.md](spec.md)
- **Criado em:** 2026-10-06

## Abordagem
Os quatro tipos entram como mais casos do `workInfoOf` e passam pelo mesmo `WorkBody` da 021, como o plano dela previu. O `WorkInfo` ganha campos opcionais para o que só um tipo tem: capa quadrada (novo tipo de imagem), caixa de data, faixa "Ouvir", pílula de situação, fatos largos (Integrantes) e figura com legenda. O texto passa de um bloco para uma lista, por causa da letra da música. As cinco obras da 021 só são adaptadas à nova forma, sem mudança visual.

Peças novas pequenas ficam em `post/work/`: `WorkDateBox`, `WorkListenButton` e `WorkStatusPill`. A leitura da data do evento é uma função pura (`eventDayOf`), num arquivo próprio, sem tocar no modelo. A figura da pesquisa reaproveita o `PostCover` do artigo; o `FactSheet` ganha uma linha de fatos largos.

No fim, os quatro `*_content.dart`, o `article_content.dart` (sem uso), `SocialIcons` e `ViewQuill` são apagados, e a pasta `post_content/` some. `AppNetworkImage` e `ImageErrorContent` ficam (Home, `core`, painel).

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/app/theme/app_dimensions/app_dimensions.dart` | Tokens `workSquareAspect`, `workDate*`, `workListen*`, `workStatus*` |
| Alterar | `lib/app/theme/app_typography/app_text_styles.dart` | Estilos `workDateDay`, `workDateMonth`, `workListenTitle`, `workListenHost`, `workStatus` |
| Alterar | `lib/app/core/components/reading/fact_sheet.dart` | Parâmetro `wideFacts`: pares na largura toda, abaixo da grade, antes das etiquetas |
| Alterar | `lib/app/features/posts/presentation/components/post/post_cover.dart` | `semanticLabel` opcional para quando não há legenda (padrão continua o do artigo) |
| Criar | `lib/app/features/posts/presentation/components/post/work/event_day.dart` | `eventDayOf(String)` → dia e mês do início, ou nada; abreviações dos meses |
| Alterar | `lib/app/features/posts/presentation/components/post/work/work_info.dart` | Campos novos do `WorkInfo`, `texts` em lista, `WorkImageKind.square`, casos de podcast, música, evento e pesquisa |
| Criar | `lib/app/features/posts/presentation/components/post/work/work_extras.dart` | `WorkDateBox`, `WorkListenButton`, `WorkStatusPill` |
| Alterar | `lib/app/features/posts/presentation/components/post/work/work_image.dart` | `WorkCover` com proporção (2:3 ou 1:1) |
| Alterar | `lib/app/features/posts/presentation/components/post/work/work_body.dart` | Coluna ao lado (imagem ou caixa de data), título com pílula, faixa "Ouvir", fatos largos, figura após o compartilhar, vários textos |
| Alterar | `lib/app/features/posts/presentation/components/post/post_type_content.dart` | Os quatro tipos vão para o `WorkBody`; sai o comentário sobre o conteúdo antigo |
| Apagar | `lib/app/features/posts/presentation/components/post_content/` (`podcast`, `music`, `event`, `search`, `article` `_content.dart`) | Desenho antigo; `article_content.dart` sem uso |
| Apagar | `lib/app/features/posts/presentation/components/social_icons.dart` | Sem uso depois de apagar `article_content.dart` |
| Apagar | `lib/app/core/components/quill/view_quill.dart` | Sem uso depois da música e do artigo antigo |
| Alterar | `docs/arquitetura.md` | Página do post: os quatro tipos, peças novas, fim do `SocialIcons` e do `ViewQuill` |

## Decisões técnicas
- **Um layout, campos opcionais.** Alternativa: um widget por tipo. O plano da 021 já fixou o `WorkInfo` como ponto de extensão; quatro widgets repetiriam migalhas, bloco, compartilhar e texto.
- **`WorkInfo` novo:**
  - `image` aceita `WorkImageKind.square` (podcast, música), que usa o `WorkCover` com `workSquareAspect` (1) e o nome "Capa de …".
  - `date` (`EventDay(day, month)`): ocupa o lugar da imagem no `_WorkBlock`, com largura `workDateColumn` (110) no tablet e no desktop e acima dos dados no celular. Imagem e data não coexistem (evento não define `image`).
  - `listen` (`WorkListen(label, url, host)`): conta como ação para a regra de linha dupla da 021 (`joined` só quando não há ação nem faixa).
  - `status` (`WorkStatus(label, positive)`): pílula depois do título, num `Wrap` com o `h1` (o texto longo ocupa a linha e a pílula desce).
  - `wideFacts`: passado ao `FactSheet`; entra em `hasSheet`.
  - `figure` (`WorkFigure(url, caption)`): só com URL não vazia; `PostCover` com `semanticLabel: 'Imagem da pesquisa'` quando sem legenda, com margem `postCoverMarginTop`, dentro do `PostHeadFrame`, depois da linha de compartilhar.
  - `texts` (`List<WorkText>`): cada texto não vazio vira `ReadingSubtitle` + conteúdo na mesma `ReadingColumn`; todos vazios, só o espaço de baixo, como hoje.
- **Rótulos e textos:** os da tabela da spec. Evento: fatos `Data`, `Horário`, `Local`, `Cidade`, `Abrangência` (`scope.portuguese`); ação `_action('Mais informações', link)`. Pesquisa: `Coordenação`, `Pesquisador(a)`, `Orientação`, `Coorientação`, `Financiamento`; `wideFacts: [('Integrantes', members)]`; `status: WorkStatus(state.portuguese, positive: state == inProgress)`. Música: fato `Artista`; textos `Descrição` (simples) e `Letra` (rico). Podcast: texto `Descrição` (simples). `typeLabel` e `badge` vazio nos quatro (o `_WorkData` já omite selo vazio).
- **`eventDayOf`:** regex sem diferenciar maiúsculas no começo do texto: `(\d{1,2})\s*[º°o]?` seguido de `/(\d{1,2})` ou `\s+de\s+(nome do mês)`; nomes de mês com e sem acento ("março"/"marco"); dia de 1 a 31 e até o máximo do mês (29 em fevereiro); mês de 1 a 12. Retorna o mês abreviado ("jan" … "dez"); a caixa o mostra com `toUpperCase`. Fora disso, `null`.
- **Host da faixa:** `Uri.tryParse(link)?.host` sem `www.`; vazio quando o link não tem esquema ou não é URL, e a faixa mostra só o texto.
- **`WorkListenButton`:** `Material` + `InkWell` com borda `line`, fundo `surface`, raio `radii.r14`; círculo `accent` de `workListenPlay` (42) com `Icons.play_arrow_rounded` branco; título `workListenTitle` em `ink`, host `workListenHost` em `inkSecondary`; `Icons.open_in_new` em `inkSecondary`. `Semantics(button, label: 'Ouvir [título] em outra aba', excludeSemantics)`, foco visível do tema. Largura toda em todas as faixas (o protótipo a estica no bloco).
- **`WorkDateBox`:** `workDateBox` (100) quadrado, `accent`, raio `radii.r18`, dia em `workDateDay` (fonte de títulos, 2,6 rem) e mês em `workDateMonth` (14 px, caixa alta, espaçamento 0,1 em), texto `colors.white`. `ExcludeSemantics`.
- **`WorkStatusPill`:** em andamento `successSurface`/`success`; concluída com o desenho do `TypeBadge` (superfície, borda, `inkSecondary`). Padding 4/12, raio de pílula, estilo `workStatus` (13 px, peso 700).
- **`FactSheet.wideFacts`:** cada par numa linha da largura toda, com o mesmo `_Fact`; o texto mantém as quebras de linha. A biblioteca não passa o parâmetro e fica igual.
- **Limpeza:** `ViewQuill.isQuillContentEmpty` só é usado pelos arquivos apagados; o `flutter_quill` continua por `ReadingRichText` e pelo editor do painel, então o `pubspec.yaml` não muda.

## Dependências e geração de código
Nenhum pacote, asset, `build_runner`, rota ou registro em `*_setup.dart`.

## Riscos e cuidados
- **Obras da 021** mudam de forma no `WorkInfo` (`texts` em lista, `wideFacts`): conferir livro, filme, revista, documento e produção acadêmica sem mudança visual.
- **`PostCover` e `FactSheet`** são usados pelo artigo e pela biblioteca: conferir artigo (imagem e legenda) e detalhe do documento.
- **Apagar `ViewQuill` e `SocialIcons`:** `grep` antes de apagar; o analyze acusa o que sobrar.
- **Data do evento em texto livre:** formatos inesperados no prod devem cair em "sem caixa", nunca em erro; conferir os eventos reais e casos injetados.
- **Imagens de podcast e música** podem não ser quadradas: o recorte central pode cortar texto da arte; aceito na spec.
- **Firebase dev** só tem uma pesquisa: conferência com build `APP_ENV=prod` só leitura e casos injetados num build temporário fora do repositório.
- **`overflow`** só aparece em modo debug: rodar a conferência também com `flutter run -d web-server`.

## Como conferir
- `fvm dart format` nos `.dart` alterados; `fvm flutter analyze` numa cópia em caminho ASCII; `fvm flutter build web --release`.
- App em 390, 768 e 1280 px: um podcast, uma música, um evento e uma pesquisa reais; casos injetados (datas variadas, sem imagem e imagem quebrada, sem link, link sem esquema, letra não-delta e vazia, pesquisa concluída e sem ficha, integrantes longos, título longo); Tab e árvore semântica; obras da 021, artigo, biblioteca e Home sem mudança; modo debug sem `overflow`.
