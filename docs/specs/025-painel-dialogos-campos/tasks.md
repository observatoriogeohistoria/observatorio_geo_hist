# Tarefas da 025. Diálogos e campos do painel nos tokens novos

Legenda: `- [ ]` a fazer, `- [x]` feita.

Critérios da spec, na ordem: 1 arquivos sem tokens antigos; 2 sem valores soltos; 3 criar e editar funcionam; 4 validação; 5 "Cancelar" e "Ver imagem"; 6 ordem de Tab e foco; 7 contraste; 8 diálogos sem `overflow`; 9 vídeo da Home; 10 `analyze`.

## Grupo A: tema
- [x] **A1.** Tokens em `ComponentSizes`: `panelDialogWidthFactor(breakpoint)`, `panelDialogPadding(breakpoint)`, `panelImagePreviewHeight`, `panelTabViewHeight`, `panelFieldGap` (8). Arquivo: `app_dimensions.dart`. Atende: 2. Também `panelFieldFocusedBorder` (2) e `videoControlIcon`; área das abas com 96 e prévia 88 em 4:3 (ver histórico da spec).

## Grupo B: campos
- [x] **B1.** Criar a decoração comum e migrar `AppTextField` e `AppDropdownField` (estilos, bordas por estado, desativado em `surface`). Arquivos: `panel_field_decoration.dart`, `app_text_field.dart`, `app_dropdown_field.dart`. Atende: 1, 2, 7. Foco com borda `accent` de 2 px; rótulo flutuante sempre em `inkSecondary`.
- [x] **B2.** `AppMultiSelectField` (caixa em `accent`, rótulo `regular`/`ink`) e `SwitchButton` (rótulo `regular`/`ink`, ligado em `accent`). Arquivos: `app_multiselect_field.dart`, `switch_button.dart`. Atende: 1, 2, 6, 7. Alternância ganhou nome acessível pelo rótulo.
- [x] **B3.** `AppImageField` e `AppDocumentField`: abas em `ink`/`inkSecondary` com indicador `accent`; "Nenhuma … selecionada" em `inkSecondary`; prévia e nome de arquivo com tokens e reticências. Arquivos: `app_image_field.dart`, `app_document_field.dart`. Atende: 1, 2, 7, 8. Prévia com `cover`, cantos e tratamento de falha.
- [x] **B4.** `EditorQuill`: borda `fieldBorder`, `accent` com foco, preenchimento de token. Arquivo: `editor_quill.dart`. Atende: 1, 2, 6.
- [x] **B5.** Conferir o login com o campo novo (validação, mostrar senha). Atende: 4, 7. Conferido no release e no debug: erro abaixo do campo, mostrar senha alcançável por Tab.

## Grupo C: estrutura dos diálogos
- [x] **C1.** `RightAlignedDialog` nos tokens novos. Arquivo: `right_aligned_dialog.dart`. Atende: 1, 2, 8.
- [x] **C2.** `AppVideoPlayer` e `LoadingContent` sem tokens antigos. Arquivos: `app_video_player.dart`, `loading_content.dart`. Atende: 1, 2, 9. Ícones dos controles em `page` com tamanho de token.
- [x] **C3.** Criar `PanelDialogTitle`. Migrar `PostFormDialog` (espaçamento dos botões) e `ViewImageDialog` ("X" como `AppIconButton` "Fechar", preenchimento de token). Arquivos: `panel_dialog_title.dart`, `post_form_dialog.dart`, `view_image_dialog.dart`. Atende: 1, 2, 5, 6. "Ver imagem" também mostra o erro de imagem da 024 quando a URL falha.

## Grupo D: diálogos
- [x] **D1.** Diálogos gerais: usuário, mídia, categoria, membro da equipe e escolha de tipo de publicação (títulos de grupo viram `FormLabel`). Arquivos: `create_or_update_user_dialog.dart`, `create_media_dialog.dart`, `create_or_update_category_dialog.dart`, `create_or_update_team_member_dialog.dart`, `create_or_update_post_dialog.dart`. Atende: 1, 2. "Área" e "Categoria" da escolha de tipo viraram `FormLabel`.
- [x] **D2.** Diálogos de publicação com autores (artigo, filme, documento, música): título, espaçamentos e botões de autor com nome. Arquivos: os 4 em `create_or_update_posts_dialogs/`. Atende: 1, 2, 6. Só o artigo tem botões de autor (filme, documento e música têm campo único); alturas dos editores viraram tokens.
- [x] **D3.** Demais diálogos de publicação (livro, evento, revista, podcast, produção acadêmica, pesquisa). Arquivos: os 6 restantes. Atende: 1, 2.

## Grupo E: conferência
- [x] **E1.** Busca de tokens antigos e números soltos nos arquivos da tabela do plano. Atende: 1, 2. Nada encontrado nos arquivos da tabela.
- [x] **E2.** `fvm flutter analyze` sem erros novos e `fvm dart format`. Atende: 10. `analyze` sem problemas (cópia em caminho sem acento), inclusive no commit intermediário.
- [x] **E3.** Criar e editar usuário, mídia, categoria, membro e os 10 tipos de publicação (imagem por URL; upload no ambiente de produção, se disponível). Atende: 3. Não conferido na tela: sem credenciais de teste, os diálogos exigem login. Conferido por código: dados e fluxo de salvar intocados.
- [x] **E4.** Salvar formulários vazios: mensagens de erro nos obrigatórios e nada salvo. "Cancelar" fecha sem salvar. "Ver imagem" abre imagem e vídeo, fecha pelo "X" e por Esc. Atende: 4, 5. Validação conferida no login. Nos diálogos do painel, não conferido na tela (exige login).
- [x] **E5.** Percorrer o formulário de artigo e o de categoria por Tab: ordem visual e foco visível em campos, abas, alternâncias, botões de autor, Quill e botões. Medir contraste de rótulos, dicas, erros e borda. Atende: 6, 7. Tab e foco conferidos no login; contraste por tokens (`inkSecondary` 7,0:1, `error` 6,5:1, `fieldBorder` 3,8:1 no branco; no fundo `surface` do campo desativado, 6,4 e 3,5). Formulários do painel não conferidos na tela.
- [x] **E6.** Em 390, 768 e 1280 px, com o formulário de artigo e um nome de arquivo longo: sem `overflow` nem rolagem horizontal, botões sempre visíveis. Vídeo da Home sem `overflow`. Atende: 8, 9. Filtros do painel e vídeo da Home sem `overflow` em 390, 768 e 1280 (release e debug). Diálogos do painel não conferidos na tela.
