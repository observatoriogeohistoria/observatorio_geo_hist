# Arquitetura do Observatório Geo-Hist

Aplicação Flutter Web organizada em **features** com camadas inspiradas em Clean Architecture. Usa Firebase (Firestore, Auth e Storage) como backend, **MobX** para estado, **GetIt** para injeção de dependência, **GoRouter** para rotas e **fpdart** (`Either`) para tratamento de erros.

O painel administrativo tem documentação própria: [arquitetura-painel-admin.md](arquitetura-painel-admin.md).

## Estrutura de diretórios

```
lib/
├── main.dart                 # Ponto de entrada (Firebase.initializeApp + setup)
├── firebase_options.dart
└── app/
    ├── app_setup.dart        # Registro de DI (serviços compartilhados + setup de cada feature)
    ├── app_widget.dart       # Widget raiz
    ├── router/               # GoRouter (app_router.dart) e PageNotFound
    ├── theme/                # app_colors, app_typography, app_dimensions, app_theme
    ├── core/                 # Código compartilhado entre features
    └── features/             # admin, home, library, posts
```

## Camadas de uma feature

Cada feature tem um `{feature}_setup.dart` (DI) e, em geral, duas camadas:

**`infra/`**: acesso a dados
- `datasources/`: consultas ao Firebase
- `repositories/`: contrato abstrato + implementação; converte exceções em `Either<Failure, T>`
- `models/`: modelos específicos da feature
- `errors/`: classes `Failure` da feature

**`presentation/`**: interface
- `pages/`: telas
- `components/`: widgets específicos da feature
- `stores/`: stores MobX (`*.g.dart` é gerado pelo `build_runner`)

Fluxo de dados: `Widget → Store → Repository → Datasource → Firebase`. O resultado volta como `Either<Failure, T>` e o store atualiza o estado observável.

## Core (`lib/app/core/`)

| Pasta | Conteúdo |
|---|---|
| `components/` | buttons, card, dialog, divider, error_content, field, footer, image, loading, loading_content, mouse_region, navbar (`navbar`, `navbar_item`, `navbar_dropdown`, `navbar_categories_menu`, `navbar_location`), focus (`AppFocusRing`), logo (`AppLogo`), pages_circles, quill, scroll, skeleton, support, text, video_player |
| `models/` | `PostModel` e os corpos de post (`academic_production`, `article`, `book`, `document`, `event`, `film`, `magazine`, `music`, `podcast`, `search`), além de `category`, `image`, `navbutton_item`, `general_state`, `paginated/`, `states/` (estados de CRUD) e `united/` |
| `utils/` | carousel_options, constants, date, enums, extensions, formatters, generator, image, messenger, screen, strings, transitions, url, validators |
| `infra/` | datasource/repository de categorias e `services/logger_service` |
| `stores/` | `fetch_categories_store` |
| `errors/` | `Failure` base e falhas de categorias |
| `routes/` | `AppRoutes` (constantes de rotas e helpers) |

## Features

| Feature | Responsabilidade |
|---|---|
| `home` | Página inicial: equipe, destaques e navbar dinâmica |
| `posts` | Listagem paginada com filtros e página de detalhe do post |
| `library` | Biblioteca de documentos por área, com busca por `slug` |
| `admin` | Login, painel de conteúdo e sidebar (ver [documento do painel](arquitetura-painel-admin.md)) |

## Rotas

Definidas em [app_router.dart](../lib/app/router/app_router.dart):

```
/                                     Home
/membro/:id                           Detalhe de membro da equipe
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
/admin/painel/:tab                    Painel (?postType=... para a aba de posts)
/admin/painel/biblioteca/:area        Lista da biblioteca no painel
```

## Dados no Firestore

| Coleção | Uso |
|---|---|
| `posts/{categoryKey}` | Documento da categoria (campo `areas` indica história/geografia) |
| `posts/{categoryKey}/category_posts/{postId}` | Posts da categoria; lidos com `collectionGroup('category_posts')` |
| `team` | Membros da equipe |
| `users` | Usuários do painel, com `role` |
| `library` | Documentos da biblioteca (campos `area`, `slug`) |

Storage: arquivos de mídia em `media/{nome}_{id}.{extensão}`, listados com paginação no painel.

## Modelo de posts

`PostModel` carrega um `PostType` e um `body` polimórfico (`PostBody`), cuja implementação concreta depende do tipo (livro, filme, podcast etc.).

Os tipos de post são os valores de `PostType`: produção acadêmica, artigo, livro, documento, evento, filme, revista, música, podcast e pesquisa. O tipo `artist` (Artista) foi removido, junto com seu model, card, dialog e conteúdo de detalhe.

## Navbar

A `Navbar` fica fixa no topo (`NavbarSliver` em páginas com `CustomScrollView`). Em ≥ 1024 px mostra os itens em linha; História e Geografia usam o `NavbarDropdown` (hover, clique e teclado) com o conteúdo de `NavbarCategoriesMenu`. Abaixo disso, um botão abre `NavbarMobileMenu`, painel com sanfonas. O item ativo vem de `NavbarLocation`, calculado pela rota e entregue ao painel.

## Home

A `HomePage` é um `CustomScrollView` com um bloco por sliver, abaixo da `NavbarSliver`. O primeiro é o `HomeHero` (`features/home/presentation/components/hero/`), carregado junto com a página: rótulo, título, texto de apoio, botões para a biblioteca e o manifesto e três atalhos (`HeroShortcutCard`). Os atalhos História e Geografia abrem `showAreaCategoriesDialog`, uma janela que reaproveita o `NavbarCategoriesMenu` e o `FetchCategoriesStore` da navbar (sem consulta nova). O fundo desenhado é o `HeroBackgroundPainter`. Os demais blocos são carregados sob demanda (`deferred`) e cada um indica, em comentário, a spec que o redesenha.

Logo abaixo do hero fica a `HighlightsSection` (`features/home/presentation/components/highlights/`), que observa o `FetchHighlightsStore` (posts publicados com `isHighlighted`). A função pura `selectHighlights` descarta posts sem `body`, `id` ou área, ordena por `createdAt` (mais recente primeiro, sem data no fim) e fica com três; o primeiro é o principal. `HighlightsGrid` monta a disposição conforme a quantidade e a faixa (coluna no celular; duas colunas 1,6 : 1 no tablet e no desktop) e também serve ao esqueleto. `HighlightCard` é um link para `/posts/:area/:categoria/:id`, com a área da categoria ou, na falta dela, a do próprio post (`highlightArea`). Estados: carregando mostra título e esqueleto, erro mostra mensagem e "Tentar de novo", e sem destaques a seção some. A `HomePage` é a única que dispara a busca (a navbar não busca mais destaques): quando as categorias mudam, quando elas falham e ao abrir a Home com as categorias já resolvidas, sempre com as categorias que houver. Para não repetir a busca a cada navbar montada (a navbar busca as categorias de novo em toda página), só busca se ainda não buscou, se a busca falhou ou se a última foi feita sem categorias e agora elas existem (`FetchHighlightsStore.fetchedWithoutCategories`); busca em andamento não é repetida.

Depois dos destaques vêm dois blocos estáticos, montados junto com a página (spec 006). `WhoWeAreSection` (`components/who_we_are/`) mostra a missão, o link "Conheça o manifesto" (`ArrowLink`, em `core/components/buttons/`, o link de texto com seta do protótipo) e os três públicos (`AudienceItem`); fica em duas colunas só no desktop. `PresentationVideoSection` (`components/video/`) mostra a capa (`VideoCover`: `assets/images/video-capa.webp` quando o arquivo existe no manifesto de assets, senão a capa desenhada por `VideoCoverPainter`), a legenda e o `VideoPlayButton`. Nada é baixado antes de "Assistir": o `AppVideoPlayer` (import `deferred`) só é montado depois do clique, atrás da capa e no mesmo quadro; os estados são capa → carregando → tocando ou erro ("Tentar de novo" remonta o player com chave nova). O vídeo toca com som só se a ativação do usuário ainda vale quando ele fica pronto (`hasUserActivation`, em `core/utils/browser/`, com import condicional para web); senão fica pausado e pronto, porque o `video_player_web` transforma a recusa de `play()` do navegador em erro do controller.

O `AppVideoPlayer` tem parâmetros opcionais, desligados por padrão (o painel administrativo usa o player sem eles): `onInitialized`, `onError` (que também faz o player acompanhar o estado real do vídeo, como o fim), `loadingPlaceholder`, `shouldStartPlaying`, `autofocusControls` e `showControlsScrim` (véu atrás dos controles, que também os afasta da borda). O `AppIconButton` aceita um `focusNode` opcional.

## Tratamento de erros

Repositórios retornam `Either<Failure, T>`; cada feature define suas próprias falhas.

```dart
Future<Either<Failure, PaginatedPosts>> fetchPosts(...) async {
  try {
    // ...
    return Right(posts);
  } catch (error) {
    return const Left(FetchPostsFailure());
  }
}
```

## Convenções

- Arquivos e pastas em `snake_case`; classes em `PascalCase`; membros em `camelCase`.
- Sufixos: `*_datasource`, `*_repository`, `*_store`, `*_model`, `*_page`, `*_setup`, `*_failures`.
- Cada feature registra suas dependências no próprio `*_setup.dart`, chamado por `app_setup.dart`.

## Adicionando uma feature

1. Criar `lib/app/features/{feature}/` com `infra/` e `presentation/`.
2. Criar `{feature}_setup.dart` e chamá-lo em `app_setup.dart`.
3. Registrar as rotas em `app_router.dart`.

## Página base e tela de carregamento (`web/`)

- [web/index.html](../web/index.html) traz título, descrição, `lang="pt-BR"`, cor de tema, tags de compartilhamento (Open Graph e Twitter/X, com `og-image.png` de 1200×630) e o link canônico `https://observatoriogeohistoria.net.br/`. Os blocos do Google Analytics e do `pdf.js` (usado pelo `pdfx` na biblioteca) não devem ser mexidos.
- A **tela de carregamento** é HTML e CSS inline no começo do `<body>`, com a marca em SVG e fonte do sistema, para aparecer antes de qualquer script. Um script inline a remove quando o motor do Flutter dispara o evento `flutter-first-frame` na janela (esmaecimento de 200 ms, sem animação com movimento reduzido). Se o app não abrir em 15 s, mostra a mensagem de demora e o botão "Recarregar". Sem JavaScript, um `<noscript>` mostra o aviso. As cores ficam num bloco de variáveis CSS espelhando `AppColors`.
- O título da aba depois que o app abre vem do `title` do `MaterialApp` em `app_widget.dart`; mantenha-o igual ao `<title>` do `index.html`.
- **Ícones e imagem de compartilhamento** (`favicon.svg`, `favicon.png`, `icons/*`, `og-image.png`) são gerados por `tool/web_icons/gerar.sh`, que fotografa as páginas de `tool/web_icons/` com o Google Chrome em modo headless. Rode de novo só se a marca (`assets/images/logo.svg`) mudar, lembrando de atualizar o SVG copiado nessas páginas e no `index.html`.

## Ferramentas e versões

- Flutter fixado via FVM em [.fvmrc](../.fvmrc); o deploy usa a mesma versão em [deploy.yml](../.github/workflows/deploy.yml). Ao trocar de versão, atualize os dois.
- Scripts em `pubspec.yaml` no formato do [derry](https://pub.dev/packages/derry): `get`, `clean`, `builder`, `build`, `run`, `test`. O `run` não usa mais `--web-renderer html`, flag removida nas versões recentes do Flutter.
- Deploy: GitHub Actions compila o web e envia por FTP para a HostGator a cada push na `main`.
- Ainda não há pasta `test/` no projeto.
