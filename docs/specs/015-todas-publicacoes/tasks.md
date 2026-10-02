# Tarefas da 015. Todas as publicações e "Ver todas" nos Destaques

Legenda: `- [ ]` a fazer, `- [x]` feita.

## Grupo A: listagem
- [ ] **A1.** `PostsListing` com `emptyTitle`/`emptyMessage` e `routeFor` anulável; `ListingTypeBlock` pula post sem rota; `PostsPage` passa os textos da categoria. Arquivos: `listing/posts_listing.dart`, `listing/listing_type_block.dart`, `pages/posts_page.dart`. Atende: critérios 8, 11. Conferir: analyze limpo; categoria com busca vazia igual a antes.
- [ ] **A2.** `PostsListingScope.all()`: sem categoria, todos os tipos em ordem alfabética do plural. Arquivo: `states/posts_listing_states.dart`. Atende: critério 3.

## Grupo B: página e rota
- [ ] **B1.** `AllPostsPage`: `ReadingPageScaffold`, `PageHeader` (migalhas "Início" › "Publicações", "Todas as publicações", descrição da spec), `PostsListing` com escopo `all()`, rota do post pelo próprio post (nula sem área) e vazio "Ainda não há publicações" / "Volte em breve."; `setSelectedCategory(null)`. Arquivo: `pages/all_posts_page.dart`. Atende: critérios 1, 2, 3, 4, 5, 6, 7, 8.
- [ ] **B2.** Rota `AppRoutes.publications` → `AllPostsPage` no `ShellRoute`. Arquivo: `router/app_router.dart`. Atende: critério 1. Conferir: `/publicacoes` e `/publicacoes/` abrem a página; `/publicacoes/historia/<categoria>` abre a categoria; `/publicacoes/historia` continua 404.

## Grupo C: entradas para a página
- [ ] **C1.** Destaques: `ArrowLink` "Ver todas as publicações" no cabeçalho (`Wrap` `spaceBetween` no tablet e desktop, coluna no celular), em carregando, erro e sucesso. Arquivo: `highlights/highlights_section.dart`. Atende: critério 9.
- [ ] **C2.** Rodapé: "Publicações" entre "Sobre" e "Biblioteca" em "Explorar". Arquivo: `core/components/footer/footer.dart`. Atende: critério 10.

## Grupo D: documentação
- [ ] **D1.** `docs/deploy-ambientes.md`: seção "Índices do Firestore" com o índice da busca de `/publicacoes` (grupo de coleções `category_posts`: `isPublished` ↑, `type` ↑, `body.title_lower` ↑), nos projetos `observatorio-geo-hist` e `observatorio-geo-hist-dev`, e como publicar. `docs/arquitetura.md`: página de todas as publicações na seção "Listagem de posts". Atende: critério 13.

## Grupo E: conferência
- [ ] **E1.** Qualidade: `fvm dart format` nos `.dart` alterados e `fvm flutter analyze` na cópia ASCII, sem problemas novos; `grep` sem `num_extension` e sem cor, fonte ou espaço soltos nos arquivos alterados; nenhuma rota escrita fora de `AppRoutes`. Atende: critério 13.
- [ ] **E2.** Rodar o app: `fvm flutter build web --release --dart-define=APP_ENV=prod` (só leitura), servir `build/web` com fallback de SPA e conferir no navegador embutido (ou Chromium sem janela via CDP) em 390, 768 e 1280: `/publicacoes` (cabeçalho, migalhas por clique e Enter, nenhum item ativo na navbar, ordem dos blocos, intercalação de categorias e áreas por data, contagem total, chips, "Ver mais" até acabar, card de História e de Geografia abrindo o post certo, esqueleto anunciado, rede bloqueada e "Tentar de novo", busca: erro tratado sem índice e "Limpar" volta à lista); Home (link nos Destaques, posição em cada largura, foco e Enter); rodapé ("Publicações"); categoria (busca, vazio da busca, "Ver mais") e post sem mudança; sem rolagem horizontal; rodapé na base. Vazio da página com dados injetados num build de debug não commitado. Depois, `fvm flutter run -d web-server` na cópia ASCII (debug) em 390, 768 e 1280 em `/publicacoes` e na Home, sem `overflow` nem asserção no console. Voltar o navegador ao preset desktop e parar os servidores. Atende: critérios 1 a 12.
