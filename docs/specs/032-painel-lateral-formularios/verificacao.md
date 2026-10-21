# Verificação da 032. Painel lateral para formulários curtos

- **Data:** 2026-10-20
- **Resultado:** aprovada com ressalvas (não conferidos: salvar no Firestore e enviar ao Storage de verdade, leitor de tela de verdade)

Revisão feita sobre o código dos commits `be1fa7a`, `3672fd8`, `1600bb4` e `8af48fc`, não só sobre o `tasks.md`. Telas abertas num Chrome headless, no build de release do site e no app de teste fora do repositório (repositórios falsos que registram o que chega para salvar, atraso de 800 ms, `falha=salvar`, `falha=proibido`, imagens quebradas e textos longos), e uma vez em modo debug.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia ASCII) | sem problemas no projeto (só o aviso de sempre no app de teste, que não é commitado) |
| `dart format --set-exit-if-changed` no projeto inteiro | 347 arquivos, nenhum alterado |
| `fvm flutter build web --release` (site e app de teste) | concluído |
| `fvm flutter run -d web-server` (debug, app de teste) | sem asserção, exceção nem `overflow` no console e no terminal |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Cinco formulários no painel lateral, 390/768/1280, sem `overflow` nem rolagem horizontal | passou | `scrollWidth` igual à largura nas três; usuário em tela cheia a 390, documento a 768, membro a 1280. Largura de 460, cabeçalho e pé iguais aos do protótipo (`.sheet`) |
| 2 | Cabeçalho e pé fixos | passou | `panel_sheet.dart`: só o corpo fica no `SingleChildScrollView`; visto com o documento rolado |
| 3 | Mesmos dados salvos; envio de imagem onde há Storage | passou (Storage real não conferido) | o que chega ao repositório ao editar categoria, membro, usuário e documento é igual ao registrado antes da mudança; criar usuário manda o papel e a senha como antes; nome e extensão do PDF e da mídia separados como antes (código e envio pelo CDP) |
| 4 | Dica do endereço com área marcada | passou | "Vira o fim do link: /publicacoes/geografia/ensino" |
| 5 | Papel em cartões, mesmo valor salvo | passou | três cartões com as explicações; seta para baixo de "Edição" marca "Leitura" e salva `VIEWER` |
| 6 | Salvar vazio mostra mensagens e foca o primeiro com erro | passou | usuário a 390 foca "Nome"; documento com título preenchido foca "Autor"; mensagens de tipo, categorias e arquivo no campo |
| 7 | "Salvando…" sem envio duplo | passou | dois cliques e Enter seguidos geram um só registro de salvar em categoria, membro, usuário e documento |
| 8 | Sucesso fecha e avisa; erro mantém painel e dados | passou | sucesso fecha e mostra o aviso curto; `falha=salvar` deixa o painel aberto, com os dados e o aviso vermelho no topo (1280 e 390, também em debug) |
| 9 | Esc, "×", "Cancelar" e fundo fecham sem salvar; foco volta ao botão | passou | os quatro fecham sem registro de salvar; aberto pelo teclado, depois do Esc o foco está no "Editar" da linha e Enter reabre o painel |
| 10 | Teclado completo, foco preso | passou | Shift+Tab do primeiro campo vai ao "×" e depois ao "Salvar" e ao "Cancelar", sem sair do painel |
| 11 | Contraste ≥ 4,5:1 | passou | valores calculados na implementação (D2) conferidos no código: dicas e "opcional" em `inkSecondary` |
| 12 | Sem valores soltos | passou | varredura do diff: números e cores só nos tokens do tema |
| 13 | `analyze` sem erros novos | passou | ver Comandos |

## Pontos de atenção do pedido
- **Diálogo antigo das publicações (`saveInDialog`):** com dados falsos válidos (revista com descrição e link), editar e salvar registra o envio, fecha o diálogo, mostra "Publicação salva." e a lista continua na tela. Com falha, o diálogo fica aberto, como antes.
- **Fechar duas vezes:** no painel lateral só o próprio painel fecha (e só se a rota for a atual); `showPanelActionResult` fecha apenas no `saveInDialog`. Em debug, depois de salvar a lista continua aberta, sem asserção. Com `falha=proibido`, a saída da sessão leva ao login sem erro.
- **Componentes do site:** Contato, Colabore e login (enviar vazio) iguais em 390 e 1280; Biblioteca pública abre, e o filtro "Tipo de produção" abre e filtra a 390.

## Problemas encontrados
- Lista suspensa do painel ("Tipo de produção") ficava com a borda normal no erro, enquanto os outros campos ficam vermelhos. Ajuste. Corrigido: `LibraryFilterSelect` ganhou `hasError` opcional (padrão desligado, a Biblioteca pública não muda). Commit `02f1b58`.

## Não conferido
- Salvar no Firestore e enviar ao Storage de verdade: não há credenciais de teste.
- Leitor de tela de verdade.
