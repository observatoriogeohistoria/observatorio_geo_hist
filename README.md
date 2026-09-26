# Observatório Geo-Hist

Site do Observatório Geo-Hist, feito em Flutter Web com Firebase (Firestore, Auth e Storage). Reúne posts, biblioteca de documentos e o projeto Geoensine, e inclui um painel administrativo para gerenciar o conteúdo.

## Requisitos

- [FVM](https://fvm.app/) com o Flutter da versão definida em [.fvmrc](.fvmrc)
- Acesso ao projeto Firebase `observatorio-geo-hist`

## Como rodar

```sh
fvm install
fvm flutter pub get
fvm flutter run -d chrome
```

Os stores MobX usam código gerado. Após alterar um store, rode:

```sh
fvm dart run build_runner build --delete-conflicting-outputs
```

Para compilar: `fvm flutter build web --release`.

## Deploy

A cada push na `main`, o GitHub Actions ([deploy.yml](.github/workflows/deploy.yml)) compila o app web e envia os arquivos por FTP para a HostGator. A versão do Flutter no workflow deve ser a mesma do `.fvmrc`.

## Documentação

- [Arquitetura do projeto](docs/arquitetura.md): camadas, features, rotas e dados no Firestore
- [Arquitetura do painel administrativo](docs/arquitetura-painel-admin.md): CRUD, autenticação e permissões
