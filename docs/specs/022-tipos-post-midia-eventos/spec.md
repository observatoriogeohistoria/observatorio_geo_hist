# 022. Tipos de post: podcast, música, evento e pesquisa

- **Status:** aprovada
- **Item do planejamento:** Fase 5: T-08 e P-08 (últimos quatro tipos de post)
- **Protótipo:** aba "Tipos de post" (Podcast e música, Evento, Pesquisa); aba "Post" para cabeçalho, compartilhar e imagem com legenda (link no CLAUDE.md)
- **Criada em:** 2026-10-06
- **Depende de:** [021-tipos-post-obras](../021-tipos-post-obras/spec.md) (cabeçalho da obra, ficha, imagem com placeholder, linha de compartilhar, texto na coluna), [012-post-base](../012-post-base/spec.md) (página, estados, Apoio, imagem com legenda do artigo), [013-compartilhamento-post](../013-compartilhamento-post/spec.md), [020-estados-especiais](../020-estados-especiais/spec.md)

## Objetivo
Quem abre um podcast, uma música, um evento ou uma pesquisa vê o mesmo desenho das obras da 021: migalhas, título, ficha, ação, compartilhar e texto na coluna de leitura. Cada tipo ganha o que só ele tem: a faixa "Ouvir" (podcast e música), a caixa de data (evento) e a pílula de situação (pesquisa). Com isso, nenhum tipo de post usa mais o desenho antigo.

## Situação atual
- [post_type_content.dart](../../../lib/app/features/posts/presentation/components/post/post_type_content.dart) já leva artigo e as cinco obras ao layout novo; podcast, música, evento e pesquisa ainda abrem `PodcastContent`, `MusicContent`, `EventContent` e `SearchContent` em [post_content/](../../../lib/app/features/posts/presentation/components/post_content/).
- Desenho antigo: imagem sem proporção fixa à esquerda (erro de imagem antigo, nada quando falta), botão secundário "Acesse"/"Mais informações", título laranja em caixa alta, linhas "Rótulo: valor" em laranja, `num_extension`. Sem migalhas e sem compartilhar.
- Na mesma pasta, `article_content.dart` não é mais usado por ninguém desde a 012; `SocialIcons` e `ViewQuill` só são usados por ele e pela música.
- O erro de imagem antigo (`AppNetworkImage`, `ImageErrorContent`) continua em uso fora dos posts: avatar e carrossel de destaques da Home, imagem arredondada de `core` e card de equipe do painel.
- Campos (não mudam):
  - **Podcast:** título, imagem, descrição (texto simples, até 5 linhas no painel), link.
  - **Música:** título (nome da música), imagem, artista, descrição (texto simples), letra (editor rico, opcional), link.
  - **Evento:** título, imagem, abrangência (Nacional, Internacional), link, local, cidade (texto livre, "Cidade/UF" ou "Cidade – País"), data (texto livre; o painel sugere "DD/MM/AAAA" e dá o exemplo "1º de janeiro de 2020 a 10 de janeiro de 2020"), horário (opcional), detalhes (texto simples, opcional).
  - **Pesquisa:** título, imagem, situação (Em andamento, Concluída), legenda da imagem, descrição (texto simples), coordenador(a), pesquisador(a), orientador(a), coorientador(a), integrantes, financiador (todos opcionais, texto livre). Não tem link.
- O prod tem os quatro tipos (conferência da 021); o dev só tem uma pesquisa.

## Comportamento

### Estrutura (os quatro tipos)
A mesma das obras (021): navbar, cabeçalho em ~756 px (migalhas, bloco, linha de compartilhar), texto na coluna de leitura de 680 px, Apoio e rodapé. Sem Leia também. Migalhas: "Início" › área › categoria › "Podcast", "Música", "Evento" ou "Pesquisa".

### Por tipo
| Tipo | Ao lado dos dados | Acima do título | Ficha | Ação | Texto (nível 2) |
|---|---|---|---|---|---|
| Podcast | Capa quadrada | (nada) | (nenhuma) | Faixa "Ouvir episódio" | "Descrição" |
| Música | Capa quadrada | (nada) | Artista | Faixa "Ouvir música" | "Descrição" e "Letra" |
| Evento | Caixa de data | (nada) | Data, Horário, Local, Cidade, Abrangência | "Mais informações" | "Detalhes" |
| Pesquisa | (nada; imagem com legenda abaixo do compartilhar) | (nada) | Coordenação, Pesquisador(a), Orientação, Coorientação, Financiamento; Integrantes na largura toda | (nenhuma) | "Descrição" |

Valem as regras da 021: título `h1` como cadastrado, em cor de tinta e sem caixa alta forçada; campo vazio não aparece na ficha; sem nenhum campo, a ficha some; ação some sem link.

### Podcast e música
- **Capa quadrada (1:1)** com 180 px, à esquerda dos dados no tablet e no desktop e acima deles, alinhada à esquerda, no celular; mesmo recorte, cantos e sombra da capa do livro. Sem imagem ou com falha: placeholder da 021 na mesma proporção.
- **Faixa "Ouvir"** abaixo do título e da ficha: caixa de fundo de superfície com borda fina e cantos arredondados, botão redondo laranja com ícone de reproduzir à esquerda, o texto "Ouvir episódio" (podcast) ou "Ouvir música" (música) e, abaixo dele em cor secundária, o endereço do site do link sem "www." (ex.: "open.spotify.com"), e o ícone de link externo à direita. A faixa inteira é um único botão que abre o link em outra aba. Não há player embutido, barra de progresso nem tempo: o link é externo e não se sabe se toca no site. Sem link, a faixa some. Se o endereço não puder ser lido, a faixa aparece só com o texto.
- **Música:** depois de "Descrição", o subtítulo "Letra" e a letra no estilo de texto rico do artigo, mantendo as quebras de linha. Letra vazia: o subtítulo "Letra" some. Letra que não é delta aparece como texto simples (regra da 021).

### Evento
- **Caixa de data** (protótipo): quadrado laranja de 100 px com o dia em número grande e o mês abreviado em caixa alta ("14" / "NOV"), à esquerda dos dados no tablet e no desktop e acima deles no celular.
- A caixa só aparece quando o dia e o mês do **início** do evento podem ser lidos do texto da data: formatos "14/11/2026" (ou "14/11") e "14 de novembro de 2026" (com "1º", maiúsculas ou sem acento). Em intervalos ("1º de janeiro de 2020 a 10 de janeiro de 2020"), vale a primeira data; dias que dividem o mês ("06 a 10 de julho", "15, 16 e 17 de julho", "20 e 22 de setembro") usam o primeiro dia com esse mês. Fora disso, não há caixa e o bloco fica só com os dados, como no documento da 021.
- A **ficha sempre traz "Data"** com o texto como foi cadastrado, porque a caixa não mostra ano nem intervalo.
- **Ação:** botão primário "Mais informações" com ícone de link externo, como o "Acessar …" das obras.
- A imagem do evento (geralmente um cartaz com proporção livre) não aparece na página, como no protótipo; continua nos cards da listagem.

### Pesquisa
- **Pílula de situação** logo depois do título, na mesma linha quando couber e na linha de baixo quando não: "Em andamento" em verde (fundo e texto de sucesso do tema) e "Concluída" em neutro (desenho do selo da 021).
- **Integrantes** ocupa a largura toda da ficha, abaixo dos outros campos, com o texto como veio (quebras de linha mantidas).
- **Imagem com legenda** abaixo da linha de compartilhar, no desenho da imagem do artigo (proporção 21:9, recorte, legenda abaixo). Sem imagem, a figura some (como no artigo); com falha, placeholder.
- Sem botão: a pesquisa não tem link.

### O que sai
- Os quatro `*_content.dart` antigos e o `article_content.dart`, sem uso; a pasta `post_content/` deixa de existir.
- `SocialIcons` e `ViewQuill`, que ficam sem nenhum uso.
- O erro de imagem antigo **fica**: Home, `core` e painel ainda o usam.

## Estados
- **Carregando, não encontrado e erro:** os da 012 e da 020, sem mudança (esqueleto no formato do artigo, 404, caixa de erro com "Tentar de novo").
- **Sem imagem / imagem com falha:** placeholder na capa quadrada; na pesquisa, figura some sem imagem e mostra placeholder na falha.
- **Casos de borda:** título longo quebra linha, também com a pílula; data em formato não reconhecido (sem caixa, "Data" na ficha); data com dia ou mês impossíveis ("32/13") sem caixa; intervalo de datas; evento sem horário e sem detalhes; música sem letra e sem artista; podcast sem link (sem faixa); link sem "http" ou malformado (faixa só com o texto); pesquisa só com situação e descrição (sem ficha); integrantes em várias linhas ou muito longos; nomes longos na ficha; descrição vazia (subtítulo some).

## Responsivo
- **Celular (390):** margens de 20 px; capa (180 px) ou caixa de data acima dos dados; ficha em uma coluna; faixa "Ouvir" e botão principal na largura toda; compartilhar no formato de celular da 013.
- **Tablet (768):** margens de 32 px; capa ou caixa de data à esquerda dos dados; ficha em duas colunas ou mais.
- **Desktop (1280):** cabeçalho em ~756 px centralizado; mesmo arranjo do tablet; texto na coluna de 680 px.
- Em todas: sem rolagem horizontal, sem sobreposição e sem `overflow`.

## Acessibilidade
- Título como `h1`; "Descrição", "Letra" e "Detalhes" como nível 2.
- Capa com nome "Capa de [título]"; placeholder decorativo; imagem da pesquisa com a legenda como nome (ou "Imagem da pesquisa" sem legenda), como no artigo.
- Faixa "Ouvir" lida como um botão: "Ouvir [título] em outra aba". "Mais informações" lido como "Mais informações em outra aba".
- Caixa de data decorativa para o leitor de tela (a "Data" da ficha já a lê por inteiro).
- Pílula lida como texto ("Em andamento"), logo depois do título. Ficha lida em pares, Integrantes também.
- Ordem de Tab: navbar → migalhas → faixa "Ouvir" ou "Mais informações" → compartilhar → Apoio e rodapé. Foco visível em todos.
- Contraste ≥ 4,5:1 na pílula (as duas situações), no texto e no endereço da faixa, no texto branco da caixa de data, na ficha e na legenda.
- Movimento reduzido: nenhum movimento novo.

## Dados e regras de negócio
- Mesmos dados e estados da página do post (012). Modelos (`PostModel`, `PodcastModel`, `MusicModel`, `EventModel`, `SearchModel`), enums, coleções, regras e índices do Firebase não mudam. Nenhum dado é corrigido. A data do evento só é lida, nunca reescrita.
- Rotas não mudam. O painel não muda.

## Critérios de aceite
1. [ ] Podcast, música, evento e pesquisa mostram, nesta ordem: navbar, migalhas "Início › [Área] › [Categoria] › [Tipo]", bloco, linha de compartilhar (na pesquisa, seguida da imagem com legenda), texto na coluna de 680 px, Apoio e rodapé; sem Leia também.
2. [ ] Título `h1` em cor de tinta, sem caixa alta forçada; ficha de cada tipo com os rótulos da tabela "Por tipo", no desenho da 021, sem campos vazios e sumindo sem campos; Integrantes na largura toda com as quebras de linha.
3. [ ] Podcast e música: capa 1:1 de 180 px sem distorcer, ao lado dos dados (tablet e desktop) ou acima (celular), com placeholder sem imagem e na falha.
4. [ ] Faixa "Ouvir episódio"/"Ouvir música" com botão redondo, endereço do site sem "www." e ícone externo; abre o link em outra aba por clique e Enter; some sem link; com endereço ilegível, só o texto.
5. [ ] Música: "Descrição" e depois "Letra" com a letra no estilo de texto rico e quebras de linha; letra vazia sem subtítulo; letra não-delta como texto simples.
6. [ ] Evento: caixa de data com dia e mês abreviado quando a data começa em "DD/MM[/AAAA]" ou "D[º] de mês [de AAAA]" (primeira data de um intervalo), inclusive com dias que dividem o mês ("06 a 10 de julho"); sem caixa em formato não reconhecido ou data impossível; "Data" sempre na ficha como cadastrada.
7. [ ] Evento: "Mais informações" abre o link em outra aba por clique e Enter e some sem link; "Detalhes" com parágrafos nas quebras de linha e sem subtítulo quando vazio.
8. [ ] Pesquisa: pílula "Em andamento" (verde) ou "Concluída" (neutra) junto do título, quebrando para a linha de baixo quando não cabe; imagem 21:9 com legenda abaixo do compartilhar, sem figura quando não há imagem e com placeholder na falha; sem botão.
9. [ ] Compartilhar é o mesmo do artigo (013), com foco visível e nome acessível.
10. [ ] Esqueleto, 404 e caixa de erro continuam como na 012/020 para esses tipos.
11. [ ] Acessibilidade conforme a seção: `h1` e nível 2, nome da capa e da imagem da pesquisa, faixa e botão "em outra aba", caixa de data decorativa, ficha em pares, ordem de Tab, contraste ≥ 4,5:1.
12. [ ] Em 390, 768 e 1280 px conforme "Responsivo": sem rolagem horizontal, sobreposição ou `overflow` (inclusive em modo debug); títulos, nomes e integrantes longos quebram linha.
13. [ ] Artigo, livro, filme, revista, documento e produção acadêmica continuam iguais, sem erro no console; Home (avatar, destaques) e biblioteca sem mudança.
14. [ ] Código novo só com tokens de `lib/app/theme/`, sem `num_extension` e sem `GestureDetector` solto; os quatro `*_content.dart`, `article_content.dart`, `SocialIcons` e `ViewQuill` apagados, sem `AppNetworkImage` nos posts e nenhum `*_content.dart` em `posts/`; `docs/arquitetura.md` atualizado; `fvm flutter analyze` sem problemas novos e `fvm flutter build web --release` sem erro; nenhum modelo, rota, regra do Firebase, pacote ou arquivo do painel alterado.

## Fora do escopo
- Player de áudio ou vídeo embutido, barra de progresso e duração do episódio.
- Imagem do evento na página.
- Esqueleto por tipo; Leia também fora do artigo.
- Apagar `AppNetworkImage` e `ImageErrorContent` (Home, `core` e painel ainda usam) e os assets dos ícones sociais antigos (Fase 7).
- Mudar modelos, painel, rotas, regras do Firebase; padronizar a data do evento; criar conteúdo de teste pelo painel.
- Painel administrativo, Geoensine e modo escuro.

## Perguntas em aberto
- Nenhuma. Respondidas no modo autônomo:
  - **Player.** Decidido no modo autônomo: no lugar do player do protótipo, uma faixa "Ouvir" com o mesmo desenho (caixa, botão redondo) que abre o link em outra aba, sem barra nem tempo, porque o link é externo (Spotify, YouTube etc.) e um player falso enganaria; o mesmo critério da 021 para o filme.
  - **Endereço na faixa.** Decidido no modo autônomo: mostrar o site do link sem "www." para a pessoa saber para onde vai antes de clicar.
  - **Imagem do podcast e da música.** Decidido no modo autônomo: capa quadrada de 180 px (o desenho da capa do livro em 1:1), embora o protótipo não mostre imagem, porque a arte do episódio ou do disco identifica o conteúdo e já aparece no desenho antigo.
  - **Caixa de data.** Decidido no modo autônomo: só quando dia e mês do início puderem ser lidos do texto livre; "Data" sempre na ficha, porque a caixa perde ano e intervalo. Caixa decorativa para o leitor de tela, para não ler a data duas vezes.
  - **Imagem do evento.** Decidido no modo autônomo: fora da página, como no protótipo (a caixa de data ocupa o lugar); cartazes têm proporção livre e o recorte cortaria informação. Continua nos cards.
  - **Abrangência.** Decidido no modo autônomo: na ficha, como no protótipo, e não no selo acima do título.
  - **Imagem da pesquisa.** Decidido no modo autônomo: como a imagem do artigo, com a legenda, abaixo do compartilhar, porque o campo de legenda é obrigatório no painel e sumiria com a imagem.
  - **Pílula da pesquisa.** Decidido no modo autônomo: "Em andamento" com as cores de sucesso (verde do protótipo) e "Concluída" neutra, no desenho do selo.
  - **Rótulos.** Decidido no modo autônomo: "Coordenação", "Orientação", "Coorientação" e "Financiamento" (neutros, como na 021 e no protótipo); "Pesquisador(a)" mantido do painel, porque "Pesquisa" seria ambíguo; "Artista" na música.
  - **Subtítulos do texto.** Decidido no modo autônomo: "Descrição" (podcast, música, pesquisa), "Letra" (música) e "Detalhes" (evento), como nível 2, como na 021.
  - **Limpeza.** Decidido no modo autônomo: apagar também `article_content.dart` (sem uso desde a 012), `SocialIcons` e `ViewQuill`, que ficam sem uso, como a 020 fez; o erro de imagem antigo fica porque Home, `core` e painel o usam.
  - **Conferência.** Decidido no modo autônomo: os quatro tipos num build de prod só leitura; os casos que não existirem (data em formatos variados, sem imagem, imagem quebrada, sem link, letra não-delta, pesquisa concluída, integrantes longos) por dados injetados num build temporário fora do repositório, sem commit; nada é criado pelo painel nem no Firestore.

## Histórico de mudanças
- 2026-10-06: criada e aprovada no modo autônomo (execução da Fase 5).
- 2026-10-06: plano e tarefas criados (`plan.md`, `tasks.md`).
- 2026-10-06: na implementação, três dos sete eventos do prod escrevem a data como dias que dividem o mês ("06 a 10 de julho de 2026", "15, 16 e 17 de julho de 2026.", "20 e 22 de setembro de 2026") e ficariam sem caixa. Decidido no modo autônomo: aceitar uma lista ou intervalo de dias antes de "de mês" (separados por vírgula, hífen, travessão, "e", "a" ou "até") e usar o primeiro dia com esse mês. Comportamento e critério 6 atualizados.
