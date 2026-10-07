# Plano da 024. Cards do painel nos tokens novos

- **Spec:** spec.md
- **Criado em:** 2026-10-06

## Abordagem
Depende da 023 (`AppCard`, `AppIconButton` e tokens do painel já migrados). Os 15 cards repetem o mesmo esqueleto: número, título, linhas secundárias e coluna de botões. Por isso, primeiro saem as peças comuns: um selo de situação em `core/` e os componentes de imagem e divisória. Depois cada card troca `AppLabel`/`AppTitle`/`AppBody` por `Text` com os estilos de `AppTheme.typography.of(context)`, e as cores e espaçamentos antigos pelos novos (mesmo mapa da 023).

Os 10 cards de tipo de publicação são quase iguais (número + título; o de artigo tem subtítulo). Eles migram juntos numa tarefa, sem fundir os arquivos: fundir é refatoração fora do escopo.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/app/theme/app_dimensions/app_dimensions.dart` | Tokens dos cards do painel |
| Alterar | `lib/app/core/components/chips/labels.dart` | Selo de situação (`StatusBadge`) com tons sucesso, erro e acento |
| Alterar | `lib/app/core/components/divider/divider.dart` | Cor `line` |
| Alterar | `lib/app/core/components/image/app_network_image.dart` | Altura do esqueleto sem `num_extension` |
| Alterar | `lib/app/core/components/error_content/image_error_content.dart` | Ícone e texto nos tokens novos |
| Alterar | `lib/app/features/admin/panel/presentation/components/cards/post_card.dart` | Rótulos, selos, botões |
| Alterar | `lib/app/features/admin/panel/presentation/components/cards/posts_cards/*.dart` (10) | Número e título (e subtítulo no artigo) |
| Alterar | `lib/app/features/admin/panel/presentation/components/cards/category_card.dart` | Textos e botões |
| Alterar | `lib/app/features/admin/panel/presentation/components/cards/media_card.dart` | Textos, URL longa, botões |
| Alterar | `lib/app/features/admin/panel/presentation/components/cards/team_member_card.dart` | Foto por faixa, Lattes, botões |
| Alterar | `lib/app/features/admin/panel/presentation/components/cards/user_card.dart` | Textos, situação, botões |

## Decisões técnicas
- **Selo novo `StatusBadge`** ao lado de `TypeBadge` e `CategoryTag`, com o mesmo preenchimento (`badgePaddingH/V`), raio `pill` e estilo `tag` em negrito. Os tons usam pares que já existem: `success`/`successSurface`, `error`/`errorSurface`, `accent`/`accentSoft`.
- **Situação do usuário** ("Usuário ativo"/"Usuário inativo") também vira selo, pelo mesmo motivo dos selos de publicação.
- **Estilos de texto:** número em `label` + `inkSecondary`; título em `h3` + `ink`; linhas secundárias em `regular` + `inkSecondary`; "Área(s):"/"Categoria:" em `formLabel` + `accent`, com o valor em `regular` + `ink`. "N Posts" da categoria em `formLabel` + `accent`.
- **Tokens novos em `ComponentSizes`:** `panelCardPaddingH` (20), `panelCardPaddingV` (16), `panelCardActionsGap` (8), `panelCardTextGap` (4), `panelMemberPhoto(breakpoint)` (64/80/96), `panelMemberPhotoRadius` = `radii.r12`. O preenchimento do card passa ao `AppCard` pelos cards (o padrão do `AppCard` continua o da 023).
- **Altura do esqueleto em `AppNetworkImage`:** sem altura, usa `height ?? width` quando a largura é finita e um token `networkImageSkeletonHeight` (253, o valor atual a 1440 px) quando não é. Assim some o `.verticalSpacing`.
- **URL da mídia e título longo:** `Text` com `softWrap` (a URL quebra em qualquer ponto via `overflow: TextOverflow.visible` dentro de `Flexible`). `IntrinsicHeight` continua, pois os botões ficam alinhados embaixo.
- **Cores dos botões:** publicar, destacar, editar e ver em `accent`; excluir em `error`; copiar link em `inkSecondary`.

## Dependências e geração de código
Nenhum pacote, rota ou `build_runner`. Depende da 023 implementada.

## Riscos e cuidados
- **`AppNetworkImage`** também é usado pelo carrossel antigo e pelo `avatar` (ambos sem uso, saem na Fase 7). Nenhuma tela em uso além do card de membro.
- **`AppDivider`** só aparece no card de publicação.
- **`IntrinsicHeight`** com texto longo pode custar desempenho em listas grandes; o número de itens por página do painel é pequeno (mídias pagina de 20 em 20).

## Como conferir
- Busca de tokens antigos (mesma da 023) nos arquivos da tabela: nada encontrado.
- `fvm flutter analyze` e `fvm dart format` (em cópia com caminho sem acento).
- `fvm flutter run -d chrome`, abas Publicações (cada tipo pelos subitens), Categorias, Mídias, Equipe e Usuários em 390, 768 e 1280 px. Testar com um título longo, uma URL longa e uma foto de membro com URL quebrada.
