# Plano da 011. Nossa história completa e Pessoa da equipe

- **Spec:** [spec.md](spec.md)
- **Criado em:** 2026-10-01

## Abordagem
A base de leitura da 010 (`lib/app/core/components/reading/`) ganha três blocos: `ReadingSubtitle`, `ReadingBulletList` e `ReadingFigure`. `OurHistoryPage` é reescrita com `ReadingPageScaffold` + `PageHeader` (com `lead`) + figura + `ReadingColumn`, reaproveitando o `MilestoneBadge` da 007. A figura fica fora da coluna de 680 px, num limite próprio de 920 px, porque o protótipo a faz mais larga que o texto.

`TeamMemberPage` passa a usar `ReadingPageScaffold` sem cabeçalho, com o corpo numa largura de 920 px: migalhas de três níveis e um layout de duas colunas (foto | texto) que empilha abaixo de 700 px de largura útil. Os estados saem do `Observer` sobre `FetchTeamStore.state`: carregando → esqueleto próprio; erro → caixa de estado com "Tentar de novo"; sucesso sem página → `PageNotFound`. A busca continua só no `initState` com `needsFetch`, o que já impede o laço; o plano só preserva isso e confere.

A regra "tem página" sai do `TeamMemberTile` e da página para uma função única, `memberHasPage(member)`, ao lado de `memberInitials` em `sort_team.dart`, para a Home e a página não divergirem. A foto da pessoa vira um componente `MemberPortrait` (quadrado, cantos `r20`, iniciais por baixo, como o `MemberAvatar` da 008).

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/app/theme/app_dimensions/app_dimensions.dart` | Em `ComponentSizes`, com comentário de origem: subtítulo (`readingSubtitleMarginTop` ≈ 1,7 em do estilo → 46, `readingSubtitleMarginBottom` 16); lista com marcadores (`readingBulletIndent` 22, `readingBulletDot` 6, `readingBulletItemGap` 7, `readingBulletListMarginVertical` 18); figura (`readingFigureMaxWidth` 920, `readingFigureAspect` 21/9, `readingFigureCaptionGap` 10, `readingFigureMarginBottom` 40); pessoa (`memberPageMaxWidth` 920, `memberPortraitMaxWidth` 300, `memberPortraitStackedMaxWidth` 280, `memberPageStackBreak` 700, `memberPageGap(bp)` 24/38/56, `memberPageTopGap` 12 + `pageHeadPaddingTop` 28, `memberNameTopGap` 8, `memberNameBottomGap` 18, `memberLattesGap` 22, `memberPageBottomGap` 64, `memberPortraitInitials`); estado de erro (`stateBoxPadding*`, `stateBoxIcon` 52, gaps). Remover `pageHeadPaddingVertical` (só a página provisória usava) |
| Alterar | `lib/app/theme/app_typography/app_text_styles.dart` | `readingSubtitle` (Bricolage 700, 24/27,2/27,2, altura 1,12, -0,02 em; `.article .prose h2`), `memberPageName` (Bricolage 800, 32/42/48, altura 1,12, -0,03 em), `memberPageInitials` (Bricolage 800, 48/64/64), `stateTitle` (Bricolage 700, 20,8; `.state-box b`). Linhas na tabela do topo. Rótulo usa `label`; legenda usa `small`; descrição usa `reading` (17/17,5 conforme protótipo 17,5) |
| Alterar | `lib/app/core/components/reading/reading_blocks.dart` | `ReadingSubtitle` (`Semantics(header, headingLevel: 2)`), `ReadingBulletList` (`SemanticsRole.list`/`listItem`, marcador redondo `ink` decorativo, alinhado ao centro da primeira linha e escalado com o texto) |
| Criar | `lib/app/core/components/reading/reading_figure.dart` | `ReadingFigure(image:, semanticLabel:, caption:)`: `PageContent` → até 920 px centralizado, `AspectRatio(21/9)`, `ClipRRect(r16)`, `Image` com `fit: cover`, `alignment` configurável, `frameBuilder` com fundo `surface` até o primeiro quadro, `errorBuilder` com placeholder `accentSoft` + ícone `image_outlined` decorativo; legenda `small`/`inkSecondary` |
| Alterar | `lib/app/features/home/presentation/pages/our_history_page.dart` | Reescrita com a base e o texto da spec; figura com `AssetImage('${AppAssets.images}/our-history.webp')`, `alignment: Alignment(0, -0.7)` e `cacheWidth` para não decodificar 3291 px no celular |
| Alterar | `lib/app/features/home/presentation/components/team/sort_team.dart` | `memberHasPage(TeamMemberModel)` (id não nulo e descrição não vazia após `trim`) |
| Alterar | `lib/app/features/home/presentation/components/team/team_member_tile.dart` | `_isLink` passa a usar `memberHasPage` |
| Criar | `lib/app/features/home/presentation/components/team/member_portrait.dart` | Foto quadrada `r20`: iniciais `memberPageInitials` em `accentStrong` sobre `accentSoft` por baixo, `Image.network(cover)` por cima, `errorBuilder` vazio; `Semantics(image, label: 'Foto de $nome')` só quando há URL |
| Criar | `lib/app/features/home/presentation/components/team/member_page_skeleton.dart` | Esqueleto: quadrado + barras (rótulo, nome, 3 linhas) com o mesmo layout responsivo |
| Criar | `lib/app/core/components/error_content/state_error_box.dart` | Caixa de estado de erro do protótipo (`.state-box.err-state`): borda tracejada simulada por borda sólida `line`, ícone `close` em círculo, "Não foi possível carregar", texto de apoio e `PrimaryButton.small('Tentar de novo')`. Em `core` porque a 012 e a Fase 5 vão reaproveitar |
| Alterar | `lib/app/features/home/presentation/pages/team_member_page.dart` | Reescrita: `ReadingPageScaffold(body:)`, corpo em 920 px; `Observer` → esqueleto / `StateErrorBox(onRetry: fetchTeam)` / `PageNotFound` / conteúdo; `LayoutBuilder` para empilhar abaixo de `memberPageStackBreak`; migalhas Início/Equipe → `AppRoutes.root`; descrição dividida por `\n` (linhas vazias descartadas) em `ReadingParagraph`; `SecondaryButton.medium('Currículo Lattes', trailingIcon: Icons.open_in_new)` → `openUrl` |
| Alterar | `docs/arquitetura.md` | Novos blocos e `ReadingFigure` na seção "Páginas de leitura"; `StateErrorBox` na tabela de `core/components/` |

## Decisões técnicas
- **Figura em arquivo próprio**, não em `reading_blocks.dart`: é a única peça mais larga que a coluna e traz `PageContent` próprio; a página a coloca entre o cabeçalho e a `ReadingColumn`. O respiro de cima vem da própria figura (`readingPaddingTop`), e a coluna abaixo recebe só o vão da figura (parâmetro `paddingTop` opcional em `ReadingColumn`, padrão `readingPaddingTop`).
- **Recorte da foto de grupo.** `Alignment(0, -0.7)`: de 3:2 para 21:9 sobram ~64% da altura; com o alinhamento a -0,7 o corte de cima fica em ~5%, acima das cabeças (≈8% da altura). Alternativa descartada: 16:10, que foge do protótipo.
- **`memberHasPage` em `sort_team.dart`**: o arquivo já guarda as regras de apresentação da equipe (`sortTeamByName`, `memberInitials`); não mexe no modelo (proibido pela spec).
- **Empilhar pela largura útil** (`LayoutBuilder`, < 700 px), não pela faixa: replica o `@container (max-width:700px)` do protótipo, que em 768 px ainda é lado a lado.
- **Descrição em parágrafos.** `split('\n')`, `trim` e descarte de vazias; cada uma num `ReadingParagraph` com estilo `reading`. Sem justificar.
- **Erro com estado próprio** (`StateErrorBox`) em vez de `PageErrorContent`, que usa `num_extension` e cinza claro. `PageErrorContent` continua para os posts (não muda).
- **404.** Continua `PageNotFound` atual (fora do escopo redesenhá-la).
- **Laço.** Nenhuma mudança na lógica de busca: `initState` com `needsFetch` e `Observer` só lendo. A conferência usa as requisições de rede do Firestore (`Listen`/`runQuery` na coleção `team`) no navegador embutido.
- **Esqueleto.** O `Skeleton` atual é estático (sem animação), então já atende movimento reduzido. Suas cores soltas não mudam aqui (componente antigo, Fase 7).
- **Nome acessível da foto de Nossa história:** "Foto de grupo dos pesquisadores do Observatório" via `semanticLabel` da `Image`.

## Dependências e geração de código
Nenhum pacote novo. Asset `our-history.webp` já está em `pubspec.yaml` (pasta `assets/images/`). Sem `build_runner` (store não muda). Nenhuma mudança em `app_router.dart`, `app_routes.dart` ou `home_setup.dart`.

## Riscos e cuidados
- **Base compartilhada.** `ReadingColumn` ganha um parâmetro opcional; conferir que o Manifesto continua idêntico.
- **Grade da Home.** `TeamMemberTile` passa a usar `memberHasPage`; conferir que os mesmos membros seguem clicáveis.
- **Firebase de teste sem membros.** O Firebase local/dev pode não ter membros com descrição; conferir a página com um membro real do ambiente usado pelo build (o build de release aponta para o Firebase configurado) e, se não houver, registrar o que não foi conferido. Erro forçado pelo bloqueio da requisição no navegador (modo offline) ou registrado como não conferido.
- **Modelo frágil.** `TeamMemberModel.fromJson` faz `as String` em campos opcionais; um membro sem `description` no banco derruba a busca inteira (vira erro). Pré-existente, fora do escopo (modelo não muda); registrar se aparecer.
- **Imagem grande.** 3291 px decodificados no celular; usar `cacheWidth` proporcional à largura × `devicePixelRatio`.

## Como conferir
- `fvm flutter analyze` numa cópia em caminho ASCII no scratchpad (rsync sem `build/` e `.dart_tool/`, `fvm flutter pub get`) e `fvm flutter build web --release`.
- Build servido por servidor Python próprio com fallback de SPA, no navegador embutido em 390, 768 e 1280 px: `/nossa-historia` (texto, foto, legenda, subtítulos, lista, semântica), `/membro/<id com descrição>`, `/membro/<id inexistente>` (rede: no máximo uma leitura e nada em 10 s), `/membro/<id sem descrição>`, acesso direto x vindo da Home, erro com rede bloqueada, `/manifesto` sem regressão, `scrollWidth` igual à largura. Voltar ao preset desktop e parar os servidores no fim.
