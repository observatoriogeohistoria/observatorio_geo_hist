# Tarefas da 034. Páginas pré-geradas para o Google

Legenda: `- [ ]` a fazer, `- [x]` feita. Critérios citados são os da [spec](spec.md), na ordem em que aparecem.

## Grupo A: base testável
- [x] **A1.** Escape de HTML e XML e caminho seguro. Arquivos: `tool/seo/escape.dart`, `tool/seo/site_writer.dart` (só a validação), `tool/seo/escape_test.dart`. Atende: testes (escape, caminho). Feito: `fileForRoute` aceita `A-Za-z0-9_-`; `SeoException` ficou em `seo_exception.dart`.
- [x] **A2.** JSON-LD com `<`, `>`, `&`, ` `/` `; teste que relê o JSON e confere o texto original, e que `</script>` no título não aparece cru. Arquivos: `tool/seo/json_ld.dart`, `tool/seo/json_ld_test.dart`. Atende: testes (JSON-LD).
- [x] **A3.** Sitemap com escape de XML e `lastmod` opcional. Arquivos: `tool/seo/sitemap.dart`, `tool/seo/sitemap_test.dart`. Atende: `lastmod`, testes (sitemap). Feito: recebe entradas (`SitemapEntry`) em vez de páginas.

## Grupo B: leitura do Firestore
- [x] **B1.** Cliente REST: listagem com `pageToken`, `runQuery` com cursor por nome, 3 tentativas com espera, decodificação dos valores tipados em JSON simples, `SeoException`. Arquivos: `tool/seo/firestore_rest.dart`, `tool/seo/firestore_rest_test.dart` (com `getJson` falso). Atende: falhas (rede após 3 tentativas), testes.
- [x] **B2.** Leitor do catálogo: categorias, posts por categoria (`isPublished == true`, `key` = id do documento), biblioteca inteira, equipe; falha em zero categorias, zero posts ou zero documentos e em modelo que não converte (id na mensagem). Arquivos: `tool/seo/catalog_reader.dart`, `tool/seo/catalog_reader_test.dart`. Atende: contagens, falhas (coleção vazia).

## Grupo C: rotas do app
- [x] **C1.** `AppRoutes`: `pageSegment`, `categoryPagePattern`, `libraryAreaPagePattern` e funções `categoryPage(area, category, n)` e `libraryAreaPage(area, n)`; `app_router.dart` redireciona para o endereço base (N inválido também). Arquivos: `lib/app/core/routes/app_routes.dart`, `lib/app/router/app_router.dart`. Atende: abrir uma página gerada carrega o app. Conferir: `/publicacoes/historia/<categoria>/pagina/2` cai na categoria; rotas de post e documento intactas.

## Grupo D: páginas
- [x] **D1.** Montar as páginas: fixas (com as metas de `RouteMeta`), categorias e áreas da biblioteca em páginas de 50 (prev/next, canonical próprio), posts com `areas.first` (sem área: fora e avisado), documentos, membros com página. Arquivos: `tool/seo/site_pages.dart`, `tool/seo/site_pages_test.dart`. Atende: canonical de post, paginação (120 → 3 páginas, sem repetição), borda de 0, 50 e 51 itens, contagens.
- [x] **D2.** Aplicar a página ao molde (`index.html`): trocar título, descrição, canonical, `og:*`, `twitter:*`; acrescentar JSON-LD, `noindex` no dev e bloco oculto (fora da tela, `aria-hidden`, sem foco, removido do DOM quando o app abre); falhar se faltar tag. Arquivos: `tool/seo/html_page.dart`, `tool/seo/html_page_test.dart`. Atende: metas por página, `noindex` no dev, falha por tag ausente.
- [x] **D3.** Gravação: recusa caminho fora do padrão e arquivo existente (exceto `index.html` da home), sitemap só em produção com `lastmod` (posts `updatedAt`, documentos `createdAt`, listagem = data mais nova). Arquivos: `tool/seo/site_writer.dart`, `tool/seo/site_writer_test.dart`. Atende: prod gera sitemap, dev não, sem sobrescrever, `lastmod`.
- [x] **D4.** Ponto de entrada e resumo (páginas por tipo, posts ignorados, sitemap). Arquivos: `tool/seo/generate_seo.dart`. Atende: critérios 1 e 2 (rodar de verdade no dev na tarefa F1).

## Grupo E: servidor
- [x] **E1.** `web/.htaccess`: `DirectorySlash Off`, `/x/` → 301 `/x`, `/x` por `x.html`, `Options -Indexes`. Arquivos: `web/.htaccess`. Atende: critério do Apache (parte das regras).
- [x] **E2.** Script de teste com Apache local (`LoadModule` de rewrite, headers, dir, autoindex, deflate se existir; porta alta; cópia do `build/web` gerado) que confere: `/contato` 200 do `contato.html`, `/contato/` 301 → `/contato`, categoria 200, rota sem arquivo 200 do `index.html`, `/assets` e `/assets/` sem listagem, `http` e `www` até o endereço final. Variante com senha para o dev (401 sem login). Arquivos: `tool/seo/check_htaccess.sh`. Atende: critérios do Apache e da senha do dev.

## Grupo F: execução real
- [x] **F1.** Build de dev, gerar com `APP_ENV=dev`, conferir contagem contra o Firestore do dev e `noindex`; gerar com `APP_ENV=prod` em cópia de `build/web` (só leitura no Firestore) para ver as contagens reais (602 documentos) e o sitemap. Rodar `check_htaccess.sh` sobre o resultado. Atende: critérios 1 a 5, 9 e 10. Feito: prod 1.083 páginas (443 posts conferidos por consulta independente, 602 documentos); dev 71.
- [x] **F2.** Abrir uma página gerada no Chrome (390, 768 e 1280 px): o app carrega, sem texto duplicado, sem erro no console, bloco oculto fora da árvore de acessibilidade. Atende: critério de abrir no navegador e acessibilidade.

## Grupo G: CI e docs
- [x] **G1.** `ci.yml`: filtro passa a tratar `tool/seo/` como mudança que roda a validação e acrescentar `flutter test tool/seo`. Arquivos: `.github/workflows/ci.yml`. Atende: testes rodam no CI.
- [x] **G2.** `docs/deployment.md`: seção "Reavaliação do prerender" com gatilho, saídas em ordem, estimativa e como rodar o gerador e o teste do Apache. Arquivos: `docs/deployment.md`. Atende: critério de documentação.
- [x] **G3.** Fechamento: `fvm dart format` nos `.dart` alterados, `dart analyze lib` por link simbólico sem acento, `flutter test tool/seo`. Atende: critério de analyze e format.
