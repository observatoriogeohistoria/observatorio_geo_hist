# Plano da 021. Tipos de post: livro, filme, revista, documento e produção acadêmica

- **Spec:** [spec.md](spec.md)
- **Criado em:** 2026-10-05

## Abordagem
Um único layout para as obras, `WorkBody`, alimentado por uma descrição neutra da obra (`WorkInfo`: tipo, selo, título, chamada, ficha, etiquetas, ação, imagem e texto). Um só arquivo (`work_info.dart`) traduz cada um dos cinco modelos para essa descrição, no mesmo espírito do `postCardInfo` da listagem. O `PostTypeContent` continua sendo o ponto único e passa a chamar `WorkBody` para os cinco tipos. A 022 só acrescenta casos ao `WorkInfo` (imagem de player, caixa de data, pílula de situação) sem mexer no layout.

As peças que já existem são reaproveitadas: `PostHeadFrame` e `ReadingColumn` (larguras do artigo), `PostShare` (013), `PostImagePlaceholder` (012), `ReadingRichText` e `ReadingSubtitle`. A ficha, o selo e as etiquetas da biblioteca saem da feature `library` para `core`, para o post usá-los sem importar outra feature; a biblioteca passa a importá-los de lá, sem mudança visual. O botão "Assistir" do vídeo da Home vai para `core` com nome acessível configurável, e o filme o usa sobre o cartaz.

As migalhas do artigo viram um widget do post (`PostBreadcrumbs`), usado pelo artigo e pelas obras. Os cinco `*_content.dart` antigos são apagados no fim.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Criar | `lib/app/core/components/reading/fact_sheet.dart` | `FactSheet` (ficha entre linhas, grade por largura, pares lidos juntos, linha larga de etiquetas opcional), movida do `_Facts` da biblioteca |
| Criar | `lib/app/core/components/chips/labels.dart` | `TypeBadge` e `CategoryTag`, movidos de `library_labels.dart` |
| Apagar | `lib/app/features/library/presentation/components/library_labels.dart` | Substituído pelo arquivo de `core` |
| Alterar | `lib/app/features/library/presentation/components/document/library_document_header.dart` | Usa `FactSheet` e `TypeBadge`; perde `_Facts` e `_Fact` |
| Alterar | `lib/app/features/library/presentation/components/listing/library_document_row.dart` | Importa `TypeBadge` e `CategoryTag` de `core` |
| Criar | `lib/app/core/components/buttons/play_pill_button.dart` | `PlayPillButton`, o `VideoPlayButton` da Home com `semanticLabel` e `onPressed` |
| Apagar | `lib/app/features/home/presentation/components/video/video_play_button.dart` | Movido para `core` |
| Alterar | `lib/app/features/home/presentation/components/video/presentation_video_section.dart` | Usa `PlayPillButton` com o nome acessível de hoje |
| Alterar | `lib/app/core/components/reading/reading_blocks.dart` | `ReadingPlainText` (parágrafos nas quebras de linha, sem vazios) |
| Alterar | `lib/app/core/components/reading/reading_rich_text.dart` | `ReadingRichText.isDelta(content)` para o fallback de texto simples |
| Criar | `lib/app/features/posts/presentation/components/post/post_breadcrumbs.dart` | Migalhas "Início › Área › Categoria › Tipo", compartilhadas |
| Alterar | `lib/app/features/posts/presentation/components/post/article_header.dart` | Usa `PostBreadcrumbs` |
| Criar | `lib/app/features/posts/presentation/components/post/work/work_info.dart` | `WorkInfo`, `WorkImage`, `WorkAction`, `WorkText` e `workInfoOf(PostModel)` para os cinco tipos |
| Criar | `lib/app/features/posts/presentation/components/post/work/work_body.dart` | Layout: migalhas, bloco (imagem + dados), linha de compartilhar, texto na coluna |
| Criar | `lib/app/features/posts/presentation/components/post/work/work_image.dart` | `WorkCover` (2:3, 180 px, sombra) e `WorkPoster` (16:9 com `PlayPillButton`), com placeholder |
| Alterar | `lib/app/features/posts/presentation/components/post/post_type_content.dart` | Cinco tipos passam para `WorkBody` |
| Apagar | `.../post_content/{book,film,magazine,document,academic_production}_content.dart` | Desenho antigo substituído |
| Alterar | `lib/app/theme/app_dimensions/app_dimensions.dart` | Tokens `work*`; tokens da ficha, do selo e das etiquetas com nome neutro |
| Alterar | `lib/app/theme/app_typography/app_text_styles.dart` | Estilos da ficha e das etiquetas com nome neutro; título da obra |
| Alterar | `docs/arquitetura.md` | Página do post (obras), `core` (ficha, selos, `PlayPillButton`), leitura (`ReadingPlainText`) |

## Decisões técnicas
- **Descrição neutra + um layout.** Alternativa: um widget por tipo. Cinco widgets repetiriam o mesmo arranjo e a 022 somaria mais quatro; o mapeamento num arquivo deixa as diferenças visíveis lado a lado (como `postCardInfo`).
- **Tokens com nome neutro.** `libraryFacts*`, `libraryFactLabelGap`, `libraryTag*`, `libraryBadge*` e os estilos `libraryFactValue`, `libraryTag` e `libraryDetailTitle` passam a `facts*`, `factLabelGap`, `tag*`, `badge*`, `factValue`, `tag` e `detailTitle`, com os mesmos valores. Componentes de `core` com token `library*` confundiriam. O título da obra usa `detailTitle` (28,8–44,8 px), menor que o do artigo, porque divide a largura com a capa.
- **Novos tokens:** `workCoverWidth` 180, `workCoverAspect` 2/3, `workPosterAspect` 16/9, `workBlockGap` por faixa (20/28/36, o `clamp(20px,4cqi,36px)` do protótipo), `workPosterFlex` 11 e `workDataFlex` 10 (1,1fr/1fr), `workShareMarginTop`, `workSharePaddingVertical` (os da linha de autoria do artigo, 26/18), `workCoverRadius` com raios assimétricos 6/12 (lombada do livro) a partir de `radii`. Sombra da capa: `shadows.soft`.
- **Arranjo:** celular empilha (capa alinhada à esquerda com 180 px; cartaz na largura); tablet e desktop em `Row` com a capa de largura fixa e os dados em `Expanded`, ou cartaz e dados em `Expanded` com os flex acima. A ficha decide as colunas pela própria largura (`LayoutBuilder` da biblioteca).
- **Ação:** `PrimaryButton.medium` com `trailingIcon: Icons.open_in_new`, `expand` no celular e `Semantics` "… em outra aba", como o "Abrir documento" da 017. No filme não há botão: o `PlayPillButton` fica centralizado num `Stack` sobre o cartaz.
- **Texto:** `WorkText` guarda título ("Sinopse" etc.), conteúdo e se é rico. Rico e `isDelta` → `ReadingRichText`; rico não-delta ou simples → `ReadingPlainText`. Vazio (`ReadingRichText.isEmpty` ou texto simples em branco) → nada. O `ReadingSubtitle` é o primeiro filho da coluna, com `paddingTop` da coluna descontando a margem de topo dele, para o vão ficar igual ao do artigo.
- **Palavras-chave:** `split(',')`, `trim`, sem vazios, em `FactSheet(tagsLabel: 'Palavras-chave', tags: …)`.
- **Ano:** `year > 0 ? '$year' : ''`; a ficha já omite valor vazio.
- **Imagem:** `FittedNetworkImage` com `fit: BoxFit.cover` em `AspectRatio` + `ClipRRect` sobre `colors.surface`, `errorBuilder` com `PostImagePlaceholder`; URL vazia mostra o placeholder direto (sem requisição). Nome acessível "Capa de …"/"Cartaz de …".
- **Esqueleto:** não muda (o tipo só se sabe com o post).

## Dependências e geração de código
Nenhum pacote, asset, `build_runner`, rota ou registro em `*_setup.dart`. Ícone de reproduzir já usado pelo vídeo da Home.

## Riscos e cuidados
- **Biblioteca e Home tocadas** pela mudança da ficha, dos selos e do botão "Assistir": conferir detalhe do documento, linhas da lista e o vídeo da Home nas três larguras (critério 14).
- **Renomear tokens** quebra o build se sobrar uso antigo: `grep` pelos nomes antigos antes do analyze.
- **Dados reais irregulares:** sinopse do filme e descrição do documento antigas podem não ser delta; anos 0; links vazios; imagens muito altas ou largas. Conferir com os posts de prod e com dados injetados.
- **Produção acadêmica** não existe em nenhum banco: conferir só por injeção num build temporário fora do repositório; sem isso, registrar como não conferida.
- **Firebase dev** só tem um post (pesquisa): a conferência dos tipos desta spec usa build `APP_ENV=prod`, só leitura. Nada é criado ou editado pelo painel.
- **`overflow`** só aparece em modo debug: rodar a conferência também com `flutter run -d web-server`.

## Como conferir
- `fvm dart format` nos `.dart` alterados; `fvm flutter analyze` numa cópia em caminho ASCII; `fvm flutter build web --release`.
- App em 390, 768 e 1280 px: um post de cada tipo (livro, filme, revista, documento em prod; produção acadêmica injetada), imagem ausente e com falha (injetadas), texto não-delta (injetado), Tab e leitor (árvore semântica), artigo e tipos da 022 sem mudança, biblioteca e vídeo da Home.
