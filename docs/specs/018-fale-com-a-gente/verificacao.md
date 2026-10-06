# Verificação da 018. Fale com a gente

- **Data:** 2026-10-05
- **Resultado:** aprovada com ressalvas (não conferidos no app: leitor de tela de verdade, sugestão de autopreenchimento e detalhe da biblioteca com documento)

Revisão do código de `991973e`, `d0bcbf0` e `4f4ffbc` e do app real: build release servido localmente e `flutter run -d web-server` (debug), no navegador embutido, com `window.open` e `navigator.clipboard.writeText` interceptados para capturar o `mailto:` e o texto copiado.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | sem problemas, antes e depois da correção |
| Conferência de formato do `CLAUDE.md` | 0 arquivos a formatar |
| `fvm flutter build web --release` | concluído sem erro, antes e depois da correção |
| `flutter run -d web-server` (debug) em 390 e 1280 | formulário vazio, com erros, com textos longos e confirmação, sem `overflow`, exceção nem asserção no log ou no console |
| Busca por cor, fonte e espaço soltos, `num_extension`, `GestureDetector`, rota solta e menção a spec/protótipo no código novo | nenhuma ocorrência |
| `git diff 6dca7c2..HEAD` em `app_text_field.dart`, `validators.dart`, `collaborate_page.dart`, rotas, painel e `pubspec.yaml` | sem diff |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Estrutura da página | passou | tela em 1280, 768 e 390, igual à aba "Contato"; migalhas "Você está em" com "Início" (link) e "Fale com a gente, página atual"; sem "CONTATO", divisória nem "ENVIAR" |
| 2 | Campos, botão, apoio, autofill, Enter | passou | quatro rótulos acima; botão com envelope à esquerda; Enter passa de Nome a E-mail, Assunto e Mensagem e quebra linha na Mensagem; `autocomplete="name"`/`"email"` nos campos do navegador (a sugestão em si não foi vista) |
| 3 | Validação | passou | envio vazio: quatro mensagens da tabela em `#B3261E` com borda de erro, foco no Nome, nenhum `mailto:`; Nome só com espaços conta como vazio; "ana@x" inválido; o erro some ao digitar depois da primeira tentativa |
| 4 | Abertura do e-mail | passou | `window.open(..., '_self')` com `mailto:` para `AppStrings.email`; assunto e corpo com acentos, `&`, `?`, `#`, `%`, emoji e quebra de linha codificados por inteiro; corpo "mensagem, linha em branco, nome, e-mail"; "ana@exemplo.com " aparado |
| 5 | Confirmação | passou | substitui o formulário com ícone, título, os dois textos, link `mailto:` e os dois botões; foco no título (Tab seguinte vai ao link); `liveRegion` no título (anúncio não ouvido em leitor de tela) |
| 6 | Copiar mensagem | passou | texto copiado no formato da spec; botão mostra "Mensagem copiada" com ✓ e volta a "Copiar mensagem" depois de 1,8 s; com a cópia recusada, "Erro ao copiar"; largura igual nos três estados (`reserveTexts`) |
| 7 | Voltar ao formulário | passou | campos mantidos, sem erros, foco no Nome (texto selecionado); novo envio abre o `mailto:` e a confirmação |
| 8 | Outros meios | passou | E-mail `mailto:`, dois `tel:` com nome "Telefone 34 …", endereço do rodapé em três linhas; foco visível; sem redes sociais na página (só no rodapé) |
| 9 | Acessibilidade | passou | árvore semântica: campos com `aria-label` do rótulo, `aria-invalid="true"` e o erro em `aria-description`; ordem de Tab Nome → E-mail → Assunto → Mensagem → botão → links; contraste: borda 3,8:1, links 6,3:1 na superfície, texto secundário 6,5:1, erro 6,5:1, ícone 5,7:1; troca sem animação |
| 10 | Responsivo, release e debug | passou | 390: uma coluna, botão na largura toda, botões da confirmação empilhados; 768: uma coluna, botão no tamanho do texto; 1280: 3/5 e 2/5 alinhados no topo; `scrollWidth` igual à janela; nome e assunto longos rolam dentro do campo, mensagem longa quebra linha; estado preservado ao trocar de largura; rodapé na base |
| 11 | Peças compartilhadas | passou | `MailForm`, `MailFormFieldSpec`, `FormTextField`, `MailConfirmation`, `FormValidators` e `MailDraft` em `core/`, sem texto de contato dentro; Colabore, painel e `Validators` sem diff |
| 12 | Tokens, analyze e build | passou | ver Comandos; nenhum pacote novo |

## Problemas encontrados
- **Foco sem rolar até o campo** (ajuste, corrigido em `2c8ee0b`): com a página rolada, "Abrir no meu e-mail" levava o foco ao primeiro campo inválido, mas ele continuava fora da tela, e o Nome ao voltar da confirmação podia ficar sob a navbar fixa. Visto em debug a 1280 (foco no E-mail com o campo escondido). O `MailForm` agora chama `Scrollable.ensureVisible` no campo focado e a `MailConfirmation` faz o mesmo com a própria caixa. Conferido de novo em debug e em release: o Nome aparece logo abaixo da navbar com o erro, e a caixa da confirmação aparece inteira.

## Regressões
- `PrimaryButton` com `leadingIcon`: Home (herói e chamada "Fale com a gente"), Manifesto ("Fale com a gente" com seta) e 404 da biblioteca sem mudança. O detalhe da biblioteca com documento não foi aberto: o ambiente de testes não tem documentos. A mudança é só aditiva (padrão nulo, repassado ao `AppButtonBase`, que já desenhava o ícone à esquerda).

## Não conferido
- Anúncio por leitor de tela de "Seu e-mail está pronto", "Mensagem copiada" e "Erro ao copiar": só o código (`liveRegion`, `SemanticsService.sendAnnouncement`) e a árvore semântica.
- Sugestão de autopreenchimento do navegador: o navegador embutido não guarda dados; conferidos só os atributos `autocomplete`.
- Detalhe da biblioteca com documento (ver Regressões).
- Painel: não conferido no app (sem credenciais); código sem diff.
