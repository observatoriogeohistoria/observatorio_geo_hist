# Plano da 030. Estrutura do painel

- **Spec:** spec.md
- **Criado em:** 2026-10-08

## Abordagem
A `PanelPage` perde a `AppBar` laranja e passa a montar a moldura do protótipo: `PanelTopBar` no topo e, embaixo, o menu fixo (≥ 1024) ou a gaveta do `Scaffold` (< 1024) ao lado do conteúdo. O menu é reescrito em `admin/sidebar/`: grupos, subitens sempre visíveis, contagens e "Sair" no pé. O recolher sai, com os campos do `SidebarStore` que só serviam a ele.

As contagens vêm de um datasource novo com consultas `count()` do Firestore, isoladas uma da outra: se uma falha, só aquele número some. Um `PanelCountsStore` guarda os números, carrega ao abrir o painel e recarrega depois de criar ou excluir. O mesmo store alimenta o resumo do cabeçalho de cada seção.

Um `PanelSectionHeader` substitui o `SectionHeaderTitle` e o título da `CrudSection`, com sobretítulo, título focável, resumo e o botão principal com "+". As listas, cartões e diálogos continuam os de hoje (031 a 033 trocam o miolo), mas ganham nomes, dicas, confirmação de exclusão e avisos curtos.

Avisos e confirmação são peças pequenas e reaproveitáveis pela 031 a 033: o `Messenger` passa a desenhar o aviso curto escuro (sucesso) e o vermelho (erro), e `showConfirmDialog` devolve `true`/`false`. As seções sabem qual ação dispararam (`_pendingAction`), escolhem o texto do aviso e só fecham diálogo quando a ação veio de um diálogo. Isso conserta o `GoRouter.pop()` que hoje roda também depois de publicar ou excluir pela lista, sem diálogo aberto.

A dica no foco por teclado vira padrão do `AppIconButton`, com nome acessível curto (`label`) separado da descrição (`tooltip`) e um estado indisponível que continua focável. Assim todo botão de ícone do painel atende a P-14 sem código repetido.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | lib/app/theme/app_dimensions/app_dimensions.dart | Tokens da barra, menu (248), gaveta, cabeçalho, aviso, confirmação e dica; `panelSidebarWidth` muda |
| Alterar | lib/app/theme/app_typography/app_text_styles.dart | `panelGroupLabel`, `panelNavItem`, `panelNavSubItem`, `panelCount`, `panelSectionTitle`, `panelSectionSummary`, `panelUserName`, `panelUserRole`, `toast`, `tooltip` |
| Alterar | lib/app/theme/app_colors/app_colors.dart | `errorStrong` (hover do botão de excluir) e `toastIcon` (verde claro sobre o escuro) |
| Alterar | lib/app/core/components/buttons/app_button_base.dart | `AppButtonKind.danger` |
| Criar | lib/app/core/components/buttons/danger_button.dart | Botão vermelho da confirmação |
| Alterar | lib/app/core/components/buttons/app_icon_button.dart | `label`, dica no foco, Esc fecha a dica, `isDisabled` focável |
| Alterar | lib/app/core/components/logo/app_logo.dart | `subtitle`, `destination` e `showName` opcionais (marca do painel) |
| Alterar | lib/app/core/utils/messenger/messenger.dart | Aviso curto escuro com ícone e aviso de erro vermelho mais longo |
| Criar | lib/app/features/admin/panel/presentation/components/dialogs/confirm_dialog.dart | `showConfirmDialog` (título, texto, Cancelar com foco, Excluir vermelho) |
| Criar | lib/app/features/admin/panel/infra/datasources/panel_counts_datasource.dart | Consultas `count()` |
| Criar | lib/app/features/admin/panel/infra/repositories/panel_counts_repository.dart | Cada contagem isolada, `null` quando falha |
| Criar | lib/app/features/admin/panel/infra/models/panel_counts.dart | Números por tipo, categorias, biblioteca por área, equipe e usuários |
| Criar | lib/app/features/admin/panel/presentation/stores/panel_counts_store.dart (+ `.g.dart`) | Estado das contagens |
| Alterar | lib/app/features/admin/panel/panel_setup.dart | Registro do datasource, repositório e store |
| Criar | lib/app/features/admin/sidebar/presentation/labels/post_type_panel_labels.dart | Extensão: plural do menu ("Produções acadêmicas", "Filmes") e "Novo artigo"/"Nova produção"… |
| Criar | lib/app/features/admin/sidebar/presentation/labels/user_role_label.dart | Extensão: "Administração", "Edição", "Leitura" (a 032 reaproveita) |
| Alterar | lib/app/features/admin/sidebar/presentation/enums/sidebar_item.dart | Título "Publicações", grupo, ícones novos, ordem dos tipos do protótipo |
| Alterar | lib/app/features/admin/sidebar/presentation/stores/sidebar_store.dart (+ `.g.dart`) | Sai `isCollapsed`, `showPostsSubItems` e os `toggle*` |
| Apagar | lib/app/features/admin/sidebar/presentation/components/toggle_collpase_button.dart, sidebar_header.dart | Recolher e logo do menu saem |
| Criar | lib/app/features/admin/sidebar/presentation/components/sidebar_group_label.dart | Título de grupo em versalete |
| Alterar | lib/app/features/admin/sidebar/presentation/components/sidebar_menu_item.dart | Item e subitem com ícone, nome, contagem e estado atual |
| Alterar | lib/app/features/admin/sidebar/presentation/components/sidebar_navigation.dart | Menu em grupos, Sair no pé, rolagem interna, foco no item atual na gaveta |
| Criar | lib/app/features/admin/panel/presentation/components/panel_top_bar.dart | Barra branca: menu, marca, Ver site, pessoa logada |
| Criar | lib/app/features/admin/panel/presentation/components/panel_user_badge.dart | Iniciais, nome e papel |
| Alterar | lib/app/features/admin/panel/presentation/pages/panel_page.dart | Moldura nova, gaveta, contagens |
| Criar | lib/app/features/admin/panel/presentation/components/panel_section_header.dart | Cabeçalho de seção |
| Apagar | lib/app/features/admin/panel/presentation/components/section_header_title.dart | Substituído |
| Alterar | lib/app/features/admin/panel/presentation/components/sections/*.dart | Cabeçalho, confirmação, avisos, contagens |
| Alterar | lib/app/features/admin/panel/presentation/components/cards/*.dart (fora `posts_cards/`) | Nomes e dicas dos botões; excluir categoria indisponível |
| Alterar | lib/app/features/admin/panel/presentation/components/dialogs/view_image_dialog.dart, create_or_update_article_dialog.dart | Nome e dica dos botões de ícone |
| Alterar | lib/app/features/library/presentation/pages/library_list_page.dart | Confirmação, avisos, "Novo documento" com "+", dica do Voltar |
| Alterar | lib/app/features/library/presentation/components/document/library_document_card.dart, filters.dart | Nome e dica dos botões de ícone |
| Alterar | docs/arquitetura-painel-admin.md | Estrutura sem recolher, contagens, aviso e confirmação |

## Decisões técnicas
- **Gaveta:** a do `Scaffold` (`drawer`), que já fecha com Esc, toque fora e `Navigator.pop`, e prende o foco. O fundo usa `drawerScrimColor` com token. O foco vai ao item atual por `autofocus` só quando o menu está na gaveta. Ao fechar sem escolher, `onDrawerChanged(false)` devolve o foco ao `FocusNode` do botão de menu. Largura `min(300, 86 %)` como no protótipo. Alternativa (overlay próprio) descartada: repetiria o que o `Scaffold` já faz.
- **Contagens:** `collectionGroup('category_posts').where('type', isEqualTo: type.name).count()` para cada tipo (total = soma, só quando os 10 vierem); `collection('posts').count()` para categorias; `collection('library').where('area', …)` para cada área, com o mesmo filtro de `_baseQuery`; `collection('team').count()`; usuários = `collection('users').count()` menos `where('isDeleted', isEqualTo: true).count()`, só para quem vê Usuários. Todas usam índice de campo único que já existe ou é automático. Recarregam depois de criar ou excluir (publicar e destacar não mudam os números).
- **Avisos:** reaproveitar o `SnackBar` (flutuante, largura máxima por token, centrado embaixo) dentro do `Messenger`, porque ele já anuncia ao leitor de tela, faz fila e some sozinho. Sucesso: fundo `ink`, ícone de confirmação, 3 s. Erro: `error`, 8 s e botão de fechar. Só o painel usa o `Messenger`, então o site não muda.
- **Texto do aviso nas seções:** cada seção guarda a ação que disparou (`publish`, `unpublish`, `highlight`, `unhighlight`, `save`, `delete`) e escolhe o texto da spec ao ver `CrudSuccessState`. Os stores ficam como estão (sem `build_runner` neles). Só `save` fecha diálogo.
- **Confirmação:** `showDialog` com `barrierDismissible`, `autofocus` no "Cancelar" e `Semantics(scopesRoute, namesRoute)`; o `Navigator` devolve o foco ao botão que abriu. Genérica (textos dos botões por parâmetro) para a 033 usar no "Sair sem salvar?".
- **Dica no foco:** o `Tooltip` não abre no foco nem fecha com Esc. O `AppIconButton` chama `ensureTooltipVisible` quando recebe foco em modo de teclado (`FocusManager.highlightMode`) e trata Esc num `Focus.onKeyEvent` que só consome a tecla se havia dica aberta; senão o Esc segue para a gaveta ou o diálogo. Nome acessível = `label` (padrão: `tooltip`, para não mudar os botões do site); dica = `tooltip`, fora da semântica do `Tooltip` e passada em `Semantics(tooltip:)`.
- **Botão indisponível:** focável, sem ação, opacidade de desabilitado e `Semantics(enabled: false)`, para a pessoa chegar por Tab e ler o motivo na dica.
- **Marca do painel:** `AppLogo(subtitle: 'Painel', destination: AppRoutes.panelPosts('artigos'), showName: …)` em vez de um widget novo: mesma marca e foco do site. Abaixo de 600 só o símbolo.
- **Ver site:** `openUrl(Uri.base.resolve(AppRoutes.root).toString())`, que abre em nova aba; `Semantics(link: true)`.
- **Rótulos:** extensões no admin (`post_type_panel_labels.dart`, `user_role_label.dart`) em vez de mexer em `PostType.portuguesePlural` (usado no site, "Filmes e Vídeos") ou nos modelos.
- **Foco no título:** o título do `PanelSectionHeader` tem `autofocus` e `key` com o nome da seção/tipo, então recebe o foco a cada troca, inclusive entre tipos (a `PostsSection` não é recriada).
- **Biblioteca até a 031:** a seção mantém os dois blocos de área, cabeçalho sem botão e resumo "N documentos". A `LibraryListPage` continua com a barra própria e recebe confirmação, avisos e dicas (registrado na spec).

## Dependências e geração de código
- Nenhum pacote novo, nenhum asset (o símbolo do logo já existe em `logo.svg`).
- `build_runner` depois de mudar o `SidebarStore` e criar o `PanelCountsStore`.
- `panel_setup.dart` registra `PanelCountsDatasource`, `PanelCountsRepository` e `PanelCountsStore` (`registerLazySingleton`).
- Sem mudança em `app_router.dart` nem em `AppRoutes`.

## Riscos e cuidados
- **Índice das contagens por tipo:** a listagem usa `type` + `createdAt`; o `count()` só com `type` em grupo de coleções precisa do índice de campo único com escopo de grupo. Se o Firestore pedir índice, o número some (falha isolada, registrada no log) e fica como ressalva, sem criar índice.
- **`AppIconButton` e `AppLogo` são do site:** dica no foco passa a valer também no player de vídeo, menu do celular e filtros da biblioteca. Conferir Home, post com vídeo, Biblioteca e login; nome acessível dos botões do site não muda (`label` cai no `tooltip`).
- **`AppButtonBase`:** só ganha um tipo; conferir botões da Home e do login.
- **`panelSidebarWidth` muda de 304 para 248:** conferir se outro lugar usa o token (hoje só o menu).
- **`Messenger`** muda de cara nos diálogos atuais (erros de validação de imagem): conferir que continua legível por cima da janela.
- **Pop do diálogo:** errar a ação pendente pode fechar a página do painel. Conferir em modo debug publicar, destacar e excluir pela lista e salvar por diálogo.
- **Gaveta e Esc:** Esc com dica aberta deve fechar só a dica; sem dica, fecha a gaveta.
- Sem credenciais: o painel real com Firebase (contagens, exclusões) fica como não conferido.

## Como conferir
- `fvm flutter analyze`, `fvm dart format` e `build_runner` na cópia ASCII (o "ó" do caminho quebra as ferramentas); copiar os arquivos gerados e formatados de volta.
- App de teste só na cópia (`lib/main_harness.dart`, nunca commitado), com:
  - `AuthRepository` falso com papel escolhido por `?papel=admin|editor|viewer` e nome longo opcional (`?nome=longo`);
  - repositórios falsos de publicações, categorias (uma com publicações, uma sem), mídias, equipe, usuários e biblioteca, registrados por cima do `GetIt` (`allowReassignment`), com atraso curto e uma falha opcional (`?falha=excluir`);
  - `PanelCountsDatasource` falso com atraso, números de 3 dígitos e uma contagem que falha (`?falha=equipe`);
  - roteador com as rotas do painel iguais às de `app_router.dart` e uma Home falsa em `/`.
- Chrome headless (CDP) em 390, 768 e 1280 px contra o protótipo, aba "Painel", e em 1024 (limite da gaveta).
- Build web release do site real: Home, post com vídeo, Biblioteca, Contato e login para as peças compartilhadas.
- Uma vez em `fvm flutter run -d web-server` (debug) com o app de teste, sem asserção nem `overflow`.
