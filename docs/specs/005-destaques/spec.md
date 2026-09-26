# 005. Home: destaques

- **Status:** implementada
- **Item do planejamento:** Fase 1, seção 1.2
- **Protótipo:** aba "Home", bloco "Destaques" logo abaixo do hero (link no CLAUDE.md)
- **Criada em:** 2026-09-26
- **Depende de:** [001-fundacao](../001-fundacao/spec.md) (tokens, tipografia, largura máxima), [002-botoes-navbar-rodape](../002-botoes-navbar-rodape/spec.md) (botões, foco) e [004-hero-atalhos](../004-hero-atalhos/spec.md) (hero acima deste bloco)

## Objetivo
Quem chega à Home vê, logo depois da apresentação, até três publicações escolhidas pela equipe, todas ao mesmo tempo, com título legível sobre qualquer foto enviada pelos autores. Hoje os destaques ficam num carrossel automático de tela quase cheia, com a foto coberta por um véu escuro de 70% e só uma publicação visível por vez.

## Situação atual
[highlights.dart](../../../lib/app/features/home/presentation/components/highlights.dart) mostra um carrossel (`carousel_slider`) que troca sozinho quando há mais de um destaque, ocupa 85% da altura da tela no desktop (50% no celular), escurece toda a foto e centraliza o título; setas "Destaque anterior" e "Próximo destaque" nas laterais e faixas cinza acima e abaixo. O clique usa `GestureDetector` (sem foco por teclado). Não há título de seção, esqueleto nem mensagem de erro: enquanto carrega, se der erro ou se não houver destaques, o bloco simplesmente não aparece. Os dados vêm do `FetchHighlightsStore`, que busca os posts publicados com `isHighlighted` e é disparado pela [home_page.dart](../../../lib/app/features/home/presentation/pages/home_page.dart) quando as categorias chegam. Durante a implementação da 004 o bloco não apareceu na Home (sem destaques no banco ou busca com erro silencioso; a causa é conferida no plano).

## Comportamento

### Posição
O bloco continua logo abaixo do hero e acima de "Quem somos". Fundo branco (cor da página), conteúdo dentro da largura máxima do site, com respiro vertical de seção.

### Cabeçalho da seção
Título "Destaques" (estilo de título de seção). O link "Ver todas as publicações" do protótipo **não** entra (ver perguntas).

### Quais destaques aparecem
- Entram os posts publicados marcados como destaque, **do mais recente para o mais antigo** (data de criação; os sem data vão para o fim).
- Aparecem **no máximo três**, todos visíveis de uma vez. O mais recente é o **principal** (cartão maior). Os demais destaques, além do terceiro, não aparecem na Home.
- Posts sem conteúdo ou sem área/categoria que permita montar o endereço são ignorados (não contam para os três).
- Sem carrossel, sem troca automática e sem setas.

### Cartão de destaque
Cada destaque é um cartão com cantos arredondados que mostra a foto do post preenchendo todo o cartão (recortada, sem distorcer). Sobre a foto, **só na parte de baixo**, um degradê escuro que sobe a partir da base e some antes do topo; a parte de cima da foto fica sem véu. Sobre o degradê, alinhados à esquerda e embaixo:
1. **Rótulo** (caixa alta, laranja claro próprio para fundo escuro): tipo do post e área, separados por " · ". Ex.: "ARTIGO · GEOGRAFIA", "FILME · HISTÓRIA". O tipo usa o nome em português que o site já usa (Artigo, Livro, Filme, Evento, Pesquisa, Podcast, Música, Revista, Documento, Produção Acadêmica).
2. **Título** do post, em branco (fonte de títulos). No cartão principal é maior e ocupa até cerca de 22 caracteres por linha no desktop.
3. **Data** (só no cartão principal, quando o post tem data de criação), em texto pequeno claro, no formato "12 mar 2026".

O cartão inteiro é um link para a página do post (`/posts/:area/:categoria/:id`, mesmo destino de hoje). Ao passar o mouse, o título ganha sublinhado.

### Disposição conforme a quantidade
| Destaques | Celular (< 600) | Tablet e desktop (≥ 600) |
|---|---|---|
| 0 | Seção inteira escondida (sem título) | Seção inteira escondida (sem título) |
| 1 | Um cartão principal | Um cartão principal na largura toda |
| 2 | Dois cartões um abaixo do outro (principal primeiro) | Duas colunas: principal à esquerda (mais larga, proporção 1,6 : 1) e o segundo à direita, os dois com a altura toda do bloco |
| 3 ou mais | Três cartões um abaixo do outro (principal primeiro) | Principal à esquerda ocupando a altura toda; os outros dois empilhados à direita, com a metade da altura cada (como no protótipo) |

## Estados
- **Carregando:** título "Destaques" e um esqueleto com a mesma disposição de três cartões (principal + dois), em tons neutros, sem textos. O esqueleto não pisca com movimento reduzido. Leitor de tela ouve "Carregando destaques".
- **Vazio (0 destaques):** a seção inteira some, sem título nem espaço reservado, como hoje. A Home passa direto do hero para "Quem somos".
- **Erro:** título "Destaques" e, no lugar dos cartões, uma caixa discreta com "Não foi possível carregar os destaques." e o botão "Tentar de novo", que refaz a busca (voltando a mostrar o esqueleto).
- **Sem imagem / imagem com falha:** o cartão mantém o mesmo tamanho e ganha um fundo escuro neutro com o ícone de imagem discreto no canto superior; rótulo, título e data continuam legíveis. Enquanto a imagem carrega, o cartão mostra o mesmo fundo escuro (sem salto de layout).
- **Casos de borda:**
  - 1, 2, 3 e mais de 3 destaques (tabela acima); com 5 destaques, só os três mais recentes aparecem.
  - Imagens muito altas, muito largas, pequenas ou muito claras (quase brancas): o recorte preenche o cartão e o texto continua com contraste suficiente.
  - Título muito longo: no máximo 3 linhas no cartão principal e 3 nos menores, terminando em reticências; o leitor de tela recebe o título completo.
  - Categoria do post não encontrada entre as categorias carregadas: o cartão usa a área do próprio post para o rótulo e o endereço.
  - Categorias da navbar com erro: os destaques ainda são buscados e mostrados.
  - Texto ampliado pelo navegador até 200%: sem sobreposição nem `overflow` (o título corta com reticências antes de invadir o rótulo).

## Responsivo
- **Celular (390):** margens de 20 px. Cartões em uma coluna com 16 px entre eles: principal com cerca de 340 px de altura, os outros com cerca de 220 px. Título principal ≈ 24 px, títulos menores ≈ 18 px.
- **Tablet (768):** margens de 32 px. Grade de duas colunas (1,6 : 1) com cerca de 400 px de altura total e 16 px de vão. Título principal ≈ 32 px, menores ≈ 22 px.
- **Desktop (1280):** conteúdo limitado a 1120 px. Grade de duas colunas (1,6 : 1) com cerca de 440 px de altura total e 16 px de vão. Título principal ≈ 35 px, menores ≈ 24 px.
- Em todas: sem rolagem horizontal e sem aviso de `overflow`.

## Acessibilidade
- "Destaques" anunciado como cabeçalho.
- Cada cartão é um link alcançável por Tab na ordem visual (principal primeiro), com o contorno de foco padrão (3 px, laranja, afastado 2 px) acompanhando os cantos arredondados, ativável por Enter, e ativável pelo toque do leitor de tela (ação de toque na semântica, como corrigido na 004).
- Nome acessível do cartão: título completo, rótulo e data. Ex.: "Cartografia escolar: por que ainda ensinar a ler mapas. Artigo, Geografia. 12 mar 2026". A foto e o ícone de "sem imagem" são decorativos.
- Contraste: rótulo, título e data com pelo menos 4,5:1 contra o degradê **mesmo sobre uma foto branca** (o degradê é forte o bastante atrás de todo o texto). Mensagem de erro em cinza escuro (≥ 4,5:1).
- Movimento reduzido: sem transições de entrada da imagem ou do bloco e esqueleto parado.

## Dados e regras de negócio
- Fonte: a mesma busca de hoje (`FetchHighlightsStore`: posts publicados com `isHighlighted` verdadeiro). Ordenação, limite de três e descarte de posts incompletos acontecem na apresentação.
- Rótulo: tipo do post (nome em português já existente) e área (da categoria do post ou, na falta dela, a primeira área do próprio post).
- Endereço do cartão: o mesmo de hoje, `/posts/:area/:categoria/:id`.
- Nada muda em modelos de dados, coleções, regras ou índices do Firebase, nem em rotas. Nenhum dado real é alterado para testar.

## Critérios de aceite
1. [ ] Com pelo menos um destaque, a seção aparece logo abaixo do hero e acima de "Quem somos", com o título "Destaques" anunciado como cabeçalho; o carrossel antigo, as setas e as faixas cinza não aparecem mais.
2. [ ] Com 0 destaques, a seção não aparece (nem título nem espaço vazio) e a Home vai do hero direto para "Quem somos".
3. [ ] Com 1 destaque, aparece um único cartão principal na largura toda do conteúdo, em 390, 768 e 1280 px.
4. [ ] Com 2 destaques, em 768 e 1280 px aparecem duas colunas (principal mais larga, 1,6 : 1, as duas com a altura toda); em 390 px, um abaixo do outro.
5. [ ] Com 3 destaques, em 768 e 1280 px o principal fica à esquerda na altura toda e os outros dois empilhados à direita; em 390 px, os três em coluna, principal primeiro.
6. [ ] Com mais de 3 destaques (ex.: 5), aparecem só os três mais recentes pela data de criação, e o mais recente é o principal; nada troca sozinho e não há setas.
7. [ ] Cada cartão mostra a foto recortada preenchendo o cartão, o degradê só na parte de baixo, o rótulo "TIPO · ÁREA", o título e, no principal, a data no formato "12 mar 2026".
8. [ ] Clicar ou apertar Enter num cartão abre `/posts/:area/:categoria/:id` do post; o mesmo vale para a ativação pelo leitor de tela.
9. [ ] Sem imagem ou com imagem que falha, o cartão mantém o tamanho, mostra o fundo escuro com o ícone de imagem e o texto continua legível.
10. [ ] Carregando: título e esqueleto na disposição de três cartões; erro: "Não foi possível carregar os destaques." com "Tentar de novo", que refaz a busca.
11. [ ] Títulos longos param em 3 linhas com reticências, e o nome acessível traz o título completo.
12. [ ] Cartões alcançáveis por Tab na ordem visual, com contorno de foco visível arredondado e nome acessível (título, rótulo e data); foto e ícones ignorados pelo leitor de tela.
13. [ ] Contraste de rótulo, título e data ≥ 4,5:1 sobre o degradê com uma foto branca por trás; mensagem de erro ≥ 4,5:1.
14. [ ] Em 390, 768 e 1280 px (e com texto a 200%), sem rolagem horizontal e sem `overflow`; alturas e tamanhos de título conforme "Responsivo".
15. [ ] Com movimento reduzido, nenhuma transição no bloco nem na imagem, e esqueleto parado.
16. [ ] O código novo usa só tokens de `lib/app/theme/` (nenhuma cor, tamanho de fonte ou espaçamento solto) e não usa `num_extension`; `fvm flutter analyze` sem problemas novos e `fvm flutter build web --release` sem erro.

## Fora do escopo
- Escolher, editar ou reordenar destaques (feito no painel administrativo) e qualquer mudança na busca, nos modelos, nas coleções, nas regras ou nos índices do Firebase.
- Página "todas as publicações" e o link "Ver todas as publicações" (não existe rota para isso).
- Mostrar autor no cartão (nem todo tipo de post tem autor).
- Redesenho de Quem somos, Vídeo, Nossa história, Equipe, Realização e apoio e Chamada para contato (specs 006 a 009).
- Remoção do pacote `carousel_slider` (ainda usado pela Equipe) e limpeza de código antigo sem uso (Fase 7).
- Painel administrativo, Geoensine e modo escuro.

## Perguntas em aberto
- Nenhuma. Respondidas no modo autônomo:
  - **Link "Ver todas as publicações".** Decidido no modo autônomo: não entra, porque não existe página que reúna todas as publicações e criar rota nova está fora do que esta spec pode decidir (mesma regra da 004). Pode voltar quando houver essa página.
  - **Quais destaques com mais de três.** Decidido no modo autônomo: os três mais recentes pela data de criação, o mais recente como principal, porque o planejamento pede "três visíveis de uma vez" e "sem carrossel automático", e a busca atual não tem ordem definida; a data de criação é o único critério estável já existente no modelo. Os demais não aparecem na Home.
  - **Disposição com 1 e 2 destaques.** Decidido no modo autônomo: 1 destaque ocupa a largura toda; 2 destaques mantêm a proporção 1,6 : 1 do protótipo com os dois na altura toda, porque preserva a hierarquia (o primeiro em destaque) sem deixar buraco na grade.
  - **Vazio.** Decidido no modo autônomo: com 0 destaques a seção some inteira, como hoje, porque uma mensagem "nenhum destaque" na Home não ajuda quem visita; o estado vazio fica tratado por não reservar espaço.
  - **Erro.** Decidido no modo autônomo: mostrar mensagem discreta com "Tentar de novo" (e não esconder), porque o CLAUDE.md exige estado de erro em toda tela com dados e o padrão "Tentar de novo" já existe (002/004). Se a busca falhar sempre por causa de configuração do Firebase, isso é registrado como ressalva, sem mexer no Firebase.
  - **Tablet.** Decidido no modo autônomo: a partir de 600 px já usa a grade de duas colunas, com altura menor (≈ 400 px), porque o protótipo só empilha abaixo de 760 px de container e em 600–759 px a coluna menor ainda fica com mais de 200 px de largura; empilhar desperdiçaria a hierarquia.
  - **Imagem ausente ou com falha.** Decidido no modo autônomo: fundo escuro neutro com ícone de imagem, em vez do laranja suave do protótipo (`.noimg`), porque o texto do cartão é branco e ficaria sem contraste sobre fundo claro.
  - **Informações do rodapé do cartão.** Decidido no modo autônomo: rótulo "Tipo · Área" em todos e data só no principal, sem autor, porque o protótipo mostra meta só no principal e nem todo tipo de post tem autor no modelo.
  - **Como conferir 0, 1, 2, 3 e mais de 3 sem mexer no banco.** Decidido no modo autônomo: com dados simulados só numa cópia local de trabalho (testes de widget temporários e um ponto de entrada de pré-visualização com repositório falso), nada disso entra no repositório. Detalhado no plano.

## Histórico de mudanças
- 2026-09-26: criada e aprovada no modo autônomo (execução da Fase 1).
- 2026-09-26: plano e tarefas criados (`plan.md`, `tasks.md`).
- 2026-09-26: diagnóstico da A1: a busca de destaques responde sem erro e com 0 documentos (não há post publicado marcado como destaque). Com os dados de hoje, a seção fica escondida no site.
- 2026-09-26: implementada. Ajustes de plano sem mudar o comportamento: largura máxima do título principal em 12 em (equivale aos 22 caracteres; o plano dizia "22 em" por engano); faixa de esmaecimento desenhada acima do texto sem tirar altura dele; busca também disparada quando as categorias falham depois de a Home abrir.
