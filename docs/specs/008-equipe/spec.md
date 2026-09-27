# 008. Home: equipe

- **Status:** aprovada
- **Item do planejamento:** Fase 1, seção 1.6 (Equipe), com o acesso à tela T-02 (Pessoa da equipe)
- **Protótipo:** aba "Home", bloco "Equipe" (grade de membros), logo abaixo de Nossa história; aba "Membro" como referência da página da pessoa (link no CLAUDE.md)
- **Criada em:** 2026-09-26
- **Depende de:** [001-fundacao](../001-fundacao/spec.md) (tokens, tipografia, largura máxima), [002-botoes-navbar-rodape](../002-botoes-navbar-rodape/spec.md) (botões, foco), [005-destaques](../005-destaques/spec.md) (padrão de carregando/erro e seção escondida sem dados), [007-resumo-nossa-historia](../007-resumo-nossa-historia/spec.md) (bloco acima)

## Objetivo
Na Home, quem visita vê de uma vez todas as pessoas da equipe, com foto, nome e função, e abre a página de quem tem apresentação escrita. Hoje a equipe aparece num carrossel que mostra um membro por vez.

## Situação atual
- [team.dart](../../../lib/app/features/home/presentation/components/team.dart): título "EQUIPE" em laranja, carrossel (`carousel_slider`) com setas "Membro anterior" e "Próximo membro", um membro por vez: foto redonda (só quando existe), nome em caixa alta laranja e função em cinza claro (contraste baixo). Clique por `GestureDetector` (sem foco por teclado); membros sem descrição ignoram o clique, mas parecem clicáveis. Usa `num_extension`.
- [home_page.dart](../../../lib/app/features/home/presentation/pages/home_page.dart): busca a equipe a cada abertura da Home; o bloco e a linha divisória que vem depois dele só aparecem quando há membros. Sem esqueleto e sem mensagem de erro: carregando ou com erro, o bloco não aparece.
- `FetchTeamStore` guarda só a lista (sem estado de carregando nem de erro; o erro é descartado). A ordem é a que o Firestore devolve (pelo identificador do documento, sem sentido para quem lê).
- A página da pessoa já existe em `/membro/:id` ([team_member_page.dart](../../../lib/app/features/home/presentation/pages/team_member_page.dart)), no visual antigo. O redesenho dela é da Fase 2 (T-02).
- O Firebase de testes local não tem membros: com ele o bloco não aparece.

## Comportamento

### Posição e cabeçalho
O bloco continua logo abaixo de Nossa história e antes de Realização e apoio. Fundo branco (cor da página), conteúdo na largura máxima do site, com o respiro vertical de seção. Título "Equipe" no estilo de título de seção (o mesmo de "Destaques"). A linha divisória que hoje vem depois da equipe sai (o protótipo não tem divisória entre Equipe e Realização e apoio).

### Grade
Todos os membros aparecem ao mesmo tempo, numa grade de colunas de mesma largura, alinhada à esquerda, sem carrossel e sem setas. Cada coluna tem no mínimo 190 px; cabem quantas colunas couberem (5 em 1280 px, 3 em 768 px, 1 em 390 px). Espaço de 20 px entre colunas e de 28 px entre linhas. Membros com textos de alturas diferentes ficam alinhados pelo topo.

**Ordem:** alfabética pelo nome, sem diferenciar maiúsculas nem acentos ("Álvaro" junto de "Alvaro").

### Membro
Alinhados à esquerda, um abaixo do outro:
1. **Foto** redonda de 76 px, recortada para preencher o círculo sem distorcer. Sem foto (ou com falha ao carregar): círculo em laranja suave com as **iniciais** do nome em laranja forte (primeira letra do primeiro e do último nome; uma letra se o nome tiver uma palavra só), na fonte de títulos.
2. **Nome** como está cadastrado (sem forçar caixa alta), fonte de títulos, 17 px.
3. **Função** em cinza escuro de texto secundário, 14,5 px.

Nome e função quebram linha quando não cabem (sem cortar com reticências).

### Quem é clicável
- **Com descrição** (texto não vazio, ignorando espaços): o membro inteiro é um link para a página da pessoa, `/membro/:id` (a página que já existe). Cursor de mão; ao passar o mouse, o nome fica laranja e a foto cresce levemente (5%).
- **Sem descrição:** não é link. Sem cursor de mão, sem efeito de hover, não recebe foco por teclado e não reage ao clique.

A página da pessoa não muda nesta spec.

## Estados
- **Carregando:** título "Equipe" e um esqueleto parado na forma da grade: uma linha de membros (círculo e duas barras), com o número de colunas da largura atual.
- **Vazio (0 membros):** a seção inteira some, sem título (mesmo critério dos destaques na 005). Nenhuma linha divisória sobra no lugar.
- **Erro:** título "Equipe", a mensagem "Não foi possível carregar a equipe." e o botão "Tentar de novo", que refaz a busca e, se der certo, mostra a grade. Mesmo quadro da 005.
- **Sem foto / foto com falha:** iniciais no círculo laranja suave, no mesmo tamanho; nada se desloca quando a foto falha.
- **Casos de borda:**
  - 1 membro: um só na primeira coluna, alinhado à esquerda.
  - Muitos membros (ex.: 25): todas as linhas visíveis, sem "ver mais".
  - Nome ou função longos: quebram linha dentro da coluna.
  - Todos sem descrição: grade igual, nenhum link.
  - Foto muito larga, muito alta ou pequena: sempre recortada no círculo.
  - Voltar à Home vindo de outra página: a grade já carregada aparece direto, sem piscar o esqueleto.

## Responsivo
- **Celular (390):** margens de 20 px; 1 coluna (350 px). Título ≈ 26 px.
- **Tablet (768):** margens de 32 px; 3 colunas. Título ≈ 30 px.
- **Desktop (1280):** conteúdo limitado a 1120 px; 5 colunas. Título ≈ 36 px.
- **Texto ampliado:** a largura mínima da coluna cresce na mesma proporção do texto (190 px × ampliação), então há menos colunas e as palavras não se partem ao meio.
- Em todas: sem rolagem horizontal e sem aviso de `overflow`.

## Acessibilidade
- "Equipe" é anunciado como cabeçalho.
- Membro clicável: um único link com o nome acessível "Nome, Função", alcançável por Tab na ordem da grade, com o contorno de foco padrão (3 px, laranja, afastado 2 px), ativável por Enter e pelo toque do leitor de tela.
- Membro não clicável: lido como texto (nome e função), fora da ordem de Tab.
- Foto e iniciais são decorativas (o nome vem logo depois).
- Contraste sobre branco: nome em tinta (≥ 15:1), nome no hover em laranja `#C94400` (4,9:1), função em `#5E5852` (≥ 7:1); iniciais `#A33600` sobre `#FFF0E6` (6,1:1).
- Movimento reduzido: a foto não cresce no hover.
- Área de toque do membro clicável com pelo menos 44 px de altura.

## Dados e regras de negócio
- Dados da coleção `team` do Firestore, pela busca que já existe (`FetchTeamStore`): `name`, `role`, `description`, `image` e `id`. Nada muda no modelo, na coleção, nas regras do Firebase nem no painel.
- "Tem descrição" = `description` não nula e com algum caractere além de espaços.
- Rota `/membro/:id` e a página da pessoa continuam como estão. Nenhuma rota nova.
- A ordem alfabética é feita no site, sem mudar a consulta.

## Critérios de aceite
1. [ ] Na Home, o bloco Equipe aparece logo abaixo de Nossa história e antes de Realização e apoio, com o título "Equipe" como cabeçalho; carrossel, setas e a linha divisória depois do bloco não aparecem mais.
2. [ ] Todos os membros aparecem de uma vez, em ordem alfabética do nome (sem diferenciar maiúsculas e acentos).
3. [ ] Grade com 5 colunas em 1280 px, 3 em 768 px e 1 em 390 px, colunas de mesma largura, 20 px entre colunas e 28 px entre linhas, membros alinhados pelo topo e à esquerda.
4. [ ] Cada membro mostra foto redonda de 76 px (recortada, sem distorcer), nome como cadastrado e função em texto secundário, conforme "Membro".
5. [ ] Sem foto ou com foto que falha: iniciais em laranja forte sobre círculo laranja suave, mesmo tamanho, sem deslocar o texto.
6. [ ] Membro com descrição abre `/membro/:id` por clique, Enter e toque do leitor de tela; tem cursor de mão, nome laranja e foto 5% maior no hover.
7. [ ] Membro sem descrição (vazia ou só espaços) não reage ao clique, não tem cursor de mão nem hover e não recebe foco por Tab.
8. [ ] Carregando: título e esqueleto de uma linha na forma da grade.
9. [ ] Erro: título, "Não foi possível carregar a equipe." e "Tentar de novo", que refaz a busca e mostra a grade quando ela dá certo.
10. [ ] 0 membros: a seção inteira some, sem título e sem linha divisória no lugar.
11. [ ] Voltar à Home depois de a equipe ter carregado não mostra o esqueleto de novo nem refaz a busca.
12. [ ] Nome e função longos quebram linha dentro da coluna, sem reticências e sem `overflow`; com texto a 200 %, há menos colunas e nenhuma palavra se parte ao meio.
13. [ ] Acessibilidade: membro clicável é um link "Nome, Função" com contorno de foco visível na ordem da grade; foto e iniciais ignoradas pelo leitor de tela; sem animação da foto com movimento reduzido.
14. [ ] Contraste: nome ≥ 4,5:1 (também no hover), função ≥ 4,5:1 e iniciais ≥ 4,5:1 sobre seus fundos.
15. [ ] Em 390, 768 e 1280 px, com 1 membro, muitos membros (25), com e sem foto e com e sem descrição: sem rolagem horizontal, sem sobreposição e sem `overflow`.
16. [ ] A página `/membro/:id` continua abrindo como antes; o painel admin não muda.
17. [ ] O código novo usa só tokens de `lib/app/theme/` (nenhuma cor, tamanho de fonte ou espaçamento solto) e não usa `num_extension`; `fvm flutter analyze` sem problemas novos e `fvm flutter build web --release` sem erro.

## Fora do escopo
- Redesenho da página da pessoa (foto quadrada, migalhas, botão "Currículo Lattes" do protótipo) e bloqueio do acesso direto a `/membro/:id` de quem não tem descrição: Fase 2 (T-02).
- Fazer o link "Equipe" do rodapé rolar até este bloco (hoje abre o topo da Home).
- Mudar o modelo `TeamMemberModel` (inclusive tolerar campos ausentes no Firestore), a consulta, as regras ou o painel.
- Realização e apoio e Chamada para contato (spec 009).
- Painel administrativo, Geoensine e modo escuro.

## Perguntas em aberto
- Nenhuma. Respondidas no modo autônomo:
  - **Página da pessoa (T-02).** Decidido no modo autônomo: o link leva à página `/membro/:id` que já existe, sem mudá-la, porque a rota já existe, o redesenho dela é da Fase 2 e criar ou mudar rota está fora do que esta spec decide.
  - **Ordem dos membros.** Decidido no modo autônomo: alfabética pelo nome, feita no site, porque a ordem atual (identificador do documento) não tem sentido para quem lê, o painel já lista em ordem de nome e mudar a consulta está fora do escopo.
  - **Membro sem foto.** Decidido no modo autônomo: iniciais em laranja forte sobre laranja suave, porque o protótipo mostra iniciais no círculo, mas com uma cor por membro que não existe nos dados; um par único de tokens do tema mantém o contraste (6,1:1).
  - **Colunas.** Decidido no modo autônomo: largura mínima de 190 px por coluna, como o `auto-fill` do protótipo (5, 3 e 1 colunas nas larguras de referência), crescendo com a ampliação do texto, porque número fixo por faixa daria colunas estreitas demais entre 1024 e 1279 px e palavras partidas com texto a 200 % (mesmo problema resolvido na 004 e na 006).
  - **Nome em caixa alta.** Decidido no modo autônomo: não, o nome aparece como cadastrado, como no protótipo.
  - **Pista de clique.** Decidido no modo autônomo: só cursor, hover e foco (sem ícone ou texto extra), como no protótipo e nas notas dele ("só os membros com descrição são clicáveis").
  - **0 membros.** Decidido no modo autônomo: a seção some, porque é o critério da 005 para seções da Home sem dados e uma mensagem "nenhum membro" não ajuda quem visita.
  - **Linha divisória depois da equipe.** Decidido no modo autônomo: sai, porque o protótipo não tem divisória entre Equipe e Realização e apoio e a 007 já tinha deixado a divisória presa à equipe só até esta spec.
  - **Busca repetida ao voltar à Home.** Decidido no modo autônomo: busca só se ainda não buscou ou se a última falhou, como a correção feita nos destaques (005), para o esqueleto não piscar a cada volta.

## Histórico de mudanças
- 2026-09-26: criada e aprovada no modo autônomo (execução da Fase 1).
- 2026-09-27: plano e tarefas criados (`plan.md`, `tasks.md`).
