# Plano da 032. Painel lateral para formulários curtos

- **Spec:** spec.md
- **Criado em:** 2026-10-19

## Abordagem
Uma peça nova, `PanelSheet`, faz a moldura comum: rota modal aberta por `showPanelSheet` (fundo escurecido, desliza da direita, 460 px a partir de 600 e tela cheia abaixo), cabeçalho fixo com título e "×", corpo com rolagem própria, aviso de erro no topo do corpo e pé fixo com "Cancelar" e "Salvar". O `PanelSheet` cuida de validar, levar o foco ao primeiro campo com erro, bloquear edição e fechamento enquanto salva e fechar só no sucesso. Os cinco formulários passam a montar só os campos dentro dele.

O resultado do salvar volta para o painel, não para um aviso flutuante. Cada seção passa a entregar `Future<String?> Function(modelo)`: dispara a ação no store, espera e devolve a mensagem do erro (ou `null`). Os stores já são `async` e deixam o estado em `CrudErrorState`/`CrudSuccessState` antes de terminar, então nada muda neles. O `showPanelActionResult` deixa de fechar diálogo e de mostrar erro quando a ação é `save`; continua mostrando o aviso curto de sucesso, recarregando as contagens e encerrando a sessão em `Forbidden`. As publicações, que seguem no diálogo de hoje até a 033, passam a usar `PanelAction.saveInDialog`, com o comportamento atual.

Os campos usam o `FormTextField` do site (029), que ganha opções todas opcionais: "opcional" ao lado do rótulo, dica abaixo, só leitura, linhas, formatadores e chave do `FormField`. O rótulo, a dica e o erro saem para um `FormFieldFrame` em `core/components/form/`, reaproveitado pelos controles novos do painel: caixas de seleção (soltas ou numa caixa com rolagem), cartões de escolha única, interruptor com dica, lista suspensa, área de imagem e área de arquivo. A 033 pode reaproveitar esses campos e o desenho do pé na página do editor.

O aviso vermelho do login vira `FormErrorAlert`, comum ao login e ao painel. Os campos antigos que ficarem sem uso (`AppDocumentField`, `AppMultiSelectField`, `AppDropdownField`) saem; os que as publicações ainda usam (`AppTextField`, `AppImageField`, `SwitchButton`, `FormLabel`, `PanelDialogTitle`, `RightAlignedDialog`, `PostFormDialog`) ficam para a 033.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | lib/app/theme/app_dimensions/app_dimensions.dart | Tokens do painel lateral (largura 460, paddings 16/20, 20, 14/20, gap do pé 10, sombra), caixas (altura máx. 220, padding 8/10, linha 5), cartões de papel (padding 12/14, gap 12 e 8), área de imagem (16:10, quadrada 140, traço), linhas da descrição (4 a 8), duração do deslize; `loginAlert*` vira `formAlert*` |
| Alterar | lib/app/theme/app_typography/app_text_styles.dart | `formOptional`, `formHint`, `panelChoiceTitle`, `panelChoiceText`, `panelDropText` (o que não houver) |
| Alterar | lib/app/theme/app_colors/app_colors.dart | Só se faltar: sombra do painel (`panelSheetShadow`) |
| Criar | lib/app/core/components/form/form_field_frame.dart | Rótulo com "opcional", filho, dica e erro, com a semântica do 029 |
| Alterar | lib/app/core/components/form/form_text_field.dart | `isOptional`, `helperText`, `readOnly`, `minLines`/`maxLines`, `inputFormatters`, `formFieldKey`; usa o `FormFieldFrame` |
| Criar | lib/app/core/components/form/form_error_alert.dart | Aviso vermelho com `liveRegion` (sai de `login_error_alert.dart`) |
| Apagar | lib/app/features/admin/login/presentation/components/login_error_alert.dart | Vira `FormErrorAlert` |
| Alterar | lib/app/features/admin/login/presentation/signin_page.dart | Usa `FormErrorAlert` |
| Criar | lib/app/features/admin/panel/presentation/components/sheet/panel_sheet.dart | `showPanelSheet` e `PanelSheet` (moldura, validação, foco, salvando, erro) |
| Criar | .../sheet/panel_validators.dart | Mesmas regras de `Validators`, com as mensagens da spec |
| Criar | .../sheet/panel_check_group.dart | Caixas de seleção com rótulo de grupo, solta ou em caixa com rolagem |
| Criar | .../sheet/panel_choice_cards.dart | Cartões de escolha única sobre `RadioGroup` |
| Criar | .../sheet/panel_switch_field.dart | Interruptor com título e dica |
| Criar | .../sheet/panel_select_field.dart | Lista suspensa do formulário sobre `LibraryFilterSelect` (48 px, `expand`) |
| Criar | .../sheet/panel_image_field.dart | Área de imagem (prévia, placeholder, falha, "Escolher imagem"/"Escolher foto") e endereço da imagem |
| Criar | .../sheet/panel_file_field.dart | Área do PDF com nome do arquivo e endereço do arquivo |
| Alterar | .../sections/panel_action.dart | `save` sem pop nem aviso de erro; `saveInDialog` para publicações; `panelSaveError(state)` |
| Alterar | .../sections/posts_section.dart | `PanelAction.saveInDialog` |
| Alterar | .../dialogs/create_or_update_category_dialog.dart, create_or_update_team_member_dialog.dart, create_or_update_user_dialog.dart, create_media_dialog.dart | Montados sobre o `PanelSheet` |
| Alterar | lib/app/features/library/presentation/components/create_or_update_document_dialog.dart | Idem |
| Alterar | .../sections/categories_section.dart, team_section.dart, users_section.dart, media_section.dart, library_section.dart | `_save` devolve `Future<String?>` |
| Apagar | lib/app/core/components/field/app_document_field.dart, app_multiselect_field.dart, app_dropdown_field.dart | Sem uso depois da troca (conferir com `grep`) |
| Alterar | docs/arquitetura-painel-admin.md | Painel lateral, fluxo do salvar, campos do formulário |

(`...` = `lib/app/features/admin/panel/presentation/components`.)

## Decisões técnicas
- **Rota:** `showGeneralDialog` com `barrierDismissible`, `barrierLabel` "Fechar sem salvar" e a cor de fundo da confirmação (`footerBackground` com `panelDrawerScrimOpacity`). Transição `SlideTransition` da direita, sem animação quando `MediaQuery.disableAnimations`. A rota modal prende o foco e o `Navigator` devolve o foco ao botão que abriu, como na confirmação (030). Alternativa (`Drawer` do `Scaffold` no lado direito) descartada: ficaria presa à `PanelPage` e já é usada pela gaveta do menu.
- **Largura:** `min(460, largura)` a partir de 600; abaixo, tela cheia e os dois botões do pé em `Expanded`. Altura total, sem cantos arredondados à direita.
- **Semântica:** `Semantics(scopesRoute, namesRoute, label: título)` e título com `header`. "×" é `AppIconButton` com `label` "Fechar" e `tooltip` "Fechar sem salvar".
- **Salvando:** o `PanelSheet` guarda `_saving`; `PopScope(canPop: !_saving)` segura Esc e fundo; "×" e "Cancelar" ficam inativos; "Salvar" usa `isLoading` com "Salvando…". Campos recebem `readOnly` por um `InheritedWidget` (`PanelSheet.isSavingOf`) e o corpo fica sob `AbsorbPointer`, para caixas e cartões. Fechar no sucesso só se a rota ainda for a atual (`ModalRoute.isCurrent`), para não fechar a página do painel por engano.
- **Validação e foco:** cada formulário passa ao `PanelSheet` a lista ordenada dos campos (`GlobalKey<FormFieldState>` + `FocusNode`). Depois do `validate()`, o primeiro com `hasError` recebe `Scrollable.ensureVisible` e foco. Não usar `validateGranularly`, que devolve um conjunto sem ordem garantida.
- **Enter envia:** campos de uma linha usam `textInputAction: done` e `onSubmitted` chamando `PanelSheet.submitOf(context)`. Na descrição, Enter quebra a linha.
- **Erro do salvar:** `FormErrorAlert` no topo do corpo, com rolagem até ele; o texto vem de `state.failure.message`. Some ao salvar de novo.
- **Mensagens:** `panel_validators.dart` repete as regras de `Validators` (vazio sem `trim`, regex de e-mail, senha e URL de hoje) só trocando o texto: "Preencha este campo.", "Informe um e-mail válido."; senha e Lattes com as mensagens atuais. Não usar `FormValidators` do site, que ignora espaços nas pontas e tem outra regex (seria regra nova).
- **Endereço da categoria:** `FormTextField` só leitura com fundo `surface`; dica "Vira o fim do link: /publicacoes/{área}/{endereço}" com `PostsAreas.routeKey` da área marcada (Geografia quando nenhuma ou as duas), recalculada ao marcar.
- **Áreas e categorias:** `PanelCheckGroup<T>` com `Checkbox` dentro de `InkWell` que ocupa a linha (nome acessível = texto), rótulo do grupo lido antes. Categorias em caixa com altura máxima 220 e `Scrollbar` própria. Erro por `FormField<List<T>>`.
- **Papel:** `PanelChoiceCards<UserRole>` com `RadioGroup` (setas trocam, Tab entra no grupo uma vez), cada cartão com `Radio`, título e explicação de `user_role_label.dart` (explicações novas na mesma extensão). Escolhido com borda `accent` e fundo `accentSoft`. Salva `UserRole` como hoje (`ADMIN`/`EDITOR`/`VIEWER`).
- **Imagem:** `PanelImageField` com `ValueNotifier<FileModel?>` para o arquivo escolhido, no lugar do `StreamController<Completer>` de hoje; o modelo montado é o mesmo (`url`, `bytes`, `name`). Prévia: bytes escolhidos (`Image.memory` com `cacheWidth` para imagem grande) ou URL atual (`FittedNetworkImage`, `cover`); sem nada ou com falha, placeholder com ícone e "Escolher imagem"/"Escolher foto". Área clicável é `InkWell` com nome acessível; sem Storage, a área só mostra a imagem e a mensagem atual de envio desabilitado. Escolher um arquivo limpa o endereço, como hoje. Extensões de hoje.
- **Arquivo do documento:** `PanelFileField` igual, sem prévia: ícone, "Escolher PDF" e o nome escolhido ou o fim do endereço atual numa linha com reticências. Extensões de hoje (pdf, doc, docx, xls, xlsx, ppt, pptx).
- **Tipo de produção:** `LibraryFilterSelect` (já focável, com teclado e menu) com `height` 48 e `expand`, envolto em `FormField` com rótulo e erro. Opção vazia "Escolha o tipo".
- **Mídia:** "Escolher imagem" abre o seletor; o nome aparece num `FormTextField` só leitura; "Salvar" fica inativo sem arquivo e sem Storage (`PanelSheet.canSave`).
- **Interruptor:** `PanelSwitchField` com título, dica e `Switch` (trilho desligado `fieldBorder`); a linha inteira alterna, com `Semantics(toggled)`. O `SwitchButton` fica para as publicações.
- **Foco ao abrir:** o primeiro campo recebe `autofocus` (no usuário editando, o nome só leitura; na mídia, a área de escolha).
- **`FormTextField`:** só parâmetros opcionais com padrão igual ao de hoje; Contato, Colabore e login não mudam.

## Dependências e geração de código
- Nenhum pacote novo (`file_picker` já existe; `RadioGroup` é do Flutter 3.44).
- Sem `build_runner`: nenhum store ou modelo muda.
- Sem mudança em rotas, `AppRoutes` ou `*_setup.dart`.

## Riscos e cuidados
- **Pop duplo:** se o `showPanelActionResult` ainda fechar algo em `save` e o `PanelSheet` também, fecha a `PanelPage`. Conferir em modo debug salvar nas cinco seções e publicar pelo diálogo antigo.
- **Publicações:** continuam no diálogo antigo; conferir criar e editar uma publicação (fecha no sucesso, aviso flutuante no erro).
- **`FormTextField` e `FormErrorAlert` são do site e do login:** conferir Contato e Colabore (enviar vazio, quatro erros) e login (credencial errada) em 390 e 1280, com a mesma árvore de semântica.
- **`LibraryFilterSelect`** é da Biblioteca pública e da barra de filtros do painel: só uso, sem mudar o componente; se precisar de parâmetro, opcional.
- **`Forbidden` ao salvar:** encerra a sessão com o painel lateral aberto. Conferir no app de teste que a ida ao login não deixa o painel por cima.
- **Imagem grande:** decodificar sem `cacheWidth` pode travar a prévia; conferir com uma imagem de alguns MB.
- **Foco preso e volta do foco:** conferir com Tab até o fim (volta ao "×") e Esc, nos dois casos: aberto por "Novo…" e por "Editar" da linha (a linha é recriada no sucesso, mas mantém a chave).
- Sem credenciais: salvar no Firestore e enviar ao Storage de verdade ficam como não conferidos.

## Como conferir
- `fvm flutter analyze` e `fvm dart format` na cópia ASCII (`scratchpad/obs`); copiar os formatados de volta. Projeto inteiro com `--set-exit-if-changed`.
- App de teste (`scratchpad/obs/lib/main_harness.dart`, fora do git), ampliado com:
  - atraso de 800 ms ao salvar, para ver "Salvando…" e tentar Enter e clique duplos;
  - `?falha=salvar` (todas as seções devolvem erro ao salvar) e `?falha=proibido` (`Forbidden` ao salvar);
  - registro no console do que chega aos repositórios falsos (`SAVE_CALL` com o modelo em JSON), para comparar com o que os formulários de hoje mandam;
  - categoria com imagem quebrada e descrição longa; membro com foto quebrada, sem foto e com Lattes; documento com título longo e endereço de PDF longo; usuário com e-mail longo;
  - build com `--dart-define=APP_ENV=prod` para a área de envio aparecer (os repositórios continuam falsos); escolha de arquivo pelo CDP (`Page.setInterceptFileChooserDialog` + `DOM.setFileInputFiles`) com uma imagem de alguns MB e um PDF de nome longo; se o seletor não puder ser automatizado, fica como não conferido.
- Chrome headless (CDP) em 390, 768 e 1280 contra a aba "Painel" do protótipo (`.sheet`, `.checks.box`, `.roles`, `.drop`, `.switch`): cada formulário aberto, rolado até o fim, com erro de validação e com erro ao salvar; `scrollWidth` igual à largura.
- Teclado: Tab do primeiro campo ao "Salvar" e de volta ao "×"; setas nos cartões de papel; Espaço nas caixas e no interruptor; Esc fecha e devolve o foco.
- Build web release do site: Contato, Colabore e login.
- Uma vez em `fvm flutter run -d web-server` (debug) com o app de teste, sem `overflow` nem asserção.
