# Verificação da 020. Estados especiais

- **Data:** 2026-10-05
- **Resultado:** aprovada com ressalvas (não conferidos no app: erro dos Destaques, "Nenhum documento encontrado" da biblioteca, leitor de tela de verdade e painel)

Revisão do código de `fc742c0`, `0bd9025`, `e14e534`, `9ca8252` e `c40cfd5` e do app real: build release servido localmente e `flutter run -d web-server` (debug), num Chrome headless controlado por CDP. Para comparar os esqueletos, o código de antes da spec (`fc742c0~1`) foi compilado e aberto lado a lado. Esqueletos vistos segurando as requisições do Firestore (`Fetch.enable`); erros com `firestore.googleapis.com` bloqueado e depois liberado.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | sem problemas |
| Conferência de formato do `CLAUDE.md` | 0 arquivos a formatar |
| `fvm flutter build web --release` | concluído sem erro |
| `flutter run -d web-server` (debug) em 390, 768 e 1280 | 404, 404 de área inválida, esqueletos (Home, categoria, post, pessoa, lista e documento da biblioteca, menu de categorias) e caixas de erro (categoria e Equipe), sem `overflow`, exceção nem asserção no console |
| Busca por cor, fonte e espaço soltos, `num_extension`, `GestureDetector`, rota solta e comentário fora das regras no código novo | nenhuma ocorrência |
| `git diff fc742c0~1..HEAD --stat` | só `skeleton.dart`, `state_message_box.dart`, `state_error_inline.dart` (novo), `highlights_section.dart`, `team_section.dart`, `page_not_found.dart`, tokens do tema, os dois componentes removidos e docs; rotas, `AppRoutes`, modelos, `pubspec.yaml`, painel e Geoensine sem diff |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | 404 em endereço desconhecido | passou | `/nao-existe`: navbar, caixa com "404" em `accent` (4,9:1 no branco), `h1` "Não encontramos esta página", texto e os dois botões; rodapé na base; navbar com `aria-current="false"` nos quatro itens; sem "HOME" nem cinza claro |
| 2 | Botões da 404 | passou | clique e Tab+Enter: "Ir para o início" leva a `/` e "Explorar a biblioteca" a `/biblioteca` |
| 3 | Mesma 404 em todos os casos | passou | `/publicacoes/xyz/abc`, categoria e post inexistentes, `/biblioteca/xyz`, documento inexistente, `/membro/inexistente` e membro sem descrição (`/membro/1790900804195`, descrição vazia no ambiente de testes) com o mesmo `h1`; membro com descrição continua abrindo a página dele; endereço de 1.760 caracteres com `ç`, `<`, `"` e `%` mostra a 404 sem rolagem horizontal |
| 4 | 404 responsiva, release e debug | passou | 390: margens de 20, botões empilhados e centralizados, "404" menor; 768: margens de 32, botões lado a lado; 1280: caixa em 1120 px; `scrollWidth` igual à janela; debug sem asserção |
| 5 | Acessibilidade da 404 | passou | árvore semântica lê "404" antes do `h1`; Tab: Sobre, História, Geografia, Biblioteca → "Ir para o início" → "Explorar a biblioteca" → rodapé, com anel de foco visível; contraste do texto 7:1 e do título 16:1 |
| 6 | Brilho e movimento reduzido | passou | quadros a 350 ms de distância diferem em todas as telas com esqueleto (Home, menu de categorias, categoria, `/publicacoes`, post, pessoa, biblioteca, lista e documento); com `prefers-reduced-motion: reduce`, quadros idênticos e cor única; cores `skeletonBase`/`skeletonHighlight` do tema, iguais às do protótipo |
| 7 | Formas dos esqueletos | passou | comparação lado a lado com o build anterior em 390, 768 e 1280: mesmos blocos, tamanhos e posições em todas as telas acima, inclusive Destaques e Equipe na Home e o menu de categorias (navbar e menu do celular); sem `overflow` em debug |
| 8 | Erro discreto da Home | passou com ressalva | Equipe com o Firestore bloqueado: faixa "Não foi possível carregar a equipe." e "Tentar de novo" em 390 e 1280, igual à de antes; com a rede liberada, "Tentar de novo" volta ao esqueleto e mostra a equipe. Destaques usam a mesma `StateErrorInline` (código), mas não foi possível provocar o erro: com o Firestore bloqueado o cache devolve lista vazia e a seção some, como antes |
| 9 | Caixas de erro, vazio e sem resultados | passou com ressalva | erro com os textos de sempre em categoria, `/publicacoes`, post, pessoa e lista da biblioteca (390 e 1280); "Tentar de novo" com a rede liberada volta ao esqueleto e carrega o conteúdo; seis cliques seguidos com a rede bloqueada e três com ela liberada terminam no conteúdo, sem exceção. Sem resultados de busca na categoria e em `/publicacoes` com "Nenhuma publicação encontrada" e "Limpar busca", que limpa; área sem documentos com "Ainda não há documentos em História". "Nenhum documento encontrado" não conferido no app (sem documentos no ambiente) |
| 10 | Componentes antigos e círculo girando | passou | `EmptyContent` e `PageErrorContent` removidos, sem referência; círculos girando só no vídeo da Home (fora do escopo) e na lista da biblioteca do painel |
| 11 | Rotas, modelos, painel e Geoensine | passou | sem diff (painel não aberto) |
| 12 | Tokens, analyze e build | passou | só tokens de `AppTheme`; sem `num_extension`, `GestureDetector` nem rota solta; nenhum pacote novo; analyze e build sem erro |

## Problemas encontrados
- Nenhum que peça correção.

## Não conferido
- Erro dos Destaques no app: o Firestore offline devolve lista vazia do cache e a seção some (comportamento anterior à spec). A peça é a mesma da Equipe, conferida.
- "Nenhum documento encontrado" e "Limpar filtros" na lista da biblioteca: o ambiente de testes não tem documentos. Os textos estão no código sem mudança.
- Anúncio por leitor de tela de verdade (árvore semântica conferida, comportamento não).
- Painel: sem credenciais de teste; sem diff.
