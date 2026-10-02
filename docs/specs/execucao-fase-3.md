# Execução da Fase 3

- **Início:** 2026-10-02
- **Término:** 2026-10-02
- **Branch:** refactor/redesign-fase-3 → PR para develop

| Spec | Itens | Spec+plano | Implementação | Verificação | Resultado |
|---|---|---|---|---|---|
| 014-listagem-categoria | cards de post, listagem de categoria | feita (18 critérios, 12 tarefas) | feita (5 commits) | feita (2 `fix:`) | verificada |
| 015-todas-publicacoes | T-11, link "Ver todas" dos Destaques | feita (13 critérios, 9 tarefas) | feita (3 commits) | feita (sem `fix:`; 1 correção de doc) | verificada com ressalvas |

## Divisão
- 014 cria o card de post do novo desenho e o aplica na listagem da categoria (cabeçalho, busca, chips de tipo, grade, paginação e estados).
- 015 reaproveita a listagem da 014 em `/publicacoes`, sem filtro de categoria e com consulta em todas as categorias, e devolve o link "Ver todas as publicações" aos Destaques da Home.

## Decisões tomadas sem a pessoa
- 014: card novo unificado com o "Leia também" do post (sai o `RelatedPostCard`; Destaques da Home mantêm card próprio); um bloco por tipo com "Ver mais", 12 itens por vez; chips com quantidade só com 2+ tipos (some só o número se a contagem falhar); "N publicações"; com busca, ordem alfabética; cabeçalho de página da 010 com migalhas e sem imagem de fundo; "Colabore com esta categoria" só com `hasCollaborateOption`; categoria vazia e busca vazia com caixas diferentes; área/categoria inexistente → 404; busca e chip fora da URL; `FetchPostsStore` vira `PostsListingStore`, pronto para a 015. Detalhes em [014/spec.md](014-listagem-categoria/spec.md).
- 015: mesma listagem da 014 em `/publicacoes` (blocos por tipo em ordem alfabética, cada um por data); cabeçalho "Todas as publicações" sem Colabore; card sem categoria; link "Ver todas as publicações" nos Destaques; "Publicações" no rodapé, navbar sem item novo; índice da busca documentado em `docs/deploy-ambientes.md`, sem `firestore.indexes.json`. Detalhes em [015/spec.md](015-todas-publicacoes/spec.md).

## Ressalvas
- 014: sem ressalvas. Não conferidos com rede real: categoria vazia, erro só na contagem e no "Ver mais" (cobertos com falha injetada na implementação); leitor de tela real.
- 015: a busca em `/publicacoes` precisa de índice novo (grupo de coleções `category_posts`: `isPublished`, `type`, `body.title_lower`, crescentes) em prod e dev; sem ele, mostra erro tratado. A pessoa publica.
- 015 (verificação): erro de rede conferido com falha injetada no datasource (não com rede cortada); leitor de tela real não conferido.

## Ocorrências
- 014: na implementação, o `count()` sem `orderBy` falhava em prod (`failed-precondition`); a contagem passou a usar a mesma consulta da lista, sem índice novo. Corrigido de passagem um rastro dos ícones sociais do rodapé ao carregar (`fix:` próprio, fora do escopo).
- 014 (verificação): offline, o Firestore devolvia cache vazio e a categoria e o post caíam na 404; consulta vazia do cache virou erro (`fix:` próprio). Esqueletos passaram a anunciar "Carregando".
- 014 (verificação): `dart format` na pasta com "ó" não lê o `analysis_options.yaml` e formata com largura 80; formatar na cópia ASCII e copiar de volta.
- 014 (verificação): o navegador embutido não pinta com o painel escondido; telas conferidas num Chromium sem janela via CDP.
- 015 (verificação): `deploy-ambientes.md` dizia que dev e prod usam o mesmo Firebase; o dev usa `observatorio-geo-hist-dev`, e só o Storage da biblioteca e das mídias do painel aponta fixo para o bucket de prod. Texto corrigido.
