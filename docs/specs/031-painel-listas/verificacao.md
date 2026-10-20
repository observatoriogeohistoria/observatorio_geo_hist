# Verificação da 031. Listas do painel em linhas, mídias em grade e filtros em linha

- **Data:** 2026-10-19
- **Resultado:** aprovada com ressalvas (não conferidos: painel real com o Firebase e leitor de tela de verdade)

Revisão feita sobre o código dos commits `014add5`, `547b3a3`, `c1bd8da`, `ba5f2a0` e `6ab7c61`, não só sobre o `tasks.md`. A verificação começou numa sessão que parou no meio e deixou correções sem commit (dica da busca da biblioteca e comentários); foram conferidas e mantidas. Telas abertas num Chrome headless, no build de release do site e num app de teste fora do repositório que monta a `PanelPage` com repositórios falsos (vazio, um item, 65 publicações paginadas, falha ao abrir e ao carregar mais, papel `viewer`, imagens ausentes e quebradas, textos longos).

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia ASCII) | sem problemas no projeto (só um aviso no app de teste, que não é commitado) |
| `dart format --set-exit-if-changed` no projeto inteiro | 339 arquivos, nenhum alterado |
| `fvm flutter build web --release` (site e app de teste) | concluído sem erro |
| `fvm flutter run -d web-server` (debug, app de teste) | seis seções, troca de área, rolagem e 1280 → 768 → 390 sem `overflow` nem asserção no console |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Seis seções como a aba "Painel" em 390, 768 e 1280, sem `overflow` nem rolagem horizontal | passou | `scrollWidth` igual à largura nas 18 combinações; linhas, selos, barra de filtros e grade batem com as regras `.row`, `.status`, `.adm-tools` e `.media-grid` do protótipo |
| 2 | Publicações em linhas com miniatura 16:10, meta, selos e quatro ações; placeholder sem imagem ou com falha | passou | `post_row.dart`; na tela, miniatura ausente e quebrada mostram o ícone em `accentSoft`; título longo em duas linhas com reticências |
| 3 | Filtros de publicações combinam; categoria depende da área; "Limpar filtros" zera todos | passou | Publicadas + Destaques + Geografia filtrou certo; a lista de categorias perdeu a de História; "Limpar filtros" no vazio voltou busca, área, situação e Destaques ao início |
| 4 | Categorias com ícone da área, contagem, selo de colaboração, busca e área | passou | globo, ampulheta e camadas; "N publicações"; "Aceita colaboração"; Excluir indisponível com publicações |
| 5 | Biblioteca na moldura, segmentado muda o endereço, busca, tipo, categorias, "Mais filtros" e "Carregar mais" | passou | História → `/admin/painel/biblioteca/historia`; "Mais filtros" abre Autor, Instituição e Ano; "Carregar mais" no rodapé |
| 6 | Mídias em grade, com busca e carregamento ao rolar | passou | 2 colunas em 390, 5 em 1280; as 40 imagens chegaram rolando |
| 7 | Equipe com "Com página"/"Sem página"; Usuários com selo de papel | passou | foto, foto quebrada (iniciais) e sem foto; "Administração" em laranja, "Edição" e "Leitura" neutros, "Removido" |
| 8 | Esqueleto, vazio com criar, filtro sem resultado, erro com "Tentar de novo" | passou | esqueleto de 4 linhas; "Nada em Revistas ainda" com "Nova revista"; "Nada encontrado com esses filtros"; caixa de erro sem aviso flutuante; `falha=mais` deixa "Carregar mais" e o aviso |
| 9 | `VIEWER` vê as listas sem ações | passou | `papel=viewer`: sem coluna de ações e sem botão de criar |
| 10 | Publicar, destacar, editar e excluir como antes | passou no app de teste | publicar e destacar pelo teclado mudam selo e ícone e mostram o aviso; fluxo real com o Firebase não conferido |
| 11 | Teclado nos filtros e nas linhas, com foco visível | passou | Tab: criar → busca → área → categoria → segmentado → Destaques → ações da 1ª linha; foco continua no botão depois de publicar e destacar |
| 12 | Contraste ≥ 4,5:1 em meta, selos e ícones | passou | meta 7,0; selo neutro 6,5; Publicado 5,7; Destaque 6,1; Removido 5,6; excluir 6,5; estrela 4,9 |
| 13 | Sem cor, fonte ou espaçamento solto | passou | diff varrido: só acumuladores `0.0` de layout; novo token `searchFieldPaddingEndEmpty` |
| 14 | `analyze` sem erros novos | passou | ver Comandos |

## Pontos de atenção conferidos
- **Rotas:** `ba5f2a0` trocou `builder` por `pageBuilder` com a mesma chave de página; nenhum caminho mudou (`AppRoutes` intocado). Troca de seção pelo menu, de tipo, de área e o voltar do navegador atualizam a página no lugar.
- **`getPosts(reset:)`:** o `PostsStore` só é usado pelo painel; a listagem pública usa outro store. `/publicacoes` e `/publicacoes/historia/seed-ensino-de-historia` abriram normais.
- **Componentes do site:** Home, Biblioteca pública (`/biblioteca/geografia`) e listagem de categoria em 390 e 1280 sem mudança; o `SearchField` do site continua reservando o espaço do "Limpar".

## Problemas encontrados
- **Corrigido** (`19fd24a`): a dica "Buscar por título" da biblioteca do painel cortava a 768 px. A busca do painel passa a usar o espaço do "Limpar" enquanto está vazia (`SearchField.keepClearSpace`, ligado por padrão no site), como faz o protótipo. Junto, saíram comentários que só descreviam as peças da lista. Gravidade: ajuste.
- **Corrigido** (`195a636`): "Buscar pelo nome do arquivo" cortava em Mídias a 390 px; a mesma opção vale agora para todas as buscas do painel. Gravidade: ajuste.
- **Corrigido** (`2963a0f`): comentário da `PanelFilterBar` descrevia a caixa em vez do porquê. Gravidade: detalhe.

## Não conferido
- Painel real com o Firebase (consultas com filtros, publicar, excluir, salvar documento): não há credenciais de teste.
- Leitor de tela de verdade: só a árvore de semântica do navegador (segmentado como rádio, "Destaques" e destacar como chave, com o estado).
