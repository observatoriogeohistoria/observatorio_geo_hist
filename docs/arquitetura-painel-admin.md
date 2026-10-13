# Arquitetura do Painel Administrativo

CMS do Observatório, em `lib/app/features/admin/`. Segue as camadas e o fluxo `Widget → Store → Repository → Datasource → Firebase` de [arquitetura.md](arquitetura.md).

## 1. Estrutura

```
lib/app/features/admin/
├── admin_setup.dart                  # DI: auth + PanelSetup e SidebarSetup
├── login/
│   ├── infra/                        # firebase_auth_datasource, auth_repository, auth_failure
│   └── presentation/                 # signin_page, stores/ (auth_store, auth_state)
├── panel/
│   ├── panel_setup.dart
│   ├── infra/
│   │   ├── datasources/              # posts, categories, media, users, team, panel_counts
│   │   ├── repositories/             # idem
│   │   ├── models/                   # media_model, paginated_medias, panel_counts, user_model, user_permissions, user_role
│   │   └── errors/                   # *_failures.dart de cada módulo
│   └── presentation/
│       ├── pages/panel_page.dart
│       ├── stores/                   # um por módulo + crud_store (base) + panel_counts_store
│       └── components/
│           ├── sections/             # uma seção por módulo + a linha de cada um (*_row), crud_section, panel_action
│           ├── list/                 # peças comuns das listas: caixa, linha, grade, filtros, esqueleto e estados
│           ├── dialogs/              # create_or_update_*, confirm_dialog + create_or_update_posts_dialogs/
│           └── form_label, panel_top_bar, panel_user_badge, panel_section_header
└── sidebar/
    ├── sidebar_setup.dart
    └── presentation/                 # components/, stores/sidebar_store.dart, enums/sidebar_item.dart, labels/
```

A `library_section.dart` mostra a lista da biblioteca dentro do painel, mas dados e stores (`LibraryStore`, `FilterDocumentsStore`) vêm da feature `library`.

## 2. Abas

O enum `SidebarItem` define as abas e a URL `/admin/painel/:tab`:

| Item | `:tab` |
|---|---|
| `users` | `usuarios` |
| `media` | `midias` |
| `categories` | `categorias` |
| `posts` | `publicacoes` (aceita `?tipo=`) |
| `team` | `equipe` |
| `library` | `biblioteca` (e `biblioteca/:area`) |

`/admin/painel/biblioteca` abre Geografia; `/admin/painel/biblioteca/:area` abre a área pedida, e o controle segmentado da seção troca o endereço. As rotas do painel usam a mesma chave de página (`_panelPage` em `app_router.dart`): trocar de seção, de tipo ou de área atualiza a `PanelPage` no lugar, sem recriar a moldura.

## 3. Moldura

A `PanelPage` monta a `PanelTopBar` (marca, "Ver site" e a pessoa logada com o papel) e, abaixo, o menu: fixo a partir de 1024 px e, antes disso, gaveta do `Scaffold` que fica por baixo da barra. O menu (`Sidebar`) tem três grupos (`SidebarGroup`); os rótulos do painel para tipos e papéis ficam em `sidebar/presentation/labels/`, separados dos do site.

As contagens do menu e dos resumos vêm do `PanelCountsStore`, com consultas `count()` do Firestore. Cada consulta falha sozinha: o número vira `null` e some, sem quebrar o menu. Mídias fica sem número, porque o Storage só conta listando tudo. O store carrega uma vez ao abrir o painel e recarrega depois de salvar ou excluir.

Toda seção abre com o `PanelSectionHeader` (sobretítulo, título que recebe o foco ao trocar de seção, resumo e botão principal, que some para quem não pode editar).

## 4. Firebase

**Authentication**: `FirebaseAuthDatasource` ([firebase_auth_datasource.dart](../lib/app/features/admin/login/infra/datasources/firebase_auth_datasource.dart)) expõe `signIn`, `signOut`, `createUser` e `currentUser`. Após o login, o `UserModel` vem de `users/{uid}`. Na criação de usuário, uma instância temporária (`TemporaryApp`) evita trocar a sessão do administrador.

**Firestore**:

| Caminho | Conteúdo |
|---|---|
| `users/{uid}` | `name`, `email`, `role`, `isDeleted` |
| `posts/{categoryKey}` | Categoria |
| `posts/{categoryKey}/category_posts/{postId}` | Posts da categoria |
| `team/{id}` | Equipe |
| `library/{id}` | Documentos |

A listagem de posts usa `collectionGroup('category_posts')`, com filtros por tipo, área e categoria, e paginação por `startAfterDocument`. A busca por título usa um intervalo sobre `body.title_lower`.

**Storage**: bucket do projeto do ambiente (só produção tem Storage habilitado; ver [deploy-ambientes.md](deploy-ambientes.md)), arquivos em `media/{nome}_{id}.{extensão}`. `MediaDatasource.getMedias` lista 20 por vez (`ListOptions`) e devolve `PaginatedMedias` (`medias`, `nextPageToken`). O preview usa a URL, sem baixar os bytes. A imagem é enviada antes de salvar o post que a referencia. O [cors.json](../cors.json) define o CORS do bucket.

## 5. CRUD

Os stores de mídia, categorias, usuários e equipe estendem `CrudStore<T>` (`getItems`, `loadMore`, `createOrUpdateItem`, `deleteItem`). Só o `MediaStore` implementa `loadMore` (guarda o `nextPageToken`, anexa a página ignorando ids repetidos e expõe `hasMore`). O `PostsStore` tem métodos próprios (`getPosts`, `createOrUpdatePost`, `deletePost`), pois pagina e filtra por tipo; a biblioteca usa o `LibraryStore`. Os dois guardam um número de pedido: filtro novo (ou `reset: true`) recomeça da primeira página e descarta a resposta antiga que ainda estava a caminho. Os estados (`CrudLoadingState`, `CrudSuccessState`, `CrudErrorState`) ficam em `core/models/states/crud_states.dart`.

**Listas**: cabeçalho, filtros e itens rolam juntos no `PanelSectionScroll` (`components/list/`), que também é um grupo de foco, para o Tab percorrer a seção antes de voltar ao menu. Cada item é uma `PanelListRow` (imagem ou ícone, título, meta, selos e ações; cartão abaixo de 600 px) dentro da `PanelList`, que fecha com o `PanelListFooter` ("Limpar filtros", "Carregar mais" ou o indicador de mais itens). Mídias usam a `PanelGrid`. A barra de filtros (`PanelFilterBar`) estica a busca para ocupar a sobra da linha.

A `CrudSection` monta categorias, equipe, usuários e mídias: chama `getItems`, carrega mais ao rolar com `paginated: true`, filtra na tela (`filter`) e escolhe o estado. Publicações e Biblioteca montam as mesmas peças por conta própria, porque paginam e filtram no Firestore.

**Estados**: esqueleto (`PanelListSkeleton`) ao abrir ou trocar de filtro; `PanelEmptyState` com o botão de criar para quem pode; `PanelNoResultsState` quando o filtro não acha nada; `PanelErrorState` com "Tentar de novo" quando a primeira página falha (sem aviso flutuante). Falha ao carregar mais vira aviso e deixa um "Carregar mais" no rodapé, em vez de tentar a cada rolada.

**Avisos e confirmação**: o store só informa sucesso ou erro. Quem dispara a ação registra qual foi num `PendingPanelAction` (salvar, excluir, publicar, despublicar, destacar, tirar do destaque), e o `showPanelActionResult` escolhe o texto do aviso, fecha o diálogo só quando a ação foi salvar e recarrega as contagens depois de salvar ou excluir. Erros vão para `Messenger.showError`; `Forbidden` encerra a sessão. Toda exclusão passa antes por `showConfirmDialog`, que devolve `true` só quando a pessoa confirma.

**Botões de ícone**: o `AppIconButton` recebe `label` (nome curto para o leitor de tela, como "Excluir") e `tooltip` (o que acontece), mostrado no mouse e no foco por teclado. Com `isDisabled` o botão continua focável, para a dica explicar por que não dá.

Salvar um post com imagem:

1. `PostsRepository.createOrUpdatePost` envia a imagem via `MediaDatasource` e troca os bytes pela URL.
2. `PostsDatasource.createOrUpdatePost` grava em `posts/{categoryId}/category_posts/{postId}`.
3. Se a categoria mudou, remove o post de `posts/{categoria antiga}/category_posts/`.

## 6. Autenticação e autorização

`UserRole` grava `ADMIN`, `EDITOR` e `VIEWER` no Firestore. O `UserModel` calcula as `UserPermissions`:

| Permissão | admin | editor | viewer |
|---|---|---|---|
| `canAccessUsersSection` | sim | não | não |
| `canEditMediaSection`, `canEditCategoriesSection`, `canEditPostsSection`, `canEditTeamSection`, `canEditLibrarySection` | sim | sim | não |

**Onde a proteção acontece**

- **Router**: o `redirect` de [app_router.dart](../lib/app/router/app_router.dart) manda para `/admin` quem não está logado, mas só no caminho exato `/admin/painel`. As rotas `/admin/painel/:tab` não passam por essa checagem.
- **PanelPage**: chama `AuthStore.currentUser()` no `initState` e observa `authStore.user`; se ficar `null`, redireciona para `/admin`. É isso que protege as abas.
- **Sidebar**: só mostra o grupo Administração (Usuários) com `canAccessUsersSection`.
- **Seções**: habilitam a edição conforme a permissão. O `viewer` só visualiza.

Toda a autorização é no cliente. O repositório não tem `firestore.rules` nem `storage.rules`: quem protege os dados são as regras do console do Firebase. Vale versioná-las.

## 7. Injeção de dependência

`AdminSetup.setup()` registra o datasource e o repositório de auth (`registerFactory`) e o `AuthStore` (`registerLazySingleton`), e chama `PanelSetup.setup()` e `SidebarSetup.setup()`. `FirebaseAuth`, `FirebaseFirestore` e `LoggerService` vêm do `AppSetup`.

## 8. Como estender

**Novo tipo de conteúdo**

1. Criar datasource, repository, model e failures em `panel/infra/`.
2. Criar o store em `panel/presentation/stores/`, estendendo `CrudStore<T>`.
3. Criar a seção (sobre a `CrudSection`), a linha (`*_row.dart`, sobre a `PanelListRow`) e o dialog em `panel/presentation/components/`.
4. Registrar em `PanelSetup`.
5. Adicionar o valor em `SidebarItem` (`value` e `title`) e na navegação da sidebar.

**Novo tipo de post**: criar o model do corpo em `core/models/`, o dialog em `dialogs/create_or_update_posts_dialogs/`, incluí-lo no `PostType` e dizer em `post_row_meta.dart` o que entra na meta da linha.

**Visual**: o painel usa os mesmos tokens do site (`AppTheme`), sem `num_extension`. Campos novos partem de `PanelFieldDecoration` (`core/components/field/`), diálogos de `PanelDialogTitle` e situação do item de `StatusBadge` (`core/components/chips/labels.dart`; texto e fundo, nunca só cor; tom `neutral` para o que não é destaque).

**Nova permissão**: adicionar o campo em `UserPermissions`, definir a regra no construtor de `UserModel` e usá-la na seção.

## 9. Pontos de atenção

- `users_section.dart` habilita a edição com `canEditTeamSection`, não com permissão própria. Sem efeito hoje, pois só administradores acessam a aba.
- `role` inválido em `users/` faz `UserRole.fromString` lançar exceção.
- Usuários removidos recebem `isDeleted`, sem exclusão física.
