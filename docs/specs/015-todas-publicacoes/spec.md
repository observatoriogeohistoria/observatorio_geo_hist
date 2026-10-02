# 015. Todas as publicações e "Ver todas" nos Destaques

- **Status:** aprovada
- **Item do planejamento:** Fase 3, tela T-11 (seção 3)
- **Protótipo:** aba "Categoria" (mesma listagem, sem tela própria para T-11); aba "Home", bloco "Destaques", para o link; aba "Estados" (link no CLAUDE.md)
- **Criada em:** 2026-10-02
- **Depende de:** [014-listagem-categoria](../014-listagem-categoria/spec.md) (listagem, card, estados), [010-leitura-manifesto](../010-leitura-manifesto/spec.md) (cabeçalho de página e migalhas), [005-destaques](../005-destaques/spec.md) (bloco dos Destaques)

## Objetivo
Quem quer ver tudo o que o Observatório publicou, sem escolher antes uma categoria, ganha a página `/publicacoes`, com a mesma busca, filtro por tipo, cards e paginação da categoria. Na Home, os Destaques voltam a ter o link "Ver todas as publicações", que leva a ela.

## Situação atual
- Não existe página em `/publicacoes`: o endereço cai na 404. `AppRoutes.publications` existe só como prefixo das rotas de categoria e post.
- A listagem da 014 ([posts_listing.dart](../../../lib/app/features/posts/presentation/components/listing/posts_listing.dart), [posts_listing_store.dart](../../../lib/app/features/posts/presentation/stores/posts_listing_store.dart)) já aceita escopo sem categoria, e o datasource já consulta `collectionGroup('category_posts')` sem filtro de categoria. O texto de "vazio" fala em "nesta categoria".
- [highlights_section.dart](../../../lib/app/features/home/presentation/components/highlights/highlights_section.dart): título "Destaques" sozinho; o link do protótipo saiu na 005 porque não havia página.
- Rodapé, coluna "Explorar": "Sobre" e "Biblioteca". Navbar: Sobre, História, Geografia, Biblioteca.

## Comportamento

### Página `/publicacoes`
Mesmo esqueleto da categoria (014), na largura do site:
1. **Cabeçalho de página** (010) em fundo de superfície com linha embaixo:
   - Migalhas: "Início" (Home) › "Publicações" (página atual).
   - Título `h1`: "Todas as publicações".
   - Descrição: "Artigos, livros, filmes, eventos e outros materiais de todas as categorias de História e Geografia."
   - Sem botão "Colabore" (é por categoria).
2. **Busca, chips e contagem** iguais aos da 014: busca por começo do título; chips "Todos" e um por tipo com publicações, com quantidade; "N publicações" (com busca, "N publicações para “termo”").
3. **Um bloco por tipo**, com os tipos em ordem alfabética do nome no plural ("Artigos", "Documentos", "Eventos", "Filmes e Vídeos", "Livros"…). Tipos sem publicação não aparecem.
4. Dentro de cada bloco, publicações de todas as categorias e das duas áreas, **da mais recente para a mais antiga** (data de publicação); com busca, em ordem alfabética do título (mesmo limite da 014).
5. **Paginação:** 12 por tipo; "Ver mais [tipo]" igual à 014.
6. **Card:** o mesmo da 014, com resumo. Abre o post no endereço de sempre, `/publicacoes/:area/:categoria/:id`, montado com a área e a categoria do próprio post.

O cabeçalho aparece na hora (não depende de dados); só a listagem carrega.

### Destaques da Home
- À direita do título "Destaques", alinhado à base dele, o link "Ver todas as publicações" com seta (mesmo link com seta de "Ler a história completa" e "Mais em…"). Abre `/publicacoes`.
- No celular, o link fica abaixo do título, alinhado à esquerda.
- Aparece junto com a seção: carregando, com erro e com destaques. Quando não há destaques a seção inteira some (005), e o link com ela.

### Rodapé
Coluna "Explorar" passa a ter "Sobre", "Publicações" e "Biblioteca", nessa ordem. "Publicações" abre `/publicacoes`.

### Navbar
Não muda (ver decisões). Em `/publicacoes` nenhum item fica ativo.

## Estados
- **Carregando:** cabeçalho pronto e esqueleto da grade (como a 014), anunciado como "Carregando".
- **Vazio (nenhuma publicação no site):** caixa de estado "Ainda não há publicações" e "Volte em breve." Sem busca nem chips.
- **Busca sem resultado:** igual à 014 ("Nenhuma publicação encontrada", "Limpar busca").
- **Erro:** caixa de erro da 011 no lugar das publicações ("Não foi possível carregar", "Tentar de novo"). Vale também para a busca: se a busca falhar, aparece a caixa de erro e o campo continua visível com "Limpar", que volta à lista sem busca. Erro no "Ver mais" e só na contagem: iguais à 014.
- **Sem imagem / imagem com falha:** placeholder do card (014).
- **Casos de borda:** um tipo só com publicações (sem chips); 13+ num tipo ("Ver mais"); post sem área cadastrada fica fora da lista (não há como montar o endereço; não deve existir); post de categoria apagada abre a 404 do post, como hoje; `/publicacoes/` com barra no fim abre a mesma página.

## Responsivo
- **Celular (390):** como a categoria na 014 (1 coluna, busca na largura toda, chips abaixo). Destaques: link abaixo do título.
- **Tablet (768):** 2 colunas. Destaques: título e link na mesma linha quando cabem.
- **Desktop (1280):** conteúdo em 1120 px, 3 colunas. Destaques: título à esquerda e link à direita.
- Em todas: sem rolagem horizontal nem `overflow`; rodapé na base com poucos itens.

## Acessibilidade
- "Todas as publicações" como cabeçalho de nível 1; título de cada bloco como nível 2 (014).
- Migalhas como navegação "Você está em"; "Publicações" como página atual.
- Link dos Destaques e do rodapé: foco visível, nome "Ver todas as publicações" e "Publicações", abrem por clique e Enter.
- Ordem de Tab na página: navbar → migalhas → busca → "Limpar" → chips → cards de cada bloco → "Ver mais" → rodapé. Na Home: título dos Destaques → "Ver todas as publicações" → cards.
- Contraste ≥ 4,5:1 nos mesmos textos da 014 e no link (laranja forte).

## Dados e regras de negócio
- Publicações pela consulta da 014 sem filtro de categoria: posts publicados de `category_posts` (todas as categorias), por tipo, mais recentes primeiro. Quantidades por contagem no banco, com os mesmos filtros.
- **Índice:** a lista e a contagem sem busca usam um índice que já existe (conferido no Firebase de produção e de dev, só leitura). A **busca sem categoria precisa de um índice novo** (publicados + tipo + título em minúsculas, em todas as subcoleções `category_posts`), que não existe em nenhum dos dois projetos. Até ele ser publicado, buscar em `/publicacoes` mostra a caixa de erro. A definição do índice fica registrada em `docs/deploy-ambientes.md`. A busca da categoria não é afetada.
- Modelos, coleções, regras e índices do Firebase não mudam por esta spec (o índice é publicado pela pessoa, fora do código). Painel não muda.
- Rotas existentes não mudam. Rota nova: `/publicacoes`, via `AppRoutes`. Busca e chip não vão para a URL.

## Critérios de aceite
1. [ ] `/publicacoes` abre a página com navbar, cabeçalho (migalhas "Início › Publicações", `h1` "Todas as publicações", descrição), busca e chips, contagem, blocos por tipo e rodapé; sem botão "Colabore"; nenhum item da navbar ativo.
2. [ ] Migalhas: "Início" abre a Home por clique e Enter; "Publicações" é a página atual.
3. [ ] Blocos de tipos em ordem alfabética do plural, com publicações de categorias e áreas diferentes, cada bloco do mais recente para o mais antigo; a contagem "N publicações" bate com o total de publicados (soma dos tipos).
4. [ ] Chips: "Todos" + um por tipo com quantidade; marcar um mostra só o bloco dele.
5. [ ] Paginação: 12 por tipo; "Ver mais [tipo]" traz os próximos sem repetir e some quando acaba.
6. [ ] Card abre o post certo (`/publicacoes/:area/:categoria/:id`) por clique e Enter, conferido em posts de História e de Geografia.
7. [ ] Busca: com o índice publicado, filtra por prefixo como na 014; sem o índice, mostra a caixa de erro e "Limpar" volta à lista; em nenhum caso fica carregando para sempre ou quebra a página.
8. [ ] Estados: esqueleto ao carregar (anunciado "Carregando"); erro com rede bloqueada e "Tentar de novo" que recupera; texto de vazio da página "Ainda não há publicações" (conferido com dados injetados); a categoria continua com "Ainda não há publicações nesta categoria".
9. [ ] Destaques da Home: "Ver todas as publicações" com seta à direita do título (abaixo no celular), abre `/publicacoes` por clique e Enter, com foco visível; aparece no carregando, no erro e com destaques.
10. [ ] Rodapé: "Explorar" com "Sobre", "Publicações" e "Biblioteca"; "Publicações" abre `/publicacoes`.
11. [ ] A página da categoria (014), o post e a Home continuam iguais fora do link e do rodapé.
12. [ ] Em 390, 768 e 1280 px: `/publicacoes` com 1, 2 e 3 colunas, Destaques com o link no lugar, sem rolagem horizontal nem `overflow`, em release e em debug.
13. [ ] Código novo só com tokens de `lib/app/theme/`, sem `num_extension`; rota pela constante de `AppRoutes`; definição do índice registrada em `docs/deploy-ambientes.md`; `fvm flutter analyze` sem problemas novos e `fvm flutter build web --release` sem erro.

## Fora do escopo
- Criar ou publicar índice no Firebase (a pessoa publica; ver ressalvas).
- Lista única misturando tipos por data (exigiria índice novo também sem busca).
- Mostrar a categoria ou a área no card.
- Página por área (`/publicacoes/historia`), item na navbar, busca global da navbar (ideia futura).
- Guardar busca e chip na URL; título da aba do navegador.
- Card dos Destaques, painel administrativo, Geoensine e modo escuro.

## Perguntas em aberto
- Nenhuma. Respondidas no modo autônomo:
  - **Desenho da página.** Decidido no modo autônomo: mesma listagem da categoria (014), com cabeçalho "Todas as publicações", porque o protótipo não tem tela própria para T-11 e o link dos Destaques leva à tela de categoria; o planejamento pede "mesma listagem, sem o filtro de categoria".
  - **Blocos por tipo, não lista única por data.** Decidido no modo autônomo: um bloco por tipo, cada um por data, porque a consulta por tipo e data sem categoria já tem índice nos dois projetos (conferido) e a lista única por data pediria índice novo (conferido: falha sem ele). Também mantém igual à categoria.
  - **Ordem dos blocos.** Decidido no modo autônomo: alfabética do plural, porque sem categoria não há ordem cadastrada e a ordem do código (nomes em inglês) não faz sentido para quem lê.
  - **Busca sem índice.** Decidido no modo autônomo: a busca fica (o planejamento pede a mesma listagem) e depende do índice novo; sem ele, mostra o erro tratado. Alternativas descartadas: filtrar publicados no navegador sobre o índice do painel (leria rascunhos, quebraria contagem e paginação) e buscar categoria por categoria (dezenas de consultas por busca).
  - **Arquivo de índice.** Decidido no modo autônomo: o projeto não tem `firestore.indexes.json`; criar um só com este índice faria um `firebase deploy` de índices propor apagar os que existem. A definição vai para `docs/deploy-ambientes.md`, com os campos e o escopo.
  - **Card sem categoria.** Decidido no modo autônomo: o card é o mesmo da 014, porque o protótipo não mostra categoria no card e mudá-lo afetaria a categoria e o "Leia também". Fica como ideia futura.
  - **Navbar e rodapé.** Decidido no modo autônomo: a navbar não ganha item, porque o protótipo e a 002 fixaram Sobre, História, Geografia e Biblioteca; o rodapé ganha "Publicações" em "Explorar", que é a lista de páginas do site e tem espaço, dando uma segunda entrada além dos Destaques (que somem sem destaques).
  - **Link nos Destaques.** Decidido no modo autônomo: texto e posição do protótipo, com o `ArrowLink` já usado em "Mais em…"; no celular abaixo do título, como no "Leia também" (012).
  - **Texto de vazio.** Decidido no modo autônomo: "Ainda não há publicações" e "Volte em breve.", porque o texto da categoria cita "nesta categoria" e "outras categorias no menu".

## Ressalvas
- **Índice da busca (bloqueia a busca em `/publicacoes`, não a página).** Publicar nos projetos `observatorio-geo-hist` e `observatorio-geo-hist-dev` o índice composto de grupo de coleções `category_posts`: `isPublished` crescente, `type` crescente, `body.title_lower` crescente. Até lá, a busca dessa página mostra erro. Recomendado publicar antes de levar à `main`.

## Histórico de mudanças
- 2026-10-02: criada e aprovada no modo autônomo (execução da Fase 3).
- 2026-10-02: plano e tarefas criados (`plan.md`, `tasks.md`).
