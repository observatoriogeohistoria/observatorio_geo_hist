# Execução da Fase 8

- **Início:** 2026-10-08
- **Branch:** refactor/redesign-fase-8 → PR para develop

As specs 029 a 033 já estavam aprovadas (#35). A etapa "Spec+plano" só cria o plano e as tarefas.

| Spec | Itens | Spec+plano | Implementação | Verificação | Resultado |
|---|---|---|---|---|---|
| 029-login-redesenho | 8.1 | feito (13 critérios, 18 tarefas) | feito (2 commits) | feito (1 fix) | verificada com ressalvas |
| 030-painel-estrutura | 8.2 | feito (15 critérios, 28 tarefas) | feito (3 commits + docs, após retomada) | feito (1 fix) | verificada com ressalvas |
| 031-painel-listas | 8.3 | feito (14 critérios, 32 tarefas) | feito (4 commits + docs) | feito (3 fix, após retomada) | verificada com ressalvas |
| 032-painel-lateral-formularios | 8.4 | pendente | pendente | pendente | |
| 033-editor-publicacao | 8.5 | pendente | pendente | pendente | |

## Decisões tomadas sem a pessoa
- (geral) Sem credenciais de teste na conversa: telas que exigem login são conferidas num app de teste fora do repositório (scratchpad) que monta os widgets com dados falsos; o fluxo real com o Firebase fica sem conferir.
- (029) Login reaproveita o `FormTextField` do site com dica, senha e ícone opcionais; `isLoading` novo no `AppButtonBase`; mensagem de credencial unificada na página, sem mudar `AuthStore`.
- (029) Em 600 px o logo encolhe (`FittedBox`) e o título reduz a fonte para não quebrar "Observatório." (registrado na spec).

- (030) Ordem dos tipos no menu é a do protótipo; logo do painel leva a Publicações → Artigos; contagem de usuários ignora removidos; até a 031 a Biblioteca resume "N documentos" e o "Novo documento" fica na página da área (registrado na spec).
- (030) Aviso curto pelo `Messenger` (SnackBar), confirmação genérica `showConfirmDialog` e dica no foco como padrão do `AppIconButton`; texto do aviso escolhido pela seção (ação pendente), sem mexer nos stores.
- (030) Salvar publicação também mostra aviso; confirmação de membro usa "Remover"; aviso de erro fica 8 s com botão de fechar; dica no foco estendida a todos os botões de ícone.
- (031) "Novo documento" no cabeçalho e resumo "N documentos em {área}"; usuários só com selo "Removido" (`isDeleted`); trocar de tipo limpa filtros, trocar de área mantém; sem "N de M" (paginação não dá o total filtrado); combinação de filtros sem índice mostra erro, sem criar índice.
- (031) Segmentado anunciado como grupo de rádio e "Destaques" como chave (Flutter web não gera `aria-pressed`); falha ao carregar mais mostra botão "Carregar mais"; em 1280 o "Destaques" cai para a segunda linha.
- (031) Buscas do painel não reservam espaço para o "Limpar" (`SearchField.keepClearSpace`, ligado por padrão no site), para a dica caber a 390 e 768 px.

## Ressalvas
- (029) Login real com o Firebase e leitor de tela de verdade não conferidos (sem credenciais; nomes acessíveis só no código).
- (030) Painel real com Firebase (contagens, exclusões, logout) e player de vídeo não conferidos; `/admin/painel/:tab` sem sessão ainda abre a moldura vazia, como antes (regra de acesso, fora do escopo).
- (031) Painel real com Firebase (inclusive índices para combinações de filtros) e leitor de tela de verdade não conferidos.

## Ocorrências
- 2026-10-08: a implementação da 030 parou no limite de uso com alterações sem commit e tarefas sem marcar. Retomada em 2026-10-13 numa sessão nova a partir dessas alterações.
- 2026-10-13: a verificação da 031 parou no limite de uso com correções sem commit e sem `verificacao.md`. Retomada em 2026-10-19 numa sessão nova a partir dessas alterações.
