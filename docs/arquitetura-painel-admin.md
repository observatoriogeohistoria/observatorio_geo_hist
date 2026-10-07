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
│   │   ├── datasources/              # posts, categories, media, users, team
│   │   ├── repositories/             # idem
│   │   ├── models/                   # media_model, paginated_medias, user_model, user_permissions, user_role
│   │   └── errors/                   # *_failures.dart de cada módulo
│   └── presentation/
│       ├── pages/panel_page.dart
│       ├── stores/                   # um por módulo + crud_store (base)
│       └── components/
│           ├── sections/             # posts, categories, media, users, team, library, crud
│           ├── cards/                # um por módulo + posts_cards/ (um por tipo de post)
│           ├── dialogs/              # create_or_update_* + create_or_update_posts_dialogs/
│           └── form_label, section_header_title, section_header_actions
└── sidebar/
    ├── sidebar_setup.dart
    └── presentation/                 # components/, stores/sidebar_store.dart, enums/sidebar_item.dart
```

`toggle_collpase_button.dart` mantém a grafia original. A `library_section.dart` gerencia a biblioteca, mas dados e stores vêm da feature `library`.

## 2. Abas

O enum `SidebarItem` define as abas e a URL `/admin/painel/:tab`:

| Item | `:tab` |
|---|---|
| `users` | `usuarios` |
| `media` | `midias` |
| `categories` | `categorias` |
| `posts` | `publicacoes` (aceita `?tipo=`) |
| `team` | `equipe` |
| `library` | `biblioteca` |

## 3. Firebase

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

## 4. CRUD

Os stores de mídia, categorias, usuários e equipe estendem `CrudStore<T>` (`getItems`, `loadMore`, `createOrUpdateItem`, `deleteItem`). Só o `MediaStore` implementa `loadMore` (guarda o `nextPageToken` e anexa a página, ignorando ids repetidos); na `CrudSection`, `paginated: true` o aciona a 200 px do fim da lista. O `PostsStore` tem métodos próprios (`getPosts`, `createOrUpdatePost`, `deletePost`), pois pagina e filtra por tipo. Os estados (`CrudLoadingState`, `CrudSuccessState`, `CrudErrorState`) ficam em `core/models/states/crud_states.dart`.

Salvar um post com imagem:

1. `PostsRepository.createOrUpdatePost` envia a imagem via `MediaDatasource` e troca os bytes pela URL.
2. `PostsDatasource.createOrUpdatePost` grava em `posts/{categoryId}/category_posts/{postId}`.
3. Se a categoria mudou, remove o post de `posts/{categoria antiga}/category_posts/`.

## 5. Autenticação e autorização

`UserRole` grava `ADMIN`, `EDITOR` e `VIEWER` no Firestore. O `UserModel` calcula as `UserPermissions`:

| Permissão | admin | editor | viewer |
|---|---|---|---|
| `canAccessUsersSection` | sim | não | não |
| `canEditMediaSection`, `canEditCategoriesSection`, `canEditPostsSection`, `canEditTeamSection`, `canEditLibrarySection` | sim | sim | não |

**Onde a proteção acontece**

- **Router**: o `redirect` de [app_router.dart](../lib/app/router/app_router.dart) manda para `/admin` quem não está logado, mas só no caminho exato `/admin/painel`. As rotas `/admin/painel/:tab` não passam por essa checagem.
- **PanelPage**: chama `AuthStore.currentUser()` no `initState` e observa `authStore.user`; se ficar `null`, redireciona para `/admin`. É isso que protege as abas.
- **Sidebar**: só mostra "usuários" com `canAccessUsersSection`.
- **Seções**: habilitam a edição conforme a permissão. O `viewer` só visualiza.

Toda a autorização é no cliente. O repositório não tem `firestore.rules` nem `storage.rules`: quem protege os dados são as regras do console do Firebase. Vale versioná-las.

## 6. Injeção de dependência

`AdminSetup.setup()` registra o datasource e o repositório de auth (`registerFactory`) e o `AuthStore` (`registerLazySingleton`), e chama `PanelSetup.setup()` e `SidebarSetup.setup()`. `FirebaseAuth`, `FirebaseFirestore` e `LoggerService` vêm do `AppSetup`.

## 7. Como estender

**Novo tipo de conteúdo**

1. Criar datasource, repository, model e failures em `panel/infra/`.
2. Criar o store em `panel/presentation/stores/`, estendendo `CrudStore<T>`.
3. Criar section, card e dialog em `panel/presentation/components/`.
4. Registrar em `PanelSetup`.
5. Adicionar o valor em `SidebarItem` (`value` e `title`) e na navegação da sidebar.

**Novo tipo de post**: criar o model do corpo em `core/models/`, o card em `cards/posts_cards/`, o dialog em `dialogs/create_or_update_posts_dialogs/` e incluí-lo no `PostType`.

**Visual**: o painel usa os mesmos tokens do site (`AppTheme`), sem `num_extension`. Campos novos partem de `PanelFieldDecoration` (`core/components/field/`), diálogos de `PanelDialogTitle`, listas vazias de `EmptyListMessage` e situação do item de `StatusBadge` (`core/components/chips/labels.dart`; texto e fundo, nunca só cor).

**Nova permissão**: adicionar o campo em `UserPermissions`, definir a regra no construtor de `UserModel` e usá-la na seção.

## 8. Pontos de atenção

- `users_section.dart` habilita a edição com `canEditTeamSection`, não com permissão própria. Sem efeito hoje, pois só administradores acessam a aba.
- `role` inválido em `users/` faz `UserRole.fromString` lançar exceção.
- Usuários removidos recebem `isDeleted`, sem exclusão física.
