# Execução da Fase 1

- **Início:** 2026-09-26
- **Branch:** refactor/redesign-fase-1 → PR para develop

| Spec | Itens | Spec+plano | Implementação | Verificação | Resultado |
|---|---|---|---|---|---|
| 004-hero-atalhos | 1.1 | feita (14 critérios, 12 tarefas) | feita (2 commits) | feita (2 fix) | verificada com ressalvas (6 commits) |
| 005-destaques | 1.2 | pendente | pendente | pendente | |
| 006-quem-somos-video | 1.3, 1.4 | pendente | pendente | pendente | |
| 007-resumo-nossa-historia | 1.5 | pendente | pendente | pendente | |
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

## Ressalvas
- 004: as opções do menu de categorias da navbar (reaproveitadas na janela dos atalhos) não respondem ao toque pela semântica do leitor de tela; não corrigido por ser navbar (fora do escopo da 004). Sugerida correção própria.
- 004: sem teste com leitor de tela real (VoiceOver/NVDA), só árvore de semântica.

## Ocorrências
- Branch criada a partir de origin/develop sem upstream configurado, para que nenhum `git push` sem argumentos vá para a develop.
