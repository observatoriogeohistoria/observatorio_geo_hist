# 012. Layout-base do post (tipo artigo) e seção Apoio

- **Status:** verificada com ressalvas
- **Item do planejamento:** Fase 2: T-08 (só o tipo artigo), P-05, P-07, P-08; Q-06
- **Protótipo:** aba "Post"; aba "Tipos de post" para os blocos por tipo; aba "Estados" para esqueleto e erro (link no CLAUDE.md)
- **Criada em:** 2026-10-01
- **Depende de:** [010-leitura-manifesto](../010-leitura-manifesto/spec.md) e [011-nossa-historia-pessoa](../011-nossa-historia-pessoa/spec.md) (base de leitura: migalhas, coluna, blocos, figura, esqueleto), [009-apoio-contato](../009-apoio-contato/spec.md) (9 logos de parceiros)

## Objetivo
Quem abre um artigo lê título, autoria, capa e texto numa coluna de leitura confortável, encontra outros artigos da mesma categoria e, no fim, vê as redes sociais e os apoiadores do Observatório. A página passa a ter um layout-base que a Fase 5 vai preencher com os blocos dos outros tipos.

## Situação atual
- [post_detailed_page.dart](../../../lib/app/features/posts/presentation/pages/post_detailed_page.dart): navbar, conteúdo do tipo, `Support` e rodapé. O carregamento usa o indicador antigo e o erro usa o `PageErrorContent` antigo, sem "tentar de novo". Post inexistente cai no erro (o datasource lança "Post not found"). Categoria inexistente na URL deixa a página carregando para sempre. Post não publicado abre normalmente por id.
- [article_content.dart](../../../lib/app/features/posts/presentation/components/post_content/article_content.dart): título em caixa alta laranja, subtítulo cinza, autores um por linha, data, ícones de compartilhar, divisor, capa 21:9 (180 a 420 px de altura), legenda, texto e observação num quadro cinza. Usa `num_extension` e os componentes de texto antigos. Não há tempo de leitura (P-05 já atendido no site atual; a regra é não incluir).
- Texto e observação vêm do editor rico (Quill, delta JSON) e são mostrados pelo [`ViewQuill`](../../../lib/app/core/components/quill/view_quill.dart), com estilos antigos (`title.big`, `darkGray`) e sem tratamento de imagem embutida. O editor do painel não oferece botão de imagem, mas conteúdo colado pode trazer uma.
- [social_icons.dart](../../../lib/app/features/posts/presentation/components/social_icons.dart): Facebook, Twitter, WhatsApp e E-mail em PNG, sem nome acessível nem foco visível.
- [support.dart](../../../lib/app/core/components/support/support.dart) (`Support`), usado só no post: fundo cinza, ícones de redes em PNG, título "APOIO" e os 9 logos (desde a 009).
- Os outros 9 tipos têm cada um seu `*_content.dart`, com cabeçalho e compartilhar próprios.
- Campos do artigo (`ArticleModel`): `title`, `subtitle`, `authors` (lista), `date` (texto "MM/aaaa"), `image`, `imageCaption`, `content`, `observation` (opcional).

## Comportamento

### Estrutura da página (todos os tipos)
De cima para baixo: navbar, **conteúdo do post**, **Leia também** (só artigo nesta spec), **Apoio**, rodapé (na base da janela quando a página é curta). Carregando, erro e não encontrado valem para todos os tipos.

### Cabeçalho do post (artigo)
Numa largura de até 820 px (com as margens, ~756 px de conteúdo), centralizada, fundo branco:

1. **Migalhas:** "Início" (Home) › área ("História" ou "Geografia", texto sem link, pois não existe página da área) › nome da categoria (abre a categoria) › "Artigo" (página atual). Quebram linha em tela estreita.
2. **Título** do artigo como está cadastrado (sem forçar caixa alta), fonte de títulos, peso 800.
3. **Subtítulo** abaixo, maior que o texto, em cor secundária. Some se estiver vazio.
4. **Linha de autoria**, entre duas linhas finas:
   - À esquerda: com **um** autor, círculo com as iniciais (laranja suave, iniciais em laranja forte) e, ao lado, o nome e a data; com **vários**, sem círculo, os nomes juntos ("Ana Silva, Bruno Costa e Carla Dias") e a data abaixo. Sem autores, só a data.
   - **Data:** o campo "MM/aaaa" mostrado como "março de 2026". Se não estiver nesse formato, mostra o texto como veio; vazio, some.
   - À direita (abaixo, em tela estreita): o **compartilhar atual**, com as mesmas quatro opções e os mesmos links (Facebook, Twitter, WhatsApp, E-mail). É o lugar que a 013 vai ampliar.
5. **Capa:** 21:9, cantos arredondados, preenchida sem distorcer (recorte centralizado), na largura do cabeçalho. **Legenda** abaixo em texto pequeno e cor secundária, se houver.

### Corpo do artigo
Coluna de leitura de 680 px (base da 010), centralizada:
- **Texto** do editor rico com o estilo de leitura (Figtree, ~18 px, entrelinha 1,75, cor de tinta, vão entre parágrafos). Títulos do editor (H1 a H3) viram subtítulos de leitura; H4 a H6 ficam em negrito no tamanho do texto. Negrito, itálico, sublinhado e riscado se mantêm. Listas com marcadores e numeradas com recuo. Citação com a barra laranja do destaque da 010. Links em laranja forte sublinhado, que abrem em outra aba. Alinhamento escolhido no editor é respeitado. Cores e fundos de texto do editor são ignorados (para não ferir o contraste).
- **Imagem dentro do texto:** na largura da coluna, sem recorte (mantém a proporção dela, porque cortar pode esconder informação), com altura máxima de ~560 px e cantos arredondados; com falha, placeholder 16:10 em laranja suave com ícone. Qualquer outro conteúdo embutido desconhecido é ignorado sem quebrar a página.
- **Nota** (campo observação, se não vazio): quadro em superfície, cantos arredondados, rótulo "NOTA" com ícone de documento em laranja forte, e o texto da observação com o mesmo tratamento do texto.
- Sem tempo de leitura (P-05), sem caixa de autor com biografia (não há dado para isso).

### Leia também (artigo)
Seção em largura de site (1120 px), depois do corpo:
- Título "Leia também" (cabeçalho de seção) e, à direita (abaixo, em tela estreita), o link com seta "Mais em [categoria]", que abre a categoria.
- Até **3 artigos** publicados da **mesma categoria**, do mais recente para o mais antigo, sem o atual.
- **Cartão:** imagem 16:10 com cantos arredondados (recorte, sem distorcer; sem imagem ou com falha, placeholder laranja suave com ícone), rótulo "ARTIGO", título (até 3 linhas, com reticências) e linha "autores · data" em cor secundária. O cartão inteiro é um link para o post, com foco visível; no hover, a imagem sobe um pouco e o título fica laranja (sem movimento quando o sistema pede menos movimento).
- **Carregando, vazio ou erro:** a seção não aparece (é conteúdo secundário e fica abaixo do texto, sem empurrar nada).

### Apoio (todos os tipos; P-07, Q-06)
Faixa em fundo de superfície, com linha no topo, depois do Leia também (ou do conteúdo) e antes do rodapé, na largura do site:
- **"Acompanhe"** (rótulo pequeno em caixa alta, cor secundária) com três botões em pílula, ícone + nome: Instagram, Facebook, YouTube, que abrem em outra aba.
- **"Apoio"** (mesmo rótulo) com os **9 logos** da Home (mesma ordem, efeito e links; colunas de no mínimo 130 px).
- Em duas colunas lado a lado (redes | logos) quando há espaço (≥ 820 px de largura útil); empilhadas abaixo disso.

### Outros 9 tipos (P-08 preparado, conteúdo na Fase 5)
Documento, livro, filme, revista, podcast, música, produção acadêmica, evento e pesquisa continuam mostrando o **bloco de conteúdo atual** (o mesmo `*_content` de hoje, com cabeçalho e compartilhar próprios), dentro da página nova: ganham os estados novos (esqueleto, não encontrado, erro) e a seção Apoio nova no lugar do `Support`; não ganham migalhas nem Leia também. A página escolhe o conteúdo pelo tipo num ponto único, para a Fase 5 trocar tipo a tipo pelo layout-base com o bloco específico.

## Estados
- **Carregando** (categorias ou post ainda não chegaram): esqueleto parado no formato do artigo: barra das migalhas, duas barras do título, uma do subtítulo, linha de autoria (círculo e duas barras), retângulo 21:9 da capa e cinco linhas de texto na coluna. Anunciado como "Carregando". Vale para todos os tipos. O rodapé fica na base da janela.
- **Não encontrado:** página 404 atual (como na 011) quando: a área da URL não é "historia" nem "geografia"; a categoria não existe (com as categorias já carregadas); o post não existe; ou o post existe mas não está publicado.
- **Erro** (falha de rede ao buscar categorias ou o post): no lugar do conteúdo, a caixa de estado da 011: "Não foi possível carregar", "Verifique sua conexão e tente novamente." e "Tentar de novo", que refaz a busca (categorias, se falharam, e o post) uma vez por clique. Apoio e rodapé continuam.
- **Sem capa:** a capa e a legenda somem; o corpo começa logo abaixo da linha de autoria.
- **Capa com falha:** placeholder na mesma proporção 21:9, laranja suave com ícone de imagem decorativo; a legenda continua.
- **Casos de borda:** título e subtítulo muito longos quebram linha sem cortar; nomes de autores longos ou muitos autores quebram linha; categoria com nome longo nas migalhas; capa muito alta ou muito larga (recorte); texto vazio (só cabeçalho e nota); observação vazia (sem nota); 0, 1, 2 e 3+ artigos relacionados (0 esconde a seção; 3+ mostra 3).

## Responsivo
- **Celular (390):** margens de 20 px; título ≈ 32 px; compartilhar abaixo do autor; capa na largura útil (~150 px de altura); Leia também em uma coluna, com "Mais em…" abaixo do título; Apoio empilhado, logos em 2 colunas.
- **Tablet (768):** margens de 32 px; cabeçalho e capa em 704 px; coluna de 680 px; Leia também em 2 colunas; Apoio empilhado.
- **Desktop (1280):** cabeçalho e capa em ~756 px, coluna de 680 px, ambos centralizados; título ≈ 53 px; Leia também em 3 colunas (1120 px); Apoio em duas colunas.
- Em todas: sem rolagem horizontal e sem `overflow`, inclusive para os outros tipos.

## Acessibilidade
- Título do post como cabeçalho de nível 1; subtítulos do texto, "Leia também" como nível 2. "Acompanhe" e "Apoio" como cabeçalhos.
- Migalhas como navegação "Você está em" (comportamento da 010); a área, sem link, é lida como texto comum, sem foco.
- Capa com nome acessível igual à legenda (ou "Imagem de capa do artigo" sem legenda); placeholders decorativos. Imagens do texto com nome "Imagem do artigo".
- Círculo de iniciais decorativo (o nome está ao lado).
- Cada opção de compartilhar com nome ("Compartilhar no Facebook" etc.), dica ao passar o mouse e foco visível. Pílulas das redes com o nome da rede. Cartões do Leia também lidos como link com título, tipo e "autores · data".
- Ordem de Tab: navbar → migalhas → compartilhar → links do texto → cartões do Leia também e "Mais em…" → redes → logos → rodapé. No erro: "Tentar de novo".
- Contraste ≥ 4,5:1 em migalhas, subtítulo, data, legenda, rótulo "NOTA", rótulo "ARTIGO", meta dos cartões, rótulos do Apoio e textos do erro; nada em cinza claro.
- Movimento reduzido: esqueleto parado; cartões sem subir no hover.

## Dados e regras de negócio
- Post pelo `FetchPostsStore` (`fetchPostById`) e categoria pelo `FetchCategoriesStore`. "Não publicado" e "não encontrado" passam a ser distinguidos de falha de rede (ajuste no datasource/repositório de posts, sem mudar modelo nem regras do Firebase).
- Leia também usa a mesma consulta da listagem da categoria por tipo (categoria + tipo artigo, publicados, mais recentes), já coberta pelos índices atuais, sem mexer na lista que a página da categoria guarda.
- Modelos (`PostModel`, `ArticleModel` e dos outros tipos), coleções e regras do Firebase não mudam. O painel não muda.
- Rotas não mudam: `/publicacoes/:area/:category/:id` e o redirecionamento de `/posts/...` continuam.
- Parceiros: a mesma lista `Partner` da Home (9).

## Critérios de aceite
1. [ ] Um artigo em `/publicacoes/:area/:category/:id` mostra, nesta ordem: navbar, migalhas "Início › [Área] › [Categoria] › Artigo", título (`h1`), subtítulo, linha de autoria com data e compartilhar, capa 21:9 com legenda, texto na coluna de 680 px, nota (se houver), Leia também, Apoio e rodapé.
2. [ ] Migalhas: "Início" abre a Home e a categoria abre `/publicacoes/:area/:category`, por clique e Enter; a área não é link nem recebe foco; "Artigo" é a página atual.
3. [ ] Autoria: com um autor, círculo de iniciais + nome; com vários, nomes juntos ("A, B e C") sem círculo; data "MM/aaaa" mostrada como "mês de aaaa" e, em outro formato, como veio; sem tempo de leitura em nenhum lugar da página.
4. [ ] Compartilhar mostra as quatro opções atuais com os mesmos destinos (Facebook, Twitter, WhatsApp, E-mail), cada uma com nome acessível, dica e foco visível, à direita do autor em 768 e 1280 e abaixo dele em 390.
5. [ ] Capa em 21:9, sem distorcer, cantos arredondados, na largura do cabeçalho; sem capa, capa e legenda somem; com falha forçada, placeholder na mesma proporção e a legenda continua.
6. [ ] Texto do editor com o estilo de leitura: parágrafos com vão, H1–H3 como subtítulos, listas com recuo, citação com barra laranja, negrito/itálico, links laranja-forte sublinhados que abrem em outra aba; cores do editor ignoradas.
7. [ ] Uma imagem embutida no texto aparece na largura da coluna sem recorte e com altura máxima; com falha, placeholder; um conteúdo embutido desconhecido não quebra a página (conferido com delta injetado).
8. [ ] Nota aparece só com observação não vazia, em quadro de superfície com rótulo "NOTA" em laranja forte.
9. [ ] Leia também mostra até 3 artigos publicados da mesma categoria, mais recentes primeiro, sem o atual; cada cartão (imagem 16:10 ou placeholder, "ARTIGO", título até 3 linhas, "autores · data") abre o post por clique e Enter; "Mais em [Categoria]" abre a categoria; com 0 relacionados ou falha, a seção não aparece.
10. [ ] Abrir um artigo pelo Leia também troca o conteúdo da página para o novo post (sem mostrar o anterior) e a lista da página da categoria não é alterada ao voltar para ela.
11. [ ] Apoio: depois do Leia também e antes do rodapé, fundo de superfície, "Acompanhe" com pílulas Instagram, Facebook e YouTube (abrem em outra aba) e "Apoio" com os 9 logos da Home na mesma ordem, efeito e links; lado a lado em 1280, empilhado em 768 e 390. O `Support` antigo não aparece mais.
12. [ ] Carregando: acesso direto mostra o esqueleto parado no formato do artigo, anunciado como "Carregando", até o post chegar.
13. [ ] Não encontrado: área inválida, categoria inexistente, post inexistente e post não publicado mostram a 404, sem ficar carregando para sempre.
14. [ ] Erro: com a rede bloqueada, aparece a caixa "Não foi possível carregar" com "Tentar de novo"; com a rede de volta, um clique carrega o post.
15. [ ] Ao menos um post de outro tipo (e, havendo no banco, um de cada tipo disponível) abre com o conteúdo atual dele, a seção Apoio nova, os estados novos e sem erro ou `overflow` no console.
16. [ ] Contraste ≥ 4,5:1 em migalhas, subtítulo, data, legenda, rótulos ("NOTA", "ARTIGO", "Acompanhe", "Apoio"), meta dos cartões e caixa de erro; ordem de Tab conforme "Acessibilidade", com foco visível em todos os itens clicáveis.
17. [ ] Em 390, 768 e 1280 px conforme "Responsivo": sem rolagem horizontal, sem sobreposição e sem `overflow`; título, autores e migalhas longos quebram linha; com a janela alta, o rodapé fica na base.
18. [ ] O código novo usa só tokens de `lib/app/theme/` e não usa `num_extension`; o artigo não usa mais `AppHeadline`, `AppTitle`, `AppDivider`, `PageErrorContent` nem `LoadingContent`; a escolha do conteúdo por tipo está num ponto único, descrito em `docs/arquitetura.md`; `fvm flutter analyze` sem problemas novos e `fvm flutter build web --release` sem erro.

## Fora do escopo
- Compartilhamento ampliado (P-06: copiar link, LinkedIn, Telegram, nativo, "Mais"): spec 013. Aqui só o lugar e as quatro opções atuais.
- Layout-base com blocos específicos dos outros 9 tipos (Fase 5).
- Barra de progresso de leitura na navbar e botão "← [Categoria]" do protótipo (ver decisões).
- Caixa de autor com biografia (não há dado no modelo).
- Redesenho da 404 (T-10, Fase 5) e dos cartões da listagem de categoria (Fase 3).
- Título da aba do navegador, item ativo da navbar (fica como hoje).
- Mudar modelos, regras do Firebase, painel ou rotas. Apagar `Support`, `SocialIcons`, `ViewQuill`, `ArticleContent` ou componentes antigos (Fase 7).
- Painel administrativo, Geoensine e modo escuro.

## Perguntas em aberto
- Nenhuma. Respondidas no modo autônomo:
  - **Outros 9 tipos.** Decidido no modo autônomo: continuam com o bloco de conteúdo atual dentro da página nova (estados novos e Apoio novo, sem migalhas nem Leia também), porque encaixar o cabeçalho novo neles duplicaria título e compartilhar, e o desenho de cada bloco é da Fase 5; é a opção que menos arrisca quebrar tipos sem dados de teste.
  - **Migalhas.** Decidido no modo autônomo: "Início › Área › Categoria › Artigo", com a área sem link, porque o protótipo mostra área e tipo, não existe página da área e, sem o botão de voltar, a categoria precisa estar nas migalhas.
  - **Botão "← Categoria".** Decidido no modo autônomo: não entra, como na 011, porque a categoria já está nas migalhas e o botão discreto não tem ícone à esquerda.
  - **Barra de progresso de leitura.** Decidido no modo autônomo: fora do escopo, porque mexe na navbar compartilhada e não está no planejamento (só nas notas do protótipo); fica como ideia.
  - **Compartilhar (P-06 é da 013).** Decidido no modo autônomo: as quatro opções atuais no lugar do protótipo, com nome acessível e foco, porque mantém o comportamento sem antecipar a 013 e cumpre a regra de foco visível.
  - **Data.** Decidido no modo autônomo: "março de 2026" a partir do "MM/aaaa" do artigo, porque o campo só tem mês e ano (o "12 mar 2026" do protótipo é exemplo) e é a data informada pelo autor.
  - **Autores.** Decidido no modo autônomo: círculo de iniciais só com um autor, porque com vários ele representaria só a primeira pessoa.
  - **Leia também.** Decidido no modo autônomo: até 3 artigos da mesma categoria, mais recentes, sem o atual, escondido se vazio ou com falha, porque o protótipo mostra só artigos com "Mais em [categoria]" e essa consulta já tem índice; esqueleto ali faria a página pular.
  - **Imagens no texto.** Decidido no modo autônomo: sem recorte, com altura máxima, porque são parte do conteúdo (mapas, gráficos) e cortá-las esconde informação; a regra de proporção fixa com `cover` vale para capas e cartões.
  - **Post não publicado.** Decidido no modo autônomo: 404, porque o site público só lista publicados e o painel não abre o post pela rota pública.
  - **Não encontrado.** Decidido no modo autônomo: a 404 atual, como na 011, porque o redesenho da 404 é da Fase 5.
  - **Apoio.** Decidido no modo autônomo: desenho do protótipo ("Acompanhe" em pílulas + "Apoio" com os 9 logos, colunas de 130 px), porque a 009 deixou esse redesenho para a fase do post.

## Histórico de mudanças
- 2026-10-01: criada e aprovada no modo autônomo (execução da Fase 2).
- 2026-10-01: plano e tarefas criados (`plan.md`, `tasks.md`).
- 2026-10-01: ajustes durante a implementação (modo autônomo): o texto do editor também ignora tamanhos (`size`), junta linhas em branco seguidas e descarta embutidos que não são imagem (antes ficavam como linhas vazias); links do texto abrem pelo mouse, mas não recebem foco de teclado (limite do Quill só leitura), o que deixa parcial a ordem de Tab de "Acessibilidade"; post sem corpo também dá 404; o Apoio fica colado ao rodapé (`beforeFooter` no `ReadingPageScaffold`); o compartilhar codifica o título e preenche o assunto do e-mail; ao abrir outro post pelo Leia também, a página volta ao topo.
- 2026-10-01: implementada. Conferência em build `APP_ENV=prod` só leitura (o Firebase dev não tem artigos).
- 2026-10-01: verificada com ressalvas ([verificacao.md](verificacao.md)), no modo autônomo. Correção: o texto e a nota deixavam duas paradas de Tab invisíveis (nó de foco do Quill na web). Ressalva: links do texto continuam sem foco por teclado (decidido aceitar: a alternativa reescreve o renderizador).
