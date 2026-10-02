# Plano da 015. Todas as publicações e "Ver todas" nos Destaques

- **Spec:** [spec.md](spec.md)
- **Criado em:** 2026-10-02

## Abordagem
A 014 deixou tudo pronto: `PostsListingStore` aceita `PostsListingScope` sem categoria e o datasource já consulta `collectionGroup('category_posts')` sem filtro de categoria. A página nova `AllPostsPage` monta `ReadingPageScaffold` + `PageHeader` (migalhas, título e descrição fixos) + `PostsListing`, carregando o store com um escopo de todos os tipos, em ordem alfabética do plural. Não depende do `FetchCategoriesStore`: o cabeçalho aparece na hora e só a lista carrega.

Mudanças pequenas na listagem: os textos do estado vazio passam a vir de quem monta a página (a categoria passa os de hoje), e `routeFor` pode devolver nulo para pular um post sem área. O endereço de cada post sai do próprio post (`areas.first`, `categoryId`, `id`).

Na Home, o cabeçalho dos Destaques ganha o `ArrowLink` "Ver todas as publicações", com a mesma disposição do "Leia também" (012): `Wrap` com `spaceBetween` no tablet e desktop, coluna no celular. O rodapé ganha "Publicações" em "Explorar".

**Índice.** Conferido no Firebase (consultas REST só leitura, com a chave web do app, prod e dev): lista e contagem sem categoria e sem busca (`isPublished` + `type` + `orderBy createdAt desc`) funcionam com os índices atuais; a busca sem categoria (`isPublished` + `type` + `orderBy body.title_lower`) falha com "The query requires an index" nos dois projetos. O código não muda por isso: a falha vira `Left`, o store vai para erro e a listagem já mostra a `StateErrorBox` com a busca visível. A definição do índice vai para `docs/deploy-ambientes.md`.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/app/router/app_router.dart` | `GoRoute(path: AppRoutes.publications)` → `AllPostsPage`, dentro do `ShellRoute`, antes de `categoryPattern` |
| Alterar | `lib/app/features/posts/presentation/stores/states/posts_listing_states.dart` | `PostsListingScope.all()`: sem categoria, tipos em ordem alfabética de `portuguesePlural` (lista fixa ordenada por `compareTo` do plural) |
| Criar | `lib/app/features/posts/presentation/pages/all_posts_page.dart` | Página: store por fábrica, `load(PostsListingScope.all())` no `initState`; `PageHeader` com migalhas "Início" › "Publicações", título "Todas as publicações" e descrição; `PostsListing` com `routeFor` do próprio post e textos de vazio "Ainda não há publicações" / "Volte em breve."; `setSelectedCategory(null)` como a navbar já faz |
| Alterar | `lib/app/features/posts/presentation/components/listing/posts_listing.dart` | Parâmetros `emptyTitle` e `emptyMessage` (obrigatórios); `routeFor` passa a `String? Function(PostModel)` |
| Alterar | `lib/app/features/posts/presentation/components/listing/listing_type_block.dart` | Pula post com rota nula |
| Alterar | `lib/app/features/posts/presentation/pages/posts_page.dart` | Passa os textos de vazio da categoria (os de hoje) |
| Alterar | `lib/app/features/home/presentation/components/highlights/highlights_section.dart` | Cabeçalho do `_Section` com `ArrowLink` "Ver todas as publicações" (`url` e `go` para `AppRoutes.publications`); celular: coluna com `postSubtitleGap`; maior: `Wrap` `spaceBetween`, `WrapCrossAlignment.end`, `postBylineGap`/`postSubtitleGap` como em `related_posts_section.dart` |
| Alterar | `lib/app/core/components/footer/footer.dart` | `_FooterLinkData('Publicações', AppRoutes.publications)` entre "Sobre" e "Biblioteca" |
| Alterar | `docs/deploy-ambientes.md` | Seção "Índices do Firestore": índice composto de grupo de coleções `category_posts` (`isPublished` ↑, `type` ↑, `body.title_lower` ↑), para prod e dev, usado pela busca de `/publicacoes`; como publicar pelo console (link que o erro do Firestore traz no console do navegador) |
| Alterar | `docs/arquitetura.md` | Seção "Listagem de posts": página de todas as publicações, escopo `all()`, textos de vazio e `routeFor` anulável |

## Decisões técnicas
- **Rota pela constante que já existe.** `AppRoutes.publications` (`/publicacoes`) já é o prefixo das rotas de categoria e post; vira também o `path` da página, sem mudar `app_routes.dart`.
- **Página própria em vez de reaproveitar `PostsPage`.** `PostsPage` gira em torno da categoria (espera as categorias, 404, Colabore, troca pelo menu). A página nova é curta e não precisa de nada disso.
- **Escopo `all()` com lista fixa ordenada pelo plural** em vez de `PostType.values` (ordem dos nomes em inglês). Ordenar com `compareTo` do plural é suficiente: nenhum plural começa por letra acentuada.
- **Endereço do post pelo próprio post** (`areas.first.key`, `categoryId`). Evita esperar o `FetchCategoriesStore`. Post sem área: `routeFor` devolve nulo e o bloco o pula (a contagem pode ficar um a mais; caso que não deve existir).
- **Sem `firestore.indexes.json`.** O projeto não tem configuração de Firestore no `firebase.json`; um arquivo só com o índice novo levaria `firebase deploy --only firestore:indexes` a propor apagar os índices que existem. A definição fica documentada.
- **Erro da busca sem tratamento especial.** A caixa de erro com o campo visível e "Limpar" já cobre; detectar `failed-precondition` para outra mensagem seria código para um estado temporário.
- **Navbar sem mudança.** `NavbarLocation` já devolve seção nula para `/publicacoes` (um segmento só): nenhum item ativo.

## Dependências e geração de código
- Sem pacote, asset ou `build_runner` (o store não muda; o escopo é classe comum).
- Rota nova `/publicacoes` no `app_router.dart`, pela constante `AppRoutes.publications`. Nenhuma rota existente muda.
- `posts_setup.dart` não muda: `PostsListingStore` já é fábrica.

## Riscos e cuidados
- **Índice da busca (ressalva da spec).** Até a pessoa publicar o índice nos dois projetos, a busca de `/publicacoes` mostra erro. Conferir em `APP_ENV=prod` que o erro aparece tratado (caixa, "Limpar" volta à lista, nada carregando para sempre) e que a busca da categoria continua funcionando.
- **Volume da primeira carga:** 10 tipos × 13 documentos + 10 contagens (prod tem 443 publicados). Conferir tempo e rolagem em 390; se ficar pesado, registrar (não mudar o tamanho de página sem atualizar a spec).
- **`createdAt` é texto ISO** no banco: a ordem é a mesma da categoria. Conferir que posts de categorias diferentes se intercalam por data.
- **Componentes compartilhados:** rodapé (todas as páginas), `PostsListing` (categoria) e Destaques (Home). Conferir categoria (vazio e busca vazia com os textos de antes), Home e uma página com rodapé em 390/768/1280.
- **Rota `/publicacoes` dentro do mesmo `ShellRoute`** que `categoryPattern`: conferir que `/publicacoes/historia/<categoria>` continua abrindo a categoria e `/publicacoes/historia` continua 404.

## Como conferir
- `fvm flutter analyze` e `fvm dart format` numa cópia em caminho ASCII (copiar os arquivos formatados de volta).
- `fvm flutter build web --release --dart-define=APP_ENV=prod` (só leitura), servir `build/web` com fallback de SPA e abrir no navegador embutido (ou Chromium sem janela via CDP) em 390, 768 e 1280: `/publicacoes`, Home (Destaques), rodapé, categoria.
- `fvm flutter run -d web-server` na cópia ASCII para ver asserções de layout em debug.
