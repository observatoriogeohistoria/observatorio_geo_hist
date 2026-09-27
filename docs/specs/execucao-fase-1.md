# Execução da Fase 1

- **Início:** 2026-09-26
- **Branch:** refactor/redesign-fase-1 → PR para develop

| Spec | Itens | Spec+plano | Implementação | Verificação | Resultado |
|---|---|---|---|---|---|
| 004-hero-atalhos | 1.1 | feita (14 critérios, 12 tarefas) | feita (2 commits) | feita (2 fix) | verificada com ressalvas (6 commits) |
| 005-destaques | 1.2 | feita (16 critérios, 13 tarefas) | feita (2 commits) | feita (1 fix) | verificada (5 commits) |
| 006-quem-somos-video | 1.3, 1.4 | feita (16 critérios, 13 tarefas) | feita (3 commits) | feita (2 fix) | verificada (6 commits) |
| 007-resumo-nossa-historia | 1.5 | feita (14 critérios, 10 tarefas) | pendente | pendente | |
| 008-equipe | 1.6 | pendente | pendente | pendente | |
| 009-apoio-contato | 1.7, 1.8 | pendente | pendente | pendente | |

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

## Ressalvas
- 004: as opções do menu de categorias da navbar (reaproveitadas na janela dos atalhos) não respondem ao toque pela semântica do leitor de tela; não corrigido por ser navbar (fora do escopo da 004). Sugerida correção própria.
- 004: sem teste com leitor de tela real (VoiceOver/NVDA), só árvore de semântica.
- 005: o banco real tem 0 posts marcados como destaque, então a seção fica escondida no site hoje. Casos 1, 2, 3 e 5 conferidos só com dados simulados (testes temporários fora do repositório).
- 006: a 390 px com texto a 200%, a palavra "conhecimento." do título de Quem somos ainda quebra ao meio (só resolveria limitando a ampliação).
- 006: bloqueio real de som no Safari/Firefox e painel admin no navegador não conferidos (bloqueio simulado; admin conferido pelo código).

## Ocorrências
- Branch criada a partir de origin/develop sem upstream configurado, para que nenhum `git push` sem argumentos vá para a develop.
- 2026-09-26: limite de uso atingido após fechar a 006. Retomar com `/sdd-fase Fase 1` a partir da 007 (spec+plano pendente).
