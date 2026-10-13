# Plano da 031. Listas do painel em linhas, mídias em grade e filtros em linha

- **Spec:** spec.md
- **Criado em:** 2026-10-13

## Abordagem
As seis seções passam a montar o miolo com peças comuns em `admin/panel/presentation/components/list/`: caixa da lista (`PanelList`), linha (`PanelListRow`, que vira cartão abaixo de 600), miniatura, avatar e ícone à esquerda, rodapé, barra de filtros, controle segmentado, botão de alternar, esqueleto e caixas de estado. Os cartões de hoje (`cards/*`, `posts_cards/*`) e a `SectionHeaderActions` saem.

A `CrudSection` continua sendo a base de Categorias, Equipe, Usuários e Mídias, mas passa a cuidar dos estados (esqueleto, vazio com botão de criar, filtro sem resultado, erro com "Tentar de novo"), da barra de filtros opcional e do rodapé; o desenho do item (linha ou grade) vem de quem a usa. Categorias e Mídias filtram na tela, sobre `store.items`. Publicações e Biblioteca têm stores próprios e paginam no Firestore; montam as mesmas peças sem a `CrudSection`.

A Biblioteca sai da `LibraryListPage` (barra laranja, painel de filtros, "Aplicar") e passa a ser a própria `LibrarySection`, dentro da moldura da 030. A rota `/admin/painel/biblioteca/:area` passa a montar a `PanelPage` com a área. As duas rotas do painel ganham a mesma chave de página, para a moldura não ser recriada ao trocar de seção ou de área (o `didUpdateWidget` da `PanelPage` já trata a troca). Os filtros reaproveitam peças do site público: `SearchField`, `LibraryFilterSelect`, `LibraryCategoryFilter` e `LibraryYearField`.

Os stores de publicações e biblioteca passam a descartar respostas antigas: com filtros que aplicam ao mudar, uma resposta lenta não pode sobrescrever a do filtro mais novo. Nenhuma consulta, modelo ou regra muda.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | lib/app/theme/app_dimensions/app_dimensions.dart | Tokens de linha, miniatura, avatar, barra de filtros, controles de 42, grade de mídias, rodapé, esqueleto; sai `panelFiltersWidth`, `panelLibraryDocIcon` e os de cartão que ficarem sem uso |
| Alterar | lib/app/theme/app_colors/app_colors.dart | `rowHover` (fundo da linha ao passar o mouse) |
| Alterar | lib/app/theme/app_typography/app_text_styles.dart | `panelRowTitle`, `panelRowMeta`, `panelTileName`, `panelListFoot`, `panelSegment` |
| Alterar | lib/app/core/components/chips/labels.dart | `StatusTone.neutral` e ícone opcional no `StatusBadge` |
| Alterar | lib/app/core/components/buttons/app_icon_button.dart | `isToggled` (estado de pressionado no leitor) |
| Alterar | lib/app/core/components/field/search_field.dart | Altura opcional (42 no painel; o site continua com 48) |
| Criar | lib/app/features/admin/panel/presentation/components/list/panel_list.dart | Caixa branca com linhas separadas e rodapé |
| Criar | .../list/panel_list_row.dart | Linha de quatro partes; cartão abaixo de 600; grupo semântico com o título |
| Criar | .../list/panel_list_footer.dart | "Limpar filtros", "Carregar mais", indicador de mais itens |
| Criar | .../list/panel_row_leading.dart | `PanelThumbnail` (16:10, "Sem imagem"), `PanelAvatar` (foto ou iniciais), `PanelLeadIcon` |
| Criar | .../list/panel_filter_bar.dart | Caixa branca em `Wrap`; busca ocupa a linha abaixo de 600 |
| Criar | .../list/panel_segmented_control.dart | Segmentado com estado de pressionado |
| Criar | .../list/panel_toggle_chip.dart | Botão "Destaques" que liga e desliga |
| Criar | .../list/panel_list_skeleton.dart | 4 linhas-esqueleto ou blocos da grade |
| Criar | .../list/panel_list_states.dart | Vazio, filtro sem resultado e erro sobre o `StateMessageBox` |
| Alterar | .../sections/panel_action.dart | Erro ao abrir a lista não vira aviso flutuante (só a caixa) |
| Alterar | .../sections/crud_section.dart | Estados, filtros, rodapé e corpo por `bodyBuilder` |
| Criar | .../sections/category_row.dart, team_member_row.dart, user_row.dart | Linhas de cada seção |
| Alterar | .../sections/categories_section.dart, team_section.dart, users_section.dart | Linhas, filtros de categorias, estados vazios |
| Criar | .../sections/media_tile.dart | Bloco da grade |
| Alterar | .../sections/media_section.dart | Grade, busca, nota de carregamento |
| Alterar | lib/app/features/admin/panel/presentation/stores/media_store.dart (+ `.g.dart`) | `hasMore` público para a nota e para carregar mais quando a grade não rola |
| Criar | .../sections/post_row.dart, post_row_meta.dart | Linha de publicação; meta e imagem por tipo |
| Criar | .../sections/posts_filter_bar.dart | Filtros de publicações |
| Alterar | .../sections/posts_section.dart | Lista, estados, rodapé, foco mantido |
| Alterar | lib/app/features/admin/panel/presentation/stores/posts_store.dart (+ `.g.dart`) | Descarta resposta antiga; `hasMore(type)` |
| Criar | .../sections/library_filter_bar.dart, library_row.dart | Filtros e linha da biblioteca |
| Alterar | .../sections/library_section.dart | Lista da área dentro da moldura, cabeçalho com "Novo documento" |
| Alterar | lib/app/features/library/presentation/stores/library_store.dart (+ `.g.dart`) | Descarta resposta antiga |
| Alterar | lib/app/features/admin/panel/presentation/pages/panel_page.dart | Recebe `libraryArea` |
| Alterar | lib/app/router/app_router.dart | Rotas do painel com chave de página comum; área da biblioteca abre a `PanelPage` |
| Apagar | components/cards/*.dart, components/cards/posts_cards/*.dart, components/section_header_actions.dart, sections/empty_list_message.dart | Substituídos |
| Apagar | lib/app/features/library/presentation/pages/library_list_page.dart, components/filters.dart, components/document/library_document_card.dart | Biblioteca dentro do painel |
| Alterar | docs/arquitetura-painel-admin.md | Peças de lista, estados, biblioteca no painel |

(`...` = `lib/app/features/admin/panel/presentation/components`.)

## Decisões técnicas
- **Linha:** `Row` de quatro partes a partir de 600; abaixo, `Column` com miniatura e título lado a lado, selos abaixo do título e ações numa faixa com borda tracejada (`CustomPaint` com token de traço). Sem `IntrinsicHeight`. Fundo `rowHover` por `InkWell`/`MouseRegion` só decorativo: a linha não é clicável (as ações são os botões). Cada linha é `Semantics(container: true, label: título)`, para o leitor saber de que item são as ações; os botões mantêm o nome curto da 030.
- **Ícones das ações:** cor `inkSecondary` (≥ 4,5:1), excluir em `error`; destacar com `Icons.star`/`star_border` e `isToggled`. Botão sem permissão: a coluna de ações não é montada.
- **Miniatura:** `AspectRatio` + `FittedNetworkImage` com `cover`; sem URL ou com falha, fundo `accentSoft`, ícone de imagem e `Semantics(label: 'Sem imagem')`; com imagem, `ExcludeSemantics` (decorativa, o título está ao lado).
- **Avatar:** `PanelAvatar` circular com iniciais (`initialsOf`) por baixo da foto; falha da foto mostra as iniciais. Cor única (`accentSoft`/`accentStrong`), sem a paleta variada do protótipo, para não criar cores soltas.
- **Selos:** `StatusBadge` com tom novo `neutral` (fundo `surface`, borda `line`, texto `inkSecondary`) para "Não publicado", "Sem página", "Edição", "Leitura" e tipo do documento; `accent` com estrela para "Destaque" e "Administração"; `success` para "Publicado", "Com página", "Aceita colaboração"; `error` para "Removido".
- **Meta das publicações (`post_row_meta.dart`):** "Área · Categoria" e, quando o tipo tem: artigo (autores, data), livro (autor, ano), produção acadêmica (autor, ano e cidade), filme (direção, ano), música (artista), evento (data), pesquisa (coordenação). Documento, revista e podcast ficam só com área e categoria. Partes vazias somem.
- **Filtros de publicações:** área e categoria em `LibraryFilterSelect` (altura 42), com "Todas as áreas"/"Todas as categorias" como primeira opção; categorias vêm do `CategoriesStore` filtradas pela área; trocar a área limpa a categoria. Situação no segmentado (`null`/`true`/`false` em `isPublished`); "Destaques" manda `isHighlighted: true` ou `null`. Busca no `SearchField` (já espera parar de digitar).
- **Respostas antigas:** `PostsStore.getPosts` e `LibraryStore.fetchDocumentsByArea` guardam um número de pedido; mudar filtro durante um carregamento dispara outro pedido e a resposta anterior é ignorada. Carregar mais sem mudar filtro continua bloqueado durante um carregamento. Só campos privados e anotações já existentes: `build_runner` só para conferir.
- **Erro ao abrir:** a seção marca o pedido da primeira página (`CrudLoadingState` sem `isRefreshing`, ou `fetchState` da biblioteca); erro depois dele mostra a caixa de erro no lugar da lista e `showPanelActionResult` não mostra aviso (sem ação pendente). `Forbidden` continua saindo do painel.
- **Biblioteca:** o segmentado chama `go(AppRoutes.panelLibraryArea(area.routeKey))`; com a chave de página comum, a `PanelPage` só recebe a área nova e o foco fica no botão. Filtros no `FilterDocumentsStore` (já singleton); aplicam ao mudar, sem "Aplicar". "Mais filtros" mostra numa segunda linha autor e instituição (`SearchField`) e ano (`LibraryYearField`). O formulário de documento continua o diálogo atual (032 troca), com a área aberta.
- **Rodapé:** "Limpar filtros" quando há filtro ativo e a lista tem itens; "Carregar mais" (biblioteca) enquanto houver mais; indicador linear ao carregar mais (publicações e mídias, que carregam ao rolar). Sem o "N de M" do protótipo: com paginação no servidor o total filtrado não é conhecido.
- **Grade de mídias:** `GridView` com `SliverGridDelegateWithMaxCrossAxisExtent` não serve (fixa largura máxima); usar `LayoutBuilder` que calcula colunas por largura mínima de bloco (token 170), com 2 colunas abaixo de 600. Nome com `TextOverflow.ellipsis` e `Tooltip` com o nome completo. Se a primeira página não enche a tela e há mais, carrega a próxima após o quadro.
- **Placeholder da busca da biblioteca:** "Buscar por título" (spec), não o do protótipo, que busca em três campos (fora do escopo).

## Dependências e geração de código
- Nenhum pacote novo, nenhum asset.
- `build_runner` depois de mexer em `MediaStore`, `PostsStore` e `LibraryStore`.
- `app_router.dart`: as rotas `panelTabPattern` e `panelLibraryAreaPattern` passam a usar `pageBuilder` com a mesma `ValueKey`; caminhos e `AppRoutes` iguais.
- Sem registro novo nos `*_setup.dart`.

## Riscos e cuidados
- **Chave de página comum:** muda a troca de seção para atualização no lugar (sem transição). Conferir troca de seção, de tipo e de área, gaveta, foco no título e voltar do navegador. Se causar regressão, voltar à página recriada e levar o foco ao segmentado depois da troca.
- **Índices do Firestore:** combinações de filtros de publicações (área + categoria + situação + destaque + busca) usam as mesmas consultas de hoje; uma combinação sem índice vira caixa de erro com "Tentar de novo". Não se cria índice: fica como ressalva e é conferido só no app de teste.
- **Componentes do site:** `StatusBadge`, `AppIconButton`, `SearchField`, `LibraryFilterSelect`, `LibraryCategoryFilter` e `LibraryYearField` são usados na Biblioteca pública, nas listagens de categoria e na Home. Mudanças só por parâmetro opcional; conferir essas telas.
- **Foco ao publicar/destacar:** a linha é recriada com o item novo; a chave por `post.id` e o botão na mesma posição mantêm o foco. A barra linear não pode trocar a lista pelo esqueleto.
- **`LibraryStore.createOrUpdateDocument`** chama `reset()` e recarrega sem filtros: com filtros ativos, a lista e a barra divergiriam. Recarregar com os filtros atuais a partir da seção, não do store.
- Sem credenciais: fluxo real com o Firebase não conferido.

## Como conferir
- `fvm flutter analyze`, `fvm dart format` e `build_runner` na cópia ASCII (`scratchpad/obs`, scripts `fmt.sh` e `check_staged.sh`); copiar gerados e formatados de volta.
- App de teste (`lib/main_harness.dart`, fora do git) ampliado com: publicações com imagem válida, sem imagem e com URL quebrada; títulos e descrições longos; 1 item; 60+ itens com páginas; tipo vazio; categorias com e sem publicações e colaboração; equipe com e sem foto/descrição/Lattes; usuários dos três papéis, e-mail longo e um removido; mídias com mais páginas e nomes longos; biblioteca nas duas áreas, com "Carregar mais"; parâmetros `?vazio=1`, `?falha=carregar` (primeira página), `?falha=mais` (segunda página) e `?papel=viewer`; rota `/admin/painel/biblioteca/:area` igual à real.
- Chrome headless (CDP) em 390, 768 e 1280, cada seção contra a aba "Painel" do protótipo, `scrollWidth` igual à largura.
- Teclado: Tab pelos filtros, linhas e rodapé; Enter/Espaço no segmentado e em "Destaques"; foco mantido após publicar e destacar.
- Build web release do site: Biblioteca pública (filtros), listagem de categoria (busca), Home.
- Uma vez em `fvm flutter run -d web-server` (debug) com o app de teste, sem `overflow` nem asserção.
