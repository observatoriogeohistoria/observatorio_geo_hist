# Ambientes e deploy (dev e produção)

Planejamento para separar **desenvolvimento (dev)** de **produção (prod)**, ambos na HostGator, para que o pessoal teste antes de publicar.

## Situação atual

- Um único workflow, [.github/workflows/deploy.yml](../.github/workflows/deploy.yml), dispara em push na `main` e envia para a HostGator por FTP.
- O commit `5d49179` (já na `main`) corrigiu o pior problema: antes o workflow enviava o repositório inteiro e depois `build/web/`, com dois passos disputando o mesmo arquivo de estado (uma execução falhou após 1h28min). Hoje há um único passo de FTP, só com `build/web/`, e `checkout@v4` com cache do Flutter.
- Pendências do workflow atual:
  - Não roda `flutter analyze` antes de publicar.
  - A versão do Flutter (`3.44.0`) está fixa no workflow, duplicada do `.fvmrc`.
  - O `server-dir` não é explícito (usa a raiz da conta FTP), o que precisa mudar para separar dev e prod.
  - O input `timeout` não existe na `FTP-Deploy-Action@4.3.0` (o log avisa `Unexpected input(s) 'timeout'`), então não tem efeito.
  - Sem `concurrency`: dois pushes seguidos podem rodar deploys ao mesmo tempo.
- Firebase: existe **um projeto só** (`observatorio-geo-hist`), usado por tudo.
- `origin/develop` existia 20 commits atrás da `main` e sem nada novo. A `develop` foi alinhada à `main` (fast-forward) e publicada no remoto; hoje as duas estão idênticas.
- `refactor/redesign` está em dia com a `main` (0 commits atrás, 17 à frente).

## Decisões a confirmar

| # | Decisão | Recomendação |
|---|---------|--------------|
| 1 | Onde fica o dev | **Subdomínio** `dev.observatoriogeohistoria.net.br` com pasta própria fora do `public_html` (`/home2/observ42/dev.observatoriogeohistoria.net.br`), para o deploy de produção nunca tocar nela. Mais simples que subpasta: o `base href` continua `/` e as rotas do GoRouter funcionam sem ajuste. |
| 2 | Firebase do dev | **Começar compartilhando** o projeto de produção, com dev **somente leitura na prática** (testar não deve criar dados). Se o pessoal precisar testar o painel admin ou escrita, criar um projeto Firebase `observatorio-geo-hist-dev`. |
| 3 | Proteção do dev | Senha via `.htpasswd` (cPanel → "Proteger diretório com senha") **e** `noindex`, para não aparecer no Google nem vazar conteúdo em rascunho. |
| 4 | Proteção de branches | `main` e `develop` protegidas no GitHub: só entram por Pull Request. |

## Fluxo de branches

```
feature/*  ──PR──▶  develop  ──PR──▶  main
  (local)          (deploy DEV)       (deploy PROD)
```

1. Trabalho em `feature/*`, `fix/*` ou `refactor/*` saindo da `develop`.
2. PR para `develop` → CI roda `analyze` e o build. Ao mergear, **deploy automático no dev**.
3. Pessoal testa no dev.
4. Aprovado, PR `develop` → `main`. Ao mergear, **deploy automático em produção**.
5. Correção urgente em produção (hotfix): branch `hotfix/*` saindo da `main`, PR para `main`, depois trazer para a `develop`.

Regra: nada vai para a `main` sem ter passado pela `develop`.

## Estrutura dos workflows

Separar em três arquivos, com um passo de build reaproveitável.

| Arquivo | Gatilho | O que faz |
|---------|---------|-----------|
| `ci.yml` | PR para `develop` ou `main` | `pub get`, `analyze`, `build web`. Não publica. |
| `deploy-dev.yml` | push na `develop` | build + FTP para a pasta do dev |
| `deploy-prod.yml` | push na `main` | build + FTP para a pasta de produção |

Pontos técnicos:

- **Enviar só `build/web/`** para o servidor (já feito no `deploy.yml` atual; manter nos novos).
- Um passo de FTP por deploy, com `server-dir` explícito (dev: `/`, com a conta FTP presa à pasta do dev; prod: a raiz atual da conta de produção), evitando o conflito de estado.
- **Secrets por ambiente**: usar *Environments* do GitHub (`DEV` e `PROD`), cada um com `FTP_HOST`, `FTP_USER`, `FTP_PASSWORD`. Em `PROD`, ativar **aprovação manual obrigatória** (Required reviewers) como trava extra.
- **Conta FTP do dev restrita** à pasta do dev (criada no cPanel), para um erro de configuração nunca sobrescrever produção.
- `concurrency` por ambiente, para dois deploys não rodarem juntos.
- Ler a versão do Flutter do `.fvmrc` com `jq` (a `subosito/flutter-action` só lê versão de `pubspec.yaml`, não do `.fvmrc`) em vez de duplicar.
- Cache de pub/Flutter para acelerar o build.
- Atualizar `actions/checkout` para `v4`.

## Diferenças entre dev e prod no app

- **Indicação visual**: faixa "Ambiente de testes" (ou título com prefixo `[DEV]`) no dev, para ninguém confundir com o site real. Implementar com `--dart-define=APP_ENV=dev` no build e uma constante lida no app.
- **Não indexar**: no build de dev, gerar `robots.txt` com `Disallow: /` e a meta `noindex` (além da senha).
- **`.htaccess`**: o app usa `usePathUrlStrategy`, então o servidor precisa reescrever rotas desconhecidas para `index.html`. Conferir se já existe na produção e criar o equivalente no dev. Versionar em `web/` se não estiver.
- **Firebase (se separar projetos)**: gerar um `firebase_options` para o dev e escolher pelo `APP_ENV`. Exige criar Auth, Firestore e Storage no projeto novo e copiar dados de teste.

## Fases

1. **Infra na HostGator** (manual, cPanel): criar subdomínio do dev, pasta, conta FTP restrita, senha do diretório. SSL para o subdomínio.
2. **GitHub**: criar Environments `DEV` e `PROD` com os secrets; proteger `main` e `develop`.
3. **Branches**: ~~alinhar e publicar a `develop`~~ (feito). Falta proteger `main` e `develop` no GitHub.
4. **Workflows**: `ci.yml`, `deploy-dev.yml`, `deploy-prod.yml`, reaproveitando o envio só de `build/web/` que já existe.
5. **App**: `APP_ENV`, faixa de ambiente, `noindex`/`robots.txt` e `.htaccess`.
6. **Documentar** o fluxo no `CLAUDE.md` (a regra atual "push na `main` publica o site" precisa citar também a `develop`).
7. **Teste ponta a ponta**: PR de uma mudança pequena → dev → prod.

Fases 1 e 2 são acesso à HostGator e ao GitHub (com você). As fases 3 a 6 podem ser feitas no repositório.

## Riscos e cuidados

- Mexer no `deploy.yml` é mexer no que publica produção: testar primeiro o `deploy-dev.yml`, e só depois trocar o de produção.
- Os deploys antigos enviavam o repositório inteiro. O último log mostra 94 arquivos no servidor (compatível com só o site), mas vale conferir no cPanel se sobrou algo fora do estado do deploy (`lib/`, `docs/`, etc.) e apagar.
- Se o dev usar o mesmo Firebase da produção, o painel admin no dev **altera dados reais**. Avisar o pessoal ou separar os projetos.
- Rollback: o deploy é reexecutável. Para voltar produção, reverter o commit na `main` (ou rodar o workflow de um commit anterior via `workflow_dispatch`, que vale incluir).

## Critérios de pronto

- Merge na `develop` publica em `dev.observatoriogeohistoria.net.br` sem tocar em produção.
- Merge na `main` publica em produção somente após aprovação.
- Dev protegido por senha, sem indexação e com faixa de ambiente visível.
- Só `build/web/` chega ao servidor (condição já atendida hoje; manter).
- PR sem `analyze` e build passando não pode ser mergeado.
