# 014. Listagem de categoria e card de post

- **Status:** aprovada
- **Item do planejamento:** Fase 3: listagem de categoria e cards de post (T-11 fica na 015)
- **Protótipo:** aba "Categoria"; aba "Estados" para esqueleto, vazio e erro; aba "Post" para o card do "Leia também" (link no CLAUDE.md)
- **Criada em:** 2026-10-02
- **Depende de:** [010-leitura-manifesto](../010-leitura-manifesto/spec.md) (cabeçalho de página e migalhas), [011-nossa-historia-pessoa](../011-nossa-historia-pessoa/spec.md) (caixa de erro), [012-post-base](../012-post-base/spec.md) (cartão do "Leia também", 404 por área ou categoria inválida)

## Objetivo
Quem abre uma categoria vê logo na primeira tela o nome, a descrição e as publicações, em cards iguais em qualquer tipo, e consegue buscar por título e filtrar por tipo. O mesmo card passa a valer no "Leia também" do post e a listagem fica pronta para a página de todas as publicações (015).

## Situação atual
- [posts_page.dart](../../../lib/app/features/posts/presentation/pages/posts_page.dart): navbar, cabeçalho de 60% da altura com a imagem de fundo da categoria escurecida, título em caixa alta, descrição e botão "COLABORE"; depois um título "Categoria | Área" e o campo "Buscar por título"; depois um bloco por tipo, com fundos alternados. Carregando usa o indicador circular antigo; vazio e erro usam `EmptyContent` e `PageErrorContent` antigos, sem "tentar de novo". Categoria inexistente deixa a página carregando para sempre; área inválida lança exceção.
- [posts_section_list.dart](../../../lib/app/features/posts/presentation/components/posts_section_list.dart) e [post_card.dart](../../../lib/app/features/posts/presentation/components/card/post_card.dart): grade 1/2/3 colunas; card com imagem em `contain` (altura variável), título e subtítulo só para artigo; aumenta no hover; `GestureDetector`, sem foco por teclado nem nome acessível. Botão "Ver mais" por tipo. Usa `num_extension`.
- [fetch_posts_store.dart](../../../lib/app/features/posts/presentation/stores/fetch_posts_store.dart): 10 por página e por tipo. A ordem dos blocos depende de qual resposta chega primeiro. Com busca, "Ver mais" repete os mesmos resultados (a consulta de busca ignora o cursor). O último "Ver mais" pode trazer página vazia.
- [related_post_card.dart](../../../lib/app/features/posts/presentation/components/post/related_post_card.dart) (012): cartão novo do "Leia também", já no desenho do protótipo, só para artigo.
- Destaques da Home (005) usam outro cartão, com imagem de fundo e título sobre degradê.

## Comportamento

### Cabeçalho da categoria
Faixa em fundo de superfície com linha embaixo, na largura do site (cabeçalho de página da 010):
1. **Migalhas:** "Início" (Home) › área ("História" ou "Geografia", texto sem link) › nome da categoria (página atual).
2. **Título:** nome da categoria como cadastrado (sem caixa alta forçada), nível 1.
3. **Descrição** da categoria abaixo, em cor secundária. Some se vazia.
4. **"Colabore com esta categoria"**: botão secundário, abaixo da descrição, só quando a categoria tem `hasCollaborateOption`. Abre `/colaborar`.
A imagem de fundo da categoria deixa de aparecer (o dado continua no banco).

### Barra de busca e filtros
Logo abaixo do cabeçalho, na largura do site:
- **Busca:** campo com lupa à esquerda, texto de ajuda "Buscar por título" e nome acessível "Buscar por título". Busca pelo começo do título, sem diferenciar maiúsculas (como hoje). Pesquisa sozinha depois que a pessoa para de digitar (~400 ms) e também ao apertar Enter. Com texto, aparece o botão "Limpar" dentro do campo, que apaga a busca e devolve o foco ao campo.
- **Chips de tipo:** "Todos" e um chip por tipo que tem publicação na categoria (com a busca atual), no plural ("Artigos", "Filmes"…), cada um com a quantidade ao lado ("Artigos 6"). Seleção única; "Todos" vem marcado. O marcado tem fundo de tinta e texto branco. Só aparecem quando há **dois ou mais** tipos com publicações; com um tipo só, a fileira some.
- **Contagem:** linha abaixo, em cor secundária: "1 publicação", "12 publicações"; com busca, "3 publicações para “mapa”". Conta todas as publicações do filtro escolhido, não só as já carregadas. É anunciada a leitores de tela quando muda.
- Ao trocar de categoria pelo menu, a busca e o chip voltam ao início.

### Publicações
- Um **bloco por tipo**, na ordem dos tipos da categoria. Cada bloco tem o título do tipo no plural com a quantidade ao lado, menor e em cor secundária ("Artigos · 6 publicações"), e a grade de cards. Tipos sem publicação não aparecem. Com "Todos", aparecem todos os blocos; com um tipo marcado, só o bloco dele.
- Dentro do bloco, do mais recente para o mais antigo; com busca, em ordem alfabética do título (limite da busca por prefixo).
- **Grade:** colunas de no mínimo 300 px, vão de 28 px entre colunas e 36 px entre linhas: 1 coluna em 390, 2 em 768, 3 em 1280.
- **Paginação:** 12 cards por tipo de cada vez. Se houver mais, aparece "Ver mais [tipo no plural, minúsculo]" ("Ver mais artigos"), botão secundário centralizado abaixo da grade. Enquanto carrega, o botão fica desativado com "Carregando…" e os cards já mostrados continuam no lugar. O botão some quando não há mais nada (sem clique que traga página vazia). Com busca, "Ver mais" continua de onde parou.

### Card de post (novo, para todos os tipos)
O card inteiro é um link para o post.
1. **Imagem** 16:10, cantos arredondados, preenchida sem distorcer (recorte centralizado). Sem imagem ou com falha: placeholder na mesma proporção, laranja suave com ícone de imagem.
2. **Rótulo do tipo**, no singular e em caixa alta ("ARTIGO", "FILME"), em laranja forte.
3. **Título** do post, até 3 linhas com reticências.
4. **Resumo** em cor secundária, até 2 linhas com reticências (some se vazio). Na listagem aparece; no "Leia também" não (como no protótipo).
5. **Linha de detalhes** em texto pequeno e cor secundária, com as partes vazias omitidas (some se tudo vazio).

| Tipo | Resumo | Detalhes |
|---|---|---|
| Artigo | subtítulo | autores ("A, B e C") · data "março de 2026" |
| Livro | sinopse | autor(a) · ano |
| Filme | sinopse (texto do editor, sem formatação) | "Direção: [nome]" · ano de lançamento |
| Evento | detalhes | data como cadastrada · cidade |
| Podcast | descrição | — |
| Música | descrição | artista |
| Revista | chamada; sem chamada, a descrição | — |
| Documento | descrição (texto do editor, sem formatação) | — |
| Produção acadêmica | resumo | autor · cidade e ano |
| Pesquisa | descrição | situação ("Em andamento" ou "Concluída") |

- **Hover** (mouse): a imagem sobe 4 px com sombra e o título fica laranja. Sem movimento quando o sistema pede menos movimento.
- **Foco:** anel de foco visível em volta do card; Enter abre o post.
- Abrir o post leva a `/publicacoes/:area/:category/:id`.

### "Leia também" do post (012)
Passa a usar o card novo, sem resumo. Conteúdo, regras (até 3 artigos da mesma categoria, sem o atual) e aparência não mudam. O cartão próprio da 012 deixa de existir.

### Destaques da Home
Não mudam: o desenho é outro (título sobre a imagem, primeiro maior). Ver decisões.

## Estados
- **Carregando a página** (categorias ainda não chegaram): esqueleto do cabeçalho (migalhas, título, duas linhas da descrição) e da grade.
- **Carregando as publicações** (cabeçalho já pronto, primeira página ou nova busca): fileira de chips e contagem somem e a grade vira esqueleto de cards: 3 em 1280, 2 em 768, 1 em 390 (retângulo 16:10, barra do rótulo, barra do título, barra dos detalhes). Parado com movimento reduzido. Anunciado como "Carregando".
- **Categoria sem publicações:** caixa de estado "Ainda não há publicações nesta categoria" e "Volte em breve ou explore outras categorias no menu." Sem botão. Busca e chips não aparecem.
- **Busca sem resultado:** caixa de estado com lupa, "Nenhuma publicação encontrada", "Tente outro termo ou limpe a busca." e o botão "Limpar busca", que apaga a busca e volta para "Todos". O campo de busca continua visível.
- **Erro** (falha ao buscar categorias ou a primeira página): no lugar das publicações (ou da página inteira, se as categorias falharam), a caixa de erro da 011: "Não foi possível carregar", "Verifique sua conexão e tente novamente." e "Tentar de novo", que refaz a busca uma vez por clique.
- **Erro no "Ver mais":** os cards já carregados ficam; o botão volta a ficar ativo e aparece, abaixo dele, "Não foi possível carregar mais publicações." em cor de erro. Novo clique tenta de novo.
- **Erro só na contagem:** a lista aparece normalmente; números dos chips, dos títulos de bloco e a linha de contagem somem.
- **Não encontrado:** área da URL diferente de "historia" e "geografia", ou categoria inexistente (com as categorias já carregadas): página 404 atual, sem ficar carregando para sempre.
- **Sem imagem / imagem com falha:** placeholder 16:10 (ver card).
- **Casos de borda:** categoria com 1 tipo (sem chips, com título do bloco), com vários tipos e só um com publicações (sem chips); 0, 1, 12 e 13+ publicações num tipo (13+ mostra "Ver mais"); título muito longo (3 linhas e reticências); resumo longo (2 linhas); nome de categoria e descrição longos quebram linha; imagem muito alta ou muito larga (recorte); busca com espaços nas pontas (ignorados) ou só com espaços (equivale a vazia).

## Responsivo
- **Celular (390):** margens de 20 px; busca na largura toda e chips abaixo, quebrando linha; 1 coluna de cards; título da categoria ≈ 32 px.
- **Tablet (768):** margens de 32 px; busca e chips na mesma linha quando cabem, senão chips abaixo; 2 colunas.
- **Desktop (1280):** conteúdo em 1120 px centralizado; busca com até 520 px e chips à direita; 3 colunas.
- Em todas: sem rolagem horizontal, sem `overflow`; com a janela alta e poucos itens, o rodapé fica na base.

## Acessibilidade
- Título da categoria como cabeçalho de nível 1; título de cada bloco de tipo como nível 2; título do card como texto do link.
- Migalhas como navegação "Você está em" (010); a área, sem link, não recebe foco.
- Campo de busca com nome "Buscar por título"; "Limpar" com nome "Limpar busca".
- Chips como botões de alternância, com estado marcado/desmarcado anunciado e nome com a quantidade ("Artigos, 6 publicações").
- Card lido como link: "[título], [tipo], [detalhes]". Imagem e placeholder decorativos.
- Contagem e caixas de estado anunciadas quando mudam.
- Ordem de Tab: navbar → migalhas → "Colabore" → busca → "Limpar" → chips → cards de cada bloco → "Ver mais" do bloco → rodapé. Foco visível em todos.
- Contraste ≥ 4,5:1 em migalhas, descrição, contagem, quantidade dos chips e dos blocos, rótulo do tipo, resumo, detalhes e textos de estado; nada em cinza claro.
- Movimento reduzido: esqueleto parado, card sem subir no hover.

## Dados e regras de negócio
- Categoria pelo `FetchCategoriesStore`; publicações pela consulta atual de posts publicados da categoria por tipo, com a busca por prefixo de `body.title_lower`.
- Quantidades por contagem no banco (mesmos filtros da listagem, por tipo; o total é a soma). Sem índice novo esperado: cada contagem usa filtros que as consultas atuais já usam.
- A listagem (busca, chips, blocos, paginação e estados) e o card não dependem da categoria para funcionar: a 015 vai usá-los em `/publicacoes` com publicações de todas as categorias, e o card abre o post a partir dos dados do próprio post.
- Modelos (`PostModel`, `CategoryModel` e os dos tipos), coleções e regras do Firebase não mudam. O painel não muda.
- Rotas não mudam: `/publicacoes/:area/:category` e o redirecionamento de `/posts/...` continuam. Busca e chip não vão para a URL.

## Critérios de aceite
1. [ ] Em `/publicacoes/:area/:category` a página mostra, nesta ordem: navbar, cabeçalho em fundo de superfície (migalhas "Início › [Área] › [Categoria]", título `h1` sem caixa alta forçada, descrição), barra de busca e chips, contagem, blocos por tipo e rodapé; a imagem de fundo da categoria não aparece.
2. [ ] Migalhas: "Início" abre a Home por clique e Enter; a área não é link nem recebe foco; a categoria é a página atual.
3. [ ] "Colabore com esta categoria" aparece só em categoria com `hasCollaborateOption` e abre `/colaborar` por clique e Enter; em categoria sem a opção, não aparece.
4. [ ] Busca: digitar um prefixo do título (em qualquer caixa) filtra depois da pausa e com Enter; "Limpar" aparece só com texto, apaga a busca e devolve o foco ao campo; espaços nas pontas são ignorados.
5. [ ] Chips: "Todos" mais um chip por tipo com publicações, com quantidade; seleção única que mostra só o bloco do tipo; somem com menos de dois tipos com publicações; voltam ao início ao trocar de categoria.
6. [ ] Contagem: "N publicação(ões)" com o total do filtro (não só o carregado) e "para “termo”" com busca, anunciada a leitores de tela.
7. [ ] Blocos na ordem dos tipos da categoria, cada um com título no plural e quantidade; tipos sem publicação não aparecem; itens do mais recente para o mais antigo (alfabético com busca).
8. [ ] Paginação: 12 por tipo; "Ver mais [tipo]" só quando há mais; durante a carga fica desativado com "Carregando…" e os cards ficam; nunca traz página vazia; com busca, continua sem repetir itens.
9. [ ] Card: imagem 16:10 com recorte (alta e larga conferidas), placeholder sem imagem e com falha forçada, rótulo do tipo em caixa alta, título até 3 linhas, resumo até 2 linhas e detalhes conforme a tabela de tipos (conferido ao menos em artigo e em um outro tipo existente no banco).
10. [ ] Card abre o post por clique e Enter, tem foco visível e nome acessível "[título], [tipo], [detalhes]"; no hover a imagem sobe e o título fica laranja; sem movimento com movimento reduzido.
11. [ ] "Leia também" do post usa o mesmo card, sem resumo, com o mesmo conteúdo e regras da 012; o cartão próprio da 012 não existe mais.
12. [ ] Carregando: acesso direto mostra o esqueleto do cabeçalho e da grade; nova busca mostra o esqueleto da grade com o cabeçalho e a busca no lugar; anunciado como "Carregando".
13. [ ] Vazio: categoria sem publicações mostra "Ainda não há publicações nesta categoria" sem busca nem chips; busca sem resultado mostra "Nenhuma publicação encontrada" com "Limpar busca", que restaura a lista em "Todos".
14. [ ] Erro: com a rede bloqueada, aparece "Não foi possível carregar" com "Tentar de novo", que carrega com a rede de volta; falha no "Ver mais" mantém os cards e mostra a mensagem abaixo do botão; falha só na contagem esconde os números e mantém a lista.
15. [ ] Não encontrado: área inválida e categoria inexistente mostram a 404, sem carregar para sempre nem exceção no console.
16. [ ] Contraste ≥ 4,5:1 nos textos listados em "Acessibilidade"; ordem de Tab conforme "Acessibilidade", com foco visível; chips anunciados como alternância com estado.
17. [ ] Em 390, 768 e 1280 px conforme "Responsivo" (1, 2 e 3 colunas): sem rolagem horizontal, sem sobreposição e sem `overflow`, em release e em debug; rodapé na base com poucos itens.
18. [ ] Código novo usa só tokens de `lib/app/theme/` e não usa `num_extension`; a listagem e o card não usam mais `PostsSectionList`, `CategoryHeader`, `ActionsHeader`, `EmptyContent`, `PageErrorContent`, `LoadingContent` nem `GestureDetector` solto; listagem e card recebem a origem das publicações de fora, sem exigir categoria (pronto para a 015); `fvm flutter analyze` sem problemas novos e `fvm flutter build web --release` sem erro.

## Fora do escopo
- T-11, página `/publicacoes` com todas as publicações, e o link "Ver todas as publicações" dos Destaques: spec 015.
- Card dos Destaques da Home (desenho próprio, não muda).
- Busca que ignore acentos, por várias palavras ou em outros campos (limite do `title_lower`; ideia futura 9.1).
- Guardar busca e chip na URL.
- Redesenho da página Colabore e da 404 (Fase 5).
- Item ativo da navbar e título da aba do navegador (ficam como hoje).
- Apagar componentes antigos (`PostCard` antigo, `PostsSectionList`, `CategoryHeader`, `ActionsHeader`, `EmptyContent`…) se ainda usados em outro lugar: a limpeza é da Fase 7.
- Mudar modelos, regras ou índices do Firebase, painel ou rotas. Painel administrativo, Geoensine e modo escuro.

## Perguntas em aberto
- Nenhuma. Respondidas no modo autônomo:
  - **Card unificado com o "Leia também".** Decidido no modo autônomo: o "Leia também" passa a usar o card desta spec, sem resumo, porque o protótipo usa o mesmo `.card` nas duas telas e o cartão da 012 já tinha esse desenho; manter dois evitaria nada e duplicaria código.
  - **Destaques da Home fora da unificação.** Decidido no modo autônomo: não mudam, porque o protótipo usa outro desenho (`feat`: título sobre a imagem, primeiro maior), aprovado na 005.
  - **Blocos por tipo, não lista única.** Decidido no modo autônomo: um bloco por tipo com "Ver mais" próprio, porque é o que o protótipo mostra e a consulta atual já é por tipo (com índices prontos); misturar tipos numa lista exigiria consulta e índice novos.
  - **Quantidades.** Decidido no modo autônomo: contagem no banco por tipo, com os mesmos filtros da listagem, porque o protótipo mostra números nos chips e no bloco e a biblioteca já usa contagem; `numberOfPosts` da categoria não serve (não separa tipo nem publicado). Falha na contagem esconde só os números.
  - **Texto da contagem.** Decidido no modo autônomo: "N publicações" (sem "Mostrando"), porque com paginação a lista mostra só parte e "Mostrando 40" seria falso.
  - **Chips só com dois ou mais tipos.** Decidido no modo autônomo: com um tipo só, os chips não filtram nada e viram ruído; o título do bloco já diz o tipo.
  - **Página de 12.** Decidido no modo autônomo: 12 por tipo (antes 10), porque fecha linhas inteiras em 1, 2 e 3 colunas.
  - **Ordem com busca.** Decidido no modo autônomo: alfabética, porque a busca por prefixo no Firestore exige ordenar pelo título; a ordem por data só sem busca.
  - **Migalhas e cabeçalho.** Decidido no modo autônomo: "Início › Área › Categoria" com área sem link e cabeçalho de página da 010, como no protótipo e na 012 (não existe página da área). Sem imagem de fundo, porque o protótipo troca o cabeçalho alto por um compacto em superfície.
  - **Texto do botão Colabore.** Decidido no modo autônomo: "Colabore com esta categoria", botão secundário, como no protótipo; a regra `hasCollaborateOption` continua (planejamento, decisão "Rodapé: Colabore").
  - **Resumo e detalhes por tipo.** Decidido no modo autônomo: tabela da seção "Card", com os campos que cada tipo já tem, porque o protótipo só mostra artigo ("autor · data") e filme ("Direção · ano") e os demais seguem a mesma lógica; campos do editor rico viram texto simples.
  - **Estados vazios.** Decidido no modo autônomo: textos da aba "Estados" para busca sem resultado (trocando "remova algum filtro" por "limpe a busca", já que os chips nunca levam a vazio) e um texto próprio para categoria sem publicações, porque são situações diferentes e a segunda não tem o que limpar.
  - **Busca e chip na URL.** Decidido no modo autônomo: ficam de fora, porque o planejamento não pede e acrescentaria parâmetros de rota; a 015 pode rever se precisar.

## Histórico de mudanças
- 2026-10-02: criada e aprovada no modo autônomo (execução da Fase 3).
- 2026-10-02: plano e tarefas criados (`plan.md`, `tasks.md`).
