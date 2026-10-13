# Execução da Fase 8

- **Início:** 2026-10-08
- **Branch:** refactor/redesign-fase-8 → PR para develop

As specs 029 a 033 já estavam aprovadas (#35). A etapa "Spec+plano" só cria o plano e as tarefas.

| Spec | Itens | Spec+plano | Implementação | Verificação | Resultado |
|---|---|---|---|---|---|
| 029-login-redesenho | 8.1 | feito (13 critérios, 18 tarefas) | feito (2 commits) | feito (1 fix) | verificada com ressalvas |
| 030-painel-estrutura | 8.2 | feito (15 critérios, 28 tarefas) | feito (3 commits + docs, após retomada) | feito (1 fix) | verificada com ressalvas |
| 031-painel-listas | 8.3 | pendente | pendente | pendente | |
| 032-painel-lateral-formularios | 8.4 | pendente | pendente | pendente | |
| 033-editor-publicacao | 8.5 | pendente | pendente | pendente | |

## Decisões tomadas sem a pessoa
- (geral) Sem credenciais de teste na conversa: telas que exigem login são conferidas num app de teste fora do repositório (scratchpad) que monta os widgets com dados falsos; o fluxo real com o Firebase fica sem conferir.
- (029) Login reaproveita o `FormTextField` do site com dica, senha e ícone opcionais; `isLoading` novo no `AppButtonBase`; mensagem de credencial unificada na página, sem mudar `AuthStore`.
- (029) Em 600 px o logo encolhe (`FittedBox`) e o título reduz a fonte para não quebrar "Observatório." (registrado na spec).

- (030) Ordem dos tipos no menu é a do protótipo; logo do painel leva a Publicações → Artigos; contagem de usuários ignora removidos; até a 031 a Biblioteca resume "N documentos" e o "Novo documento" fica na página da área (registrado na spec).
- (030) Aviso curto pelo `Messenger` (SnackBar), confirmação genérica `showConfirmDialog` e dica no foco como padrão do `AppIconButton`; texto do aviso escolhido pela seção (ação pendente), sem mexer nos stores.
- (030) Salvar publicação também mostra aviso; confirmação de membro usa "Remover"; aviso de erro fica 8 s com botão de fechar; dica no foco estendida a todos os botões de ícone.

## Ressalvas
- (029) Login real com o Firebase e leitor de tela de verdade não conferidos (sem credenciais; nomes acessíveis só no código).
- (030) Painel real com Firebase (contagens, exclusões, logout) e player de vídeo não conferidos; `/admin/painel/:tab` sem sessão ainda abre a moldura vazia, como antes (regra de acesso, fora do escopo).

## Ocorrências
- 2026-10-08: a implementação da 030 parou no limite de uso com alterações sem commit e tarefas sem marcar. Retomada em 2026-10-13 numa sessão nova a partir dessas alterações.
