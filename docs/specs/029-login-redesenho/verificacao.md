# Verificação da 029. Login redesenhado

- **Data:** 2026-10-08
- **Resultado:** aprovada com ressalvas (não conferidos: login real com o Firebase e leitor de tela de verdade)

Revisão feita sobre o código dos commits `e0bfbab` e `8a6089c`, não só sobre o `tasks.md`. Telas abertas num Chrome headless, no build de release do site e num app de teste fora do repositório que monta a `SigninPage` com um `AuthRepository` falso.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia ASCII) | sem problemas |
| `dart format --set-exit-if-changed` no projeto inteiro | 328 arquivos, nenhum alterado |
| `fvm flutter build web --release` (site e app de teste) | concluídos |
| `fvm flutter run -d web-server` (app de teste, debug) | sem `overflow` nem asserção em 1280, 768, 600 e 390 |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Protótipo em 390, 768 e 1280 sem `overflow` | passou | capturas nos três tamanhos (e em 600, em debug) batem com a aba "Login": marca escura com anéis e cartão de 400 px; no celular, faixa só com logo, sobretítulo e título. `scrollWidth` igual à janela em 390 |
| 2 | Rótulos em caixa normal, sem regra de senha | passou | "E-mail" e "Senha" na tela; `Validators.isValidPassword` fora da página |
| 3 | Envio vazio | passou | duas mensagens de campo; foco num `input` de texto (e-mail) |
| 4 | Senha curta aceita | passou | `abc` chegou ao repositório falso (`LOGIN_CALL a@b.com\|abc`) |
| 5 | Credencial errada | passou | aviso "E-mail ou senha não conferem…" no topo do cartão, senha vazia e com foco (`INPUT:password` vazio), sem aviso flutuante |
| 6 | "Entrando…" sem duplo envio | passou | captura com indicador e "Entrando…"; Enter e clique durante a espera não geraram segunda chamada |
| 7 | Sucesso e sessão aberta | passou no app de teste | sucesso foi para `/admin/painel`; `/admin` com sessão aberta também. Com o Firebase: não conferido |
| 8 | Voltar ao site e logo | passou | os dois levam a `/` (por clique e, no link, por Enter) |
| 9 | Mostrar/ocultar senha | passou | Tab chega ao olho com anel de foco e dica; Espaço mostra a senha e a dica vira "Ocultar a senha". Nome e `toggled` em `password_visibility_button.dart` |
| 10 | Faixa de ambiente | passou | "Ambiente de testes" no dev em todas as telas; em prod o `EnvironmentBanner` devolve `SizedBox.shrink()` (conferido em build prod na implementação) |
| 11 | Contraste ≥ 4,5:1 | passou | razões calculadas na implementação (menor: botão em carregamento, 4,9) e cores conferidas no código |
| 12 | Sem valores soltos | passou | só tokens nos arquivos tocados; `Colors.transparent` segue o padrão do `AppButtonBase` |
| 13 | `analyze` | passou | ver Comandos |

Ordem de Tab conferida: e-mail, senha, olho, Entrar, Voltar ao site (o logo vem antes, pela `WidgetOrderTraversalPolicy`).

## Regressões nas peças compartilhadas
- `FormTextField`: Contato em 390 e 1280 igual ao de antes; enviar vazio mostra os quatro erros. Colabore em 1280 igual. Sem `suffix`, a árvore do campo não muda.
- `AppButtonBase`/`PrimaryButton`: botões da Home, de Contato e de Colabore iguais; `isLoading` tem padrão `false`.
- `AppLogo`: navbar e rodapé com o nome acessível de antes (o parâmetro novo é opcional).
- `EnvironmentBanner`: só o texto mudou, visto na Home, Contato, Colabore e login.

## Problemas encontrados
- Comentário do `isLoading` no `AppButtonBase` passava de 100 colunas e descrevia o quê. Ajuste, corrigido (`9246076`).

## Não conferido
- Login real com o Firebase (sem credenciais de teste): erro de credencial, outros erros e entrada no painel foram vistos só com o repositório falso.
- Leitor de tela de verdade: nomes, `liveRegion` do aviso e erros ligados ao campo conferidos no código.
- O app de teste não registra `GlobalCupertinoLocalizations` e mostra um aviso disso no console em debug; o app real registra.
