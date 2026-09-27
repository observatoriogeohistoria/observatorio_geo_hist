# Arquitetura do Observatório Geo-Hist

Flutter Web organizado em **features**, com camadas inspiradas em Clean Architecture. Backend Firebase (Firestore, Auth e Storage), **MobX** para estado, **GetIt** para injeção, **GoRouter** para rotas e **fpdart** (`Either`) para erros.

O painel administrativo tem documento próprio: [arquitetura-painel-admin.md](arquitetura-painel-admin.md). O deploy está em [deploy-ambientes.md](deploy-ambientes.md).

## Estrutura de diretórios

```
lib/
├── main.dart                 # Firebase.initializeApp + setup
├── firebase_options.dart
└── app/
    ├── app_setup.dart        # DI: serviços compartilhados + setup de cada feature
    ├── app_widget.dart       # Widget raiz
    ├── router/               # GoRouter (app_router.dart) e PageNotFound
    ├── theme/                # app_colors, app_typography, app_dimensions, app_theme
    ├── core/                 # Código compartilhado
    └── features/             # admin, home, library, posts
```

## Camadas de uma feature

Cada feature tem um `{feature}_setup.dart` (DI) e, em geral, duas camadas:

- **`infra/`**: `datasources/` (consultas ao Firebase), `repositories/` (contrato + implementação, convertendo exceções em `Either<Failure, T>`), `models/` e `errors/` (`Failure`s).
- **`presentation/`**: `pages/`, `components/` e `stores/` (MobX; `*.g.dart` gerado pelo `build_runner`).

Fluxo: `Widget → Store → Repository → Datasource → Firebase`. O resultado volta como `Either<Failure, T>` e o store atualiza o estado observável.

## Core (`lib/app/core/`)

| Pasta | Conteúdo |
|---|---|
| `components/` | Widgets compartilhados: buttons, card, dialog, field, footer, navbar, focus (`AppFocusRing`), logo, skeleton, video_player, entre outros |
| `models/` | `PostModel` e os corpos de post, `category`, `image`, `paginated/`, `states/` (CRUD) e demais modelos comuns |
| `utils/` | Constantes, datas, enums, formatters, validators, `environment/`, `browser/` e demais utilitários |
| `infra/` | Datasource/repository de categorias e `services/logger_service` |
| `stores/` | `fetch_categories_store` |
| `errors/` | `Failure` base e falhas de categorias |
| `routes/` | `AppRoutes` (constantes e helpers de rota) |

## Features

| Feature | Responsabilidade |
|---|---|
| `home` | Página inicial: hero, destaques, quem somos, vídeo e equipe |
| `posts` | Listagem paginada com filtros e detalhe do post |
| `library` | Biblioteca de documentos por área, com busca por `slug` |
| `admin` | Login, painel de conteúdo e sidebar |

## Rotas

Definidas em [app_router.dart](../lib/app/router/app_router.dart):

```
/                                     Home
/membro/:id                           Membro da equipe
/posts/:area/:category                Lista de posts
/posts/:area/:category/:id            Detalhe do post
/contato                              Contato
/colaborar                            Colaboração
/manifest                             Manifesto
/biblioteca                           Biblioteca
/biblioteca/:area                     Documentos da área
/biblioteca/:area/documento/:slug     Detalhe de documento
/admin                                Login
/admin/painel                         Redireciona para /admin/painel/categorias
/admin/painel/:tab                    Painel (?postType=... na aba de posts)
/admin/painel/biblioteca/:area        Biblioteca no painel
```

## Dados

| Coleção | Uso |
|---|---|
| `posts/{categoryKey}` | Categoria (campo `areas`: história/geografia) |
| `posts/{categoryKey}/category_posts/{postId}` | Posts da categoria, lidos com `collectionGroup('category_posts')` |
| `team` | Equipe |
| `users` | Usuários do painel, com `role` |
| `library` | Documentos (campos `area`, `slug`) |

Storage: mídias em `media/{nome}_{id}.{extensão}`, listadas com paginação no painel.

## Modelo de posts

`PostModel` carrega um `PostType` e um `body` polimórfico (`PostBody`) cuja implementação depende do tipo: produção acadêmica, artigo, livro, documento, evento, filme, revista, música, podcast e pesquisa.

## Navbar

Fixa no topo (`NavbarSliver` em páginas com `CustomScrollView`). Em ≥ 1024 px mostra os itens em linha; História e Geografia usam o `NavbarDropdown` (hover, clique e teclado) com o `NavbarCategoriesMenu`. Abaixo disso, um botão abre o `NavbarMobileMenu` (sanfonas). O item ativo vem de `NavbarLocation`, calculado pela rota.

## Home

A `HomePage` é um `CustomScrollView` com um bloco por sliver, abaixo da navbar. O hero carrega junto com a página; os demais blocos são `deferred`.

- **Hero** (`components/hero/`): título, botões e três atalhos. História e Geografia abrem `showAreaCategoriesDialog`, que reaproveita o `NavbarCategoriesMenu` e o `FetchCategoriesStore`.
- **Destaques** (`components/highlights/`): observa o `FetchHighlightsStore` (posts publicados com `isHighlighted`). `selectHighlights` descarta posts sem `body`, `id` ou área, ordena por `createdAt` (mais recente primeiro) e fica com três; o primeiro é o principal. Carregando mostra esqueleto, erro mostra "Tentar de novo" e, sem destaques, a seção some. Só a `HomePage` dispara a busca, e só se ainda não buscou, se falhou ou se a última busca foi feita sem categorias (`fetchedWithoutCategories`).
- **Quem somos** (`components/who_we_are/`): missão, `ArrowLink` para o manifesto e três públicos. Duas colunas só no desktop.
- **Vídeo de apresentação** (`components/video/`): capa (`assets/images/video-capa.webp` se existir, senão `VideoCoverPainter`) e `VideoPlayButton`. Nada é baixado antes de "Assistir": o `AppVideoPlayer` (import `deferred`) só é montado após o clique. Estados: capa → carregando → tocando ou erro. O vídeo toca com som só se a ativação do usuário ainda vale quando fica pronto (`hasUserActivation`); senão fica pausado e pronto. Se o navegador recusar o início automático (`onAutoplayBlocked`), o player é remontado pausado, sem mostrar erro.

O `AppVideoPlayer` tem parâmetros opcionais desligados por padrão (o painel o usa sem eles): `onInitialized`, `onError`, `loadingPlaceholder`, `shouldStartPlaying`, `onAutoplayBlocked`, `autofocusControls` e `showControlsScrim`.

## Tratamento de erros

Repositórios retornam `Either<Failure, T>`; cada feature define suas falhas.

```dart
Future<Either<Failure, PaginatedPosts>> fetchPosts(...) async {
  try {
    return Right(posts);
  } catch (error) {
    return const Left(FetchPostsFailure());
  }
}
```

## Convenções

- Arquivos e pastas em `snake_case`; classes em `PascalCase`; membros em `camelCase`.
- Sufixos: `*_datasource`, `*_repository`, `*_store`, `*_model`, `*_page`, `*_setup`, `*_failures`.

## Adicionando uma feature

1. Criar `lib/app/features/{feature}/` com `infra/` e `presentation/`.
2. Criar `{feature}_setup.dart` e chamá-lo em `app_setup.dart`.
3. Registrar as rotas em `app_router.dart`.

## Página base e tela de carregamento (`web/`)

- [web/index.html](../web/index.html) traz título, descrição, `lang="pt-BR"`, cor de tema, Open Graph/Twitter (`og-image.png`, 1200×630) e link canônico. Não mexa nos blocos do Google Analytics e do `pdf.js` (usado pelo `pdfx`).
- A **tela de carregamento** é HTML/CSS inline no início do `<body>`, com marca em SVG e fonte do sistema. Sai no evento `flutter-first-frame` (esmaecimento de 200 ms, sem animação com movimento reduzido). Após 15 s sem o app abrir, mostra aviso e botão "Recarregar"; sem JavaScript, um `<noscript>`. As cores espelham `AppColors` em variáveis CSS.
- O título da aba vem do `title` do `MaterialApp` em `app_widget.dart`; mantenha-o igual ao `<title>` do `index.html`.
- **Ícones e imagem de compartilhamento** (`favicon.*`, `icons/*`, `og-image.png`) são gerados por `tool/web_icons/gerar.sh` (Chrome headless). Rode de novo só se `assets/images/logo.svg` mudar, atualizando o SVG copiado nas páginas de `tool/web_icons/` e no `index.html`.

## Ferramentas e versões

- Flutter fixado via FVM em [.fvmrc](../.fvmrc); os workflows leem a versão dali.
- Scripts em `pubspec.yaml` no formato do [derry](https://pub.dev/packages/derry): `get`, `clean`, `builder`, `build`, `run`, `test`.
- Ainda não há pasta `test/`.
