# Verificação da 030. Estrutura do painel

- **Data:** 2026-10-13
- **Resultado:** aprovada com ressalvas (não conferidos: painel real com o Firebase, player de vídeo e leitor de tela de verdade)

Revisão feita sobre o código dos commits `1f87f8d`, `74b3a17`, `b74c04b` e `b9c3de9`, não só sobre o `tasks.md`. Como a implementação foi feita em duas sessões, procurei sobras: tokens sem uso, componentes apagados ainda citados, `isCollapsed`/`toggleCollapse` e duplicações. Telas abertas num Chrome headless, no build de release do site e num app de teste fora do repositório que monta a `PanelPage` com repositórios falsos (papel, nome longo e falhas por parâmetro).

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia ASCII) | sem problemas no projeto (só avisos `info` no app de teste, que não é commitado) |
| `dart format --set-exit-if-changed` no projeto inteiro | 338 arquivos, nenhum alterado |
| `fvm dart run build_runner build` | `panel_counts_store.g.dart` regenerado após a correção |
| `fvm flutter build web --release` (site e app de teste) | concluídos |
| `fvm flutter run -d web-server` (app de teste, debug) | sem `overflow` nem asserção em 1280, 1023, 768 e 390, abrindo a gaveta e confirmando exclusão |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Protótipo em 390, 768 e 1280 sem `overflow` | passou | capturas batem com a aba "Painel" (barra de 64, menu de 248, cabeçalho com sobretítulo, título e resumo, botão "+ Novo artigo"); `scrollWidth` igual à janela nos três tamanhos |
| 2 | Três grupos, Administração só para `ADMIN` | passou | grupos em `sidebar_navigation.dart`; com `papel=editor` e `viewer` o grupo Administração some |
| 3 | Dez tipos e Publicações abre Artigos | passou | tipos sempre visíveis na ordem do protótipo; `open()` manda Publicações para `artigos` |
| 4 | Contagens, Mídias sem número, falha não quebra | passou no app de teste | 260/128/14/399/23/9 no menu; Mídias sem número; cada consulta falha sozinha (`_orNull` no repositório), e o número que falha some, conferido no app de teste na implementação (H4). Consultas `count()` conferidas contra os datasources (`category_posts` por `type`, `library` por `area`, `users` menos `isDeleted`). Com o Firebase: não conferido |
| 5 | Sem recolher | passou | `toggle_collpase_button.dart` e `sidebar_header.dart` apagados; nenhuma referência restante |
| 6 | Nome, papel e "Ver site" | passou | "Nome Sobrenome / Administração" a 1280; só iniciais abaixo de 1024; "Ver site" abre `Uri.base.resolve('/')` em nova aba (`openUrl`) |
| 7 | Gaveta | passou | abre com foco em "Categorias" (item atual), Esc fecha e o foco volta ao botão de menu com a dica; fechar ao escolher item e ao tocar fora conferido na implementação (H4) e no código (`onNavigate`, `drawerScrimColor`) |
| 8 | `VIEWER` sem ações | passou | com `papel=viewer` sem botão principal nem botões nas linhas |
| 9 | Confirmação antes de excluir | passou | janela "Excluir esta categoria?" com Cancelar focado; Esc cancela e a categoria continua; Excluir remove e mostra "Categoria excluída." |
| 10 | Categoria com publicações | passou | botão desabilitado e focável; nome "Excluir" com a dica "Só dá para excluir categoria sem publicações. Esta tem 12." |
| 11 | Aviso curto e aviso de erro | passou | "Publicado. Já aparece no site." escuro e centrado embaixo; com `falha=excluir`, aviso vermelho "Não foi possível excluir a publicação." com botão de fechar |
| 12 | Dicas e nome acessível | passou | dica aparece no Tab (foco por teclado) e no mouse; árvore de semântica mostra nome curto e descrição em todos os botões das linhas |
| 13 | Contraste ≥ 4,5:1 | passou | razões calculadas na implementação (menor 4,87:1) e cores conferidas no código: contagens, grupos e papel em `inkSecondary` |
| 14 | Sem valores soltos | passou | varredura do diff: só tokens; as cores e durações novas moram no tema |
| 15 | `analyze` sem erros novos | passou | ver Comandos |

## Regressões no site público
- Home (390 e 1280), menu do celular, Biblioteca e login da 029: logo, botões e dicas iguais ao esperado; sem rolagem horizontal. `/admin/painel` sem sessão volta a `/admin`.
- `AppIconButton` agora põe a própria semântica (nome igual à dica quando não há `label`), então o nome dos botões do site não mudou.

## Problemas encontrados
- **Corrigido** (`a47b638`): ao falhar o logout, a `PanelPage` lia `state.loginState as LoginStateError` em vez do estado de logout, o que quebraria a tela em vez de mostrar o erro. Vinha de antes da spec, no arquivo que ela reescreveu. Gravidade: ajuste.
- **Corrigido** (`a47b638`): sobra da primeira sessão, o parâmetro `force` de `PanelCountsStore.load` não era usado por ninguém (a recarga é o `refresh`). Gravidade: detalhe.
- `/admin/painel/:tab` sem sessão continua abrindo a moldura vazia, como antes da spec. Mudar isso é regra de acesso, fora do escopo (já registrado no H5). Gravidade: detalhe.

## Não conferido
- Painel real com o Firebase (contagens de verdade, exclusões, logout): não há credenciais de teste.
- Player de vídeo do site: sem post com vídeo à mão. O `AppIconButton` foi revisado no código e é o mesmo componente conferido no menu do celular.
- Leitor de tela de verdade: só a árvore de semântica do navegador.
