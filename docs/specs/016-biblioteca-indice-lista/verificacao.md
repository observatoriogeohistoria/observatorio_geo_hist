# Verificação da 016. Biblioteca: entrada por área e lista com filtros

- **Data:** 2026-10-02
- **Resultado:** aprovada com ressalvas (índices da busca com filtro a publicar; pontos não conferidos no app)

Revisão do código de `9fbe997..fce5f9c` e do app real: build `APP_ENV=prod` só leitura servido localmente num Chrome sem janela controlado por CDP (o navegador embutido não pinta com o painel escondido e perdia cliques), e `flutter run -d web-server` em debug com `APP_ENV=prod`. Nada foi escrito no banco.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | sem problemas |
| Conferência de formato do `CLAUDE.md` (cópia ASCII) | 0 arquivos a formatar |
| `fvm flutter build web --release` (com e sem `APP_ENV=prod`) | concluído sem erro |
| `flutter run -d web-server` (debug) em 390, 768 e 1280 | entrada, Geografia, História, painel de categorias aberto, Manifesto, `/publicacoes` e uma categoria sem exceção, `overflow` nem asserção |
| Busca por cor, fonte e espaço soltos, `num_extension`, `GestureDetector`, rota solta e menção a spec/protótipo nos arquivos novos | nenhuma ocorrência |
| `git diff 9fbe997..HEAD` nos arquivos do painel (`library_list_page.dart`, `filters.dart`, `library_document_card.dart`, diálogo, `library_store.dart`, `filter_documents_store.dart`, `_fetchDocuments`, `_applyFilters`, `LibraryDocumentsQuery`) | sem diff |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Entrada com navbar, cabeçalho, dois cartões e rodapé, sem foto, artigos e parceiros | passou | `library_page.dart`; tela em 390, 768 e 1280 |
| 2 | Cartão com ícone, título, descrição, números, "Explorar", link, foco e hover | passou | 218 dissertações · 68 teses (Geografia) e 247 · 69 (História), iguais ao total da lista; hover sem subida com movimento reduzido (`disableAnimationsOf`). O título não é anunciado como `h2` (ver ressalvas) |
| 3 | Lista com navbar, cabeçalho e migalhas, sem `AppBar` | passou | `library_area_page.dart`; "Biblioteca" leva a `/biblioteca` |
| 4 | Busca com "Buscar em", ajuda por campo, pausa e Enter, minúsculas, "Limpar", troca de campo | passou | "o lugar" → 3 documentos para “o lugar”; `_adjustCase` e `setSearchField` no store |
| 5 | Tipo com "Tipo: todos", "Tese (68)", "Dissertação (218)", filtra na hora | passou | tela; chip "Tipo: Tese" |
| 6 | Ano só números, 4 dígitos ou vazio | passou | `LibraryYearField` (formatadores e `_handleChanged`); no código, remover o chip limpa o campo (`didUpdateWidget`) |
| 7 | Painel de categorias | passou | ordem alfabética com quantidades, seleção múltipla (Avaliação + Conceitos = 44), selo "2", Esc devolve o foco ao botão, Tab sai; no celular abre acima do botão, na largura da tela menos as margens |
| 8 | Chips e "Limpar tudo" | passou | tela; "×" com nome "Remover filtro …" |
| 9 | Contagem do filtro, com termo, anunciada | passou | "286 documentos", "5 documentos", `liveRegion` |
| 10 | Linha do documento | passou | 3 linhas, detalhes sem vazios, 2 etiquetas e "+1", selo e seta, hover; abre o detalhe por clique (tela) e Enter (`InkWell` com foco) |
| 11 | Paginação de 20 com "Ver mais documentos" | passou | "Carregando…" desativado com as linhas no lugar; `limit + 1` no datasource |
| 12 | Esqueletos | passou | barras na entrada e 5 linhas na lista, rótulo "Carregando" |
| 13 | Vazio | passou em parte | "Nenhum documento encontrado" e "Limpar filtros" no código (`noResults`); área sem documentos não conferida no app |
| 14 | Erros | passou | busca + tipo cai na caixa de erro com "Tentar de novo" (índice faltando); falhas de contagem e de "Ver mais" pelo código (`toNullable`, `loadMoreFailed`) e pelo teste com falha injetada da implementação |
| 15 | Painel sem mudança | passou no código | rota do painel continua em `LibraryListPage`; arquivos do painel sem diff; app não conferido (sem credenciais de teste) |
| 16 | Contraste, ordem de Tab, nomes e estados | passou | textos em `inkSecondary`/`accentStrong`; Tab: busca → Limpar → Tipo → Ano → Categoria → chips → Limpar tudo; menus com `expanded`, valor e "N selecionadas" |
| 17 | 390, 768 e 1280 sem rolagem horizontal nem `overflow` | passou | `scrollWidth` 390 no celular; release e debug |
| 18 | Tokens, `AppRoutes`, índices documentados, analyze e build | passou | tokens novos em `app_dimensions`, `app_text_styles` e `app_colors`; índices em `docs/deploy-ambientes.md` |

## Problemas encontrados
- **Clique fora do menu abria o documento embaixo** (ajuste, corrigido em `6e223a8`). Com Tipo, "Buscar em" ou Categoria abertos, clicar numa linha para fechar o menu também abria aquele documento. Os dois `MenuAnchor` passaram a consumir o clique de fora (`consumeOutsideTap`). Conferido em debug: o clique fecha o menu e a página continua na lista.
- **Texto da arquitetura** (detalhe, corrigido no commit da verificação): dizia que o site não usa mais o `LibraryStore`, mas o detalhe do documento ainda usa.
- **Separador dos números** (detalhe, sem mudança): a spec escreve "66 dissertações · 62 teses", o protótipo e a tela separam por espaço, sem ponto.

## Ressalvas
- **Índices da busca com filtro:** busca junto com tipo, ano ou categoria cai no erro tratado até a pessoa publicar os índices compostos listados em `docs/deploy-ambientes.md`, nos dois projetos.
- **Título do cartão de área não é `h2` para leitores de tela:** o cartão é lido como um link só ("Geografia, 218 dissertações, 68 teses, Explorar Geografia"), como o card de post; um link com rótulo próprio esconde o cabeçalho de dentro. Decisão da implementação, mantida.
- **Limitações dos dados de prod** (fora do escopo): parte dos registros está toda em maiúsculas (título e autor), e a busca com inicial maiúscula não os encontra; ao menos um documento de Geografia tem o resumo gravado como slug e o detalhe dele mostra "Erro ao carregar a página" (detalhe da 017 e ajuste do painel).

## Não conferido
- Área sem documentos e documento sem slug: não existem em prod; conferidos só no código.
- Painel administrativo no app: sem credenciais de teste (código sem diff).
