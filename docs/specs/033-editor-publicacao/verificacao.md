# Verificação da 033. Editor de publicação em página própria

- **Data:** 2026-10-20
- **Resultado:** aprovada com ressalvas (não conferidos: salvar no Firestore e enviar ao Storage de verdade, destaques da Home lendo o Firestore, leitor de tela de verdade; foco do resumo em Imagem e Categoria com a semântica ligada)

Revisão feita sobre o código dos commits `537af65` a `6bf2d45`, não só sobre o `tasks.md`. Telas abertas num Chrome headless e uma vez no navegador embutido, no app de teste fora do repositório (repositórios falsos que registram o que chega para salvar, `falha=salvar`, `falha=proibido`, `papel=viewer`, imagem quebrada, título longo), e uma vez em modo debug.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia ASCII) | sem problemas no projeto (só o aviso de sempre no app de teste, que não é commitado) |
| `dart format --set-exit-if-changed` no projeto inteiro | nenhum arquivo alterado |
| `fvm flutter build web --release` (site e app de teste) | concluído |
| `fvm flutter run -d web-server` (debug, app de teste) | sem asserção, exceção nem `overflow` em 1280, 768 e 390 (só o erro conhecido do `client.js` do dwds) |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Endereços `nova?tipo=` e `:categoria/:id/editar`; recarregar mantém | passou | rotas em `AppRoutes` e `app_router.dart` com a mesma chave de página; abrir o endereço direto carrega a publicação; id inexistente mostra "Publicação não encontrada" com "Voltar para Artigos" |
| 2 | Protótipo em 390/768/1280, sem `overflow`, barra fixa | passou | `scrollWidth` igual à largura nas três; duas colunas (lateral fixa) só em 1280; no celular ações divididas ao meio e sem "Salvo pela última vez"; barra fora da rolagem |
| 3 | Ações por situação, salvam com a situação certa, aviso curto | passou | não publicada: "Salvar rascunho" manda `isPublished: false`, "Publicar" manda `true` e troca para "Despublicar"/"Salvar alterações" e o selo "Publicado"; aviso "Publicado. Já aparece no site." |
| 4 | Destaque do editor aparece na Home | passou (Firestore não conferido) | o salvar manda `isHighlighted: true`; a Home lê `isHighlighted` em `fetch_highlights_datasource.dart` |
| 5 | Resumo com links, sem aviso flutuante | passou | "Para publicar/salvar, falta preencher:" com os campos do tipo; foco vai ao aviso; link leva ao campo (Título, Link) |
| 6 | Categoria por área; trocar move | passou | desmarcar a área limpa a categoria; a lista só mostra as da área; mudar de Ensino para Memória manda `pastCategory: ensino` e o endereço passa a `/memoria/article-3/editar` |
| 7 | Autores: adicionar, remover cada um, mínimo de um | passou | "Adicionar autor" foca o campo novo; "×" só com mais de um |
| 8 | Imagem: escolher, trocar, remover, placeholder na falha | passou (envio ao Storage não conferido) | endereço colado mostra a prévia 16:10 com "Remover"; imagem quebrada mostra o placeholder |
| 9 | Os 10 tipos abrem e salvam como antes | passou | formulários conferidos contra os diálogos apagados (rótulos e obrigatoriedades); podcast novo e artigo editado salvos no app de teste |
| 10 | Sair com alteração pede confirmação; sem alteração sai direto | passou | "Sair sem salvar?" no "← Artigos" em 1280, 768 e 390; sem alteração vai direto à lista |
| 11 | Tab sai do editor de texto; teclado na página toda | passou | Tab e Shift+Tab percorrem barra, coluna principal e lateral; com a semântica ligada, depois da correção, também passam pelo "×" e por "Adicionar autor" |
| 12 | `VIEWER` não abre o editor | passou | `papel=viewer` vai para `/admin/painel/publicacoes?tipo=artigos` |
| 13 | Diálogos antigos sem uso | passou | arquivos apagados; `grep` sem referências |
| 14 | Contraste ≥ 4,5:1; sem valores soltos | passou | rótulos, dicas e "Salvo pela última vez" em `inkSecondary`; varredura do diff sem cor, fonte ou espaçamento solto |
| 15 | `analyze` sem erros novos | passou | ver Comandos |

## Problemas encontrados
- Depois de tentar salvar, marcar a área ou escolher a categoria deixava "Marque pelo menos uma área." na tela: o `Form` validava antes de reconstruir o campo e lia a escolha anterior. Ajuste, compartilhado com os painéis laterais da 032. Corrigido em `PanelCheckGroup` e `PanelSelectField` (guardam a escolha no estado). Commit `673b8eb`.
- Com a semântica ligada, o Tab no "×" de remover autor e em "Adicionar autor" deixava o navegador sem foco: os botões tiravam o nó do botão da semântica sem marcar o próprio nó como focável, e a dica aberta no foco tirava o foco de novo. Ajuste. Corrigido em `AppIconButton` e `AppButtonBase` (nó focável e, com o leitor ligado, sem abrir a dica no foco). Contato e painel lateral de categoria conferidos depois. Commit `7ea21a7`.
- Ao abrir uma publicação, o título vinha focado e todo selecionado: a primeira tecla apagava o título. Ajuste. Corrigido pondo o cursor no início depois do foco. Commit `eecde52`.

## Ressalvas
- Com a semântica forçada, os links "Imagem" e "Categoria" do resumo mudam o foco do Flutter, mas o navegador fica na página: a digitação não chega ao campo. Sem a semântica funciona. Tentado: pedir o foco no quadro seguinte à rolagem, sem efeito (desfeito). Parou porque vem dos componentes compartilhados com `excludeSemantics` (área de imagem e lista suspensa da 031/032), padrão espalhado pelo site.
- A barra de formatação do Quill tem o nome de cada botão num nó em volta do botão, não no próprio botão (limitação do pacote), como registrado na implementação.

## Não conferido
- Salvar no Firestore, enviar ao Storage (escolher arquivo), destaques da Home lendo o Firestore e recarregar com a sessão real: não há credenciais de teste.
- Leitor de tela de verdade.
