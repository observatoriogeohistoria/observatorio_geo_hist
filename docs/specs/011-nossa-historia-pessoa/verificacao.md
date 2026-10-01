# Verificação da 011. Nossa história completa e Pessoa da equipe

- **Data:** 2026-10-01
- **Resultado:** aprovada com ressalvas (após 1 correção)

Revisão do código dos commits `687d3cd`, `07e068e`, `15d2ce3` e `0f1f390`, com o app real (build servido localmente, Firebase dev) no navegador embutido. Onde a evidência veio da conferência da implementação (F2 em `tasks.md`), está indicado.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | sem problemas, antes e depois da correção |
| `fvm flutter build web --release` | concluído sem erro, antes e depois da correção |
| `git diff 55504ae..HEAD` de roteador, rotas, `home_setup.dart`, `infra/` e painel | vazio |
| Script: frases do texto antigo de Nossa história (git) contra o novo | todas presentes, salvo "e, por fim," e o traço em "2016–2018" |
| Busca por `num_extension`, cor solta, `GestureDetector` e imports antigos nos arquivos da spec | nenhuma ocorrência (`style.fontSize` em `reading_blocks.dart` é do `TextStyle`) |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Estrutura de `/nossa-historia` | passou | Tela em 390, 768 e 1280 px |
| 2 | Texto exato e na ordem | passou | Script acima; ordem conferida em `our_history_page.dart` |
| 3 | Subtítulos `h2` e lista com marcadores | passou | `ReadingSubtitle` com `headingLevel: 2`; `ReadingBulletList` com `SemanticsRole.list`; tela em 768 |
| 4 | Foto 21:9 com rostos, legenda, nome acessível, placeholder | passou | Tela em 768 e 1280; falha forçada conferida na implementação |
| 5 | Pessoa com migalhas, foto, rótulo, `h1`, descrição, Lattes | passou | Tela do único membro com descrição no dev; Lattes só com dados injetados (implementação) |
| 6 | Sem Lattes sem botão; iniciais sem foto | passou | Membro do dev sem Lattes; iniciais com dados injetados (implementação) |
| 7 | 404 com no máximo uma leitura | passou | Busca só no `initState` com `needsFetch` (`team_member_page.dart`); contador e rede na implementação |
| 8 | Esqueleto no acesso direto, nada vindo da Home | passou | Código (`FetchTeamInitialState`/`LoadingState` → esqueleto); tela na implementação |
| 9 | Caixa de erro e "Tentar de novo" | passou | `StateErrorBox(onRetry: fetchTeam)`; falha forçada na implementação |
| 10 | Clicáveis da Home = quem tem página | passou | `memberHasPage` usado no tile e na página |
| 11 | Migalhas e ordem de Tab com foco visível | passou após correção | Ver "Problemas encontrados" |
| 12 | Contraste ≥ 4,5:1 | passou | Tokens: rótulo 6,8; iniciais 6,1; texto secundário 7,0/6,5; ícone de erro sobre `errorSurface` 5,6 |
| 13 | 390, 768 e 1280 sem rolagem horizontal | passou | `scrollWidth` igual à largura em 768; pessoa empilhada em 390 e lado a lado em 768/1280 |
| 14 | Rodapé na base com janela alta | passou | Pessoa em 1280 × 800 e 768 × 1024 com rodapé na base |
| 15 | Nenhuma rota muda | passou | Diff vazio; Manifesto e Home abrem como antes |
| 16 | Blocos na base de leitura, documentados | passou | `core/components/reading/`; seção "Páginas de leitura" em `docs/arquitetura.md` |
| 17 | Tokens, sem `num_extension` nem componentes antigos; analyze e build | passou | Comandos acima |

## Problemas encontrados
- **Foco escondido sob a navbar fixa** (ajuste, resolvido). Com a página rolada, o primeiro Tab ia para "Início" (que fica acima da navbar na ordem de leitura por posição) e o foco ficava sob a navbar, sem rolar. Não saía da ordem: ficava invisível. Valia para Manifesto, Nossa história e pessoa. Correção no `ReadingPageScaffold`: `OrderedTraversalPolicy` com a navbar em primeiro e `requestFocusCallback` que também rola o item focado para fora de baixo da navbar (`keepVisibleAtStart`). Conferido com registro do foco num build de teste: em 1280 (rolagem curta e longa) e 390, a ordem é navbar → Início (rolado e com contorno) → conteúdo → rodapé. Menu "História" da navbar por teclado igual ao da Home.

## Ressalvas
- Offline, o Firestore responde do cache vazio e a pessoa cai na 404 em vez da caixa de erro. Comportamento anterior; corrigir exige mudar o datasource, fora do escopo.
- Membro sem descrição, botão Lattes e foto ausente só conferidos com dados injetados: o banco de dev não tem esses casos.

## Não conferido
- Shift+Tab pela ferramenta do navegador (ela envia Tab sem o Shift). O sentido inverso usa a política padrão do Flutter, que já rola para mostrar o item.
- Painel administrativo: não se aplica.
