# 016. Biblioteca: entrada por área e lista com filtros

- **Status:** aprovada
- **Item do planejamento:** Fase 4: índice da biblioteca (P-09) e lista por área com filtros, resultados e paginação (T-06, P-10, P-11, P-12). O detalhe do documento (T-07) fica na 017.
- **Protótipo:** abas "Biblioteca" (entrada) e "Lista"; aba "Estados" para esqueleto, vazio e erro (link no CLAUDE.md)
- **Criada em:** 2026-10-02
- **Depende de:** [010-leitura-manifesto](../010-leitura-manifesto/spec.md) (cabeçalho de página e migalhas), [011-nossa-historia-pessoa](../011-nossa-historia-pessoa/spec.md) (caixa de erro), [014-listagem-categoria](../014-listagem-categoria/spec.md) (campo de busca, caixa de estado, "Ver mais", estados)

## Objetivo
Quem procura teses e dissertações escolhe a área já sabendo quantos documentos há em cada uma e, na lista, encontra o que quer com busca, tipo, ano e categorias, vendo quantos documentos cada filtro tem. As duas telas ganham o desenho novo do site, com estados de carregando, vazio e erro.

## Situação atual
- [library_page.dart](../../../lib/app/features/library/presentation/pages/library_page.dart) (`/biblioteca`): cabeçalho alto com foto escurecida e "Biblioteca"; bloco cinza com "Teses e Dissertações", um texto que cita "artigos científicos" e dois botões laranja ("Geografia", "História") com `GestureDetector`, sem foco por teclado; seção de parceiros e rodapé. Sem contagem. Usa `num_extension`.
- [library_list_page.dart](../../../lib/app/features/library/presentation/pages/library_list_page.dart) (`/biblioteca/:area`): `AppBar` laranja com "Voltar" e o nome da área, sem navbar nem rodapé. No desktop, painel lateral de 20% ([filters.dart](../../../lib/app/features/library/presentation/components/filters.dart)) com Título, Autor, Instituição, Ano, Tipo e Categorias, aplicados só no botão "Aplicar Filtros"; no celular o painel abre num botão "Filtros". Lista de 10 em 10 com "Carregar mais", em rolagem interna. Carregando com círculo, erro e vazio só com texto. Busca por prefixo, diferenciando maiúsculas.
- **A mesma página atende o painel** em `/painel/biblioteca/:area` (rota do painel aponta para `LibraryListPage`): com login e permissão, mostra "Criar documento", editar e excluir. O painel usa também `Filters`, `LibraryDocumentCard`, o diálogo de documento, `LibraryStore` e `FilterDocumentsStore`; o detalhe do documento usa `LibraryStore`.
- O datasource já tem `countByType` e `countByCategory`, sem uso e com um defeito: compara com o enum em vez do texto gravado, então contaria zero.

## Comportamento

### Entrada da biblioteca (`/biblioteca`)
1. **Cabeçalho de página** (010), em fundo de superfície com linha embaixo:
   - Migalhas: "Início" (Home) › "Biblioteca" (página atual).
   - Título `h1`: "Biblioteca".
   - Texto: "Produções acadêmicas sobre História e Geografia de várias instituições e pesquisadores, reunidas em um só lugar. Teses e dissertações para consultar e citar."
2. **Dois cartões de área**, Geografia e depois História (ordem do protótipo). Cada cartão é um link para `/biblioteca/:area` e tem:
   - ícone em quadrado laranja suave (globo para Geografia, ampulheta para História);
   - nome da área como título `h2`;
   - "Teses e dissertações sobre o ensino de Geografia." (ou "de História.");
   - linha de números, acima de um fio: "**66** dissertações · **62** teses" (singular com 1: "1 tese"; zero aparece como "0 teses");
   - "Explorar Geografia" com seta, em laranja.
   - Hover: borda laranja, sombra e o cartão sobe 3 px (sem movimento com movimento reduzido).
3. Sai o cabeçalho com foto, o bloco cinza, o texto que citava artigos e a seção de parceiros (o protótipo não tem; o rodapé continua).

### Lista por área (`/biblioteca/:area`)
Passa a ter navbar e rodapé como as outras páginas, sem `AppBar` própria.

1. **Cabeçalho de página** (010):
   - Migalhas: "Início" › "Biblioteca" (link para `/biblioteca`) › área (página atual).
   - Título `h1`: nome da área ("Geografia", "História").
   - Texto: "Teses e dissertações sobre o ensino de Geografia, de várias instituições e pesquisadores." (ou "de História").
2. **Busca**, na largura do conteúdo:
   - Seletor "Buscar em" com **Título** (padrão), **Autor** e **Instituição**, à esquerda do campo.
   - Campo de busca da 014 (lupa, "Limpar"), com texto de ajuda conforme o seletor: "Buscar por título", "Buscar por autor", "Buscar por instituição". Pesquisa depois da pausa (~400 ms) e com Enter. Trocar o seletor com texto no campo refaz a busca no campo novo.
   - Busca pelo começo do texto, como hoje. Se o termo vier todo em minúsculas, a primeira letra vira maiúscula antes de buscar ("ensino" encontra "Ensino de…"), porque os títulos e nomes estão gravados com inicial maiúscula e o banco diferencia maiúsculas. Espaços nas pontas são ignorados.
3. **Filtros em linha**, abaixo da busca (no celular quebram em linhas):
   - **Tipo:** seletor com "Tipo: todos", "Tese (N)" e "Dissertação (N)". Só esses dois tipos (P-10). Seleção única.
   - **Ano:** campo curto "Ano", só números, com até 4 dígitos. Filtra quando tem 4 dígitos ou quando é esvaziado.
   - **Categoria:** botão "Categoria" com seta; com categorias marcadas, mostra a quantidade marcada num selo laranja ("Categoria 2"). Abre um painel logo abaixo com as categorias em ordem alfabética, cada uma com caixa de seleção e a quantidade de documentos da área à direita. Seleção livre de quantas quiser; o documento aparece se tiver **qualquer** uma das marcadas (P-11). Rodapé do painel: "Selecione quantas quiser" e "Limpar" (desmarca todas). O painel fecha com Esc, clique fora ou Tab para fora; a lista atualiza a cada marcação.
   - Categorias com zero documentos na área não aparecem no painel. Se a contagem falhar, aparecem as 16, sem números.
   - Sem botão "Aplicar": cada filtro vale na hora.
4. **Filtros ativos:** abaixo dos filtros, um chip removível por filtro aplicado ("Tipo: Tese", "Ano: 2024", um por categoria marcada), cada um com "×" (nome "Remover filtro [nome]"), e o botão "Limpar tudo", que tira filtros e busca. A busca não vira chip (tem o próprio "Limpar"). A fileira some sem filtros.
5. **Contagem:** "1 documento", "37 documentos"; com busca, "3 documentos para “mapa”". Conta todos os documentos do filtro, não só os carregados. Anunciada a leitores de tela quando muda.
6. **Resultados:** lista de linhas separadas por fio, do mais recente para o mais antigo (data de cadastro); com busca, em ordem alfabética do campo buscado (limite da busca por prefixo). Cada linha é um link para o detalhe do documento (`/biblioteca/:area/documento/:slug`, página atual, que a 017 redesenha):
   - **Título** do documento (`h3`), até 3 linhas com reticências;
   - **Detalhes** em cor secundária: "Autor · Instituição · Ano", sem as partes vazias;
   - **Categorias:** até 2 etiquetas pequenas e "+N" para as demais (some sem categorias);
   - à direita (abaixo, no celular): selo do tipo ("Tese", "Dissertação"; some sem tipo) e seta.
   - Hover: fundo de superfície e título laranja. Foco: anel visível na linha; Enter abre o documento.
7. **Paginação:** 20 documentos por vez. Se houver mais, "Ver mais documentos" (botão secundário centralizado). Durante a carga, desativado com "Carregando…", com as linhas no lugar. Some quando não há mais (nunca traz página vazia).
8. Filtros, busca e seletor não vão para a URL e voltam ao início ao trocar de área ou sair da página.

### Painel administrativo
Não muda. `/painel/biblioteca/:area` continua com a página, os filtros, o card e o diálogo de hoje.

## Estados
- **Carregando (entrada):** cabeçalho pronto; nos cartões, a linha de números vira duas barras de esqueleto. O resto do cartão e o link funcionam.
- **Carregando (lista):** cabeçalho, busca e filtros prontos; no lugar dos resultados, 5 linhas de esqueleto (barra do título, barra dos detalhes, duas etiquetas). Anunciado como "Carregando". Parado (sem animação).
- **Área sem documentos:** caixa de estado "Ainda não há documentos em Geografia" e "Volte em breve." Busca e filtros não aparecem.
- **Nenhum resultado com busca ou filtro:** caixa de estado com lupa, "Nenhum documento encontrado", "Tente outro termo ou remova algum filtro." e o botão "Limpar filtros", que tira filtros e busca. Busca e filtros continuam visíveis.
- **Erro (lista):** caixa de erro da 011 ("Não foi possível carregar", "Verifique sua conexão e tente novamente.", "Tentar de novo") no lugar dos resultados, com busca e filtros visíveis.
- **Erro no "Ver mais":** linhas ficam; botão volta a ficar ativo e aparece abaixo "Não foi possível carregar mais documentos." em cor de erro.
- **Erro nas contagens:** entrada sem a linha de números (cartões continuam); lista sem os números do tipo e das categorias e sem a linha de contagem; a lista em si aparece.
- **Área inválida na URL:** 404 atual (como hoje).
- **Casos de borda:** 0, 1, 20 e 21+ documentos (21+ mostra "Ver mais"); título muito longo (3 linhas); autor, instituição ou ano vazios (omitidos); documento com 1, 2 e 3+ categorias ("+1"); documento sem slug (linha aparece sem link e sem seta); termo só com espaços (equivale a vazio); ano com menos de 4 dígitos (não filtra); todas as categorias marcadas.

## Responsivo
- **Celular (390):** margens de 20 px; cartões de área em 1 coluna; seletor "Buscar em" acima do campo, ambos na largura toda; filtros quebram em linhas; painel de categorias com a largura da tela menos as margens; na linha do documento, selo e seta vão para baixo dos detalhes.
- **Tablet (768):** margens de 32 px; cartões em 2 colunas; seletor e campo na mesma linha; filtros na mesma linha quando cabem.
- **Desktop (1280):** conteúdo em 1120 px; cartões em 2 colunas; busca na largura do conteúdo; painel de categorias com até 360 px; selo e seta à direita da linha.
- Em todas: sem rolagem horizontal, sem `overflow`; rodapé na base com poucos itens.

## Acessibilidade
- `h1` no cabeçalho; nome da área como `h2` nos cartões; título do documento como `h3` (texto do link).
- Migalhas como navegação "Você está em"; página atual sem link.
- Cartão de área lido como link: "Geografia, 66 dissertações, 62 teses, Explorar Geografia".
- Seletor "Buscar em" e seletor de tipo com nome acessível e valor anunciado; campo "Ano" com nome "Ano"; botão "Categoria" anuncia aberto/fechado e quantas estão marcadas ("Categoria, 2 selecionadas"); cada caixa do painel com nome "[categoria], N documentos" e estado marcado. Ao abrir o painel, o foco vai para a primeira caixa; ao fechar com Esc, volta ao botão.
- Linha do documento lida como link: "[título], [tipo], [detalhes]".
- Contagem e caixas de estado anunciadas quando mudam.
- Ordem de Tab: navbar → migalhas → "Buscar em" → busca → "Limpar" → Tipo → Ano → Categoria (→ painel, se aberto) → chips de filtros ativos → "Limpar tudo" → linhas → "Ver mais documentos" → rodapé. Foco visível em todos.
- Contraste ≥ 4,5:1 em migalhas, textos dos cartões, números, contagem, detalhes, etiquetas, selo do tipo, quantidades do painel e textos de estado; nada em cinza claro.
- Movimento reduzido: cartão de área sem subir; esqueleto parado.

## Dados e regras de negócio
- Documentos da coleção `library`, filtrados por área, com os filtros que o datasource já aceita: tipo (igual), categorias (qualquer uma), ano (igual) e busca por começo de título, autor ou instituição.
- Contagens no banco: por área e tipo (entrada e seletor de tipo), por área e categoria (painel), e o total do filtro atual (linha de contagem). As quantidades do tipo e das categorias são da área inteira, sem considerar os outros filtros.
- Contagem e lista sem combinações conhecidas de índice: combinações de filtros que o Firestore recusar por falta de índice caem no estado de erro tratado, nunca carregando para sempre. Índices que faltarem são documentados em `docs/deploy-ambientes.md`, como na 015.
- `LibraryDocumentModel`, os enums de área, tipo e categoria, coleções, regras e índices do Firebase não mudam. Rotas não mudam (`/biblioteca`, `/biblioteca/:area`, `/biblioteca/:area/documento/:slug`, `/painel/biblioteca/:area`).
- O painel não muda: a página do painel, `Filters`, `LibraryDocumentCard`, o diálogo de documento, `LibraryStore` e `FilterDocumentsStore` continuam com o mesmo comportamento. A página pública deixa de mostrar as ações de edição (o painel tem as suas).

## Critérios de aceite
1. [ ] `/biblioteca` mostra navbar, cabeçalho (migalhas "Início › Biblioteca", `h1` "Biblioteca", texto da spec), dois cartões (Geografia, História) e rodapé; sem foto de fundo, sem o texto que citava artigos e sem seção de parceiros.
2. [ ] Cada cartão tem ícone, `h2`, descrição, "N dissertações · N teses" com os números do banco (singular com 1) e "Explorar [área]"; abre `/biblioteca/:area` por clique e Enter, com foco visível; hover com borda, sombra e subida (sem subida com movimento reduzido).
3. [ ] `/biblioteca/:area` mostra navbar, cabeçalho (migalhas "Início › Biblioteca › [Área]" com "Biblioteca" levando à entrada, `h1` com a área, texto da spec), busca, filtros, contagem, resultados e rodapé; sem `AppBar` própria.
4. [ ] Busca: seletor Título/Autor/Instituição com texto de ajuda correspondente; prefixo filtra após a pausa e com Enter; termo em minúsculas encontra o registro com inicial maiúscula; "Limpar" aparece só com texto e devolve o foco ao campo; espaços nas pontas ignorados; trocar o seletor refaz a busca.
5. [ ] Tipo: só "Tipo: todos", "Tese (N)" e "Dissertação (N)", com números da área; a escolha filtra na hora.
6. [ ] Ano: só aceita números; filtra com 4 dígitos e volta ao todo quando vazio.
7. [ ] Categoria: painel com as categorias da área em ordem alfabética e quantidades, seleção livre, documento aparece com qualquer uma marcada; selo com a quantidade marcada; "Limpar" do painel desmarca; fecha com Esc (foco volta ao botão), clique fora e Tab; sem a contagem, mostra as 16 sem números.
8. [ ] Filtros ativos: um chip por filtro, "×" remove só aquele, "Limpar tudo" tira filtros e busca; a fileira some sem filtros.
9. [ ] Contagem "N documento(s)" com o total do filtro (não só o carregado) e "para “termo”" com busca, anunciada a leitores de tela.
10. [ ] Linha do documento: título até 3 linhas, detalhes sem partes vazias, até 2 categorias e "+N", selo do tipo e seta; abre o detalhe atual por clique e Enter, com foco visível; hover com fundo e título laranja; ordem por data (alfabética do campo com busca).
11. [ ] Paginação: 20 por vez; "Ver mais documentos" só quando há mais; durante a carga fica desativado com "Carregando…" e as linhas ficam; nunca traz página vazia nem repete itens.
12. [ ] Carregando: esqueleto da linha de números na entrada e 5 linhas de esqueleto na lista, anunciado "Carregando".
13. [ ] Vazio: área sem documentos mostra "Ainda não há documentos em [Área]" sem busca nem filtros; sem resultado mostra "Nenhum documento encontrado" com "Limpar filtros", que restaura a lista completa.
14. [ ] Erro: falha na lista mostra a caixa de erro com "Tentar de novo" que recarrega; falha no "Ver mais" mantém as linhas e mostra a mensagem abaixo do botão; falha nas contagens esconde só os números (entrada e lista); combinação de filtros sem índice cai no erro tratado, sem carregar para sempre.
15. [ ] Painel administrativo sem mudança: `/painel/biblioteca/:area` usa a mesma página, filtros, card e diálogo de antes (conferido no código; no app, se houver acesso de teste).
16. [ ] Contraste ≥ 4,5:1 nos textos listados em "Acessibilidade"; ordem de Tab conforme "Acessibilidade", com foco visível; seletores, botão e caixas do painel com nome e estado anunciados.
17. [ ] Em 390, 768 e 1280 px conforme "Responsivo", nas duas telas: sem rolagem horizontal, sem sobreposição e sem `overflow`, em release e em debug; rodapé na base com poucos itens.
18. [ ] Código novo usa só tokens de `lib/app/theme/`, não usa `num_extension` nem `GestureDetector` solto; rotas só por `AppRoutes`; índices que faltarem documentados em `docs/deploy-ambientes.md`; `fvm flutter analyze` sem problemas novos e `fvm flutter build web --release` sem erro.

## Fora do escopo
- Detalhe do documento (T-07): spec 017. A lista só leva à página atual.
- Busca que ignore acentos e maiúsculas por completo, por várias palavras ou em vários campos ao mesmo tempo (exigiria campos normalizados, ajuste do painel; ideia futura 9.1).
- Seletor de instituição com lista de valores e seletor de ano com lista (não há como listar os valores sem ler todos os documentos).
- Agrupar resultados por categoria, tipo ou ano; modo "todas as categorias" (P-11 fecha em "qualquer uma").
- Quantidades que reagem aos outros filtros (exigiria uma contagem por opção a cada mudança e índices novos).
- Guardar filtros na URL; título da aba do navegador; item ativo da navbar (já marca "Biblioteca").
- Apagar a imagem `library.webp` e componentes antigos ainda usados pelo painel (limpeza da Fase 7).
- Criar ou publicar índice no Firebase, mudar modelos, regras, rotas ou o painel. Geoensine e modo escuro.

## Perguntas em aberto
- Nenhuma. Respondidas no modo autônomo:
  - **Painel separado da página pública.** Decidido no modo autônomo: a rota pública ganha página nova e a do painel continua com a `LibraryListPage` atual, porque o painel não pode mudar e hoje as duas rotas dividem a página, os filtros, o card e os stores.
  - **Busca num campo com seletor de campo.** Decidido no modo autônomo: um campo com "Buscar em" Título/Autor/Instituição, porque o protótipo junta os três num campo só, mas o banco busca um campo por vez (por prefixo); buscar nos três juntos pediria três consultas mescladas e quebraria a paginação. Mantém as três buscas que o site já oferece.
  - **Inicial maiúscula automática.** Decidido no modo autônomo: termo todo em minúsculas ganha inicial maiúscula, porque o banco diferencia maiúsculas e não há campo normalizado (criar é ajuste do painel, fora do escopo); quem digita "ufu" precisa digitar "UFU". Limitação registrada.
  - **Ano como campo, Instituição sem seletor.** Decidido no modo autônomo: o protótipo tem seletores de ano e instituição com valores de exemplo, mas não há como listar os valores reais sem ler a coleção inteira. Ano vira campo numérico curto (como hoje) e instituição fica na busca.
  - **Quantidades da área inteira.** Decidido no modo autônomo: números do tipo e das categorias contam a área sem os outros filtros, porque é o que `countByType`/`countByCategory` fazem (P-12) e o protótipo mostra números fixos; recalcular a cada filtro pediria 18 contagens por mudança e índices novos.
  - **Categorias zeradas escondidas e ordem alfabética.** Decidido no modo autônomo: as 16 categorias valem para as duas áreas, mas várias são de uma área só; esconder as com zero evita opções que levam a vazio. Ordem alfabética porque a ordem do código não é intencional. Sem contagem, aparecem as 16.
  - **Filtros na hora, sem "Aplicar".** Decidido no modo autônomo: como no protótipo e na listagem de posts; o painel lateral de 20% sai (nota do protótipo).
  - **Lista em linhas, 20 por vez, "Ver mais".** Decidido no modo autônomo: linhas como no protótipo (documentos não têm imagem); 20 por página porque a linha é baixa; "Ver mais documentos" e "nunca página vazia" como na 014.
  - **Ordem com busca.** Decidido no modo autônomo: alfabética do campo buscado, porque a busca por prefixo no Firestore ordena por esse campo (mesma regra da 014).
  - **Textos de vazio.** Decidido no modo autônomo: "Nenhum documento encontrado" com "Limpar filtros" (aba "Estados" e lista do protótipo) e um texto próprio para área sem documentos, que não tem o que limpar.
  - **Sem ações de edição na página pública.** Decidido no modo autônomo: hoje quem tem login vê "Criar", "Editar" e "Excluir" também em `/biblioteca/:area`; a página nova não mostra, porque o painel tem a mesma tela com essas ações e o site público fica só de leitura.
  - **Sem parceiros na entrada.** Decidido no modo autônomo: o protótipo não tem a seção na biblioteca e a listagem de categoria (014) também não usa; os parceiros seguem na Home e no post.
  - **Documento sem slug.** Decidido no modo autônomo: a linha aparece sem link, porque hoje leva a um endereço vazio que quebra; não deve existir no banco.

## Histórico de mudanças
- 2026-10-02: criada e aprovada no modo autônomo (execução da Fase 4).
- 2026-10-02: plano e tarefas criados (`plan.md`, `tasks.md`).
