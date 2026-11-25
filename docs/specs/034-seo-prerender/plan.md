# Plano da 034. Páginas pré-geradas para o Google

- **Spec:** [spec.md](spec.md)
- **Criado em:** 2026-11-24

## Abordagem
Um gerador em `tool/seo/`, executado como `flutter test` (os modelos importam o Flutter), roda depois do `flutter build web`. Ele lê o Firestore pela API REST pública, converte os valores tipados da REST (`stringValue`, `arrayValue`…) em JSON simples e entrega esse JSON aos `fromJson` dos modelos do app. Assim o texto e as metas saem do mesmo código que o app usa (`RouteMeta`, `plainTextFromRich`), sem segunda cópia das regras.

O gerador monta uma lista de páginas (rota, meta, texto, links, JSON-LD) e a grava sobre o `build/web/index.html` como molde: troca as tags de meta, acrescenta o JSON-LD no `head` e o bloco de texto oculto no início do `body`. Gravação recusa caminho fora do padrão e arquivo já existente. O sitemap sai só em produção.

No servidor, três regras novas no `web/.htaccess` fazem `/x` ser servido por `x.html`. No app, uma rota nova leva `…/pagina/N` ao endereço base (quem abre uma página gerada pelo navegador cai no app, que precisa conhecer o endereço).

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Criar | `tool/seo/generate_seo.dart` | Ponto de entrada (`flutter test`); escolhe o ambiente, lê, monta, grava e imprime o resumo |
| Criar | `tool/seo/firestore_rest.dart` | Cliente REST: listagem com paginação, `runQuery`, tentativas, decodificação dos valores; `SeoException` |
| Criar | `tool/seo/catalog_reader.dart` | Lê categorias, posts (por categoria), biblioteca e equipe e devolve modelos; falha em coleção vazia |
| Criar | `tool/seo/site_pages.dart` | Monta as páginas (fixas, categorias e áreas paginadas, posts, documentos, membros) |
| Criar | `tool/seo/html_page.dart` | Aplica uma página ao molde; bloco oculto |
| Criar | `tool/seo/escape.dart` | `escapeHtml`, `escapeXml` |
| Criar | `tool/seo/json_ld.dart` | JSON-LD por tipo de página, com `<` como `<` |
| Criar | `tool/seo/sitemap.dart` | `sitemap.xml` |
| Criar | `tool/seo/site_writer.dart` | Validação do caminho, recusa de sobrescrita, gravação |
| Criar | `tool/seo/*_test.dart` | Testes de escape, JSON-LD, sitemap, caminho, gravação, REST, paginação, falhas |
| Criar | `tool/seo/check_htaccess.sh` | Sobe um Apache local sobre o `build/web` gerado e confere as respostas |
| Alterar | `lib/app/core/routes/app_routes.dart` | `pageSegment`, padrões `…/pagina/:page` e funções que montam esses endereços |
| Alterar | `lib/app/router/app_router.dart` | Redireciona `…/pagina/N` para a categoria ou área |
| Alterar | `web/.htaccess` | `DirectorySlash Off`, `/x/` → `/x`, `/x` por `x.html`, `Options -Indexes` |
| Alterar | `.github/workflows/ci.yml` | Passo de testes do gerador; `tool/seo/` passa a contar como mudança que roda a validação |
| Alterar | `docs/deployment.md` | Seção de reavaliação (gatilho e saídas) |

## Decisões técnicas
- **Posts por categoria com `runQuery`:** `parent` = `posts/{categoryId}`, coleção `category_posts`, filtro `isPublished == true`. Sem `orderBy` na consulta (igualdade mais outra ordenação pediria índice composto): pagina por cursor no nome do documento (`__name__`) e ordena na memória por `createdAt` decrescente, como o app. O collection group deu 404 na REST.
- **Biblioteca e equipe:** listagem comum da REST com `pageSize=300` e `pageToken`. A biblioteca é lida inteira; `status` é ignorado (o campo pode existir nos documentos antigos, `null` no dev).
- **Chave da categoria:** o id do documento em `posts/{id}`; o gerador o injeta como `key` antes do `fromJson`.
- **Rota "página N":** `/…/pagina/N` com N ≥ 2. Alternativas: query (`?pagina=2`, não distingue arquivo estático) e número solto (`/2`, pode colidir com id de post). A página 1 é o endereço base; `/pagina/1` não é gerada.
- **Texto do bloco oculto:** título, resumo/descrição da `RouteMeta` e, no artigo, o texto completo em `plainTextFromRich`. Demais tipos usam os campos de texto do corpo. Escondido com a técnica de "somente leitura para buscador" (fora da tela e `aria-hidden`), nunca `display: none`, e sem foco por teclado. Sai do DOM quando o app abre, para não duplicar texto no leitor de tela.
- **`lastmod`:** a spec manda usar `updatedAt`. O Firestore só tem `updatedAt` em **posts**; documentos da biblioteca têm só `createdAt` (confirmado no dev). Plano: posts usam `updatedAt` (sem ele, nada); documentos usam `createdAt`; listagens usam a data mais nova da página. A spec foi ajustada para isso.
- **Ambiente e origem:** `APP_ENV` pelo `AppEnvironment.current`; projeto e `apiKey` vêm dos `firebase_options_*`. Origem de dev: `https://dev.observatoriogeohistoria.net.br`.
- **Teste do Apache:** o `httpd` do macOS (2.4) tem `mod_rewrite.so` em `/usr/libexec/apache2`, mas não o carrega por padrão; o script monta um `httpd.conf` temporário com `LoadModule` e `AllowOverride All`, aponta para uma cópia do `build/web` e usa porta alta.
- **`.htaccess`:** a regra de `/x/` fica depois das de `www` e `https` (a combinação `www` + barra final tem dois saltos, aceito: os endereços do sitemap nunca têm barra final). A regra de `x.html` fica antes da que manda tudo para `index.html`. `Options -Indexes` fecha a listagem de pastas.

## Dependências e geração de código
Sem pacotes novos nem `build_runner`. Rota nova em `app_router.dart`. O gerador usa `dart:io` e `dart:convert`; `http` do pacote só se já estiver no `pubspec.yaml` (senão, `HttpClient` de `dart:io`, com `HttpOverrides.global = null`, porque o `flutter test` bloqueia rede).

## Riscos e cuidados
- **Regra do Firestore:** a consulta pública de posts só passa com `isPublished == true` (já é o filtro). Qualquer 403 vira falha.
- **Modelos que quebram com dados reais:** `fromJson` lança em campo faltando. Decisão: um post ou documento que não converte **interrompe** a geração, com o id na mensagem (falha fechada), em vez de sumir do sitemap em silêncio. Conferir no dev e na produção na primeira execução.
- **`.htaccess` é enviado a cada deploy:** erro nele derruba o site inteiro. O teste local com Apache é obrigatório antes do PR; `AllowOverride Options` na HostGator é a hipótese a validar no dev (se `Options -Indexes` der 500, tirar essa linha e confiar no `DirectoryIndex`).
- **Apache x HostGator:** o teste local não prova o servidor real; a etapa 5 confere no dev.
- **Arquivos e inodes:** 1.100 a 1.300 por ambiente, dentro da estimativa; o resumo imprime a contagem.
- **App:** a rota nova não altera as existentes; conferir `/publicacoes/historia/<categoria>`, post e documento depois.

## Como conferir
- `fvm flutter analyze` (via link simbólico sem acento) e `fvm dart format` nos `.dart` alterados.
- `fvm flutter test tool/seo` (testes do gerador).
- `fvm flutter build web --release --dart-define=APP_ENV=dev` e `fvm flutter test tool/seo/generate_seo.dart --dart-define=APP_ENV=dev`; conferir a contagem contra o Firestore do dev.
- `tool/seo/check_htaccess.sh` (Apache local).
- `fvm flutter run -d chrome`: abrir `/publicacoes/historia/<categoria>/pagina/2` e ver que cai na categoria, em 390, 768 e 1280 px.
