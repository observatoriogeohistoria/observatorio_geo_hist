# Verificação da 013. Compartilhamento ampliado do post

- **Data:** 2026-10-01
- **Resultado:** aprovada com ressalvas (após 2 correções, num só `fix:`)

Revisão do código dos commits `b6f8291` e `0e44013`, com o app real: build `APP_ENV=prod` só leitura, servido localmente, no navegador embutido. Nada foi compartilhado: `window.open`, `navigator.share` e a área de transferência foram interceptados e só as URLs e os dados gerados foram lidos. Título com aspas e "&", falha da cópia e caixa de erro vieram de build temporário com dados injetados (fora do repositório, não commitado).

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | sem problemas, antes e depois da correção |
| `fvm flutter build web --release` (`prod`) | concluído sem erro, antes e depois da correção |
| `git diff b81390d..HEAD` de `pubspec.yaml`, modelos, rotas, painel e regras | sem mudanças |
| Busca por `num_extension`, cor/tamanho solto e `GestureDetector` em `post_share.dart`, `native_share*` e `app_button_base.dart` | nenhuma ocorrência nova |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | 768/1280: rótulo, seis ícones na ordem e "Copiar link"; sem nativo | passou | Árvore de acessibilidade: WhatsApp, Facebook, X, LinkedIn, Telegram, e-mail, "Copiar link"; sem "Compartilhar" nativo. Em 1280 na mesma linha do autor; em 768 desce para baixo dele (ver ressalvas) |
| 2 | Redes em outra aba, link e título codificados | passou | URLs interceptadas com o título real (“aspas curvas” e acentos) e com título injetado `Teste "aspas" & ação #1?`: decodificados, chegam idênticos em `text`/`url` de WhatsApp, X, Telegram; Facebook e LinkedIn só com `url` |
| 3 | E-mail na mesma aba, título no assunto, título + link no corpo | passou | `mailto:` com `subject` e `body` corretos, alvo `_self` |
| 4 | Cópia, "Link copiado" ~2 s, largura estável | passou | Área de transferência recebeu o endereço do post; botão "Link copiado" com ícone e volta; largura 146 px antes, durante e na falha |
| 5 | Anúncio; falha mostra "Erro ao copiar" e anuncia a frase completa | passou | Região `aria-live` recebeu "Link copiado" e, com `writeText` rejeitado, "Não foi possível copiar o link"; botão "Erro ao copiar" |
| 6 | 390: "Copiar link", WhatsApp, "Mais"; clique, Enter e Espaço | passou | Tela em 390; Enter em "Mais" abre a linha e mantém o foco nele; Enter no Facebook e Espaço no X abriram as URLs. Estado `expanded` no código (`Semantics(expanded:)`); a árvore de acessibilidade não pôde ser lida na emulação de celular |
| 7 | Nativo em 390 com suporte; cancelar não muda nada; sem suporte some | passou | Sem `navigator.share`: ausente. Com `navigator.share` simulado: aparece, envia título e link; `AbortError` não muda a tela. Ausente em 768/1280 |
| 8 | Nomes, dicas, foco visível, Tab na ordem visual com reveladas | passou | Nomes na árvore (1280); Tab em 390: WhatsApp → Mais → Facebook → X → LinkedIn → Telegram, com contorno visível |
| 9 | Contraste, hover, sem PNG nem "Twitter" | passou após correção | Ícones e rótulo em `inkSecondary` (7,0:1). Hover era `accent` sobre `accentSoft` (4,4:1); passou a `accentStrong` (6,1:1), conferido na tela. `post/` sem PNG nem "Twitter" |
| 10 | Sem rolagem horizontal nem `overflow` | passou | `scrollWidth` = largura em 390 (com "Mais" aberto e nativo) e 768; console sem erros |
| 11 | Outros tipos como na 012 | passou | Filme (Nomadland) abre no layout atual, sem compartilhar, console sem erros |
| 12 | Tokens, sem `num_extension` nem pacote novo, componente único, analyze e build | passou | Comandos acima; `PostShare` descrito em `docs/arquitetura.md` |

Regressão do `AppButtonBase`: sem `leadingIcon`/`reserveTexts`, o código monta a mesma árvore de antes. Conferidos na tela os botões do hero da Home, "Fale com a gente" do Manifesto e "Tentar de novo" da caixa de erro (falha injetada): sem mudança.

## Problemas encontrados
- **"Mais" sozinho na segunda linha do celular** (detalhe, resolvido). Com o botão nativo em 390 px, WhatsApp cabia na primeira linha e "Mais" descia sozinho, ao contrário da spec ("WhatsApp e Mais descem"). Correção: WhatsApp e "Mais" num `Row` que quebra junto. Conferido: com nativo, a segunda linha tem os dois; sem nativo, tudo numa linha.

- **Ícone em hover abaixo de 4,5:1** (ajuste, resolvido). `accent` sobre `accentSoft` dá 4,4:1. Correção: hover em `accentStrong` (ainda laranja, 6,1:1). Conferido na tela em 1280.

## Divergências registradas na implementação
- **"Erro ao copiar"** no botão (o anúncio mantém a frase completa): aceita. Texto curto evita reservar ~200 px no botão; quem usa leitor de tela ouve a mensagem inteira.
- **Duas linhas no celular com o nativo:** aceita. "Compartilhar" + "Copiar link" ocupam a largura útil de 390; com a correção acima a quebra fica limpa.

## Ressalvas
- Em 768 o compartilhar desce para baixo do autor mesmo com nome curto (autor ~207 px + compartilhar 524 px > 704 px úteis). A spec permite e o resultado é limpo, alinhado à esquerda; ficar na mesma linha exigiria encolher o botão ou os vãos abaixo do protótipo.

## Não conferido
- Folha de compartilhamento real do sistema: o navegador embutido não tem `navigator.share`; conferido com simulação.
- Estado `expanded` lido por leitor de tela em 390 (a semântica do Flutter não ativa na emulação de celular); conferido pelo código.
- Shift+Tab (a ferramenta envia Tab sem o Shift).
- Painel administrativo: não se aplica.
