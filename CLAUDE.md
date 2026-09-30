# Observatório Geo-Hist

Site do Observatório do Ensino de História e Geografia (UFU). Flutter Web com Firebase (Firestore, Auth e Storage). Estado com MobX, injeção com GetIt, rotas com GoRouter, erros com `Either` (fpdart).

## Idioma
Texto de interface, documentação, comentários e mensagens de commit em **português do Brasil**. Nomes de código em inglês, como já é no projeto.

## Estilo de escrita e de código
- **Sempre evite prolixidade**, em respostas, docs, comentários e mensagens de commit. Seja direto, sem repetir o que já foi dito.
- **Sem comentários no meio do código.** O código deve se explicar por nomes claros. Só comente o que não é óbvio (o porquê, nunca o quê), em uma linha curta e sem repetir o que o código já diz.

## Comandos
Sempre com FVM (versão em `.fvmrc`):

```sh
fvm flutter pub get
fvm flutter run -d chrome
fvm flutter analyze
fvm dart run build_runner build --delete-conflicting-outputs   # após mudar stores MobX ou modelos com Freezed
fvm flutter build web --release
```

Os arquivos gerados (`*.g.dart`, `*.freezed.dart`) ficam no repositório. Ainda não existe pasta `test/`.

## Cuidados com o git
- **Push na `main` publica o site** e push na `develop` publica o dev (GitHub Actions, por FTP). Nunca faça push sem pedido explícito. Detalhes em [docs/deploy-ambientes.md](docs/deploy-ambientes.md).
- Só faça commit quando for pedido. Mensagens no formato `tipo: descrição` (`feat`, `fix`, `refactor`, `docs`, `chore`), em português.

## Arquitetura
Leia [docs/arquitetura.md](docs/arquitetura.md) antes de mexer em uma feature e [docs/arquitetura-painel-admin.md](docs/arquitetura-painel-admin.md) para o painel.

Resumo: `lib/app/features/{feature}/` com `infra/` (datasources, repositories, models, errors) e `presentation/` (pages, components, stores). Código compartilhado em `lib/app/core/`. Fluxo: Widget → Store → Repository → Datasource → Firebase, com `Either<Failure, T>` na volta. Cada feature registra dependências no seu `*_setup.dart`.

Convenções: arquivos em `snake_case`; sufixos `*_datasource`, `*_repository`, `*_store`, `*_model`, `*_page`, `*_setup`, `*_failures`.

**Rotas sempre em português**, minúsculas, sem acento e com hífen (`/nossa-historia`, `/publicacoes/:area/:category`), inclusive no painel e nos parâmetros de consulta (`?tipo=`). Todos os caminhos saem de `AppRoutes` (constantes `*Pattern` no roteador e funções para montar o endereço); não escreva rota solta no código. Ao renomear uma rota pública, mantenha a antiga redirecionando para a nova.

## Redesign do site público (em andamento)
- **Fonte de verdade:** [docs/redesign/planejamento.md](docs/redesign/planejamento.md) (decisões, fases, telas, ideias futuras).
- **Protótipo navegável:** https://claude.ai/artifact/PimRbbQyUDbqrapiv8HseH. É a referência visual. Confira cada tela nele antes de implementar.
- **Escopo:** só o site público. Painel administrativo, Geoensine e modo escuro estão fora.

### Regras de design ao implementar
- Use os tokens de `lib/app/theme/` (`AppTheme.colors`, `.dimensions`, `.typography`). **Não escreva cores, tamanhos de fonte ou espaçamentos soltos no código.** Se faltar um token, crie-o no tema.
- Componentes novos usam tamanhos fixos por faixa de largura (celular < 600, tablet 600–1023, desktop ≥ 1024) e largura máxima de conteúdo. **Não use** `num_extension` (`.scale`, `.fontSize`, `.verticalSpacing`) em código novo. Ele só é removido quando todas as telas migrarem.
- Texto secundário nunca em cinza claro: contraste mínimo de 4,5:1 (a regra vale para texto e para ícones informativos).
- Toda área clicável tem foco visível por teclado e nome acessível (`Semantics`/tooltip). Preferir `InkWell`/botões do Material a `GestureDetector` solto.
- Imagens vêm dos autores, sem proporção garantida: use proporção fixa com `cover`, placeholder quando não houver imagem e trate falha de carregamento.
- Telas devem funcionar em 390, 768 e 1280 px, sem rolagem horizontal e sem `overflow`.
- Estados obrigatórios em toda tela com dados: carregando (esqueleto), vazio e erro.

## Desenvolvimento guiado por especificação (SDD)
Para features de mais ou menos meio dia para cima, siga o fluxo abaixo. Correções pequenas dispensam spec.

1. `/sdd-spec <item do planejamento>` cria `docs/specs/NNN-nome/spec.md` e para para aprovação.
2. `/sdd-plan <NNN>` cria `plan.md` e `tasks.md` a partir da spec aprovada.
3. `/sdd-implement <NNN>` executa as tarefas em ordem, marcando o progresso.
4. `/sdd-verify <NNN>` confere o resultado contra os critérios de aceite.

Detalhes em [docs/specs/README.md](docs/specs/README.md). A spec é a fonte do que será feito: se a implementação precisar divergir, atualize a spec antes.
