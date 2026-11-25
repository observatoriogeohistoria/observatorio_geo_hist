# 034. Páginas pré-geradas para o Google

- **Status:** implementada
- **Origem:** pedido de 2026-11-24 (indexação, etapa 3), seguindo o que o expoGEO já faz em `tool/seo/`
- **Protótipo:** não se aplica (nenhuma tela muda)
- **Criada em:** 2026-11-24

## Objetivo
Cada endereço público do site passa a responder, no servidor, com um HTML que já traz título, descrição, texto e dados estruturados do conteúdo. O Google deixa de depender de executar o Flutter para entender a página. Quem abre o site no navegador continua vendo o app de sempre.

## Situação atual
- O app é uma página só (`web/index.html`). O `.htaccess` manda qualquer rota desconhecida para ela, então todo endereço devolve o mesmo HTML, com o título e a descrição da home.
- As metas por rota (título, descrição, canonical) são aplicadas pelo app depois que ele abre (#44). Quem não executa JavaScript não as vê.
- `web/robots.txt` existe só para produção; o deploy de dev o troca por `Disallow: /`. Não há sitemap.
- Posts ficam em `posts/{categoryId}/category_posts`; a categoria é o documento pai, com `key` igual ao id numérico. Documentos da biblioteca estão em `library` (602 hoje) e a equipe em `team`.

## Comportamento

### Execução
- Um comando só, depois do `flutter build web` e antes do envio por FTP: `fvm flutter test tool/seo/<arquivo>.dart --dart-define=APP_ENV=dev|prod`. É teste porque os modelos do app importam o Flutter.
- O ambiente vem de `APP_ENV` e escolhe o projeto Firebase e o endereço de origem (`https://observatoriogeohistoria.net.br` em produção, `https://dev.observatoriogeohistoria.net.br` no dev).
- Os dados vêm da API REST pública do Firestore, sem login:
  - **Posts:** uma consulta (`runQuery`) por categoria, com `isPublished == true`. As categorias são lidas de `posts`.
  - **Biblioteca:** todos os documentos, qualquer que seja o `status` antigo. O endereço usa o id do documento no Firestore.
  - **Equipe:** coleção `team`; só entra quem tem página no site (id e descrição preenchidos).

### O que é gerado
Para cada rota pública, um arquivo HTML com o nome da rota (`/contato` vira `contato.html`; `/publicacoes/historia/livros/abc` vira `publicacoes/historia/livros/abc.html`). A home reescreve o `index.html` do build.

| Rota | Conteúdo |
|---|---|
| `/` e páginas fixas (`/nossa-historia`, `/manifesto`, `/contato`, `/colaborar`, `/biblioteca`, `/publicacoes`) | Metas atuais de cada uma, texto e links principais |
| `/publicacoes/:area/:category` (e `…/pagina/N`) | Meta da categoria, texto de apresentação e a lista de títulos com link, 50 por página |
| `/publicacoes/:area/:category/:id` | Meta do post, título, resumo e texto |
| `/biblioteca/:area` (e `…/pagina/N`) | Meta da área e a lista de documentos com link, 50 por página |
| `/biblioteca/:area/documento/:id` | Meta do documento (autor, instituição, ano) |
| `/membro/:id` | Meta e texto do membro |

- Páginas de listagem: a primeira é o próprio endereço da categoria ou da área; a segunda em diante é `/pagina/2`, `/pagina/3`… Cada uma tem canonical para si mesma e links para a anterior e a próxima.
- Cada página traz as metas (título, descrição, canonical, Open Graph e Twitter) trocadas, um **bloco de texto oculto** com o conteúdo (invisível para quem usa o site, presente no HTML) e **JSON-LD** adequado ao tipo (organização e site na home, artigo no post, trilha de migalhas, página de coleção nas listagens).
- **Canonical de post:** usa a primeira área do post (`areas.first`), como a página "Todas as publicações" já monta o link. Post sem área fica de fora e é avisado no relatório.
- Texto vindo do Firestore é escapado antes de entrar no HTML e no JSON-LD. Em especial, `<` dentro do JSON-LD sai como `<`, para um título nunca fechar a tag `<script>`.

### Só em produção
- `sitemap.xml` único com todas as páginas geradas. `lastmod` vem de `updatedAt` nos posts e de `createdAt` nos documentos da biblioteca (que não têm `updatedAt`); sem o campo, a linha não leva `lastmod`. Nas listagens, vale a data mais nova entre os itens da página.
- Páginas sem `noindex`.

### No dev
- Cada página leva `<meta name="robots" content="noindex, nofollow">`; nenhum `sitemap.xml`.

### Falha fechada
O comando termina com erro, e o deploy não segue para o FTP, quando:
- uma leitura do Firestore falha depois das tentativas (3, com espera);
- o Firestore devolve zero categorias, zero posts publicados no total ou zero documentos na biblioteca;
- falta no `index.html` do build alguma tag que a geração precisa trocar (título, descrição, canonical, Open Graph, `</head>`, `<body>`);
- um endereço sai fora do padrão (cada trecho só com `A-Z`, `a-z`, `0-9`, `_` e `-`, começando por letra ou número) ou o arquivo de destino já existe no build, exceto o `index.html` da home. Nada do build é sobrescrito, e um id estranho do Firestore nunca grava fora de `build/web`.

Ao final imprime um resumo: quantas páginas por tipo, posts ignorados e se gerou sitemap.

### Regras do `.htaccess`
Acrescentar às que existem as três do expoGEO:
1. `DirectorySlash Off`.
2. `/x/` redireciona (301) para `/x`.
3. `/x` é atendido por `x.html` quando o arquivo existe; senão, segue a regra atual (`index.html`).

As regras de `www`, `https` e arquivos ocultos continuam valendo e não encadeiam redirecionamentos (um só salto). Pastas reais como `/assets` não mostram listagem.

### Reavaliação (só documentar)
Em `docs/deployment.md`, uma seção curta com o gatilho e as saídas em ordem de custo crescente. Nada disso é implementado agora.
- **Gatilho:** perto de 10 mil páginas, deploy acima de 15 minutos ou aviso de inodes da HostGator.
- **Saídas, em ordem:** (1) parar de gerar as páginas de listagem além da primeira, mantendo só itens no sitemap; (2) gerar só o que mudou desde o último deploy; (3) renderizar no servidor sob demanda (PHP/rewrite) em vez de arquivos; (4) mover o site para hospedagem com pré-renderização (por exemplo, Firebase Hosting).
- **Estimativa de hoje:** cerca de 1.100 a 1.300 arquivos novos por ambiente. Inodes da conta: 58.558 de ilimitado.

## Estados
- **Carregando / vazio / erro:** não há tela. Erro é o comando falhando com mensagem em português (ver "Falha fechada"). Coleção vazia é erro, não "nada a gerar".
- **Sem imagem:** a página gerada não depende de imagem; o `og:image` continua o do `index.html`.
- **Casos de borda:** categoria sem posts (gera a página com texto de apresentação e sem lista, sem paginação); exatamente 50 itens (uma página só); 51 itens (duas); título ou resumo com `<`, `&`, aspas, ` ` ou emoji; post sem corpo (usa a descrição padrão de `RouteMeta`).

## Responsivo
Não se aplica. O bloco oculto não aparece em nenhuma largura nem desloca o app (sem rolagem, sem salto de layout) em 390, 768 e 1280 px.

## Acessibilidade
- O bloco oculto não pode entrar na árvore de acessibilidade nem atrapalhar o foco: leitores de tela e o Tab continuam vendo só o app.
- Nenhum texto gerado muda a navegação por teclado do app depois que ele abre.

## Dados e regras de negócio
- O Firestore não muda. As regras já permitem a leitura pública de posts publicados, biblioteca e equipe; se alguma consulta der 403 em produção, é falha (e a causa vai para a regra, não para o gerador).
- Coleção `team` e `library`: mesmos campos usados pelo app; nada é gravado.
- O texto vem dos mesmos modelos e das mesmas funções de meta do app (`RouteMeta`, `plainTextFromRich`), para a página gerada e a que o app monta dizerem a mesma coisa.
- Mudanças fora de `tool/`: `web/.htaccess`, `docs/deployment.md` e, para as listagens `…/pagina/N` abrirem direito para pessoas, uma rota no app que leva ao endereço base da categoria ou da área.

## Critérios de aceite
- [ ] Gerar com `APP_ENV=prod` cria um HTML por rota da tabela, mais `sitemap.xml`, sem sobrescrever nenhum arquivo do build (exceto o `index.html` da home).
- [ ] Gerar com `APP_ENV=dev` cria as mesmas páginas com `noindex, nofollow` e sem `sitemap.xml`.
- [ ] A contagem de páginas confere com o Firestore: todas as categorias, todos os posts publicados com área, os 602 documentos e os membros com página.
- [ ] Em cada página: título, descrição, canonical, `og:url` e JSON-LD são os da rota; o canonical de post usa `areas.first`.
- [ ] Uma categoria com 120 posts gera 3 páginas (50, 50, 20) com canonical e links de anterior e próxima corretos; a lista de links não repete itens entre páginas.
- [ ] `lastmod` do sitemap vem de `updatedAt` nos posts e de `createdAt` nos documentos; item sem o campo fica sem `lastmod`.
- [ ] Testes automatizados passam para: escape de HTML, JSON-LD com `<`, `</script>`, `&` e aspas (saída com `<`, JSON válido ao reler), sitemap (escape de XML), validação de caminho (`..`, ponto, espaço, barra dupla, trecho vazio; maiúsculas e `_` são aceitas) e recusa de sobrescrever arquivo do build.
- [ ] O comando falha, com mensagem em português, para: erro de rede após 3 tentativas, coleção vazia e `index.html` sem uma das tags.
- [ ] Num Apache local com a estrutura real do build (`build/web` gerado, pastas `assets`, `icons`, `canvaskit` e `publicacoes/…`): `/contato` → 200 do `contato.html`; `/contato/` → 301 para `/contato`; `/publicacoes/historia/livros` → 200 do HTML da categoria; rota sem arquivo → 200 do `index.html`; `/assets` e `/assets/` sem listagem; `http` e `www` ainda chegam ao endereço final em um redirecionamento.
- [ ] O `.htaccess` do dev (com senha) continua pedindo login em todas as rotas geradas.
- [ ] Abrir uma página gerada no navegador carrega o app normalmente, sem texto duplicado visível e sem erro no console; o bloco oculto não é lido pelo leitor de tela.
- [ ] `docs/deployment.md` descreve o gatilho de reavaliação e as saídas em ordem.
- [ ] `fvm flutter analyze` e `fvm dart format` limpos nos `.dart` alterados.

## Fora do escopo
- Mudar os workflows (passo de gerar, checagem de `googletagmanager`, remoção do gtag no dev, deploy agendado): etapa 4.
- Comandos de verificação no servidor e Search Console: etapa 5. Relatório de segurança: etapa 6. Enxugar docs: etapa 7.
- Implementar a reavaliação (item acima), geração incremental e renderização sob demanda.
- Página por área de **posts** (`/publicacoes/:area`), que hoje não existe no app.
- Gerar o endereço de um post pela segunda área (só a primeira área é canônica).
- Prometer posição ou prazo de indexação no Google.

## Perguntas em aberto
- Nenhuma. Decididas em 2026-11-24, todas como proposto:
  1. "Por área" é `/biblioteca/:area`; "por categoria" é `/publicacoes/:area/:category`; `/publicacoes` é página fixa, sem lista paginada.
  2. Páginas seguintes em `…/pagina/N`, com rota no app que leva ao endereço base.
  3. Testes em `tool/seo/*_test.dart`, gerador em `tool/seo/generate_seo.dart`, passo novo no `ci.yml`.
  4. Sem limite de queda entre deploys; só falha em zero.
  5. Ordem das saídas de reavaliação como listada.
  6. Branch a partir da `develop` com #45 e #46 mergeados (feito).

## Histórico de mudanças
- 2026-11-24: criada.
- 2026-11-24: aprovada, com as perguntas em aberto resolvidas.
- 2026-11-24: `lastmod` dos documentos da biblioteca passa a vir de `createdAt` (não têm `updatedAt`).
- 2026-11-24: caminho aceita maiúsculas e `_`, porque os ids reais da biblioteca em produção têm maiúsculas.
