# Verificação da 014. Listagem de categoria e card de post

- **Data:** 2026-10-02
- **Resultado:** aprovada (após 2 correções, em commits `fix:` próprios)

Revisão do código de `2776a36..003a65e` e do app real: build `APP_ENV=prod` só leitura, servido localmente, num Chromium sem janela controlado por CDP (o navegador embutido não pinta quadros com o painel escondido), e `flutter run -d web-server` em debug. Árvore de acessibilidade lida com a semântica do Flutter ligada; anúncios lidos do `flt-announcement-host`. Rede cortada com bloqueio de URL e modo offline do navegador. Nada foi escrito no banco.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | sem problemas, antes e depois das correções |
| Conferência de formato do `CLAUDE.md` (cópia ASCII) | 0 arquivos a formatar |
| `fvm flutter build web --release --dart-define=APP_ENV=prod` | concluído sem erro |
| `flutter run -d web-server` (debug) em 390, 768 e 1280 | categoria, busca, Manifesto, Nossa história, Pessoa, post e 404 sem `overflow` nem asserção |
| Busca por cor, fonte e espaço soltos, `num_extension` e `GestureDetector` nos arquivos alterados | nenhuma ocorrência |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Ordem da página, cabeçalho em superfície, sem imagem de fundo | passou | Leituras e Audiovisual em 1280/768/390; `h1` na árvore |
| 2 | Migalhas | passou | Navegação "Você está em": "Início" é link (Tab 6 com foco visível); área é texto sem foco; "Leituras, página atual" |
| 3 | "Colabore" só com a opção | passou | Aparece em Leituras (com opção), não em Audiovisual (sem); Tab 7 com foco visível |
| 4 | Busca | passou | "his" e "ens" filtram após a pausa; "Limpar" só com texto; `trim()` no store e no datasource |
| 5 | Chips | passou | "Todos 108", "Documentos 13"…; alternância mostra só o bloco (Livros); 390 quebra linha |
| 6 | Contagem anunciada | passou | "108 publicações"; anúncio "13 publicações para “ens”" no leitor |
| 7 | Blocos na ordem, plural e quantidade | passou | "Documentos · 13 publicações" como `h2` com a quantidade no nome |
| 8 | Paginação | passou | "Ver mais livros" → "Carregando…" desativado, cards ficam, +12 itens |
| 9 | Card | passou | 16:10 com recorte; placeholder com falha real de imagem (offline); detalhes de livro, filme ("Direção: … · ano"), artigo e documento conforme a tabela |
| 10 | Abrir, foco, nome, hover | passou | Tab chega ao card com anel visível e Enter abre o post; nome "título, Tipo, detalhes"; hover sobe e fica laranja. Movimento reduzido: conferido no código (`disableAnimations`) |
| 11 | "Leia também" com o mesmo card | passou | Post de Leituras: 2 artigos relacionados no card novo, sem resumo; `related_post_card.dart` apagado |
| 12 | Carregando anunciado | passou após correção | Esqueletos tinham o rótulo "Carregando" mas não eram anunciados; agora o anúncio sai ao buscar |
| 13 | Vazio | passou | "zzq" → "Nenhuma publicação encontrada", anunciado, com "Limpar busca". Categoria vazia: conferida na implementação com dados injetados |
| 14 | Erro | passou após correção | Rede cortada mostrava a 404; agora mostra a caixa de erro, e "Tentar de novo" carrega com a rede de volta. Erro na busca com a lista já aberta conferido. Erro no "Ver mais" e só na contagem: conferidos na implementação com falha injetada (offline real, o Firestore serviu os itens do cache) |
| 15 | Não encontrado | passou | `/publicacoes/xyz/abc` e `/publicacoes/historia/naoexiste` em debug: 404, sem erro no console |
| 16 | Contraste, Tab, chips | passou | Tokens: `inkSecondary` 7,0:1 (branco) e 6,5:1 (superfície), `accentStrong` 6,8:1, `error` 6,5:1, chip marcado 17:1. Tab: navbar → Início → Colabore → busca → chips → cards. Chips como `switch` com `checked` |
| 17 | Responsivo | passou | 1/2/3 colunas em 390/768/1280; `scrollWidth` = largura em 390; rodapé na base na caixa de erro |
| 18 | Tokens, sem componentes antigos, pronto para a 015 | passou | Buscas acima; `PostsListing` recebe store e `routeFor`; `PostsListingScope` sem categoria |

Regressão de `PageHeader` e `StateErrorBox`: o `PageHeader` só ganhou `action` opcional e o `StateErrorBox` monta pela `StateMessageBox` a mesma árvore, com os mesmos tokens. Manifesto, Nossa história, Pessoa da equipe e post conferidos em release e debug, iguais aos da 010–012; a caixa de erro do post apareceu com rede cortada, igual à da 011.

## Problemas encontrados
- **Sem conexão, categoria e post mostravam 404** (bloqueia, resolvido). Offline, o Firestore devolve o cache vazio sem erro: as categorias chegavam vazias e a página caía na 404; a busca da lista cairia em "Nenhuma publicação". Correção: consulta vazia vinda do cache vira `OfflineException` em `FetchCategoriesDatasource` e `FetchPostsDatasource`. Conferido: caixa de erro na categoria, no post e na busca; "Tentar de novo" recupera.
- **"Carregando" não era anunciado** (ajuste, resolvido). Faltava `liveRegion` nos esqueletos da grade e da página. Conferido pelo anúncio ao buscar.
- **Comentários que descreviam a classe** (detalhe, resolvido) em `PostsListing` e `PostCardSkeletonRow`.

## Não conferido
- Leitor de tela de verdade (VoiceOver/NVDA): conferidos a árvore de acessibilidade e os anúncios gerados pelo Flutter.
- Categoria sem publicações, erro só na contagem e erro no "Ver mais" com rede real: o banco não tem categoria vazia e o cache do Firestore atende o "Ver mais" offline; ficam as conferências com falha injetada da implementação.
