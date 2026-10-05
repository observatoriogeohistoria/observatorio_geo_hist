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
| `components/` | Widgets compartilhados: buttons (inclui `InlineLink`, link sublinhado para `mailto:`, `tel:` e externos), card, chips (`FilterChipButton`, chip de filtro com quantidade), dialog, field (inclui `SearchField`, busca com pausa e "Limpar"), form (formulário que abre o e-mail, ver [Formulários por e-mail](#formulários-por-e-mail)), footer, navbar, focus (`AppFocusRing`), logo, partners (Realização e apoio), reading (base das páginas de texto), error_content (`StateMessageBox`, caixa de estado com ícone, título, texto e ação; `StateErrorBox`, a de erro com "Tentar de novo"), skeleton, video_player, entre outros |
| `models/` | `PostModel` e os corpos de post, `category`, `image`, `paginated/`, `states/` (CRUD) e demais modelos comuns |
| `utils/` | Constantes, datas, enums, formatters, validators (`Validators` do painel e do login; `FormValidators` do site), `url/` (`openUrl`, `MailDraft`), `environment/`, `browser/` e demais utilitários |
| `infra/` | Datasource/repository de categorias e `services/logger_service` |
| `stores/` | `fetch_categories_store` |
| `errors/` | `Failure` base e falhas de categorias |
| `routes/` | `AppRoutes` (constantes e helpers de rota) |

## Features

| Feature | Responsabilidade |
|---|---|
| `home` | Página inicial: hero, destaques, quem somos, vídeo, nossa história, equipe, realização e apoio e chamada para contato |
| `posts` | Listagem da categoria (busca, filtro por tipo e paginação) e detalhe do post |
| `library` | Biblioteca de documentos por área, aberta pelo identificador |
| `admin` | Login, painel de conteúdo e sidebar |

## Rotas

Definidas em [app_router.dart](../lib/app/router/app_router.dart):

```
/                                     Home
/membro/:id                           Membro da equipe
/publicacoes/:area/:category          Lista de posts da categoria
/publicacoes/:area/:category/:id      Detalhe do post
/contato                              Contato
/colaborar                            Colaboração
/manifesto                            Manifesto
/nossa-historia                       Nossa história (provisória, redesenho na Fase 2)
/biblioteca                           Biblioteca
/biblioteca/:area                     Documentos da área
/biblioteca/:area/documento/:id       Detalhe de documento
/admin                                Login
/admin/painel                         Redireciona para /admin/painel/categorias
/admin/painel/:tab                    Painel (?tipo=... na aba de publicações)
/admin/painel/biblioteca/:area        Biblioteca no painel
```

Rotas sempre em português, sem acento (os caminhos ficam em `AppRoutes`). Os endereços antigos `/manifest` e `/posts/...` redirecionam para os novos.

## Dados

| Coleção | Uso |
|---|---|
| `posts/{categoryKey}` | Categoria (campo `areas`: história/geografia) |
| `posts/{categoryKey}/category_posts/{postId}` | Posts da categoria, lidos com `collectionGroup('category_posts')` |
| `team` | Equipe |
| `users` | Usuários do painel, com `role` |
| `library` | Documentos (campos `area`, `title_lower`, `author_lower`, `institution_lower`) |

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
- **Vídeo de apresentação** (`components/video/`): capa (`assets/images/video-capa.webp` se existir, senão `VideoCoverPainter`) e `VideoPlayButton` na faixa de baixo, para não cobrir o título da capa (no celular, só o botão, menor). Nada é baixado antes de "Assistir": o `AppVideoPlayer` (import `deferred`) só é montado após o clique. Estados: capa → carregando → tocando ou erro. O vídeo toca com som só se a ativação do usuário ainda vale quando fica pronto (`hasUserActivation`); senão fica pausado e pronto. Se o navegador recusar o início automático (`onAutoplayBlocked`), o player é remontado pausado, sem mostrar erro.
- **Nossa história** (`components/our_history/`): resumo estático com `MilestoneBadge` (marco da FAPEMIG) e `ArrowLink` para `/nossa-historia` (`OurHistoryPage`, com o texto completo).
- **Equipe** (`components/team/`): observa o `FetchTeamStore`, que tem estado (inicial, carregando, sucesso, erro) e guarda a lista em ordem alfabética (`sortTeamByName`, sem acentos nem caixa). `TeamGrid` põe quantas colunas de 190 px (× ampliação do texto) couberem; no celular, duas fixas. Membro com página (`memberHasPage`: id e descrição não vazia) é link para `/membro/:id`; sem descrição e com Lattes, abre o currículo em outra aba; sem foto, `MemberAvatar` mostra as iniciais. Carregando mostra esqueleto, erro mostra "Tentar de novo" e, sem membros, a seção some. A `HomePage` só busca se ainda não buscou ou se falhou (`needsFetch`). Só tem respiro de seção em cima; o de baixo fica em Realização e apoio, para o espaço não sumir quando a equipe está escondida.
- **Realização e apoio** (`core/components/partners/`): `PartnersSection` com a `PartnerLogoGrid` (colunas de no mínimo 150 px; três fixas no celular) e um `PartnerLogo` por instituição do enum `Partner` (sigla, nome completo, site e logo; a ordem do enum é a de exibição). O logo é link para o site em outra aba, com nome acessível completo; `url` nula deixa o logo sem link. A mesma seção aparece em Colabore; o `Support` do post usa a mesma grade, com colunas de 130 px.
- **Chamada para contato** (`components/contact_call/`): quadro com "Fale com a gente" para `/contato` (`AppRoutes.contact`). Botão à direita só no desktop.

O `AppVideoPlayer` tem parâmetros opcionais desligados por padrão (o painel o usa sem eles): `onInitialized`, `onError`, `loadingPlaceholder`, `shouldStartPlaying`, `onAutoplayBlocked`, `autofocusControls` e `showControlsScrim`.

## Páginas de leitura

Páginas de texto (Manifesto, Nossa história, Pessoa da equipe e post) se montam com as peças de `core/components/reading/`:

- `ReadingPageScaffold(header:, body:, beforeFooter:)`: navbar, cabeçalho opcional, corpo e rodapé na base da janela; `beforeFooter` fica colado ao rodapé (a seção Apoio do post). No Tab, a navbar vem antes do conteúdo e o item focado é rolado para fora de baixo da navbar fixa.
- `PageHeader`: faixa de superfície com `Breadcrumbs` (lista de `BreadcrumbItem`, de qualquer número de níveis; o último é a página atual e um nível do meio sem `route` é texto comum, sem foco), título, `lead` e `action` (um botão abaixo do lead) opcionais.
- `ReadingRichText`: texto do editor rico (delta do Quill) com o estilo de leitura, só leitura e fora do Tab. Ignora cores, fundos, fontes, tamanhos, linhas em branco seguidas e conteúdo embutido que não seja imagem; imagens ficam na largura da coluna, sem recorte, com altura máxima e placeholder na falha. Links abrem em outra aba (só pelo mouse: o Quill não dá foco a links).
- `ReadingColumn`: coluna de 680 px centralizada; funciona sem `PageHeader` (Pessoa e post têm cabeçalho próprio). `paddingTop` opcional troca o respiro de cima (abaixo de uma figura).
- `ReadingFigure`: imagem em 21:9 até 920 px, mais larga que a coluna, com legenda opcional, recorte por `alignment` e placeholder na falha. Fica entre o cabeçalho e a `ReadingColumn`, que recebe `paddingTop: readingFigureMarginBottom`.
- Pessoa da equipe (`TeamMemberPage`) usa só o `ReadingPageScaffold`, com corpo próprio de 920 px: `MemberPageLayout` (foto | texto, empilha abaixo de 700 px de largura útil), `MemberPortrait` e `MemberPageSkeleton`. Erro mostra `StateErrorBox`; sem página (`memberHasPage`), a 404. A equipe só é buscada no `initState`, se `needsFetch`.
- Blocos, que já trazem a própria margem: `ReadingLead`, `ReadingParagraph`, `ReadingSubtitle` (cabeçalho de nível 2), `ReadingNumberedList`, `ReadingBulletList` e `ReadingQuote`. Novos blocos entram no mesmo arquivo.

## Formulários por e-mail

Fale com a gente (`ContactUsPage`) e Colabore montam o formulário com as peças de `core/components/form/`; nada vai a servidor, o envio é um `mailto:`.

- `MailForm(fields:, submitText:, hint:, buildDraft:, confirmationTexts:)`: um `FormTextField` por `MailFormFieldSpec` (rótulo, validador, várias linhas, teclado, sugestão do navegador), botão principal com envelope e texto de apoio (`**negrito**` via `MarkedText`). Valida ao enviar e, depois da primeira tentativa, a cada digitação; foco no primeiro inválido. Com tudo válido, `buildDraft` recebe os valores aparados e devolve o `MailDraft` (destinatário, assunto, corpo), que abre na mesma aba; a `MailConfirmation` toma o lugar do formulário e "Voltar ao formulário" mantém os valores.
- `MailConfirmation`: título focado e anunciado, link do destinatário, "Copiar mensagem" (`MailDraft.copyText`, com retorno como o do "Copiar link" do post) e "Voltar ao formulário". Textos em `MailConfirmationTexts`.
- `FormTextField`: rótulo acima, borda `fieldBorder` (acento no foco, erro com erro), erro abaixo e marcado como inválido na semântica. O `AppTextField` continua só no painel.
- `FormValidators.required`, `.email` e `.minLength` recebem a mensagem e ignoram espaços nas pontas.

## Listagem de posts

A página da categoria (`PostsPage`) usa o `ReadingPageScaffold` com o `PageHeader` (migalhas Início › área › categoria e, com `hasCollaborateOption`, o botão "Colabore com esta categoria") e a `PostsListing` (`posts/presentation/components/listing/`). Categorias carregando mostram o `CategoryPageSkeleton`; falha nas categorias, `StateErrorBox`; área ou categoria inexistente, a 404.

- **Store por página:** `PostsListingStore` (fábrica no GetIt) recebe um `PostsListingScope` (categoria opcional e tipos) e guarda um `PostsTypeBlock` por tipo com publicação (itens, cursor, "tem mais", carregando mais, falha no "ver mais"), as contagens por tipo (nulas se falharem), o tipo marcado e a busca. Páginas de 12; respostas de uma busca ou escopo anterior são descartadas por número de requisição.
- **Dados:** `fetchPosts` aceita categoria nula (todas as categorias), continua do cursor também na busca e pede um item a mais para saber se há próxima página. `countPosts` usa a mesma consulta e ordenação da lista (`count()`), para aproveitar os mesmos índices.
- **Listagem genérica:** `PostsListing(store:, routeFor:, emptyTitle:, emptyMessage:)` não sabe de categoria: busca (`SearchField`), chips (só com dois ou mais tipos), contagem, blocos (`ListingTypeBlock`, com "Ver mais") e os estados de carregando, vazio, busca vazia e erro. Os textos de vazio vêm da página; `routeFor` devolve nulo para post sem endereço, que fica fora do bloco.
- **Todas as publicações:** `AllPostsPage` (`/publicacoes`) monta a mesma listagem com `PostsListingScope.all()` (sem categoria, tipos em ordem alfabética do plural). O cabeçalho é fixo e não espera as categorias; o endereço de cada post sai dele mesmo (`areas.first`, `categoryId`). A busca sem categoria depende de um índice próprio (ver [deploy-ambientes.md](deploy-ambientes.md#índices-do-firestore)).
- **Card único:** `PostCard(post:, route:, showSummary:)` vale para todos os tipos; rótulo, resumo e detalhes de cada tipo saem de `postCardInfo`, num ponto só (texto do editor rico vira texto simples com `plainTextFromRich`). `PostCardGrid` põe colunas de no mínimo 300 px, até três; `PostCardSkeletonRow` é a linha-esqueleto.

## Biblioteca

A página pública e a do painel são separadas: `/biblioteca/:area` monta a `LibraryAreaPage` e `/painel/biblioteca/:area` continua com a `LibraryListPage` (criar, editar, excluir), com `Filters`, `LibraryDocumentCard` e `FilterDocumentsStore`, que o site não usa mais. O `LibraryStore` fica só no painel.

- **Entrada** (`LibraryPage`): `ReadingPageScaffold` + `PageHeader` e um `LibraryAreaTile` por área, com as contagens do `LibraryIndexStore` (`countByType` por área; sem contagem, a linha de números some).
- **Lista** (`LibraryAreaPage` + `LibraryListing`, em `library/presentation/components/listing/`): busca com "Buscar em" (`LibrarySearchField`), tipo, ano e categorias (`LibraryFilterSelect`, `LibraryYearField`, `LibraryCategoryFilter`, menus do Material), chips de filtros ativos, contagem, `LibraryDocumentRow` e "Ver mais documentos". Filtros valem na hora e não vão para a URL.
- **Store por página:** `LibraryListingStore` (fábrica) guarda filtros, itens, cursor, total do filtro e contagens da área por tipo e categoria (nulas se falharem), com descarte de respostas velhas. Páginas de 20. Vazio sem filtros é "área sem documentos"; com filtros ou busca, "nenhum resultado". A busca compara o termo em minúsculas com `title_lower`, `author_lower` e `institution_lower`, gravados pelo painel (e preenchidos nos antigos por `tool/library_search_fields`).
- **Dados:** `fetchListing` e `countListing` (mesma consulta, `count()`) filtram por área, tipo, ano, categorias (`arrayContainsAny`) e intervalo de prefixo no campo buscado, sempre em ordem de `createdAt`, e pedem um item a mais para saber se há próxima página. O painel segue com `_fetchDocuments`. Busca combinada com outro filtro depende de índices próprios (ver [deploy-ambientes.md](deploy-ambientes.md#índices-do-firestore)).
- **Detalhe** (`LibraryDocumentDetailedPage`, em `components/document/`): `ReadingPageScaffold`, coluna de 920 px com migalhas (área do documento, não a da URL), `LibraryDocumentHeader` (selo, título, ficha e "Abrir documento") e `LibraryDocumentPdfViewer`, que baixa o PDF e desenha uma página por vez com o `pdfx`, sem `PdfView`. Store próprio, `LibraryDocumentStore` (fábrica), com carregando (`LibraryDocumentSkeleton`), sucesso, não encontrado (404) e erro. Selo e etiqueta são os mesmos da lista (`library_labels.dart`).
- **Endereço do documento:** o trecho final é o identificador, como nos posts. O painel não pede mais slug; o campo continua gravado nos documentos antigos só para links já compartilhados: o detalhe procura pelo identificador e, sem resultado, pelo slug (`fetchDocumentByAddress`). O arquivo enviado se chama `<identificador>.<extensão>` e é apagado pelo endereço salvo.

## Página do post

`PostDetailedPage` (spec 012) usa o `ReadingPageScaffold` e um `PostDetailStore` próprio por página (fábrica no GetIt), com os estados carregando (`PostPageSkeleton`), sucesso, não encontrado (404) e erro (`StateErrorBox`). O datasource lança `PostNotFoundException` para post inexistente ou não publicado, que vira `PostNotFoundFailure`; categoria ou área inexistente também dão 404. A página só busca o post quando a categoria da URL aparece no `FetchCategoriesStore`, e não busca de novo quando a navbar recarrega as categorias.

O conteúdo sai de um ponto único, `PostTypeContent` (`posts/presentation/components/post/`): artigo usa o layout-base (`ArticleBody`: `ArticleHeader` com migalhas, título, autoria, compartilhar e `PostCover`, mais `ReadingRichText` e `ArticleNote` na coluna); os outros tipos ainda usam o `*_content.dart` antigo. Na Fase 5, cada tipo troca ali para o layout-base com o seu bloco. Abaixo do conteúdo, só no artigo, vem o `RelatedPostsSection` (Leia também: até 3 artigos da mesma categoria, sem o atual, no `PostCard` sem resumo, escondido se vazio ou com falha) e, em todos, o `Support` (Acompanhe + logos), colado ao rodapé.

O compartilhar do layout-base é o `PostShare` (spec 013): copiar link, redes e e-mail, e a folha do aparelho no celular (`core/utils/browser/native_share`). Na Fase 5, os outros tipos o usam no cabeçalho; o `SocialIcons` antigo some na Fase 7.

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
- Comentários seguem as regras do [CLAUDE.md](../CLAUDE.md): só o porquê do que não é óbvio, curto e sem citar spec ou protótipo.
- **Elementos clicáveis acessíveis:** `Semantics(link:/button:, label:, onTap:, excludeSemantics: true)` por fora, `AppFocusRing` e `InkWell` por dentro. O `onTap` do `Semantics` repete o do `InkWell`, porque o `excludeSemantics` esconde o `InkWell` do leitor de tela. Links internos levam `linkUrl`; `preventSemanticLinkNavigation` impede o navegador de seguir o `<a href>` sozinho.

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
