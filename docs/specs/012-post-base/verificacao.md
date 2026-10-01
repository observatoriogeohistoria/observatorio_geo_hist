# Verificação da 012. Layout-base do post (tipo artigo) e seção Apoio

- **Data:** 2026-10-01
- **Resultado:** aprovada com ressalvas (após 1 correção)

Revisão do código dos commits `b24a7f2`, `8fff92f`, `5f3c395` e `1daf844`, com o app real (build servido localmente, navegador embutido). O Firebase dev só tem um post (pesquisa); artigos e os demais tipos foram conferidos num build `APP_ENV=prod`, só leitura. Capa ausente, capa com falha e delta de teste vieram de um build temporário com dados injetados (fora do repositório, não commitado). Onde a evidência veio da conferência da implementação (E2 em `tasks.md`), está indicado.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | sem problemas, antes e depois da correção |
| `fvm flutter build web --release` (`prod` e `dev`) | concluído sem erro, antes e depois da correção |
| `git diff 825d086..HEAD` de modelos, rotas, painel, regras e `pubspec.yaml` | só `app_router.dart` (área inválida → 404, sem mudar caminho) |
| Busca por `num_extension`, cor/tamanho solto, `GestureDetector`, `AppHeadline`, `AppTitle`, `AppDivider`, `PageErrorContent`, `LoadingContent` nos arquivos da spec | nenhuma ocorrência |
| Recursos do Firestore em 6 s na 404 (categoria e id inexistentes) | contagem parada (15 → 15; 10 → 10): sem laço |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Ordem da página do artigo | passou | Artigo real em 1280, 768 e 390: migalhas, `h1`, subtítulo, autoria, capa, texto, nota, Leia também, Apoio, rodapé |
| 2 | Migalhas (clique e Enter; área sem foco) | passou | Tab: Início → categoria → compartilhar (área pulada); clique na categoria abre `/publicacoes/geografia/…` |
| 3 | Autoria e data; sem tempo de leitura | passou | Um autor com "RB"; dois autores "Ivan Conterno e Gabriela Varão" sem círculo; "11/2024" → "novembro de 2024"; `formatMonthYear` devolve o texto fora do formato |
| 4 | Compartilhar: 4 opções, nome, dica, foco, posição | passou | `social_icons.dart` (nomes "Compartilhar no …", `Tooltip`, `AppFocusRing`); foco visível no Twitter e e-mail; à direita em 768/1280, abaixo em 390 |
| 5 | Capa 21:9; sem capa; com falha | passou | Tela; build injetado: `capa=sem` some capa e legenda, `capa=falha` placeholder 21:9 com legenda |
| 6 | Estilo do texto do editor | passou | Delta injetado: H2, negrito, itálico, cor e fundo ignorados, link laranja sublinhado, listas, citação com barra |
| 7 | Imagem embutida; embutido desconhecido | passou | Delta injetado: imagem quebrada vira placeholder; vídeo embutido ignorado sem erro |
| 8 | Nota só com observação | passou | "NOTA" em `accentStrong` com link; `ArticleNote` só com `!isEmpty` |
| 9 | Leia também | passou | 3 artigos da categoria, sem o atual; Enter no cartão abre o post; "Mais em Experiências Educativas" focável; escondido se vazio (`RelatedPostsSection`) |
| 10 | Trocar de post pelo Leia também; lista da categoria intacta | passou | Página trocou para "Árvore da Vida" no topo; `PostDetailStore` é fábrica e não toca o `FetchPostsStore`; categoria abriu normal |
| 11 | Apoio | passou | Lado a lado em 1280, empilhado em 768 e 390 (logos em 2 colunas); pílulas com nome |
| 12 | Esqueleto no acesso direto | passou | Tela em 1280 no acesso direto; `PostPageSkeleton` estático, `Semantics(label: 'Carregando')` |
| 13 | 404 sem carregar para sempre | passou | Área "fisica", categoria e id inexistentes → 404 estável. Post não publicado: código (`isPublished != true`) e conferência da implementação |
| 14 | Erro com "Tentar de novo" | passou | `_ErrorFrame` com `StateErrorBox(onRetry: _retry)`; falha injetada na implementação |
| 15 | Outros tipos | passou | Prod: evento, filme, podcast, música, documento, livro, revista; dev: pesquisa. Conteúdo atual + Apoio novo, console sem erros. Produção acadêmica não existe em nenhum banco |
| 16 | Contraste e ordem de Tab | passou com ressalva | Contraste pelos tokens (`inkSecondary` 7,0; `accentStrong` 6,8; `accent` 4,9). Tab passou após correção; links do texto sem foco (ressalva) |
| 17 | 390, 768, 1280 sem rolagem horizontal | passou | `scrollWidth` 390 = largura; título e migalhas quebram linha em 390 |
| 18 | Tokens, componentes antigos, ponto único, analyze e build | passou | Comandos acima; `PostTypeContent` descrito em `docs/arquitetura.md` |

## Problemas encontrados
- **Duas paradas de Tab invisíveis no texto** (ajuste, resolvido). Na web o `QuillEditor` cria um `KeyboardListener` com `FocusNode` próprio, que entra no Tab mesmo com o nó do editor em `skipTraversal`. Depois do compartilhar, o foco ia para o texto e para a nota sem contorno. Correção em `ReadingRichText`: `FocusTraversalGroup(descendantsAreTraversable: false)`. Conferido: compartilhar → "Mais em…" → cartões.

## Ressalvas
- **Links dentro do texto do artigo e da nota não recebem foco por teclado.** O Quill só leitura os desenha como trechos com reconhecedor de toque, sem nó de foco. Alternativa sem pacote novo seria desenhar o delta com widgets próprios (links como botões focáveis), o que reescreve o `ReadingRichText` (títulos, listas, citação, alinhamento): fora do porte de uma correção. Abrem pelo mouse e por leitor de tela. Pesa mais na nota, onde costuma estar o "Acesse aqui" do texto completo. Fica para quando o renderizador for revisto.
- O título do cartão em hover usa `accent` (4,9:1): atende o mínimo, com pouca folga.

## Não conferido
- Erro com a rede bloqueada no app real: o navegador embutido não bloqueia o Firestore; vale a conferência da implementação com falha injetada.
- Post não publicado na tela: as regras não deixam listar não publicados sem login; conferido pelo código e na implementação.
- Shift+Tab (a ferramenta envia Tab sem o Shift).
- Painel administrativo: não se aplica.
