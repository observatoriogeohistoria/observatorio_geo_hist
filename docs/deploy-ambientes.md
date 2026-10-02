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
| [ci.yml](../.github/workflows/ci.yml) | PR para `develop` ou `main` | `pub get`, conferência de formatação (`dart format`), `analyze` e `build web`. Não publica. |
| `deploy-dev.yml` | push na `develop` ou manual | Build, `robots.txt` bloqueando indexação e FTP para o dev. |
| `deploy-prod.yml` | push na `main` ou manual | Build e FTP para produção. |

Comum aos três:

- Versão do Flutter lida do `.fvmrc` com `jq`.
- Só `build/web/` é enviado, em um único passo de FTP (`SamKirkland/FTP-Deploy-Action`, FTPS).
- `concurrency` por ambiente: dois deploys do mesmo ambiente não rodam juntos.

## Secrets e Environments

Cada deploy usa um *Environment* do GitHub (`DEV` e `PROD`) com `FTP_HOST`, `FTP_USER` e `FTP_PASSWORD`. Cada usuário FTP é restrito à pasta do próprio ambiente, então o dev não consegue sobrescrever produção. Em `PROD`, dá para exigir aprovação manual (*Required reviewers*) antes do deploy.

## Diferenças entre dev e produção

- **`APP_ENV`**: o build recebe `--dart-define=APP_ENV=dev|prod`, lido em [app_environment.dart](../lib/app/core/utils/environment/app_environment.dart). No dev, o app mostra a faixa de aviso de ambiente de testes.
- **Indexação**: o deploy de dev gera `robots.txt` com `Disallow: /`.
- **Senha**: o dev fica atrás de senha (`.htpasswd`, pelo cPanel).
- **`.htaccess`**: o app usa `usePathUrlStrategy`, então o servidor reescreve rotas desconhecidas para `index.html`. O `.htaccess` de cada ambiente (com a senha, no dev) fica só no servidor: o deploy apaga apenas arquivos que ele mesmo enviou.
- **Cache**: os arquivos do Flutter mantêm o mesmo nome a cada build (`main.dart.js`, `assets/fonts/MaterialIcons-Regular.otf`...). Sem `Cache-Control`, o navegador reaproveita versões antigas por conta própria, e aparecem, por exemplo, ícones sumidos (fonte de ícones antiga com código novo). O `.htaccess` de cada ambiente deve mandar revalidar sempre (o servidor responde 304 quando nada mudou):

  ```apache
  <IfModule mod_headers.c>
    Header set Cache-Control "no-cache"
  </IfModule>
  ```
- **Firebase**: o `APP_ENV` escolhe o projeto (`observatorio-geo-hist-dev` no dev, `observatorio-geo-hist` em produção), então Firestore, Auth e Storage do dev são separados de produção. O dev não tem Storage habilitado (`AppEnvironment.hasStorage`): lá o painel não lista mídias e recusa enviar ou apagar arquivos de mídia e da biblioteca. Arquivos já gravados com URL de produção continuam abrindo, só para leitura.

## Índices do Firestore

O projeto não guarda `firestore.indexes.json`: os índices são criados pelo console do Firebase. Um arquivo só com os índices novos faria o `firebase deploy` propor apagar os que já existem.

| Uso | Escopo | Campos | Projetos |
|---|---|---|---|
| Busca em `/publicacoes` (todas as categorias) | Grupo de coleções `category_posts` | `isPublished` ↑, `type` ↑, `body.title_lower` ↑ | `observatorio-geo-hist` e `observatorio-geo-hist-dev` |

Sem esse índice, a página abre normalmente, mas a busca mostra "Não foi possível carregar". Para criar: abra `/publicacoes`, faça uma busca e siga o link que o Firestore escreve no console do navegador (erro `failed-precondition`), ou crie à mão em *Firestore › Índices › Composto*, com escopo "Grupo de coleções". Publique nos dois projetos antes de levar à `main`.

## Operação

- **Deploy manual**: rode o workflow em *Actions* (`workflow_dispatch`), escolhendo a branch ou o commit.
- **Rollback**: reverta o commit na `main` ou rode o workflow de um commit anterior.
- **Falha no FTP**: reexecute o workflow. O deploy é idempotente.
