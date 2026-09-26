# Arquitetura do Painel Administrativo

Sistema de gerenciamento de conteúdo do Observatório, em `lib/app/features/admin/`. Segue a mesma estrutura de camadas descrita em [arquitetura.md](arquitetura.md): Firebase (Auth, Firestore, Storage), MobX, GetIt e `Either<Failure, T>`.

## 1. Estrutura

```
lib/app/features/admin/
├── admin_setup.dart                  # DI: auth + chama PanelSetup e SidebarSetup
├── login/
│   ├── login_setup.dart
│   ├── infra/
│   │   ├── datasources/firebase_auth_datasource.dart
│   │   ├── repositories/auth_repository.dart
│   │   └── errors/auth_failure.dart
│   └── presentation/
│       ├── signin_page.dart
│       └── stores/                   # auth_store, auth_state (+ .g.dart e .freezed.dart gerados)
├── panel/
│   ├── panel_setup.dart
│   ├── infra/
│   │   ├── datasources/              # posts, categories, media, users, team
│   │   ├── repositories/             # posts, categories, media, users, team
│   │   ├── models/                   # media_model, paginated_medias, user_model, user_permissions, user_role
│   │   └── errors/                   # *_failures.dart de cada módulo
│   └── presentation/
│       ├── pages/panel_page.dart
│       ├── stores/                   # posts, categories, media, users, team + crud_store (base)
│       └── components/
│           ├── sections/             # posts, categories, media, users, team, library, crud
│           ├── cards/                # um card por módulo + posts_cards/ (um por tipo de post)
│           ├── dialogs/              # create_or_update_* + create_or_update_posts_dialogs/ (um por tipo)
│           └── form_label, section_header_title, section_header_actions
└── sidebar/
    ├── sidebar_setup.dart
    └── presentation/
        ├── components/               # sidebar_navigation, sidebar_header, sidebar_menu_item, toggle_collpase_button
        ├── stores/sidebar_store.dart
        └── enums/sidebar_item.dart
```

`toggle_collpase_button.dart` mantém a grafia original do arquivo.

A biblioteca é gerenciada por `library_section.dart`, mas seus dados e stores vêm da feature `library`.

## 2. Abas do painel

O enum `SidebarItem` define as abas e o segmento da URL (`/admin/painel/:tab`):

| Item | Rota (`:tab`) |
|---|---|
| `users` | `usuarios` |
| `media` | `mídias` |
| `categories` | `categorias` |
| `posts` | `posts` (aceita `?postType=`) |
| `team` | `equipe` |
| `library` | `biblioteca` |

## 3. Firebase

**Authentication**: `FirebaseAuthDatasource` ([firebase_auth_datasource.dart](../lib/app/features/admin/login/infra/datasources/firebase_auth_datasource.dart)) expõe `signIn`, `signOut`, `createUser` e `currentUser`. Após o login, o `UserModel` é carregado do documento `users/{uid}`.

Na criação de usuário, uma instância temporária do Firebase (`TemporaryApp`) é usada para não trocar a sessão do administrador logado. Ela é removida ao final.

**Firestore**:

| Caminho | Conteúdo |
|---|---|
| `users/{uid}` | Usuário, com `name`, `email`, `role` e `isDeleted` |
| `posts/{categoryKey}` | Categoria |
| `posts/{categoryKey}/category_posts/{postId}` | Posts da categoria |
| `team/{id}` | Membros da equipe |
| `library/{id}` | Documentos da biblioteca |

A listagem de posts usa `collectionGroup('category_posts')`, com filtros por tipo, área e categoria, ordenação e paginação por `startAfterDocument`. A busca por título usa um intervalo sobre `body.title_lower` (`>= texto` e `< texto + ''`).

**Storage**: bucket `gs://observatorio-geo-hist.firebasestorage.app`, com arquivos em `media/{nome}_{id}.{extensão}`. A listagem é paginada: `MediaDatasource.getMedias` usa `list(ListOptions(maxResults: 20, pageToken: ...))` e devolve um `PaginatedMedias` (`medias` e `nextPageToken`, com `hasMore` derivado do token). Os bytes dos arquivos não são baixados na listagem; o preview usa a URL. A imagem é enviada antes de salvar o post que a referencia. O [cors.json](../cors.json) na raiz define a política de CORS do bucket.

## 4. Fluxo de CRUD

```
Widget → Store (MobX) → Repository → Datasource → Firebase
                                         ↓
              Either<Failure, T> → Store atualiza estado → Observer reconstrói a UI
```

Os stores de mídia, categorias, usuários e equipe estendem `CrudStore<T>` (`getItems`, `loadMore`, `createOrUpdateItem`, `deleteItem`). `loadMore` é um no-op por padrão e só o `MediaStore` o implementa: guarda o `nextPageToken`, anexa a próxima página a `items` (ignorando ids já carregados) e usa `CrudLoadingState(isRefreshing: true)`. Na `CrudSection`, `paginated: true` (usado pela `MediaSection`) faz o scroll chamar `loadMore()` a 200 px do fim da lista. O `PostsStore` tem métodos próprios (`getPosts`, `createOrUpdatePost`, `deletePost`), pois pagina e filtra por tipo. Os estados de operação (`CrudLoadingState`, `CrudSuccessState`, `CrudErrorState`) ficam em `core/models/states/crud_states.dart`.

Salvar um post que tem imagem:

1. `PostsRepository.createOrUpdatePost` envia a imagem via `MediaDatasource` e troca os bytes pela URL.
2. `PostsDatasource.createOrUpdatePost` grava em `posts/{categoryId}/category_posts/{postId}`.
3. Se a categoria mudou, o post antigo é removido de `posts/{categoria antiga}/category_posts/`.

## 5. Autenticação e autorização

### Papéis e permissões

`UserRole` tem três valores, gravados no Firestore como `ADMIN`, `EDITOR` e `VIEWER`. O `UserModel` calcula `UserPermissions` a partir do papel:

| Permissão | admin | editor | viewer |
|---|---|---|---|
| `canAccessUsersSection` | sim | não | não |
| `canEditMediaSection` | sim | sim | não |
| `canEditCategoriesSection` | sim | sim | não |
| `canEditPostsSection` | sim | sim | não |
| `canEditTeamSection` | sim | sim | não |
| `canEditLibrarySection` | sim | sim | não |

### Onde a proteção acontece

- **Router**: o `redirect` global de [app_router.dart](../lib/app/router/app_router.dart) manda para `/admin` quem não está logado, mas só quando o caminho é exatamente `/admin/painel`. As rotas `/admin/painel/:tab` não passam por essa checagem.
- **PanelPage**: no `initState` chama `AuthStore.currentUser()` e observa `authStore.user`. Se ficar `null`, redireciona para `/admin`. É essa reação que protege as abas.
- **Sidebar**: exibe o item "usuários" apenas se `permissions.canAccessUsersSection` for verdadeiro.
- **Seções**: cada seção habilita os botões de edição conforme a permissão correspondente. Um `viewer` vê o conteúdo sem poder editar.

Toda a autorização acontece no cliente. O repositório não tem arquivos de regras do Firestore ou do Storage (`firestore.rules` e `storage.rules`), então quem protege os dados de fato são as regras configuradas no console do Firebase. Vale versioná-las.

## 6. Injeção de dependência

`AdminSetup.setup()` registra, com GetIt, o datasource e o repositório de autenticação (`registerFactory`) e o `AuthStore` (`registerLazySingleton`). Em seguida chama `PanelSetup.setup()` (usuários, categorias, posts, mídia e equipe) e `SidebarSetup.setup()` (`SidebarStore`). Instâncias de `FirebaseAuth`, `FirebaseFirestore` e `LoggerService` vêm do `AppSetup`.

## 7. Como estender

**Novo tipo de conteúdo**

1. Criar datasource e repository em `panel/infra/`, além do model e das failures.
2. Criar o store em `panel/presentation/stores/`, estendendo `CrudStore<T>`.
3. Criar a section, o card e o dialog em `panel/presentation/components/`.
4. Registrar em `PanelSetup`.
5. Adicionar o valor em `SidebarItem` (com `value` e `title`) e na navegação da sidebar.

**Novo tipo de post**: criar o model do corpo em `core/models/`, o card em `cards/posts_cards/` e o dialog em `dialogs/create_or_update_posts_dialogs/`, e incluí-lo no `PostType`.

**Nova permissão**

1. Adicionar o campo em `UserPermissions`.
2. Definir a regra no construtor de `UserModel`.
3. Usar a permissão na seção correspondente.

## 8. Pontos de atenção

- `users_section.dart` habilita a edição com `canEditTeamSection`, e não com uma permissão própria de usuários. Hoje isso não muda o resultado, porque só administradores chegam nessa aba.
- Um documento em `users/` com `role` inválido faz `UserRole.fromString` lançar exceção.
- Usuários removidos recebem `isDeleted`, sem exclusão física do documento.
