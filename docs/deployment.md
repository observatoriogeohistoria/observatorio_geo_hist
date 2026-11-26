# Deploy (dev e produção)

O site roda em dois ambientes na HostGator, publicados por GitHub Actions via FTP.

| Ambiente | Branch | Workflow | Endereço |
|---|---|---|---|
| Dev | `develop` | [deploy-dev.yml](../.github/workflows/deploy-dev.yml) | `dev.observatoriogeohistoria.net.br` |
| Produção | `main` | [deploy-prod.yml](../.github/workflows/deploy-prod.yml) | `observatoriogeohistoria.net.br` |

## Fluxo de branches

```
feature/*  ──PR──▶  develop  ──PR──▶  main
                  (deploy dev)      (deploy prod)
```

1. Trabalhe em `feature/*`, `fix/*` ou `refactor/*` saindo da `develop`.
2. PR para `develop`: o CI valida. Ao mergear, o dev é publicado.
3. Depois de testar no dev, PR `develop` → `main`. Ao mergear, produção é publicada.
4. Hotfix: `hotfix/*` saindo da `main`, PR para `main` e depois para a `develop`.

Nada vai para a `main` sem passar pela `develop`.

## Workflows

| Arquivo | Gatilho | O que faz |
|---|---|---|
| [ci.yml](../.github/workflows/ci.yml) | PR para `develop` ou `main` | `pub get`, conferência de formatação (`dart format`), `analyze`, testes do gerador (`flutter test tool/seo`) e `build web`. Não publica. |
| `deploy-dev.yml` | push na `develop` ou manual | Índices, build, `robots.txt` bloqueando indexação, remoção do Analytics, páginas pré-geradas (`noindex`) e suas conferências, senha no `.htaccess`, FTP para o dev e regras do Firestore. |
| `deploy-prod.yml` | push na `main` ou manual | Índices, build, páginas pré-geradas e `sitemap.xml` com suas conferências, conferência do `.htaccess`, FTP para produção e regras do Firestore e do Storage. |

Push que só mexe em arquivos fora do site (`docs/`, `*.md`, `.claude/`, `.vscode/`, `tool/web_icons/`, `tool/seed_dev/`, `ci.yml`, `analysis_options.yaml`) não dispara deploy (`paths-ignore`). `tool/seo/` dispara, porque muda o site publicado. Para publicar mesmo assim, use o deploy manual. O CI segue a mesma ideia: PR só com `docs/`, `*.md`, `.claude/`, `.vscode/`, `tool/web_icons/`, `tool/seed_dev/` ou `deploy-*.yml` não roda validação.

Comum aos três:

- Versão do Flutter lida do `.fvmrc` com `jq`.
- Só `build/web/` é enviado, em um único passo de FTP (`SamKirkland/FTP-Deploy-Action`, FTPS).
- `concurrency` por ambiente: dois deploys do mesmo ambiente não rodam juntos.
- Ações fixadas por SHA (com a versão em comentário) e `firebase-tools` em versão exata. Para atualizar, troque o SHA pelo da nova tag (`git ls-remote https://github.com/actions/checkout refs/tags/v4.4.0`).
- `permissions: contents: read` e checkout com `persist-credentials: false`, para o token do GitHub não ficar gravado em `.git/config`. Um deploy antigo que enviava a raiz do repositório publicou esse arquivo, com o token, no servidor.

## Secrets e Environments

Cada deploy usa um *Environment* do GitHub (`DEV` e `PROD`) com `FTP_HOST`, `FTP_USER` e `FTP_PASSWORD`. O ambiente `DEV` tem ainda a **variável** (não segredo) `HTPASSWD_PATH`: caminho absoluto do `.htpasswd` no servidor, fora da pasta pública. Sem ela o deploy de dev falha em vez de publicar aberto. Cada usuário FTP é restrito à pasta do próprio ambiente, então o dev não consegue sobrescrever produção. Em `PROD`, dá para exigir aprovação manual (*Required reviewers*) antes do deploy.

## Diferenças entre dev e produção

- **`APP_ENV`**: o build recebe `--dart-define=APP_ENV=dev|prod`, lido em [app_environment.dart](../lib/app/core/utils/environment/app_environment.dart). No dev, o app mostra a faixa de aviso de ambiente de testes.
- **Indexação**: o deploy de dev gera `robots.txt` com `Disallow: /`.
- **Senha**: só o dev tem. O workflow acrescenta ao `.htaccess` do build `AuthType`, `AuthName`, `AuthUserFile` (de `HTPASSWD_PATH`) e `Require valid-user`, mais `X-Robots-Tag: noindex, nofollow`. O `.htpasswd` fica no servidor, fora do repositório e da pasta pública; para trocar a senha ou os usuários, edite-o por lá.
- **`.htaccess`**: versionado em [web/.htaccess](../web/.htaccess), igual nos dois ambientes, e **enviado a cada deploy: substitui o do servidor**. Ele reescreve rotas desconhecidas para `index.html` (o app usa `usePathUrlStrategy`), redireciona `http` e `www` para `https://` sem `www` (301, um só salto), manda HSTS e cabeçalhos de segurança, bloqueia arquivos ocultos (`.git`, `.ftp-deploy-sync-state.json`; `.well-known` fica aberto), comprime texto e manda `Cache-Control: no-cache` em tudo. Guarde uma cópia do que está no servidor antes do primeiro deploy com ele.
  - **Não ponha nele** blocos gerados pelo cPanel (handler de PHP, *Privacidade de diretórios*): o próximo deploy os apagaria. O site é Flutter, sem PHP. A senha do dev entra só pelo workflow.
  - **Não ponha `<FilesMatch ...>` com `Require all granted`**: no dev liberaria JS, imagens e fontes sem senha (o workflow reprova o deploy se achar).
- **Cache**: os arquivos do Flutter mantêm o mesmo nome a cada build (`main.dart.js`, `assets/fonts/MaterialIcons-Regular.otf`...). Sem `Cache-Control`, o navegador reaproveita versões antigas, e aparecem, por exemplo, ícones sumidos. O `.htaccess` manda revalidar sempre (o servidor responde 304 quando nada mudou).
- **Firebase**: o `APP_ENV` escolhe o projeto (`observatorio-geo-hist-dev` no dev, `observatorio-geo-hist` em produção), então Firestore, Auth e Storage do dev são separados de produção. O dev não tem Storage habilitado (`AppEnvironment.hasStorage`): lá o painel não lista mídias e recusa enviar ou apagar arquivos de mídia e da biblioteca. Arquivos já gravados com URL de produção continuam abrindo, só para leitura.

## Índices do Firestore

Os índices compostos ficam em `firestore.indexes.json`, ligado no `firebase.json`, e são publicados pelos workflows de deploy (dev e produção) antes do site. O arquivo tem **todos** os índices do projeto: o deploy não apaga os que estiverem só no console, mas eles ficariam fora do controle do repositório. Ao criar um índice pelo console, exporte de novo (`firebase firestore:indexes --project observatorio-geo-hist > firestore.indexes.json`).

**Segredo `FIREBASE_SERVICE_ACCOUNT`** (nos ambientes `DEV` e `PROD` do GitHub): JSON de uma conta de serviço do projeto correspondente com os papéis *Cloud Datastore Index Admin*, *Firebase Rules Admin* e *Service Usage Consumer*. Sem ele, o deploy para no passo dos índices e o site não é publicado.

Para publicar à mão:

```sh
firebase deploy --only firestore:indexes --project observatorio-geo-hist-dev
```

Índices que o site novo exige:

| Uso | Escopo | Campos |
|---|---|---|
| Busca em `/publicacoes` | Grupo de coleções `category_posts` | `isPublished` ↑, `type` ↑, `body.title_lower` ↑ |
| Busca na biblioteca | Coleção `library` | `category` (matriz, se marcada), `area` ↑, `type` ↑ e `year` ↑ (os marcados), `createdAt` ↓, campo buscado (`title_lower`, `author_lower` ou `institution_lower`) ↓. Um índice por combinação: 24 ao todo |

Sem eles, a página abre, mas a busca mostra "Não foi possível carregar". O índice fica pronto alguns minutos depois do deploy (status em *Firestore › Índices*).

**Campos de busca da biblioteca:** a busca compara o termo em minúsculas com `title_lower`, `author_lower` e `institution_lower`. O painel grava esses campos ao salvar; os documentos antigos já foram preenchidos em produção por um script avulso, removido depois do uso (está no git, em `tool/library_search_fields`).

## Operação

- **Deploy manual**: rode o workflow em *Actions* (`workflow_dispatch`), escolhendo a branch ou o commit.
- **Rollback**: reverta o commit na `main` ou rode o workflow de um commit anterior.
- **Falha no FTP**: reexecute o workflow. O deploy é idempotente.

## Regras de segurança

[firestore.rules](../firestore.rules) e [storage.rules](../storage.rules) ficam no repositório e são publicadas pelos workflows **depois** do FTP: as regras negam a busca de post do build anterior, que não filtrava `isPublished`, então publicar antes quebraria a página de post durante o envio. O dev publica só as do Firestore (não tem Storage). O que cada papel pode fazer está em [admin-panel.md](admin-panel.md).

Para publicar à mão:

```sh
firebase deploy --only firestore:rules --project observatorio-geo-hist-dev
firebase deploy --only firestore:rules,storage --project observatorio-geo-hist
```

Regra publicada pelo console é sobrescrita no próximo deploy: mude sempre o arquivo.

## Páginas pré-geradas (prerender)

O app é uma página só, então o Google não veria o texto de cada rota sem executar o Flutter. Depois do build, o gerador (`tool/seo/`) lê o Firestore pela API REST pública e grava um HTML por rota ao lado do `index.html` (`/contato` vira `contato.html`; `/publicacoes/historia/12/abc` vira `publicacoes/historia/12/abc.html`). Cada página tem título, descrição, canonical, Open Graph, JSON-LD e um bloco de texto fora da tela, que o app remove no primeiro quadro. As regras do `.htaccess` servem `/x` por `x.html`.

```sh
fvm flutter build web --release --dart-define=APP_ENV=prod
fvm flutter test tool/seo/generate_seo.dart --dart-define=APP_ENV=prod   # dev: APP_ENV=dev
fvm flutter test tool/seo                                                # testes do gerador
tool/seo/check_htaccess.sh prod                                          # Apache local sobre build/web
```

- **Produção:** páginas sem `noindex` e `sitemap.xml`. **Dev:** `noindex, nofollow` em cada página e sem sitemap.
- **Falha fechada:** erro de leitura do Firestore (3 tentativas), coleção vazia, post ou documento que não converte, tag ausente no `index.html` ou arquivo do build que seria sobrescrito interrompem o comando. Rode de novo só sobre um build novo (`rm -rf build/web` antes de `flutter build web`).
- **Listagens:** categorias e áreas da biblioteca saem em páginas de 50 itens (`/pagina/2`, `/pagina/3`…). No app, esses endereços levam à listagem normal.
- **`lastmod` do sitemap:** `updatedAt` nos posts e `createdAt` nos documentos da biblioteca (que não têm `updatedAt`). Páginas sem data ficam sem `lastmod`.
- **Tamanho (produção, 2026-11-24):** 1.083 páginas (443 posts, 602 documentos, 25 listagens, 6 membros, 7 fixas), em cerca de 10 s. A conta da HostGator tinha 58.558 inodes em uso, sem limite.
- **Primeiro deploy de produção com o gerador (2026-11-25):** 1.206 arquivos locais contra 92 no servidor; gerar as páginas levou 12 s e o envio por FTP, 15 min 23 s (22,7 kB/s, quase tudo é custo por arquivo), 18 min 16 s no total. Os inodes foram de 58.558 para 59.763 (+1.205, sem limite no plano).
- **Só o primeiro é lento:** o `FTP-Deploy-Action` guarda o hash de cada arquivo em `.ftp-deploy-sync-state.json` no servidor e, nos deploys seguintes, envia só o que mudou, novo ou apagado. As páginas não têm data nem nada que varie, então uma página só é reenviada quando o conteúdo muda. Os deploys normais mexem em `main.dart.js` e poucos arquivos mais, e em um deploy sem commit de conteúdo só entram as páginas editadas no Firestore desde o último. O estado é por servidor: se o arquivo sumir, o próximo deploy volta a enviar tudo.

### No deploy

Os dois deploys têm um passo **Gerar páginas** depois do build e antes do FTP. Se ele ou uma conferência falhar, o deploy para ali e nada é enviado. As regras do Firestore continuam sendo publicadas só depois do FTP.

- **Dev:** antes de gerar, o snippet do gtag é removido do `build/web/index.html` (o gerador copia esse arquivo para cada página; sem isso o dev contaria visitas). Depois de gerar, o deploy falha, listando os arquivos, se algum arquivo de `build/web` citar `googletagmanager`, se existir `sitemap.xml` ou se alguma página `.html` estiver sem `noindex`.
- **Produção:** o deploy falha se `sitemap.xml` não existir ou estiver vazio, ou se alguma página `.html` tiver `noindex`.

### Regerar sem commit (agendamento)

O conteúdo do Firestore muda sem commit, então páginas e sitemap ficam velhos até o próximo deploy. O `deploy-prod.yml` roda a cada 3 dias (`schedule`, 06:00 UTC), regenerando páginas e sitemap e reenviando só o que mudou. O GitHub desativa workflows agendados depois de 60 dias sem atividade no repositório; o job `keepalive` reativa o workflow pela API a cada execução, com `actions: write` só nele (`GITHUB_TOKEN`, sem segredo novo). Agendamento só roda na branch padrão. Se o ambiente `PROD` exigir aprovação (*Required reviewers*), a execução agendada fica esperando por ela.

### Validação depois do deploy

Só leitura. Use `DEV=https://dev.observatoriogeohistoria.net.br`, `PROD=https://observatoriogeohistoria.net.br`, uma página de cada tipo e o usuário do dev (`-u usuario:senha`). Rota de exemplo por tipo: fixa `/contato`; listagem `/publicacoes/<area>/<categoria>`; publicação `/publicacoes/<area>/<categoria>/<id>`; biblioteca `/biblioteca/<area>/documento/<id>`; membro `/membro/<id>`.

#### Dev (depois do deploy da `develop`)

1. **Página servida por `/rota`:** `curl -s -u "$U" $DEV/contato | grep -c 'id="seo-content"'` → `1`. Se for `0`, veio o `index.html` genérico: o `.htaccess` ou o gerador não rodou.
2. **`noindex`:** `curl -sI -u "$U" $DEV/contato | grep -i x-robots-tag` → `noindex, nofollow`. No corpo, `curl -s -u "$U" $DEV/contato | grep -o '<meta name="robots"[^>]*>'` → `noindex, nofollow`.
3. **Sem `sitemap.xml`:** `curl -s -u "$U" $DEV/sitemap.xml | grep -c 'id="seo-content"'` → `0` e `curl -sI -u "$U" $DEV/sitemap.xml | head -1` → `200` (é o `index.html`, não um sitemap). `curl -s -u "$U" $DEV/robots.txt` → `Disallow: /`.
4. **Sem gtag:** `curl -s -u "$U" $DEV/contato | grep -c googletagmanager` → `0`. O mesmo para `$DEV/` e `$DEV/main.dart.js`.
5. **Sem senha, 401:** `curl -sI $DEV/contato | head -1` → `401`.
6. **App sobre a página pré-gerada:** abra `$DEV/contato` no navegador (e uma publicação e um documento). A tela de carregamento some, o app aparece sem piscar o texto e, no console, `document.getElementById('seo-content')` → `null`. Recarregue com `Ctrl+Shift+R` para fugir do cache.
7. **Rota sem página gerada:** `curl -s -u "$U" $DEV/rota-que-nao-existe | grep -c 'id="seo-content"'` → `0` (cai no `index.html`; o app decide o que mostrar).

#### Produção (depois do primeiro deploy da `main` com o gerador)

1. **`sitemap.xml`:** `curl -sI $PROD/sitemap.xml` → `200`, `content-type: application/xml` (ou `text/xml`). `curl -s $PROD/sitemap.xml | grep -c '<loc>'` → cerca de 1.083 (ver "Tamanho"); confira que há uma URL de cada tipo e que todas começam com `https://observatoriogeohistoria.net.br/`, sem `www` nem `.html`.
2. **`robots.txt`:** `curl -s $PROD/robots.txt` → `Allow: /`, `Disallow: /admin` e `Sitemap: https://observatoriogeohistoria.net.br/sitemap.xml`. A linha vem de [web/robots.txt](../web/robots.txt).
3. **Canonical e JSON-LD (uma página de cada tipo):**
   - `curl -s $PROD/<rota> | grep -o '<link rel="canonical"[^>]*>'` → a própria URL, `https`, sem `www`, `.html` ou barra final.
   - `curl -s $PROD/<rota> | grep -o '"@type":"[A-Za-z]*"'` → fixa `WebPage`; listagem `CollectionPage`; publicação `Article` ou `CreativeWork`; documento `Thesis`; membro `Person`; todas com `BreadcrumbList`; a home com `WebSite` e `EducationalOrganization`.
   - Cole a URL no [Teste de resultados da pesquisa](https://search.google.com/test/rich-results) e na [validação do Schema.org](https://validator.schema.org/): sem erros.
   - `curl -s $PROD/<rota> | grep -c noindex` → `0`.
4. **Redirecionamentos (um salto só):** `curl -sI http://observatoriogeohistoria.net.br/contato`, `http://www.…/contato` e `https://www.…/contato` → `301` com `Location: https://observatoriogeohistoria.net.br/contato`. `curl -sI $PROD/contato/` → `301` para `/contato`. `curl -sIL` mostra um único `301`.
5. **Arquivo `.html`:** `curl -sI $PROD/contato` → `200` e `content-type: text/html`; `curl -s $PROD/contato | grep -c 'id="seo-content"'` → `1`. `curl -sI $PROD/.htaccess` → `403` (o Apache bloqueia antes da regra do `.htaccess`; `404` também serve). Nunca `200`.
6. **Hidratação sem piscar:** abra uma publicação em janela anônima, com *Slow 4G* nas ferramentas do navegador. O texto não aparece fora do lugar antes do app (o bloco é invisível), a tela de carregamento sai e `document.getElementById('seo-content')` → `null`. Confira também o app em `/` e navegue entre rotas.
7. **Google Analytics:** a aba *Rede* carrega `googletagmanager.com` em produção.

Tudo isto passa a valer só **depois** do deploy novo. Antes dele, produção responde `index.html` para `/sitemap.xml`, `/robots.txt` e `/rota.html` e redireciona `http://www.` para `https://www.`.

### Search Console

Não faz parte do deploy; é manual, depois da validação de produção.

1. Confirme a propriedade `observatoriogeohistoria.net.br` (de preferência por domínio, via DNS) em [search.google.com/search-console](https://search.google.com/search-console).
2. *Sitemaps* → informe `sitemap.xml` → *Enviar*. O status deve ficar *Êxito*, com a contagem de páginas descobertas próxima à do sitemap.
3. *Inspeção de URL* para uma página de cada tipo (fixa, listagem, publicação, documento, membro e a home): *Testar URL publicada* deve mostrar "A URL pode ser indexada", canonical declarado igual ao selecionado e, em *Ver página testada*, o texto do bloco no HTML. Depois, *Solicitar indexação*.
4. **Primeiras semanas**, em *Páginas* (cobertura), uma vez por semana:
   - *Indexadas* sobe aos poucos até perto do número do sitemap (esperar semanas, não dias).
   - *Descoberta, mas não indexada* e *Rastreada, mas não indexada* altas no começo são normais; se não caírem em 4 semanas, revise a qualidade e os links internos.
   - *Duplicada, o Google escolheu outra página como canônica* ou *Página com redirecionamento*: confira `www`/`http`, barra final e canonical.
   - *Soft 404* ou *Não encontrada (404)*: URL do sitemap sem página; compare com o Firestore.
   - *Bloqueada pelo robots.txt* ou *Excluída pela tag noindex*: não deve haver nenhuma (se houver, é vazamento da configuração do dev).
   - *Aprimoramentos* e *Experiência*: erros de dados estruturados e de usabilidade em dispositivos móveis.
5. Em *Desempenho*, acompanhe impressões e cliques por página e por consulta.

### Quando reavaliar

Revise a abordagem se **qualquer um** acontecer: cerca de **10 mil páginas**, deploy **incremental** acima de **15 minutos** (o primeiro, que envia tudo, não conta) ou **aviso de inodes** da HostGator. Saídas, da mais barata para a mais cara:

1. Parar de gerar as listagens além da primeira página e deixar os itens só no sitemap.
2. Gerar só o que mudou desde o último deploy.
3. Renderizar sob demanda no servidor (PHP ou regra de reescrita) em vez de arquivos.
4. Mudar para hospedagem com pré-renderização (por exemplo, Firebase Hosting).

Nada disso está implementado.

## Pendências manuais

- [x] `schedule` e `keepalive` do `deploy-prod.yml` ativos (ver "Regerar sem commit").
- [x] Checklist de produção rodado em 2026-11-25. O do dev ainda precisa da senha.
- [x] `sitemap.xml` enviado e processado no Search Console (2026-11-26).
- [ ] Pedir a inspeção de URL de uma página de cada tipo.
- [x] Inodes conferidos depois do primeiro deploy (ver "Tamanho").
