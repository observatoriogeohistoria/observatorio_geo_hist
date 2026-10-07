# Plano da 023. Login e estrutura do painel nos tokens novos

- **Spec:** spec.md
- **Criado em:** 2026-10-06

## Abordagem
Primeiro o tema ganha os tokens que faltam (tamanhos do painel e a cor de aviso informativo). Depois migram os componentes de `core/` usados pelo painel, porque login e abas dependem deles. Em seguida login, barra lateral e abas, nessa ordem, cada um deixando o app compilando.

A migração troca, arquivo por arquivo:
- `num_extension` (`.scale`, `.horizontalSpacing`, `.verticalSpacing`) por `dimensions.spacing.sNN` ou por um token de `components`, fixo ou por faixa de largura (`_byBreakpoint`);
- `AppHeadline`, `AppTitle`, `AppLabel`, `AppBody` e `typography.headline/title/body/label` por `Text` com estilos de `AppTheme.typography.of(context)`;
- cores antigas pelas novas: `orange` → `accent`, `darkGray` → `ink`, `gray` → `inkSecondary`, `lighterGray` → `surface` (fundo) ou `line` (borda), `lightOrange` → `accentSoftBorder`.

O layout de cada tela fica como está; só os valores mudam.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/app/theme/app_colors/app_colors.dart` | Cor `info` para o aviso informativo |
| Alterar | `lib/app/theme/app_dimensions/app_dimensions.dart` | Tokens do painel e do login em `ComponentSizes` |
| Alterar | `lib/app/core/components/loading/circular_loading.dart` | Tamanho fixo e cor de acento |
| Alterar | `lib/app/core/components/loading/linear_loading.dart` | Espaçamento fixo e cor de acento |
| Alterar | `lib/app/core/components/scroll/app_scrollbar.dart` | Espessura, raio, recuo e cor novos |
| Alterar | `lib/app/core/components/buttons/app_icon_button.dart` | Tamanho do ícone e preenchimento sem escala |
| Alterar | `lib/app/core/components/card/app_card.dart` | Cores, raio e espaçamento novos |
| Alterar | `lib/app/core/utils/messenger/messenger.dart` | Cores `error`, `success`, `info` e texto em Figtree |
| Alterar | `lib/app/features/admin/login/presentation/signin_page.dart` | Tokens, largura máxima, botão de senha acessível |
| Alterar | `lib/app/features/admin/sidebar/presentation/components/sidebar_header.dart` | Espaçamento fixo |
| Alterar | `lib/app/features/admin/sidebar/presentation/components/sidebar_menu_item.dart` | Tokens, foco visível nos itens e subitens |
| Alterar | `lib/app/features/admin/sidebar/presentation/components/toggle_collpase_button.dart` | Vira `AppIconButton` com nome acessível |
| Alterar | `lib/app/features/admin/sidebar/presentation/components/sidebar_navigation.dart` | Larguras e espaçamentos fixos |
| Alterar | `lib/app/features/admin/panel/presentation/pages/panel_page.dart` | Barra do topo e recuo do conteúdo |
| Alterar | `lib/app/features/admin/panel/presentation/components/section_header_title.dart` | Título e espaçamento |
| Alterar | `lib/app/features/admin/panel/presentation/components/section_header_actions.dart` | Espaçamentos dos filtros |
| Alterar | `lib/app/features/admin/panel/presentation/components/form_label.dart` | Estilo `formLabel` |
| Alterar | `lib/app/features/admin/panel/presentation/components/sections/crud_section.dart` | Tokens e estado vazio |
| Alterar | `lib/app/features/admin/panel/presentation/components/sections/posts_section.dart` | Tokens e estado vazio com e sem filtro |
| Alterar | `lib/app/features/admin/panel/presentation/components/sections/library_section.dart` | Tokens; blocos de área focáveis |

`categories_section`, `media_section`, `team_section` e `users_section` só montam a `CrudSection` e não têm token antigo: não mudam.

## Decisões técnicas
- **Tokens do painel em `ComponentSizes`**, com prefixo `panel`/`signin`, como as outras telas fizeram. Valores próximos dos atuais a 1440 px, onde a escala antiga é perto de 1: barra lateral aberta 304 (largura padrão do `Drawer`), ícone da barra 28, recolhida = ícone + 2 × 16; cartão do login com largura máxima 440; recuo do conteúdo 16/24/32 por faixa.
- **Espaçamentos com `spacing.sNN`**, não com `space`/`radius` (escala antiga, que a Fase 7 avalia). `stroke` continua, pois o site novo inteiro usa.
- **Estado vazio como texto simples** centralizado (`regular`, `inkSecondary`), sem `StateMessageBox`: a caixa exige título e mensagem, e a spec define uma frase só.
- **"Com filtro" em Publicações** é qualquer um dos cinco filtros preenchido (texto, área, categoria, publicação, destaque).
- **Cor `info` nova** (`#1E5AA8`, contraste com branco acima de 6:1). `error` e `success` já existem e passam de 4,5:1 com branco.
- **Botões só com ícone usam `AppIconButton`** (tooltip e anel de foco já embutidos). Itens e subitens da barra lateral e os blocos de área da biblioteca recebem `AppFocusRing`, como os itens da navbar. O `GestureDetector` dos blocos de área vira `InkWell` (regra do CLAUDE.md para área clicável).
- **`AppCard`**: o ícone de mão no hover só é usado pelo carrossel sem uso, que sai na Fase 7. Ele fica, em `accent` e com tamanho de token, para não mexer na API agora.

## Dependências e geração de código
Nenhum pacote novo, nenhuma rota nova, sem `build_runner` (stores não mudam).

## Riscos e cuidados
- **`AppIconButton`** é usado no menu do celular, no vídeo da Home e no diálogo de categorias do hero. Sem a escala, o ícone fica do tamanho pedido (diferença pequena: a escala era perto de 1). Conferir essas telas.
- **`AppScrollbar`, `CircularLoading` e `LinearLoading`** aparecem em `library_list_page` e `filters` (painel da biblioteca, item 6.4). Conferir que continuam sem `overflow`.
- **`AppCard`** é a base dos cards do painel (6.2): eles mudam de borda e cor já nesta spec. É esperado, e eles terminam de migrar na 6.2.
- **`Messenger`** é usado pelo diálogo de documento da biblioteca e pela `library_list_page`; só muda a cor do aviso.
- **Campos de formulário** (`AppTextField`, `AppDropdownField`) ainda escalam até a 6.3. No login e nos filtros, os campos ficam com o visual antigo por enquanto.

## Como conferir
- `fvm flutter analyze` e `fvm dart format` nos arquivos alterados (numa cópia em caminho sem acento, como nas fases anteriores).
- Busca dos critérios 1 e 2: `grep -nE "num_extension|AppHeadline|AppTitle|AppLabel|AppBody|typography\.(headline|title|body|label)|colors\.(orange|lightOrange|gray|lightGray|lighterGray|darkGray|red|green|blue)\b"` nos arquivos da tabela não deve achar nada.
- `fvm flutter run -d chrome` em 390, 768 e 1280 px: login (erro de validação, credencial errada, login certo), todas as abas, "Criar", filtros de Publicações, recolher e expandir a barra, menu no celular, "Sair", navegação por Tab.
- Site público: menu do celular, vídeo da Home, diálogo de categorias do hero e biblioteca em 390, 768 e 1280 px.
