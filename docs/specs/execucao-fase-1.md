# Execução da Fase 1

- **Início:** 2026-09-26
- **Término:** 2026-09-29
- **Branch:** refactor/redesign-fase-1 → PR para develop

| Spec | Itens | Spec+plano | Implementação | Verificação | Resultado |
|---|---|---|---|---|---|
| 004-hero-atalhos | 1.1 | feita (14 critérios, 12 tarefas) | feita (2 commits) | feita (2 fix) | verificada com ressalvas (6 commits) |
| 005-destaques | 1.2 | feita (16 critérios, 13 tarefas) | feita (2 commits) | feita (1 fix) | verificada (5 commits) |
| 006-quem-somos-video | 1.3, 1.4 | feita (16 critérios, 13 tarefas) | feita (3 commits) | feita (2 fix) | verificada (6 commits) |
| 007-resumo-nossa-historia | 1.5 | feita (14 critérios, 10 tarefas) | feita (4 commits) | feita (1 fix) | verificada (7 commits) |
| 008-equipe | 1.6 | feita (17 critérios, 11 tarefas) | feita (2 commits) | feita (0 fix) | verificada com ressalvas (4 commits) |
| 009-apoio-contato | 1.7, 1.8 | feita (18 critérios, 13 tarefas) | feita (2 commits) | feita (1 fix) | verificada com ressalvas (5 commits) |

## Divisão
- 1.3 e 1.4 juntas: dois blocos simples e vizinhos da Home.
- 1.7 e 1.8 juntas: dois blocos finais da Home, ambos pequenos.
- 1.5 depende de T-03 (rota nova de Nossa história): a spec 007 cria a rota com uma página provisória que reaproveita o texto completo atual; o redesign dessa página fica para a Fase 2.

## Decisões tomadas sem a pessoa
- 004: atalhos História e Geografia abrem diálogo com as categorias reais da área (reaproveita o menu da navbar), porque não existe página de área e rota nova está fora do que o modo autônomo decide.
- 004: descrições dos atalhos neutras; as do protótipo citam categorias de exemplo (P-04, P-10).
- 004: tablet com três colunas e ícone acima do texto, para não faltar espaço entre 600 e 767 px.
- 004: rótulo do hero em laranja forte #A33600, porque o acento sobre a superfície dá 4,48:1.
- 004: Home só ganha o hero no topo; os demais blocos ficam na ordem atual (já é a do protótipo) até suas specs.
- 004: botões compartilhados ganham ícone opcional à direita (mudança só aditiva).
- 004: com texto ampliado a partir de 130%, os atalhos passam para uma coluna (token novo), para não quebrar palavras.
- 005: link "Ver todas as publicações" do protótipo fica de fora (não existe rota).
- 005: com mais de 3 destaques, mostra os três mais recentes pela data de criação; o mais recente é o principal.
- 005: 1 destaque ocupa a largura toda; 2 destaques em colunas 1,6 : 1; 0 destaques some a seção.
- 005: sem imagem, fundo escuro com ícone (o laranja claro do protótipo não dá contraste com texto branco).
- 005: cartão mostra "Tipo · Área" e, só no principal, a data; sem autor.
- 006: capa do vídeo gerada com os tokens do tema até existir assets/images/video-capa.webp (usada sem mudar código quando for adicionada).
- 006: legenda "Conheça o Observatório", sem "em 2 minutos" (o vídeo tem 1 min 20 s).
- 006: o parágrafo longo atual de "Quem somos" sai da Home e dá lugar aos textos do protótipo (missão e três públicos); em Pesquisadores, "artigos" virou "pesquisas".
- 006: sem autoplay; o MP4 só baixa depois de "Assistir". Erro do vídeo mostra "Tentar de novo" em vez de esconder o bloco.
- 006: AppVideoPlayer e AppIconButton ganham só parâmetros opcionais (painel admin inalterado); novo ArrowLink compartilhado.

- 007: rota nova `/nossa-historia` com página provisória (texto atual inalterado); redesign na Fase 2.
- 007: resumo na Home com os textos do protótipo e selo FAPEMIG 2016–2018; link com ArrowLink.
- 007: rodapé ganha "Nossa história" entre Manifesto e Equipe; nenhum item da navbar ativo na página nova.
- 007: sai a divisória entre Nossa história e Equipe.

- 008: o membro com descrição abre a página `/membro/:id` que já existe, sem mudá-la (redesenho e bloqueio de acesso direto sem descrição na Fase 2).
- 008: ordem alfabética pelo nome, sem acentos nem caixa, feita no store (a consulta não muda).
- 008: sem foto, iniciais em laranja forte sobre laranja suave (o protótipo usa uma cor por membro, que não existe nos dados).
- 008: colunas pela largura (mínimo 190 px × ampliação do texto), como o `auto-fill` do protótipo: 5, 3 e 1 colunas.
- 008: 0 membros esconde a seção; sai a divisória depois da Equipe; a Home só busca a equipe se ainda não buscou ou se falhou.

- 009: lista única de 9 parceiros (enum `Partner` com sigla, nome completo e site), na ordem do protótipo; bloco "Realização e apoio" compartilhado pela Home, Biblioteca e Colabore.
- 009: no post, o `Support` só troca os 4 cartões pelos 9 logos (Q-06); o redesenho do bloco fica para a fase do post (P-07).
- 009: logos com link para o site oficial (conferido na implementação; o que não abrir fica sem link); nome acessível completo; subida de 3 px e cinza a 55 % como no protótipo.
- 009: chamada com os textos do protótipo; botão à direita só no desktop.
- 009: o respiro entre Equipe e Realização e apoio passa para cima de Realização e apoio, para não sumir quando a equipe está escondida.
- 009: plano inclui a conferência da Home inteira (aceite da Fase 1) com dados simulados e com o Firebase de testes.

## Ressalvas
- 004: as opções do menu de categorias da navbar (reaproveitadas na janela dos atalhos) não respondem ao toque pela semântica do leitor de tela; não corrigido por ser navbar (fora do escopo da 004). Sugerida correção própria.
- 004: sem teste com leitor de tela real (VoiceOver/NVDA), só árvore de semântica.
- 005: o banco real tem 0 posts marcados como destaque, então a seção fica escondida no site hoje. Casos 1, 2, 3 e 5 conferidos só com dados simulados (testes temporários fora do repositório).
- 006: a 390 px com texto a 200%, a palavra "conhecimento." do título de Quem somos ainda quebra ao meio (só resolveria limitando a ampliação).
- 006: bloqueio real de som no Safari/Firefox e painel admin no navegador não conferidos (bloqueio simulado; admin conferido pelo código).
- 008: `/membro/<id inexistente>` carrega para sempre e busca a equipe em laço (~35 leituras em 10 s). Já acontecia antes da 008; anotado na T-02 para a Fase 2, com prioridade.
- 008: o Firebase de testes não tem membros; todos os estados com dados foram conferidos só com dados simulados.
- 008: contorno de foco por teclado conferido só em teste de widget.
- 009: faixa lilás embaixo de `/colaborar` em janelas mais altas que o conteúdo (Scaffold sem cor de fundo, anterior à 009; Fase 5).
- 009: links de semântica sem `href` (padrão do site inteiro); logos aparecem um instante depois do resto no primeiro carregamento, sem deslocar a grade.
- 009: `Support` do post conferido só em pré-visualização com dados simulados (Firebase de testes sem posts); `overflow` do aceite da fase conferido por testes de widget (o build release não imprime o aviso).

### Ressalvas depois do encerramento (2026-09-30)
- Aceitas pela pessoa: destaques e membro de equipe cadastrados e conferidos no Firebase de testes; leitor de tela real e bloqueio de som dispensados.
- Corrigidas:
  - Menu de categorias da navbar, botão de menu, itens do painel de celular, links do rodapé, redes, logo e `CustomIconButton` repetem `onTap` na semântica.
  - Links com `href` (`linkUrl`): um ouvinte web cancela a navegação nativa do `<a>`, e quem navega é o `onTap`.
  - "conhecimento." a 390 px e 200%: `WordSafeText` reduz a fonte só quando a maior palavra não cabe (títulos de Quem somos e Nossa história).
  - `/membro/:id`: busca só se `needsFetch`; id inexistente ou membro sem descrição mostra o 404.
  - Piscada dos logos de apoio ao tirar o mouse: a sombra ia para lista vazia, encolhendo com a cor cheia sob o fundo que esmaecia. Agora anima até a mesma sombra transparente (`shadows.hidden`).
  - Texto selecionável nas páginas públicas (`SelectionArea` num `ShellRoute`, realce `textSelection`). O que é clicável fica fora da seleção (`AppFocusRing` e `notSelectable`). Painel administrativo sem mudança.
- Nova, não corrigida: a 390 px e 200%, o botão "Assistir" do vídeo encosta na legenda "Conheça o Observatório".

## Ocorrências
- Branch criada a partir de origin/develop sem upstream configurado, para que nenhum `git push` sem argumentos vá para a develop.
- 2026-09-26: limite de uso atingido após fechar a 006. Retomar com `/sdd-fase Fase 1` a partir da 007 (spec+plano pendente).
- 2026-09-26: retomada na 007. A primeira chamada da implementação foi interrompida pela pessoa depois de já ter feito 2 commits; a segunda sessão continuou a partir do tasks.md.
- 007: a implementação ajustou o rodapé do tablet (duas linhas, sem LayoutBuilder) em commit próprio; a verificação conferiu /manifest, /biblioteca e /nossa-historia a 768 px sem regressão.
- 2026-09-27: a primeira sessão de verificação da 008 foi interrompida sem efeito; refeita do zero.
- 2026-09-27: a primeira sessão de implementação da 009 foi interrompida pela pessoa e deixou código sem commit; a sessão seguinte revisou, corrigiu um bug (quadro da chamada encolhendo no tablet) e fez os commits.
- 2026-09-29: o classificador do modo automático falhou durante a verificação da 009; a orquestradora fez o commit do fix pendente e a mesma sessão concluiu a documentação.
