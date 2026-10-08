# Execução da Fase 8

- **Início:** 2026-10-08
- **Branch:** refactor/redesign-fase-8 → PR para develop

As specs 029 a 033 já estavam aprovadas (#35). A etapa "Spec+plano" só cria o plano e as tarefas.

| Spec | Itens | Spec+plano | Implementação | Verificação | Resultado |
|---|---|---|---|---|---|
| 029-login-redesenho | 8.1 | feito (13 critérios, 18 tarefas) | feito (2 commits) | feito (1 fix) | verificada com ressalvas |
| 030-painel-estrutura | 8.2 | pendente | pendente | pendente | |
| 031-painel-listas | 8.3 | pendente | pendente | pendente | |
| 032-painel-lateral-formularios | 8.4 | pendente | pendente | pendente | |
| 033-editor-publicacao | 8.5 | pendente | pendente | pendente | |

## Decisões tomadas sem a pessoa
- (geral) Sem credenciais de teste na conversa: telas que exigem login são conferidas num app de teste fora do repositório (scratchpad) que monta os widgets com dados falsos; o fluxo real com o Firebase fica sem conferir.
- (029) Login reaproveita o `FormTextField` do site com dica, senha e ícone opcionais; `isLoading` novo no `AppButtonBase`; mensagem de credencial unificada na página, sem mudar `AuthStore`.
- (029) Em 600 px o logo encolhe (`FittedBox`) e o título reduz a fonte para não quebrar "Observatório." (registrado na spec).

## Ressalvas
- (029) Login real com o Firebase e leitor de tela de verdade não conferidos (sem credenciais; nomes acessíveis só no código).

## Ocorrências
- (limites, falhas de ambiente, retomadas)
