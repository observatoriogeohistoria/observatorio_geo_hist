# 007. Home: resumo de Nossa história

- **Status:** implementada
- **Item do planejamento:** Fase 1, seção 1.5 (Nossa história, resumo), com a rota nova de T-03
- **Protótipo:** aba "Home", bloco "Nossa história" (fundo de superfície, coluna estreita), logo abaixo do vídeo; aba "História" como referência da página completa (link no CLAUDE.md)
- **Criada em:** 2026-09-26
- **Depende de:** [001-fundacao](../001-fundacao/spec.md) (tokens, tipografia, largura máxima), [002-botoes-navbar-rodape](../002-botoes-navbar-rodape/spec.md) (navbar, rodapé, foco), [006-quem-somos-video](../006-quem-somos-video/spec.md) (bloco acima, link com seta)

## Objetivo
Na Home, quem visita lê em poucas linhas de onde vem o Observatório (a pesquisa financiada pela FAPEMIG) e pode abrir a história completa numa página própria. Hoje o texto inteiro, com três parágrafos longos, ocupa a Home.

## Situação atual
- [our_history.dart](../../../lib/app/features/home/presentation/components/our_history.dart): faixa cinza com o título "NOSSA HISTÓRIA" em branco e, abaixo, três parágrafos (cerca de 330 palavras) em cinza escuro, na largura toda. Usa `num_extension`. Há uma foto comentada no código (`our-history.webp`, "Foto: Antônio César Ortega").
- Na [home_page.dart](../../../lib/app/features/home/presentation/pages/home_page.dart) o bloco é carregado de forma adiada, logo abaixo do vídeo, seguido de uma linha divisória e da Equipe.
- Não existe página própria de Nossa história (T-03 do planejamento).
- O rodapé tem, em "Institucional", Manifesto, Equipe e Fale com a gente; o protótipo inclui "Nossa história" entre Manifesto e Equipe.

## Comportamento

### Home: resumo
O bloco continua no mesmo lugar: logo abaixo do vídeo e antes da Equipe. Aparece junto com a página, sem esperar dados. Faixa com fundo de superfície (`#F7F5F2`), com o respiro vertical de seção; o conteúdo fica numa coluna estreita alinhada à esquerda dentro da largura máxima do site:

1. **Rótulo** (caixa alta, laranja forte): "Nossa história".
2. **Título** (fonte de títulos, mesmo tamanho do título de Quem somos): "Da pesquisa em Minas Gerais a um observatório aberto."
3. **Marco** num selo em forma de pílula, fundo laranja suave e texto em laranja forte, com ícone de relógio: "Projeto financiado pela FAPEMIG · 2016–2018".
4. **Texto** (tamanho de leitura), dois parágrafos:
   - "O Observatório nasce da confluência entre o espírito acadêmico e o desejo de construir pontes entre pesquisadores, professores, estudantes e a sociedade. Foi idealizado pelo Grupo de Estudos e Pesquisas em Ensino de Geografia (GEPEGH/UFU), vinculado ao Programa de Pós-Graduação em Educação da Universidade Federal de Uberlândia."
   - "Embora o foco inicial seja Minas Gerais, sua missão ultrapassa qualquer fronteira geográfica: uma ferramenta de divulgação científica que valoriza a participação de todos."
5. **Link** "Ler a história completa" com seta, em laranja forte (o mesmo link com seta de "Conheça o manifesto") → abre a página Nossa história.

A faixa cinza com título branco, os três parágrafos longos e a linha divisória entre o bloco e a Equipe deixam de aparecer na Home (a mudança de fundo já separa os blocos).

### Página Nossa história (provisória)
Página nova no endereço **`/nossa-historia`**, com a navbar e o rodapé do site. É provisória: reaproveita o texto completo de hoje, sem mudar uma palavra, e o redesenho (foto, lista das três dimensões, subtítulos, migalhas) fica para a Fase 2.

- **Cabeçalho:** faixa de superfície com o título "Nossa história" (fonte de títulos, tamanho de título de página), alinhado à esquerda dentro da largura máxima, com uma linha fina na base.
- **Texto:** os três parágrafos atuais, na ordem de hoje, em tamanho de leitura e cor de tinta, numa coluna de leitura centralizada (até 680 px), com espaço entre os parágrafos.
- A página abre no topo. O botão voltar do navegador leva de volta à Home.
- Com pouco conteúdo na tela (janela muito alta), o rodapé fica colado na base da janela.

### Rodapé
Na coluna "Institucional", entra o link "Nossa história" entre "Manifesto" e "Equipe", abrindo `/nossa-historia`, com o mesmo estilo e foco dos demais.

## Estados
- **Carregando:** não se aplica. O resumo e a página são estáticos e aparecem junto com a navbar.
- **Vazio:** não se aplica (textos fixos).
- **Erro:** não se aplica (sem dados do banco). Endereço errado continua caindo na página 404 atual.
- **Sem imagem / imagem com falha:** não se aplica (nenhuma imagem nesta entrega).
- **Casos de borda:**
  - Selo do marco em tela estreita ou com texto ampliado: o texto quebra dentro do selo (que cresce na altura), sem `overflow`.
  - Texto ampliado pelo navegador até 200%: título, selo, parágrafos e link quebram linha sem sobreposição nem `overflow`, na Home e na página.
  - Acesso direto a `/nossa-historia` (atualizar a página ou abrir o link colado): a página abre normalmente.

## Responsivo
- **Celular (390):** margens de 20 px. Título do resumo ≈ 27 px, texto 17 px; selo quebra em duas linhas se precisar. Na página, título ≈ 32 px e coluna de leitura na largura toda.
- **Tablet (768):** margens de 32 px. Título do resumo ≈ 36 px, texto 18 px, coluna de até 720 px. Na página, título ≈ 40 px, coluna de leitura de até 680 px centralizada.
- **Desktop (1280):** conteúdo limitado a 1120 px. Resumo numa coluna de até 720 px à esquerda, título ≈ 40 px. Na página, título ≈ 52 px, coluna de leitura de 680 px centralizada.
- Em todas: sem rolagem horizontal e sem aviso de `overflow`.

## Acessibilidade
- O título do resumo e o título da página são anunciados como cabeçalhos.
- "Ler a história completa" é um link alcançável por Tab, com o contorno de foco padrão (3 px, laranja, afastado 2 px), ativável por Enter e pelo toque do leitor de tela.
- O ícone de relógio do selo e a seta do link são decorativos. O selo é lido como texto: "Projeto financiado pela FAPEMIG · 2016–2018".
- O link "Nossa história" do rodapé tem foco visível e nome acessível, como os demais.
- Contraste: rótulo e link em laranja forte `#A33600` sobre a superfície (6,3:1); texto do selo `#A33600` sobre laranja suave `#FFF0E6` (6,1:1); título e parágrafos em tinta (≥ 15:1).
- Movimento reduzido: o link não anima o vão da seta no hover (comportamento já existente do link com seta).

## Dados e regras de negócio
- Textos fixos no código. O resumo usa os textos do protótipo aprovado; a página usa o texto completo de hoje, sem alteração (o conteúdo real não é apagado, só muda de lugar).
- Rota **nova** `/nossa-historia`. Nenhuma rota existente muda; nada muda em modelos de dados, coleções ou regras do Firebase.
- A navbar não marca item ativo em `/nossa-historia`, como já acontece em `/manifest`.

## Critérios de aceite
1. [ ] Na Home, o bloco Nossa história aparece logo abaixo do vídeo e antes da Equipe, sem a linha divisória entre ele e a Equipe; a faixa cinza com "NOSSA HISTÓRIA" em branco e os três parágrafos longos não aparecem mais na Home.
2. [ ] O resumo mostra, com os textos exatos desta spec, rótulo, título, selo do marco com ícone, os dois parágrafos e o link "Ler a história completa", sobre o fundo de superfície.
3. [ ] "Ler a história completa" abre `/nossa-historia` por clique, Enter e toque do leitor de tela.
4. [ ] `/nossa-historia` mostra navbar, cabeçalho de superfície com "Nossa história", os três parágrafos do texto atual (idênticos, na mesma ordem) e o rodapé; abre no topo e funciona por acesso direto (atualizar a página).
5. [ ] O botão voltar do navegador, a partir de `/nossa-historia`, volta à Home.
6. [ ] O rodapé mostra "Nossa história" entre "Manifesto" e "Equipe", abrindo `/nossa-historia` por clique e Enter.
7. [ ] Nenhuma rota existente muda (`/`, `/manifest`, `/membro/:id`, `/contato`, `/colaborar`, posts, biblioteca e admin continuam abrindo como antes).
8. [ ] Em 1280 px, o resumo fica numa coluna de até 720 px alinhada à esquerda dentro de 1120 px e o texto da página numa coluna de 680 px centralizada; em 768 e 390 px, conforme "Responsivo".
9. [ ] O selo do marco quebra linha dentro da pílula quando não cabe (390 px e texto ampliado), sem `overflow`.
10. [ ] Os títulos do resumo e da página são cabeçalhos; ícone do selo e seta do link são ignorados pelo leitor de tela; link do resumo e link do rodapé alcançáveis por Tab na ordem visual, com contorno de foco visível.
11. [ ] Contraste: rótulo e link ≥ 4,5:1 sobre a superfície, texto do selo ≥ 4,5:1 sobre o laranja suave, título e parágrafos ≥ 4,5:1.
12. [ ] Com pouco conteúdo na janela (tela alta), o rodapé de `/nossa-historia` fica na base da janela.
13. [ ] Em 390, 768 e 1280 px (e com texto a 200%), na Home e em `/nossa-historia`: sem rolagem horizontal, sem sobreposição e sem `overflow`.
14. [ ] O código novo usa só tokens de `lib/app/theme/` (nenhuma cor, tamanho de fonte ou espaçamento solto) e não usa `num_extension`; `fvm flutter analyze` sem problemas novos e `fvm flutter build web --release` sem erro.

## Fora do escopo
- Redesenho completo da página Nossa história (foto com legenda, selo do marco, lista das três dimensões, subtítulos, frase de apoio e migalhas do protótipo): Fase 2.
- Título da aba do navegador por página e item ativo da navbar em páginas institucionais.
- Revisar ou reescrever o texto completo de Nossa história.
- Apagar `our-history.webp` e outros arquivos sem uso (Fase 7).
- Redesenho de Equipe, Realização e apoio e Chamada para contato (specs 008 e 009).
- Painel administrativo, Geoensine e modo escuro.

## Perguntas em aberto
- Nenhuma. Respondidas no modo autônomo:
  - **Endereço da página.** Decidido no modo autônomo: `/nossa-historia`, porque as rotas públicas novas do site são em português e com hífen onde precisa (`/contato`, `/colaborar`, `/biblioteca`), e criar rota nova é permitido desde que nenhuma existente mude.
  - **Conteúdo da página provisória.** Decidido no modo autônomo: o texto completo de hoje, sem alteração, com título, cabeçalho e coluna de leitura nos tokens novos (sem foto, lista, subtítulos nem migalhas), porque a divisão da Fase 1 ([execucao-fase-1.md](../execucao-fase-1.md)) deixa o redesenho da página para a Fase 2 e o conteúdo real não pode ser alterado.
  - **Textos do resumo.** Decidido no modo autônomo: os do protótipo aprovado (título, selo e dois parágrafos), porque são uma condensação fiel do texto atual, que continua inteiro na página nova (mesmo critério da 006 em Quem somos).
  - **Link no rodapé.** Decidido no modo autônomo: incluir "Nossa história" entre Manifesto e Equipe, porque o rodapé do protótipo já tem esse link e, com a página existindo, a mudança é só aditiva.
  - **Linha divisória antes da Equipe.** Decidido no modo autônomo: sai, porque a faixa de superfície do resumo já separa os blocos e o protótipo não tem divisória ali; a Equipe em si fica para a 008.
  - **Selo em tela estreita.** Decidido no modo autônomo: o texto quebra dentro da pílula, porque a 390 px o selo em uma linha passa da largura útil (350 px) e cortar o texto esconderia o marco.
  - **Item ativo da navbar.** Decidido no modo autônomo: nenhum, igual a `/manifest`, porque mudar a lógica da navbar está fora do item 1.5.
  - **Cor do rótulo, do link e do selo.** Decidido no modo autônomo: laranja forte `#A33600`, porque o laranja de acento sobre a superfície dá 4,48:1 (mesma regra da 004 e da 006) e o protótipo já usa o laranja forte no selo.

## Histórico de mudanças
- 2026-09-26: criada e aprovada no modo autônomo (execução da Fase 1).
- 2026-09-26: plano e tarefas criados (`plan.md`, `tasks.md`).
- 2026-09-26: na implementação, o padrão do Manifesto (`SliverFillRemaining` vazio seguido do rodapé) deixava o rodapé abaixo da janela alta, com um vão em branco. Decidido no modo autônomo: o rodapé da página nova fica dentro do `SliverFillRemaining`, alinhado à base; para isso o rodapé no tablet troca o `LayoutBuilder` + `Wrap` por duas linhas de duas colunas (mesmo visual), porque o `SliverFillRemaining` mede o filho por altura intrínseca. As demais páginas com o padrão antigo ficam como estão (fora do escopo).
- 2026-09-26: implementada.
