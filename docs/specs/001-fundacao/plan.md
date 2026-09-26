# Plano da 001. Fundação visual (tokens, fontes e breakpoints)

- **Spec:** [spec.md](spec.md)
- **Criado em:** 2026-09-26

## Abordagem
Tudo entra **ao lado** do que existe, sem tocar nos valores antigos. Isso garante o critério "telas atuais idênticas": nenhum arquivo de tela é alterado e os getters antigos (`AppTypography.headline/title/body/label`, `AppColors.orange` etc.) ficam como estão.

- **Cores:** novos campos em `AppColors`, com nomes por função (`page`, `surface`, `ink`, `inkSecondary`, `line`, `accent`...), distintos dos antigos (que são por cor: `orange`, `gray`...).
- **Espaçamento, raios, sombras e foco:** novos membros em `AppDimensions` (`spacing`, `radii`, `shadows`, `focus`). Os `space`/`radius`/`stroke` antigos não mudam.
- **Fontes:** Bricolage Grotesque e Figtree em arquivos `.ttf` **estáticos** dentro de `assets/fonts/`, declarados no `pubspec.yaml`. Nada de `google_fonts` nos estilos novos.
- **Tipografia:** os tamanhos dependem da faixa de largura, então os estilos novos precisam do `BuildContext`. Nova classe `AppTextStyles`, obtida por `AppTheme.typography.of(context)`, que devolve o conjunto (h1, h2, h3, leitura, padrão, pequeno, rótulo) já na faixa certa. A escolha do tamanho fica numa função pura por faixa, fácil de conferir.
- **Breakpoints:** enum `Breakpoint` (celular, tablet, desktop) e funções puras por largura em `screen_utils.dart`, mais constantes de largura máxima (1120) e margem (20 / 32). Um widget `PageContent` centraliza e limita o conteúdo novo. Os métodos antigos de `ScreenUtils` (inclusive `getPageHorizontalPadding`) ficam intactos.
- **Verificação:** tela de teste temporária (rota provisória, não commitada) com todos os estilos, e um script de contraste fora do projeto.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Criar | `assets/fonts/BricolageGrotesque-{SemiBold,Bold,ExtraBold}.ttf` | Títulos (600, 700, 800) |
| Criar | `assets/fonts/Figtree-{Regular,Medium,SemiBold,Bold}.ttf` | Texto (400, 500, 600, 700) |
| Criar | `assets/fonts/licenses/OFL-BricolageGrotesque.txt`, `OFL-Figtree.txt` | Licenças OFL junto das fontes |
| Alterar | `pubspec.yaml` | Declarar as duas famílias (a pasta `assets/fonts/` já é referenciada por arquivo, então cada `.ttf` entra em `fonts:`; a subpasta `licenses/` não precisa de declaração) |
| Alterar | `lib/app/theme/app_colors/app_colors.dart` | Cores novas (0.1) |
| Alterar | `lib/app/theme/app_dimensions/app_dimensions.dart` | Espaçamentos, raios, sombras e foco novos (0.1) |
| Criar | `lib/app/theme/app_typography/app_text_styles.dart` | Escala de texto por faixa (0.2), como `part` do tema |
| Alterar | `lib/app/theme/app_typography/app_typography.dart` | Getter `of(context)` que devolve `AppTextStyles` |
| Alterar | `lib/app/theme/app_theme.dart` | Incluir a nova `part` |
| Alterar | `lib/app/core/utils/screen/screen_utils.dart` | `Breakpoint`, largura máxima e margens (0.3) |
| Criar | `lib/app/core/components/page_content/page_content.dart` | Widget que limita a 1120 px e aplica a margem |
| Criar (temporário) | `lib/app/dev/foundation_preview_page.dart` e rota provisória em `app_router.dart` | Tela de teste; **removidos antes de fechar** |
| Criar | `docs/specs/001-fundacao/verificacao.md` | Feito por `/sdd-verify` |

## Decisões técnicas
- **Cores em `AppColors` e não em classe nova.** O tema já é acessado por `AppTheme.colors`, e o `CLAUDE.md` manda usar esse caminho. Nomes por função evitam confusão com os antigos por cor. Alternativa (uma `AppColorsV2`) foi descartada: duplicaria o acesso e obrigaria a migrar de novo na Fase 7.
- **Fontes estáticas, não variáveis.** O Flutter Web lida mal com fonte variável (eixos de peso), e a decisão D-01 do planejamento já aponta esse caminho. Gerar instâncias estáticas com `fonttools` (`fonttools varLib.instancer`) a partir dos arquivos do repositório `google/fonts` (licença OFL). Para a Bricolage, que tem os eixos `opsz` e `wdth`, fixar `wdth=100` e um `opsz` único; **o valor de `opsz` será escolhido comparando com o protótipo** (ver riscos).
- **`fontFamilyFallback`** com fontes do sistema (`system-ui`, `Roboto`, `Arial`) nos estilos novos, para o caso de falha de carregamento (caso de borda da spec).
- **Estilos novos dependem de `BuildContext`** (via `MediaQuery`/`ScreenUtils`), em vez de `num_extension`. Cada estilo é montado com `TextStyle` explícito (família, peso, tamanho, altura de linha, espaçamento entre letras) tirado do protótipo. Alturas de linha e `letterSpacing` não constam na spec: serão lidos do protótipo na tarefa D1 e anotados no código.
- **Sombras como `List<BoxShadow>`** (`soft` e `elevated`), prontas para `BoxDecoration.boxShadow`. Valores lidos do protótipo.
- **Foco padrão:** constantes (largura 3, offset 2, cor de acento) em `AppDimensions.focus`, mais um `BorderSide`/helper simples para reuso. O componente em si (botões, etc.) é da spec 002.
- **Raio "pílula":** `radii.pill = 999`.
- **Pares de cor que podem falhar:** acento `#C94400` sobre `#F7F5F2` e sobre `#FFF0E6` é o mais apertado. Se falhar em 4,5:1, ajustar o valor, registrar na spec (Histórico de mudanças) e no `verificacao.md`.

## Dependências e geração de código
- Nenhum pacote novo. `google_fonts` continua no `pubspec.yaml` (as telas antigas usam).
- Ferramenta local só para gerar as fontes: `fonttools` (`pip install fonttools`). Não vira dependência do projeto.
- `build_runner`: **não** é necessário (sem MobX nem Freezed).
- Sem mudança de rota permanente. A rota da tela de teste é provisória.
- Sem novo registro em `*_setup.dart`.

## Riscos e cuidados
- **Regressão nas telas antigas:** o risco é baixo porque só se adicionam membros. Conferir mesmo assim que `git diff` não toca em nenhum valor antigo, e abrir home, lista/detalhe de post, biblioteca e painel admin lado a lado com a `main`.
- **Peso errado ou fonte caindo no sistema:** os pesos da Dosis no `pubspec.yaml` estão mapeados de forma incomum (Medium como 400, Regular como 500). Não mexer. Para as novas, declarar `weight` exato de cada arquivo e conferir na tela de teste que 400/500/600/700 são visivelmente distintos.
- **Fonte só funciona com internet?** Testar com a rede desligada (DevTools → Network → Offline, com cache desativado) e conferir que nenhuma requisição vai para `fonts.gstatic.com` a partir dos estilos novos.
- **Tamanho do bundle:** 7 arquivos `.ttf` novos. Conferir o peso e, se ficar grande, considerar subconjunto latino (`pyftsubset`), mantendo acentos do português.
- **`opsz` da Bricolage:** aparência dos títulos muda com o valor escolhido. Comparar com o protótipo antes de fixar.
- **Tela de teste não pode ser commitada:** removê-la e a rota antes de encerrar; conferir `git status`.

## Como conferir
- `fvm flutter analyze` (sem novos avisos).
- `fvm flutter run -d chrome` e abrir a tela de teste em 390, 768 e 1280 px; comparar com a aba "Fundamentos" do protótipo.
- Script de contraste (fora do projeto, na pasta temporária) para os pares da spec.
- Navegar pelas telas antigas e pelo painel e comparar com a `main`.
- Rede offline para o teste das fontes.
