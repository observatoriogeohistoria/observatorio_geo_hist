# Plano da 025. Diálogos e campos do painel nos tokens novos

- **Spec:** spec.md
- **Criado em:** 2026-10-06

## Abordagem
Depende da 023 (tokens do painel, `FormLabel`, `AppIconButton`, `AppScrollbar`) e da 024 (`ImageErrorContent`). Primeiro migram as peças de `core/`, porque todos os diálogos dependem delas: campos, alternância, Quill, diálogo lateral, player e indicador. Depois os diálogos, que repetem o mesmo padrão: título, `FormLabel` e campos separados por `space.medium.verticalSpacing` (82 ocorrências) ou `space.huge.verticalSpacing` (14).

Os campos mantêm a estrutura do Material (`TextFormField`, `DropdownButtonFormField`, `Checkbox`, `TabBar`), com rótulo flutuante. Só trocam estilos, cores, bordas e espaçamentos. A decoração comum (bordas por estado, preenchimento, estilos de rótulo, dica e erro) fica num lugar só para texto e lista de opções, em vez de duplicada como hoje.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/app/theme/app_dimensions/app_dimensions.dart` | Tokens de diálogo lateral, campos do painel, prévia de imagem, Quill |
| Criar | `lib/app/core/components/field/panel_field_decoration.dart` | Decoração comum de `AppTextField` e `AppDropdownField` |
| Alterar | `lib/app/core/components/field/app_text_field.dart` | Tokens novos |
| Alterar | `lib/app/core/components/field/app_dropdown_field.dart` | Tokens novos |
| Alterar | `lib/app/core/components/field/app_multiselect_field.dart` | Caixa de seleção e rótulo novos |
| Alterar | `lib/app/core/components/field/app_image_field.dart` | Abas, textos, prévia |
| Alterar | `lib/app/core/components/field/app_document_field.dart` | Abas, textos, nome do arquivo |
| Alterar | `lib/app/core/components/buttons/switch_button.dart` | Rótulo e cor |
| Alterar | `lib/app/core/components/quill/editor_quill.dart` | Borda, foco, espaçamento |
| Alterar | `lib/app/core/components/dialog/right_aligned_dialog.dart` | Fundo, borda, larguras por faixa |
| Alterar | `lib/app/core/components/video_player/app_video_player.dart` | Espaçamentos sem escala |
| Alterar | `lib/app/core/components/loading_content/loading_content.dart` | Cor `accent` |
| Criar | `lib/app/features/admin/panel/presentation/components/dialogs/panel_dialog_title.dart` | Título comum dos diálogos (15 usos) |
| Alterar | `lib/app/features/admin/panel/presentation/components/dialogs/*.dart` (7) | Título, espaçamentos, "X" acessível no "Ver imagem" |
| Alterar | `lib/app/features/admin/panel/presentation/components/dialogs/create_or_update_posts_dialogs/*.dart` (10) | Título, espaçamentos, botões de autor |

## Decisões técnicas
- **Decoração comum dos campos em `core/components/field/`**, não em `theme/`: é composição de widgets, e o tema guarda só valores. Fica perto dos campos que a usam.
- **Estilos:** texto digitado em `regular` + `ink`; rótulo e dica em `regular` + `inkSecondary`; erro em `formError` + `error`; borda `fieldBorder` com `formFieldBorder` (1,5); foco em `accent`; desativado com fundo `surface`. Raio `radii.r10`, preenchimento `formFieldPaddingH/V` (já usados no formulário de contato).
- **`AppTextField.margin`** (hoje `space.small.verticalSpacing` acima de cada campo) vira `spacing.s8` fixo, para não mudar o espaçamento entre campos.
- **Título dos diálogos** num widget `PanelDialogTitle` (`h3` + `ink`), já que 15 diálogos repetem o mesmo trecho. Rótulos de grupo ("Área", "Categoria", "Autores", "Conteúdo") usam o `FormLabel` da 023; onde hoje é `AppTitle` de grupo, passa a `FormLabel`.
- **Espaçamento entre campos:** `space.medium.verticalSpacing` → `spacing.s16`; `space.huge.verticalSpacing` → `spacing.s32`.
- **Botões "+"/"−" de autores** (artigo, filme, documento, música) viram `AppIconButton` com tooltip "Adicionar autor" e "Remover autor": hoje são `IconButton` sem nome.
- **"X" do "Ver imagem"** vira `AppIconButton` com tooltip "Fechar". O diálogo já fecha com Esc (`barrierDismissible` padrão); conferir.
- **Diálogo lateral:** larguras por faixa como tokens (`panelDialogWidthFactor(breakpoint)` = 1,0 / 0,7 / 0,5), fundo `page`, borda esquerda `line`, raio `radii.r12`, preenchimento `panelDialogPadding(breakpoint)` (16/24/24).
- **Prévia de imagem no campo** com altura `panelImagePreviewHeight` (120) e `cover`; altura da área das abas (`72` solto hoje) vira `panelTabViewHeight`.
- **Nome de arquivo longo:** `Text` com `maxLines: 1` e reticências, dentro de `Flexible`.
- **Quill:** a barra de ferramentas do pacote fica como está (fora dos tokens, é do pacote). Só a caixa do editor muda: borda `fieldBorder`, `accent` quando o editor tem foco (via `FocusNode` próprio) e preenchimento `formFieldPaddingH`.

## Dependências e geração de código
Nenhum pacote, rota ou `build_runner`. Depende da 023 e da 024 implementadas.

## Riscos e cuidados
- **Campos compartilhados com a biblioteca do painel** (`filters.dart`, diálogo de documento): mudam de visual já aqui, antes da 026. Esperado; conferir que não quebram.
- **Login** usa `AppTextField` e muda junto (está na spec).
- **`AppVideoPlayer`** é o player do vídeo da Home. Só muda o espaço entre os controles (8 px fixos, antes ~8 escalados). Conferir a Home.
- **`RightAlignedDialog`** é usado pelo diálogo de documento da biblioteca (026); muda junto.
- **`expands` em `AppTextField`** (sem `minLines`/`maxLines`): manter o comportamento atual para não quebrar os campos de altura fixa.

## Como conferir
- Busca de tokens antigos nos arquivos da tabela: nada encontrado.
- `fvm flutter analyze` e `fvm dart format` (em cópia com caminho sem acento).
- `fvm flutter run -d chrome` em 390, 768 e 1280 px: criar e editar cada tipo de conteúdo, inclusive o artigo (formulário mais longo); validação vazia; "Cancelar"; "Ver imagem" com imagem, vídeo e URL quebrada; login; vídeo da Home.
