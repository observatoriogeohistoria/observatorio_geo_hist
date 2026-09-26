# Verificação da 005. Home: destaques

- **Data:** 2026-09-26
- **Resultado:** aprovada (um problema encontrado e corrigido: buscas de destaques repetidas)

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | No issues found, antes e depois da correção (o único aviso aparece nos testes temporários, fora do repositório) |
| `fvm flutter build web --release` (cópia ASCII) | concluído sem erro, depois da correção |
| Testes de widget temporários (só na cópia do scratchpad, não entram no repositório) | 33 testes da seção passando: 0, 1, 2, 3 e 5 destaques × 390, 768 e 1280 px × texto a 100% e 200% (posição e tamanho de cada cartão, principal = mais recente, nenhuma exceção de `overflow`), esqueleto → erro → "Tentar de novo" (volta a buscar e mostra 3 cartões), título de 320 caracteres (3 linhas, nome acessível completo), Tab + Enter abrindo `/posts/geografia/cat/p1`, imagem que falha. Mais 3 testes da `HomePage` inteira (com GoRouter e repositórios falsos) contando as buscas de destaques |
| Pré-visualização com repositório falso (`lib/main_preview.dart` só na cópia) servida por Python com fallback de SPA + navegador embutido | 3 destaques em 768 e 390 com texto a 200% (fonte raiz do documento em 32 px), erro em 768, ida à Biblioteca e volta |
| Build de `main.dart` com os dados reais, servido do mesmo jeito | 390, 768 e 1280 px; `scrollWidth` igual à largura nas três |

Todas as tarefas do [tasks.md](tasks.md) estão marcadas. Revisão feita no código dos commits `4f1bc81` e `0b42834`, não só no relatório da implementação.

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Seção abaixo do hero e acima de "Quem somos", título como cabeçalho; sem carrossel, setas nem faixas | passou | `home_page.dart`: sliver da `HighlightsSection` logo depois do `HomeHero`; `Semantics(header: true)` no título. `components/highlights.dart` apagado; nenhuma referência a ele sobrou (`grep`). Na pré-visualização, "Destaques" aparece entre os atalhos e "Quem somos" |
| 2 | 0 destaques: nada aparece | passou | Teste: altura 0 e nenhum "Destaques" nas três larguras. Build real (0 destaques no banco): hero → "Quem somos" direto em 390 e 1280 |
| 3 | 1 destaque na largura toda | passou | Testes: 350×340 (390), 704×400 (768), 1056×440 (1280) |
| 4 | 2 destaques: colunas 1,6 : 1 na altura toda; coluna no celular | passou | Testes: 423/265 × 400 (768), 640/400 × 440 (1280); 390 empilhado 340 + 220 |
| 5 | 3 destaques: principal à esquerda, dois empilhados | passou | Testes: 768 → 423×400 + 265×192 ×2; 1280 → 640×440 + 400×212 ×2; 390 em coluna. Conferido na tela em 768 |
| 6 | Mais de 3: só os três mais recentes, principal = mais recente, sem troca nem setas | passou | Teste com 5: 3 cartões e o principal é o de data mais recente (`selectHighlights`) |
| 7 | Foto `cover`, degradê só embaixo, rótulo, título, data "12 mar 2026" no principal | passou | `highlight_card.dart`; tela em 768 e 390 ("ARTIGO · GEOGRAFIA", "12 mar 2026") |
| 8 | Clique, Enter e leitor de tela abrem `/posts/:area/:categoria/:id` | passou | Teste Tab + Enter com GoRouter; `Semantics(onTap: _open)`. Com destaque real não conferido: não há destaque no banco |
| 9 | Sem imagem ou falha: mesmo tamanho, fundo escuro e ícone | passou | Teste com URL inválida: ícone nos dois cartões; mesmo tamanho pela grade fixa |
| 10 | Esqueleto; erro com "Tentar de novo" que refaz a busca | passou | Teste (esqueleto → erro → nova busca → cartões); tela de erro em 768 |
| 11 | Título longo em 3 linhas com reticências, nome acessível completo | passou | Teste: `maxLines` 3 e rótulo semântico com o título inteiro, "Artigo, Geografia" e a data |
| 12 | Tab na ordem visual, foco arredondado, nome acessível, foto ignorada | passou | Teste de Tab; `AppFocusRing` raio 16; `ExcludeSemantics` na foto e no ícone |
| 13 | Contraste ≥ 4,5:1 sobre foto branca; erro ≥ 4,5:1 | passou | Véu mínimo 0,72 sobre branco (≈ #56534F): branco ≈ 7,6:1, rótulo ≈ 5,2:1, data ≈ 5,1:1 (cálculo da implementação, conferido com a foto branca na tela); erro em `inkSecondary` |
| 14 | 390/768/1280 e texto a 200% sem rolagem horizontal nem `overflow`; alturas e títulos conforme "Responsivo" | passou | Testes a 200% sem exceção nas 15 combinações; **no navegador**, texto a 200% em 768 e 390 sem sobreposição (título corta com reticências) e `scrollWidth` = largura |
| 15 | Movimento reduzido: sem transição, esqueleto parado | passou | `Duration.zero` no fade da imagem com `disableAnimations`; `Skeleton` estático |
| 16 | Só tokens, sem `num_extension`; analyze e build sem erro | passou | `grep` nos arquivos novos: nenhuma cor, fonte ou espaçamento solto nem `num_extension` (o `.verticalSpacing` que aparece na `home_page.dart` é do vídeo, bloco da 006). Analyze e build acima |

## Problemas encontrados
- **Buscas de destaques repetidas (ajuste, corrigido em `db9a29d`).** A navbar ainda tinha uma reação antiga que buscava os destaques quando as categorias mudavam, além da reação da Home; e a navbar busca as categorias de novo a cada página. Medido com teste da `HomePage` inteira: abrir o site disparava **4** buscas e ir a outra página e voltar, mais 4 (8 no total); na pré-visualização, voltar da Biblioteca disparou mais 2. Cada nova busca põe o store em "carregando" e troca os cartões pelo esqueleto por um instante (com 0 destaques, o esqueleto aparecia e sumia, empurrando a página). A segunda reação (categorias com erro) em si não duplicava: com erro, `categories` não muda e só ela dispara (1 busca). Correção: a navbar deixa de buscar destaques; a Home só busca se ainda não buscou, se a busca falhou ou se a última foi sem categorias e agora elas existem (campo `fetchedWithoutCategories` no store); busca em andamento não se repete. Conferido de novo: 1 busca ao abrir (com categorias, com erro nas categorias e com 0 destaques), nenhuma ao ir e voltar; com categorias que falham e depois chegam, exatamente uma busca a mais. No navegador, nenhuma busca nova ao voltar da Biblioteca; o menu de categorias da navbar continua carregando as categorias reais.
- **Detalhe, sem correção:** `Colors.transparent` no `overlayColor` do cartão (serve só para anular o realce do `InkWell`; não é cor de design).
- **Observação dos testes:** a navbar acusa `overflow` de 3 px nos testes de widget por causa da fonte de teste; no navegador, em 1280, não há `overflow` (bloco da 002, fora desta spec).

## Não conferido
- Clique num destaque real: o banco não tem nenhum post publicado marcado como destaque (diagnóstico da A1). Conferido com dados simulados.
- Comparação lado a lado com o protótipo: feita na implementação (D3); aqui a conferência foi pelas medidas da spec.
