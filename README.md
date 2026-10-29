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

Push na `develop` publica o ambiente de testes e push na `main` publica produção, pelo GitHub Actions (FTP para a HostGator). Detalhes em [docs/deployment.md](docs/deployment.md).

## Documentação

- [Arquitetura do projeto](docs/architecture.md): camadas, features, rotas e dados no Firestore
- [Painel administrativo](docs/admin-panel.md): CRUD, autenticação e permissões
- [Deploy](docs/deployment.md): ambientes, workflows e índices do Firestore
- [Histórico do redesign](docs/redesign-history.md) e [ideias futuras](docs/future-ideas.md)
- [Especificações (SDD)](docs/specs/README.md)
