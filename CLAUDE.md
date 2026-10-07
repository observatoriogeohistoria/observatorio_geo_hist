# Observatório Geo-Hist

Site do Observatório do Ensino de História e Geografia (UFU). Flutter Web com Firebase (Firestore, Auth e Storage). Estado com MobX, injeção com GetIt, rotas com GoRouter, erros com `Either` (fpdart).

## Idioma
Texto de interface, documentação, comentários e mensagens de commit em **português do Brasil**. Nomes de código em inglês, como já é no projeto.

## Estilo de escrita e de código
- **Sempre evite prolixidade**, em respostas, docs, comentários e mensagens de commit. Seja direto, sem repetir o que já foi dito.
- **Comentários são exceção.** O código se explica por nomes claros. Comente só o que alguém não entenderia lendo o código:
  - regra de negócio que não está à vista (ex.: quem ganha página na equipe);
  - contorno de limitação do Flutter, de pacote ou do navegador (ex.: foco do Quill, altura intrínseca);
  - motivo de um número ou cor que parece arbitrário (ex.: contraste mínimo).
- Quando comentar: uma ou duas linhas, em tom de conversa, dizendo o **porquê**. Nunca o quê.
- **Não comente:** o que o nome já diz (campos, tokens, getters), cabeçalhos de seção, a classe inteira em prosa, padrões repetidos (ficam em [docs/arquitetura.md](docs/arquitetura.md)) nem código desativado.
- **Nunca cite spec, fase, protótipo ou seletor CSS** (`spec 012`, `.feat`, "aba Post"). Isso envelhece; o histórico fica nos docs e no git.

## Comandos
Sempre com FVM (versão em `.fvmrc`):

```sh
fvm flutter pub get
fvm flutter run -d chrome
fvm flutter analyze
fvm dart run build_runner build --delete-conflicting-outputs   # após mudar stores MobX ou modelos com Freezed
fvm dart format <arquivos .dart alterados>                     # antes de cada commit; largura 100, em analysis_options.yaml
fvm flutter build web --release
```

Os arquivos gerados (`*.g.dart`, `*.freezed.dart`) ficam no repositório. Ainda não existe pasta `test/`.

**Formatação:** todo `.dart` alterado passa pelo `dart format` antes do commit (largura 100, a mesma do VS Code). O CI reprova PR com arquivo fora do formato. Arquivos gerados ficam de fora: o `build_runner` os recria. Para conferir o projeto inteiro:

```sh
find lib -name '*.dart' ! -name '*.g.dart' ! -name '*.freezed.dart' -print0 | xargs -0 fvm dart format --output=none --set-exit-if-changed
```

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
- **Escopo:** o site público e, na Fase 8, o redesenho do login e do painel administrativo (abas Login, Painel e Editor do protótipo), sem mudar dados nem permissões. Geoensine e modo escuro estão fora.

### Regras de design ao implementar
- Use os tokens de `lib/app/theme/` (`AppTheme.colors`, `.dimensions`, `.typography`). **Não escreva cores, tamanhos de fonte ou espaçamentos soltos no código.** Se faltar um token, crie-o no tema.
- Componentes novos usam tamanhos fixos por faixa de largura (celular < 600, tablet 600–1023, desktop ≥ 1024) e largura máxima de conteúdo. Nada escala pelo tamanho da tela.
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
