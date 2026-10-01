# 011. Nossa história completa e Pessoa da equipe

- **Status:** implementada
- **Item do planejamento:** Fase 2, T-03 (Nossa história completa) e T-02 (Pessoa da equipe)
- **Protótipo:** abas "História" e "Membro"; aba "Estados" para o erro (link no CLAUDE.md)
- **Criada em:** 2026-10-01
- **Depende de:** [010-leitura-manifesto](../010-leitura-manifesto/spec.md) (base de leitura: cabeçalho, migalhas, coluna e blocos), [007-resumo-nossa-historia](../007-resumo-nossa-historia/spec.md) (página provisória e selo do marco), [008-equipe](../008-equipe/spec.md) (grade da Home, regra de quem é clicável, iniciais)

## Objetivo
Quem abre Nossa história lê a trajetória do Observatório com foto, subtítulos e as três dimensões da pesquisa em lista, no mesmo padrão de leitura do Manifesto. Quem clica numa pessoa da equipe vê foto, função, nome, apresentação e o Currículo Lattes num layout claro, com carregando, erro e "não encontrada" tratados.

## Situação atual
- [our_history_page.dart](../../../lib/app/features/home/presentation/pages/our_history_page.dart) (spec 007, provisória): cabeçalho de superfície só com o título, três parágrafos longos na coluna de 680 px. Sem migalhas, foto, subtítulos nem lista. Monta cabeçalho e coluna na própria página, sem a base da 010.
- [team_member_page.dart](../../../lib/app/features/home/presentation/pages/team_member_page.dart): visual antigo com `num_extension`: foto redonda (só quando existe), nome em caixa alta laranja, função em caixa alta cinza claro (contraste baixo), descrição justificada e botão primário "Currículo Lattes". Carregando usa o indicador antigo; erro usa `PageErrorContent` antigo ("Erro ao carregar a página", sem tentar de novo). O rodapé fica fora do `SliverFillRemaining`.
- Acesso à pessoa: busca a equipe uma vez no `initState`, só se ainda não buscou ou se a última busca falhou (`needsFetch`). Com a busca concluída, id inexistente ou membro sem descrição mostra a 404 (`PageNotFound`). O laço de leituras em `/membro/<id inexistente>` registrado na verificação da 008 **já não ocorre** no código atual (a página não chama mais `fetchTeam()` no `build` nem numa reação). Esta spec mantém isso como critério.
- A foto `assets/images/our-history.webp` (3291 × 2197, foto de grupo) existe nos assets e já foi usada na Home com a legenda "Foto: Antônio César Ortega".

## Comportamento

### Nossa história (`/nossa-historia`)
Usa a base de leitura da 010, de cima para baixo:

1. **Cabeçalho de página:** migalhas "Início" (abre a Home) › "Nossa história"; título "Nossa história"; texto de apoio "Da pesquisa em Minas Gerais a um observatório aberto a todo o país."
2. **Foto com legenda:** largura de até 920 px, centralizada, com cantos arredondados, proporção fixa de 21:9 preenchida sem distorcer (recorte). O recorte preserva o alto da foto (rostos) e corta embaixo. Legenda abaixo, em texto pequeno e cor secundária: "Foto: Antônio César Ortega".
3. **Coluna de leitura (680 px)**, com os blocos na ordem:
   - **Selo:** "Projeto financiado pela FAPEMIG · 2016–2018" (o mesmo selo do resumo da Home).
   - **Parágrafo:** "O Observatório do Ensino de História e Geografia nasce da confluência entre o espírito acadêmico e o desejo de construir pontes entre pesquisadores, professores, estudantes e a sociedade brasileira, dentro e fora dos muros escolares e universitários."
   - **Parágrafo:** "O Observatório foi idealizado e criado pelo Grupo de Estudos e Pesquisas em Ensino de Geografia – GEPEGH/UFU, vinculado à Linha de Pesquisa “Saberes e Práticas Educativas” do Programa de Pós-Graduação em Educação da Universidade Federal de Uberlândia, Minas Gerais, Brasil."
   - **Parágrafo:** "O Observatório é um espaço formativo e colaborativo, fruto do Projeto de Pesquisa Coletivo, financiado pela FAPEMIG (2016–2018), intitulado “Observatório do Ensino de História e Geografia em Minas Gerais: políticas educacionais, formação docente e produção de conhecimentos”. O projeto foi desenvolvido por pesquisadores de diferentes níveis (IC, Mestrado e Doutorado), apoiado por diversas instituições."
   - **Subtítulo:** "As três dimensões investigadas"
   - **Parágrafo:** "A investigação realizada se deteve no estudo das três dimensões do ensino de História e Geografia em Minas, as quais se refletiram na concepção deste Observatório:"
   - **Lista com marcadores:**
     - "as políticas públicas educacionais voltadas para o desenvolvimento do ensino e aprendizagem de História e Geografia implementadas pela Secretaria de Educação do estado (SEE/MG);"
     - "a produção acadêmica (teses e dissertações) das Instituições de Ensino Superior (IES) públicas que focalizam o ensino de História e Geografia;"
     - "o lugar do ensino de História e Geografia nos cursos de formação inicial de professores das IES públicas."
   - **Subtítulo:** "Para além de Minas Gerais"
   - **Parágrafo:** "Embora o foco inicial seja o nosso estado de Minas Gerais, entendemos que a missão deste espaço – que é, sobretudo, uma ferramenta para divulgação científica –, ultrapassa qualquer fronteira geográfica. Concebemos um Observatório capaz de interconectar diversas dimensões e realidades que permeiam a educação brasileira e o ensino de História e Geografia, congregando saberes, projetos, opiniões, experiências educativas e protagonistas de diferentes lugares."
   - **Parágrafo:** "Para tanto, valorizamos e incentivamos a participação de todos e contamos com o poder multiplicador de cada pessoa, seja ela pesquisador, professor ou estudante."
4. **Rodapé**, na base da janela quando a página é curta.

O texto é o de hoje, palavra por palavra, só redistribuído: o primeiro parágrafo vira três; o segundo vira introdução + lista (sai só o conector "e, por fim,"); o terceiro vira dois. "2016-2018" passa a "2016–2018" (traço de intervalo). Apoio e subtítulos são textos novos do protótipo.

**Blocos novos da base de leitura** (reaproveitáveis pela 012):
- **Subtítulo:** fonte de títulos, peso 700, maior que o texto, com respiro maior acima do que abaixo.
- **Lista com marcadores:** marcador redondo à esquerda, texto em tinta no tamanho de leitura; texto que quebra linha fica alinhado ao texto, não ao marcador; pequeno vão entre itens.
- **Figura:** imagem em proporção fixa com legenda opcional, mais larga que a coluna (até 920 px).

### Pessoa da equipe (`/membro/:id`)
Usa o esqueleto da base de leitura sem a faixa de cabeçalho. Conteúdo numa largura de até 920 px, centralizada:

1. **Migalhas:** "Início" (Home) › "Equipe" (Home) › nome da pessoa (página atual).
2. **Foto e texto lado a lado** (coluna da foto de até 300 px; empilhados em tela estreita):
   - **Foto** quadrada com cantos arredondados, preenchida sem distorcer (recorte centralizado).
   - **Função** como rótulo (caixa alta, laranja forte, pequeno).
   - **Nome** como título da página (fonte de títulos, grande), como está cadastrado, sem forçar caixa alta.
   - **Descrição** em texto de leitura, alinhada à esquerda (não justificada). Cada quebra de linha do texto cadastrado vira um parágrafo; linhas em branco não geram vão extra.
   - **Botão secundário "Currículo Lattes"** com ícone de link externo, que abre o Lattes em outra aba. Só aparece se houver `lattesUrl`.
3. **Rodapé**, na base da janela quando a página é curta.

O nome em caixa alta laranja, a função em cinza claro, o texto justificado e o indicador de carregamento antigo deixam de aparecer.

**Quando a página existe:** só para membro com descrição não vazia (ignorando espaços), a mesma regra da grade da Home. Id inexistente ou membro sem descrição mostra a página 404 atual.

## Estados

### Nossa história
- **Carregando / vazio / erro:** não se aplicam (texto fixo).
- **Foto:** enquanto a imagem decodifica, o espaço da foto já tem a proporção final com fundo de superfície (sem pulo de layout). Se falhar, fica um placeholder na mesma proporção, fundo laranja suave com ícone de imagem decorativo; a legenda continua.

### Pessoa da equipe
- **Carregando** (equipe ainda não buscada, por acesso direto): esqueleto na mesma estrutura (quadrado da foto, barras do rótulo, do nome e de três linhas de texto), sem migalhas com nome. Com a equipe já carregada (vindo da Home), a página aparece direto, sem esqueleto.
- **Erro** na busca: no lugar do conteúdo, caixa de estado com "Não foi possível carregar", "Verifique sua conexão e tente novamente." e botão primário "Tentar de novo", que refaz a busca uma vez por clique.
- **Não encontrada** (id inexistente ou sem descrição): página 404 atual, depois de **no máximo uma** leitura da coleção `team`; nenhuma nova leitura enquanto a 404 estiver aberta.
- **Sem foto ou foto com falha:** quadrado em laranja suave com as iniciais do nome em laranja forte (as mesmas iniciais da grade da Home), no mesmo tamanho.
- **Casos de borda:** nome ou função muito longos quebram linha; descrição de uma linha só ou muito longa; sem Lattes (sem botão); foto muito alta ou muito larga (recorte, sem distorcer).

## Responsivo
- **Celular (390):** margens de 20 px. Nossa história: foto na largura útil (350 px, ~150 px de altura), subtítulo ≈ 24 px. Pessoa: foto em cima, até 280 px de largura, alinhada à esquerda; texto abaixo; nome ≈ 32 px.
- **Tablet (768):** margens de 32 px. Nossa história: foto na largura útil (704 px), coluna de 680 px. Pessoa: foto (até 300 px) e texto lado a lado.
- **Desktop (1280):** Nossa história: cabeçalho alinhado à esquerda em 1120 px, foto de 920 px e coluna de 680 px centralizadas, subtítulo ≈ 27 px. Pessoa: bloco de 920 px centralizado, foto de 300 px e texto lado a lado, nome ≈ 48 px.
- Em todas: sem rolagem horizontal e sem `overflow`.

## Acessibilidade
- Título anunciado como cabeçalho de nível 1 ("Nossa história"; na pessoa, o nome). Subtítulos de Nossa história como cabeçalho de nível 2.
- Migalhas como navegação "Você está em", com o item atual marcado (comportamento da 010). Links com foco visível e ativáveis por Enter.
- Foto de Nossa história com nome acessível "Foto de grupo dos pesquisadores do Observatório"; a legenda é lida como texto. Ícones de placeholder são decorativos.
- Foto da pessoa com nome acessível "Foto de [nome]"; com placeholder de iniciais, decorativo (o nome já está no título).
- Lista com marcadores lida como lista de três itens; marcadores não lidos.
- Ordem de Tab na pessoa: migalhas → "Currículo Lattes" → rodapé. No erro: "Tentar de novo".
- Contraste ≥ 4,5:1: rótulo da função, legenda, migalhas, texto, iniciais e textos da caixa de erro; nada em cinza claro.
- Movimento reduzido: o esqueleto não pisca quando o sistema pede menos movimento (se o `Skeleton` atual animar, fica estático nessa condição).

## Dados e regras de negócio
- Nossa história: texto fixo no código; foto `assets/images/our-history.webp`, já declarada nos assets.
- Pessoa: dados da coleção `team` pelo `FetchTeamStore` já existente (`name`, `role`, `description`, `lattesUrl`, `image`). Modelo, datasource e regras do Firebase não mudam.
- A regra "tem página" (descrição não vazia ignorando espaços) é a mesma na grade da Home e na página.
- Rotas: nenhuma muda. `/nossa-historia` e `/membro/:id` continuam; "Equipe" nas migalhas aponta para a Home, como o link "Equipe" do rodapé.
- A navbar não marca item ativo nessas páginas (como hoje).

## Critérios de aceite
1. [ ] `/nossa-historia` mostra navbar, cabeçalho de superfície com migalhas "Início › Nossa história", título "Nossa história" e o apoio "Da pesquisa em Minas Gerais a um observatório aberto a todo o país.", depois a foto com legenda, a coluna de leitura e o rodapé.
2. [ ] O texto de Nossa história é exatamente o desta spec, na ordem (selo, três parágrafos, subtítulo, introdução, lista de 3 itens, subtítulo, dois parágrafos); conferido por script que toda frase do texto atual está presente, salvo "e, por fim," e o traço em "2016–2018".
3. [ ] Os dois subtítulos aparecem na fonte de títulos, maiores que o texto, e são anunciados como cabeçalho de nível 2; a lista das três dimensões tem marcadores, texto quebrado alinhado ao texto e é anunciada como lista.
4. [ ] A foto de Nossa história fica em 21:9, até 920 px, cantos arredondados, sem distorcer, com os rostos visíveis (corte embaixo), legenda "Foto: Antônio César Ortega" abaixo e nome acessível; sem pulo de layout ao carregar; com falha forçada, aparece o placeholder na mesma proporção.
5. [ ] `/membro/<id com descrição>` mostra migalhas "Início › Equipe › Nome", foto quadrada, função como rótulo, nome como título `h1`, descrição em parágrafos alinhados à esquerda e "Currículo Lattes" (secundário, ícone externo) quando há `lattesUrl`; o botão abre o Lattes em outra aba por clique e Enter.
6. [ ] Sem `lattesUrl`, o botão não aparece; sem foto ou com foto que falha, aparece o quadrado com as iniciais, do mesmo tamanho.
7. [ ] `/membro/<id inexistente>` e `/membro/<id sem descrição>` mostram a 404 depois de no máximo uma leitura da coleção `team`; a 404 aberta por 10 s não gera nenhuma leitura nova (conferido nas requisições de rede ou com contador no repositório).
8. [ ] Acesso direto a `/membro/<id>` mostra o esqueleto até a equipe chegar; vindo da Home (equipe já carregada), não há esqueleto nem nova leitura.
9. [ ] Com falha na busca da equipe, aparece "Não foi possível carregar", "Verifique sua conexão e tente novamente." e "Tentar de novo"; o botão refaz a busca uma vez por clique e, com sucesso, mostra a pessoa.
10. [ ] Os membros clicáveis na grade da Home são exatamente os que têm página (mesma regra), e cada um abre a sua página.
11. [ ] Migalhas das duas páginas: links abrem a Home por clique e Enter; item atual não é link; ordem de Tab na pessoa: migalhas → Currículo Lattes → rodapé, com foco visível.
12. [ ] Contraste ≥ 4,5:1 em rótulo da função, legenda, migalhas, texto, iniciais e caixa de erro; nenhum texto em cinza claro.
13. [ ] Em 390, 768 e 1280 px conforme "Responsivo": sem rolagem horizontal, sem sobreposição, sem `overflow`; foto da pessoa empilhada em 390 e lado a lado em 768 e 1280; nome e descrição longos quebram linha.
14. [ ] Com a janela alta, o rodapé fica na base da janela nas duas páginas.
15. [ ] Nenhuma rota muda (`/`, `/nossa-historia`, `/membro/:id`, `/manifesto`, `/contato`, posts, biblioteca e admin abrem como antes); "Ler a história completa" na Home e "Nossa história" no rodapé abrem a página.
16. [ ] Subtítulo, lista com marcadores e figura são blocos da base de leitura (`core/components/reading/`), descritos em `docs/arquitetura.md`; Nossa história não monta mais cabeçalho e coluna por conta própria.
17. [ ] O código novo usa só tokens de `lib/app/theme/` e não usa `num_extension`; as duas páginas não importam mais `AppHeadline`, `AppBody`, `PageErrorContent` nem `LoadingContent`; `fvm flutter analyze` sem problemas novos e `fvm flutter build web --release` sem erro.

## Fora do escopo
- Redesenho da página 404 e dos estados gerais (T-10, Fase 5): a pessoa não encontrada usa a 404 atual.
- Âncora para a seção Equipe na Home (o link "Equipe" vai para o topo da Home, como no rodapé).
- Botão "← Equipe" do protótipo (ver decisões).
- Título da aba do navegador por página e item ativo da navbar.
- Mudar o modelo `TeamMemberModel`, o datasource, o painel de equipe ou as regras do Firebase.
- Apagar `AppHeadline`, `AppBody`, `PageErrorContent`, `LoadingContent`, `Avatar` ou `num_extension` (Fase 7).
- Layout do post e compartilhamento (012 e 013). Painel administrativo, Geoensine e modo escuro.

## Perguntas em aberto
- Nenhuma. Respondidas no modo autônomo:
  - **Texto de Nossa história.** Decidido no modo autônomo: estrutura do protótipo (apoio, foto, selo, subtítulos, lista) com o texto atual palavra por palavra, porque o protótipo reescreve trechos (troca termos, tira "e o ensino de História e Geografia", encurta os itens) e não se pode apagar conteúdo real; diferente da 010, aqui as mudanças do protótipo não são só correções.
  - **Foto de Nossa história.** Decidido no modo autônomo: usar `our-history.webp` com a legenda do protótipo, em 21:9 com o recorte puxado para cima, porque o protótipo pede a foto real com essa legenda e um corte central tiraria os rostos da foto de grupo.
  - **Botão "← Equipe".** Decidido no modo autônomo: não entra, porque as migalhas logo ao lado já têm "Equipe" com o mesmo destino, e o botão discreto atual não tem ícone à esquerda (seria mudar o componente da 002).
  - **Destino de "Equipe".** Decidido no modo autônomo: a Home, como o link "Equipe" do rodapé, porque não há âncora para a seção e criá-la mexe na Home e no roteador.
  - **Pessoa não encontrada.** Decidido no modo autônomo: a 404 atual, porque o redesenho da 404 é da Fase 5 (T-10) e o planejamento diz que id inexistente "já mostra o 404".
  - **Laço de leituras.** Decidido no modo autônomo: não há correção a fazer (o código atual busca só no `initState` e só se `needsFetch`); vira o critério 7 para não regredir.
  - **Descrição.** Decidido no modo autônomo: alinhada à esquerda e com quebras de linha virando parágrafos, porque o protótipo usa `.prose` (sem justificar) e a descrição vem de um campo de texto livre do painel.
  - **Erro na pessoa.** Decidido no modo autônomo: caixa de estado do protótipo (aba "Estados") com "Tentar de novo", porque o `PageErrorContent` antigo não deixa tentar de novo e usa cinza claro.
  - **Função como rótulo.** Decidido no modo autônomo: laranja forte (`accentStrong`), como o rótulo do resumo da Home (007), porque garante folga de contraste.

## Histórico de mudanças
- 2026-10-01: criada e aprovada no modo autônomo (execução da Fase 2).
- 2026-10-01: plano e tarefas criados (`plan.md`, `tasks.md`).
- 2026-10-01: ajustes na implementação (modo autônomo): cor `errorSurface` no tema para o ícone da caixa de erro; layout foto | texto em `MemberPageLayout` (arquivo próprio, usado pela página e pelo esqueleto); no erro da pessoa, sem migalhas; a caixa de erro ocupa toda a largura. Status: implementada.
