# 004. Home: hero e atalhos

- **Status:** verificada com ressalvas
- **Item do planejamento:** Fase 1, seção 1.1
- **Protótipo:** aba "Home", bloco do topo (link no CLAUDE.md)
- **Criada em:** 2026-09-26
- **Depende de:** [001-fundacao](../001-fundacao/spec.md) (tokens, tipografia, largura máxima) e [002-botoes-navbar-rodape](../002-botoes-navbar-rodape/spec.md) (botões, navbar, menu de categorias)

## Objetivo
Quem chega à Home entende logo o que é o Observatório e para quem ele serve, e chega em um clique às duas áreas (História e Geografia) e à Biblioteca. Hoje a página abre direto num carrossel de destaques, sem dizer o que é o site.

## Situação atual
[home_page.dart](../../../lib/app/features/home/presentation/pages/home_page.dart) monta a Home como uma lista de blocos abaixo da navbar fixa: Destaques (carrossel), Quem somos (foto em tela cheia), Vídeo, Nossa história (texto completo), Equipe, Parceiros, Fale com a gente e rodapé. Não há topo de apresentação nem atalhos. Não existe página própria de "História" ou "Geografia": as áreas só se abrem pelo menu da navbar, que lista as categorias vindas do banco (P-04).

## Comportamento

### Ordem da Home
O hero passa a ser o **primeiro bloco** da Home, logo abaixo da navbar. Os demais blocos continuam como estão e na ordem atual, que já é a do protótipo (Destaques, Quem somos, Vídeo, Nossa história, Equipe, Realização e apoio, Chamada para contato, rodapé). Cada um será redesenhado na sua spec (005 a 009). O hero aparece de imediato, sem esperar carregamento de dados.

### Hero
Faixa de fundo na cor de superfície (`#F7F5F2`), com linha fina na base e um desenho decorativo de círculos concêntricos bem suaves (laranja no canto superior direito, tom escuro no canto inferior esquerdo), que se apaga em direção à base. O desenho é só decoração: não se move, não recebe foco e não é lido por leitor de tela.

Conteúdo, alinhado à esquerda dentro da largura máxima do site:
1. **Rótulo** (caixa alta, laranja forte): "Universidade Federal de Uberlândia".
2. **Título** (fonte de títulos, peso 800): "Ensino de História e Geografia, **em um só lugar.**". O trecho "em um só lugar." fica na cor de acento. O título quebra em no máximo cerca de 15 caracteres por linha no desktop (como no protótipo).
3. **Texto de apoio** (cinza escuro, maior que o texto padrão): "Narrativas, pesquisas, documentos e experiências didáticas reunidos para professores, pesquisadores e estudantes."
4. **Dois botões**, lado a lado (quebram para a linha de baixo se faltar espaço):
   - Primário: "Explorar a biblioteca" com seta à direita → abre `/biblioteca`.
   - Secundário: "Ler o manifesto" → abre `/manifest`.
5. **Três atalhos** em cartões (fundo branco, borda fina, cantos arredondados), cada um com ícone num quadrado laranja suave, título, descrição curta e seta:

| Atalho | Ícone | Descrição | Ao ativar |
|---|---|---|---|
| História | ampulheta | "Categorias e publicações da área" | Abre a lista de categorias de História |
| Geografia | globo | "Categorias, Expogeo e Geoensine" | Abre a lista de categorias de Geografia |
| Biblioteca | livro | "Teses e dissertações" | Abre `/biblioteca` |

   Ao passar o mouse, o cartão ganha borda laranja, sobe 2 px e ganha sombra suave.

### Lista de categorias de uma área
Como não existe página de área, os atalhos História e Geografia abrem uma **janela** sobre a página, com:
- título "Categorias de História" (ou "de Geografia") e botão "Fechar";
- o mesmo conteúdo do menu da área na navbar: as categorias reais vindas do banco, sem agrupar; em Geografia, Expogeo e Geoensine primeiro (links externos, com o ícone de link externo), separados por um divisor.

Escolher uma categoria fecha a janela e abre a página da categoria (`/posts/:area/:categoria`), como faz o menu da navbar. Escolher Expogeo ou Geoensine fecha a janela e abre o site externo. A janela fecha por "Fechar", Esc ou clique/toque fora; ao fechar, o foco volta ao atalho que a abriu. Se a lista for maior que a tela, ela rola dentro da janela.

## Estados
- **Carregando:** o hero é estático e não carrega nada. Na janela de categorias, enquanto as categorias não chegam, aparece o esqueleto do menu da navbar (mesmo comportamento da 002).
- **Vazio:** se a área não tiver categorias, a janela mostra a mensagem de vazio do menu da navbar (em Geografia, Expogeo e Geoensine continuam aparecendo).
- **Erro:** se as categorias falharem, a janela mostra a mensagem de erro com "Tentar de novo", como no menu da navbar.
- **Sem imagem / imagem com falha:** não há imagens de autores neste bloco (o desenho do fundo é gerado no próprio site).
- **Casos de borda:** muitas categorias (a janela rola); nomes de categoria longos (quebram linha, sem cortar); texto ampliado pelo navegador até 200% sem sobreposição; abrir a janela e redimensionar a tela.

## Responsivo
- **Celular (390):** margens laterais de 20 px. Título grande (≈ 35 px), texto de apoio ≈ 17 px. Botões um abaixo do outro quando não couberem lado a lado. Atalhos em **uma coluna**, cada um em linha (ícone, textos, seta). Janela de categorias ocupa quase toda a largura, com margem.
- **Tablet (768):** margens de 32 px. Título ≈ 54 px. Atalhos em **três colunas**, com o ícone acima do título e da descrição, para caber sem apertar o texto. Janela centralizada com largura máxima.
- **Desktop (1280):** conteúdo limitado a 1120 px. Título ≈ 64 px. Atalhos em três colunas, em linha (ícone, textos, seta), como no protótipo. Janela centralizada com largura máxima.
- Com o texto ampliado a partir de 130%, os atalhos ficam em uma coluna em qualquer largura, para os títulos não quebrarem no meio (decidido na verificação).
- Em todas: sem rolagem horizontal e sem aviso de `overflow`.

## Acessibilidade
- Título do hero anunciado como cabeçalho.
- Botões e atalhos alcançáveis por Tab, na ordem visual, com o contorno de foco padrão (3 px, laranja, afastado 2 px), e ativáveis por Enter e Espaço.
- Nomes acessíveis: atalhos História e Geografia são botões ("História. Categorias e publicações da área. Abre a lista de categorias"); Biblioteca é um link ("Biblioteca. Teses e dissertações"). Ícones e seta são decorativos.
- Janela de categorias: tem nome ("Categorias de História"), prende o foco enquanto aberta, fecha por Esc e devolve o foco ao atalho.
- Contraste: rótulo em laranja forte (`#A33600`) sobre a superfície (o laranja normal fica em 4,48:1, abaixo do mínimo); texto de apoio e descrições em cinza escuro (`#5E5852`, ≥ 6:1). O trecho laranja do título é texto grande (≥ 3:1).
- Movimento reduzido: sem a subida de 2 px nem transições no hover dos cartões e na abertura da janela.

## Dados e regras de negócio
- Textos do hero e dos atalhos são fixos no código.
- A lista de categorias vem do mesmo lugar que o menu da navbar (categorias já carregadas pela navbar); nenhuma consulta nova ao banco.
- Nada muda em modelos de dados, coleções do Firebase ou rotas existentes. Os destinos são rotas já existentes (`/biblioteca`, `/manifest`, `/posts/:area/:categoria`).

## Critérios de aceite
1. [ ] Ao abrir `/`, o hero é o primeiro bloco abaixo da navbar, e os blocos seguintes (Destaques, Quem somos, Vídeo, Nossa história, Equipe, Parceiros, Fale com a gente, rodapé) continuam aparecendo e funcionando como antes.
2. [ ] O hero mostra rótulo, título (com "em um só lugar." na cor de acento), texto de apoio, dois botões e três atalhos, com os textos exatos desta spec.
3. [ ] "Explorar a biblioteca" abre `/biblioteca` e "Ler o manifesto" abre `/manifest`.
4. [ ] O atalho Biblioteca abre `/biblioteca`.
5. [ ] Os atalhos História e Geografia abrem a janela "Categorias de História"/"Categorias de Geografia" com as categorias reais da área; em Geografia, Expogeo e Geoensine aparecem primeiro, separados por divisor.
6. [ ] Escolher uma categoria na janela fecha a janela e abre a página da categoria; escolher Expogeo ou Geoensine abre o site externo.
7. [ ] A janela fecha por "Fechar", Esc e clique fora, e o foco volta ao atalho que a abriu.
8. [ ] Na janela, carregando mostra esqueleto, erro mostra mensagem com "Tentar de novo", e área sem categorias mostra a mensagem de vazio.
9. [ ] Layout em 390 px: atalhos em uma coluna; em 768 px: três colunas com ícone acima do texto; em 1280 px: três colunas em linha e conteúdo limitado a 1120 px. Nas três larguras, sem rolagem horizontal e sem `overflow` no console.
10. [ ] Todos os botões e atalhos são alcançáveis por Tab na ordem visual, mostram contorno de foco visível e têm nome acessível; os ícones são ignorados pelo leitor de tela.
11. [ ] Hover dos atalhos: borda laranja, subida de 2 px e sombra; com movimento reduzido, sem subida nem transição.
12. [ ] Contraste de todo texto do hero e dos atalhos ≥ 4,5:1 (título grande ≥ 3:1); rótulo em laranja forte.
13. [ ] O código novo usa só tokens de `lib/app/theme/` (nenhuma cor, tamanho de fonte ou espaçamento solto) e não usa `num_extension`.
14. [ ] `fvm flutter analyze` sem problemas novos e `fvm flutter build web --release` sem erro.

## Fora do escopo
- Redesenho de Destaques, Quem somos, Vídeo, Nossa história, Equipe, Realização e apoio e Chamada para contato (specs 005 a 009). O botão "MANIFESTO" atual de Quem somos continua até a 006.
- Página própria de área (História ou Geografia) e qualquer rota nova.
- Busca geral (ideia futura, P-13).
- Mudanças na navbar, no menu de celular e no rodapé.
- Painel administrativo, Geoensine e modo escuro.

## Perguntas em aberto
- Nenhuma. Respondidas no modo autônomo:
  - **Destino dos atalhos História e Geografia.** Decidido no modo autônomo: abrem uma janela com as categorias reais da área (o mesmo conteúdo do menu da navbar), porque não existe página de área, criar rota nova está fora do que esta spec pode decidir, e ir para "a primeira categoria" esconderia as demais. Mantém P-04 (categorias reais, sem agrupar; Expogeo e Geoensine antes em Geografia).
  - **Descrições dos atalhos.** Decidido no modo autônomo: "Categorias e publicações da área", "Categorias, Expogeo e Geoensine" e "Teses e dissertações", porque as descrições do protótipo citam nomes de categoria que são só exemplos (P-04) e a biblioteca tem apenas Tese e Dissertação (P-10).
  - **Atalhos no tablet.** Decidido no modo autônomo: três colunas com ícone acima do texto, porque o protótipo usa três colunas acima de 760 px, mas em 600–767 px o cartão em linha deixaria menos de 40 px para o texto.
  - **Cor do rótulo.** Decidido no modo autônomo: laranja forte `#A33600`, porque o laranja de acento sobre a superfície dá 4,48:1 (abaixo do mínimo), mesma regra já registrada na 002.
  - **Estrutura da Home.** Decidido no modo autônomo: só inserir o hero no topo, sem mexer na ordem dos demais blocos, porque a ordem atual já coincide com a do protótipo e cada bloco muda na sua spec.

## Histórico de mudanças
- 2026-09-26: criada e aprovada no modo autônomo (execução da Fase 1).
- 2026-09-26: plano e tarefas criados (`plan.md`, `tasks.md`).
- 2026-09-26: implementada. Ajustes de plano, sem mudar o comportamento da spec: altura de linha do título 1,12 e largura do título em 8,4 em (reproduz as três linhas do protótipo, que usa `text-wrap: balance`); texto de apoio com 770 px; `AppFocusRing` ganhou `fit` opcional para os cartões terem a mesma altura.
- 2026-09-26: verificada com ressalvas ([verificacao.md](verificacao.md)). Correções: ação de toque na semântica dos atalhos e botões, janela anunciada como diálogo, título e atalhos acompanham o texto ampliado. Ressalva: opções do menu de categorias da navbar (fora do escopo).
