# Plano da 033. Editor de publicação em página própria

- **Spec:** spec.md
- **Criado em:** 2026-10-20

## Abordagem
Uma página nova, `PostEditorPage`, fora da moldura do painel (sem barra nem menu), atende as duas rotas novas. Ela tem a barra fixa no topo e, abaixo, uma área com rolagem própria: coluna principal flexível e lateral de 340 px a partir de 1024, uma coluna só antes disso. As duas rotas usam a mesma chave de página, para que salvar uma publicação nova e trocar para o endereço de edição atualize a página no lugar, sem perder o que está na tela.

Os dados passam por um store novo, `PostEditorStore`: carrega a publicação pelo caminho direto `posts/{categoria}/category_posts/{id}` (método novo `getPost` no datasource e no repositório, sem mudar o que é gravado) e salva pelo `createOrUpdatePost` de hoje. Cada botão da barra monta o `PostModel` inteiro com `isPublished` e `isHighlighted` vindos da tela; o resto da montagem (corpo, `createdAt`, `updatedAt`, imagem e categoria antiga) é o mesmo dos diálogos atuais. A página espera o resultado e decide o aviso, sem o `PendingPanelAction`.

A coluna lateral é comum aos 10 tipos e reaproveita os campos da 032 (`PanelCheckGroup`, `PanelSelectField`, `PanelSwitchField`, `PanelImageField`, `FormTextField`, `StatusBadge`). A principal vem de um formulário por tipo, todos sobre a mesma base: a lista ordenada dos campos (chave do `FormField`, foco e rótulo, para o resumo do que falta) e a montagem do corpo. O artigo vem primeiro, com a autoria; os outros 9 tipos seguem, e por fim saem o diálogo de duas etapas, os 10 diálogos, o `PostFormDialog`, o `saveInDialog` e os campos antigos que ficarem sem uso.

O `EditorQuill` passa a receber o `QuillController` de fora (some o `StreamController<Completer>`), cresce com o texto dentro da rolagem da página, devolve o texto sem formatação para a validação e solta o Tab pelo `onKeyPressed` do Quill, para o foco seguir a ordem da página.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | lib/app/core/routes/app_routes.dart | `panelPostNewPattern`, `panelPostEditPattern`, `panelPostNew(tipo)`, `panelPostEdit(categoria, id)` |
| Alterar | lib/app/router/app_router.dart | Duas rotas com a mesma chave (`_editorPage`), `onExit` para a confirmação de saída, `?tipo=` inválido mostra `PageNotFound` |
| Alterar | lib/app/features/admin/panel/infra/datasources/posts_datasource.dart | `getPost(categoryKey, id)` com a categoria preenchida; documento ausente lança `PostNotFoundException` |
| Alterar | lib/app/features/admin/panel/infra/repositories/posts_repository.dart | `getPost` com `Either`; `GetPostFailure` e `PostNotFoundFailure` |
| Alterar | lib/app/features/admin/panel/infra/errors/posts_failures.dart | As duas falhas, com mensagens em português |
| Criar | lib/app/features/admin/panel/presentation/stores/post_editor_store.dart (+ `.g.dart`) | Estados de carregar e de salvar, publicação atual |
| Alterar | lib/app/features/admin/panel/panel_setup.dart | Registro do `PostEditorStore` (`registerFactory`, um por página) |
| Criar | lib/app/features/admin/panel/presentation/pages/post_editor_page.dart | Sessão, permissão, carregar, estados, montagem do `PostModel`, salvar, avisos, confirmação de saída |
| Criar | .../editor/post_editor_bar.dart | Voltar, título, selo, "Salvo pela última vez", ações; quebra em 390 |
| Criar | .../editor/post_editor_layout.dart | Duas colunas ou uma, largura máxima, rolagem |
| Criar | .../editor/post_editor_card.dart | Cartão branco com sobretítulo opcional |
| Criar | .../editor/post_editor_side.dart | Situação, Onde aparece, Imagem (com legenda quando houver) |
| Criar | .../editor/post_editor_authors.dart | Um campo por autor, "×", "+ Adicionar autor", foco no novo |
| Criar | .../editor/post_editor_missing_alert.dart | Resumo "Para publicar/salvar, falta preencher:" com links |
| Criar | .../editor/post_editor_skeleton.dart | Esqueleto das duas colunas |
| Criar | .../editor/post_editor_labels.dart | "Novo/Nova …", "Editar …" por tipo, com gênero |
| Criar | .../editor/post_editor_form.dart | Base dos formulários: `PostEditorField` (chave, foco, rótulo), `PostEditorFormState` (campos, corpo, alteração) |
| Criar | .../editor/forms/article_editor_form.dart | Artigo |
| Criar | .../editor/forms/{book,film,magazine,music,podcast,document,event,academic_production,search}_editor_form.dart | Os outros 9 tipos, com os campos e regras de hoje |
| Criar | lib/app/core/utils/browser/leave_guard.dart (+ `_web`, `_stub`) | `beforeunload` do navegador ligado e desligado pela página |
| Alterar | lib/app/core/components/quill/editor_quill.dart | Controller de fora, sem altura fixa, Tab livre, barra no visual do tema, erro e nome acessível |
| Alterar | .../sheet/panel_image_field.dart | Opcionais: "Remover", "Cortada em 16:10 nos cards", texto de apoio da área e mensagem de erro própria; o padrão continua o da 032 |
| Alterar | .../sheet/panel_validators.dart | Mensagens do editor ("Dê um título à publicação.", "Escreva o texto da publicação." etc.) |
| Alterar | lib/app/theme/app_dimensions/app_dimensions.dart | Tokens do editor (barra, colunas, cartão, gaps, altura mínima do texto, autor) |
| Alterar | lib/app/theme/app_typography/app_text_styles.dart | `editorTitleField`, `editorBarTitle`, `editorCardEyebrow` (o que não houver) |
| Alterar | .../sections/posts_section.dart | "Novo …" e "Editar" navegam para as rotas; sai `_save` e `saveInDialog` |
| Alterar | .../sections/panel_action.dart | Sai `saveInDialog` |
| Apagar | .../dialogs/create_or_update_post_dialog.dart, post_form_dialog.dart, create_or_update_posts_dialogs/* | Trocados pela página |
| Apagar | Sem uso depois da troca (conferir com `grep`): `app_text_field.dart`, `app_image_field.dart`, `app_dropdown_field.dart`, `panel_field_decoration.dart`, `switch_button.dart`, `form_label.dart`, `panel_dialog_title.dart` | `right_aligned_dialog.dart` fica (usado pelo `view_image_dialog`) |
| Alterar | docs/arquitetura-painel-admin.md | Editor, rotas, store, saída sem salvar; tira o diálogo das publicações |

(`...` = `lib/app/features/admin/panel/presentation/components`.)

## Decisões técnicas
- **Rotas:** `'$panel/$publicationsSegment/nova'` e `'$panel/$publicationsSegment/:categoria/:id/editar'`, declaradas antes de `panelTabPattern`. Não colidem com `/admin/painel/:tab` nem com `biblioteca/:area` (número de segmentos diferente). `?tipo=` passa por `PostType.fromString`; ausente ou inválido, `PageNotFound`. `MaterialPage(key: ValueKey('editor'))` nas duas.
- **Sessão e permissão:** como a `PanelPage`: `authStore.currentUser()` no `initState` e `reaction` no usuário; `null` vai para `/admin`, `VIEWER` (`!canEditPostsSection`) vai com `go` para a lista do tipo. O `redirect` do roteador não muda (ver histórico da spec).
- **Carregar:** `getPost` lê o documento e o de `posts/{categoria}` (para a categoria vir preenchida, como na lista). Documento ausente vira `PostNotFoundFailure`; o erro mostra "Tentar de novo" (só na falha comum) e "Voltar para {tipo}" (tipo carregado ou, sem ele, `sidebarStore.selectedPostType` ou Artigos).
- **Salvar:** `PostAction { publish, saveDraft, saveChanges, unpublish }` decide `isPublished` e o aviso. Antes, valida o `Form` e os campos fora dele (texto do Quill, imagem); com erro, monta o resumo. Salvando: botão clicado com "Salvando…" e os quatro inativos, campos sob `AbsorbPointer` com `readOnly`. Sucesso: guarda o `PostModel` devolvido como nova base, a imagem vira URL (como `_keepImage` faz na lista, para não reenviar), zera a alteração, recarrega as contagens, mostra o aviso; publicação nova troca o endereço com `Router.neglect` + `go(panelPostEdit(...))`. Erro: `Messenger.showError`; `Forbidden` chama `authStore.logout`.
- **Categoria antiga:** a mesma regra de hoje (categoria mudou numa publicação existente → `pastCategory`). Depois de mover, o endereço troca para a categoria nova, também com `Router.neglect`.
- **Onde aparece:** `PanelCheckGroup` (História, Geografia) e `PanelSelectField` com as categorias do `CategoriesStore` filtradas pelas áreas marcadas, opção vazia "Escolha a categoria" e "Nenhuma categoria nesta área" sem opções. Desmarcar a área da categoria escolhida limpa a categoria. A página chama `categoriesStore.getItems()` se a lista estiver vazia; falha de categorias entra no estado de erro do carregamento.
- **Imagem:** `PanelImageField` com `ValueNotifier<FileModel?>`, sobre a área 16:10 da 032, com "Remover" (limpa arquivo e endereço e devolve o foco à área) e "Cortada em 16:10 nos cards" quando há imagem; placeholder com "Trocar imagem" na falha. Mantém o endereço da imagem e as extensões de hoje. Mensagem de obrigatório: "Escolha uma imagem. Ela aparece no card e no topo do post."
- **Editor de texto:** `EditorQuill(controller, focusNode, label, errorText, minHeight)`. `QuillEditorConfig(scrollable: false, expands: false, onKeyPressed:)` devolvendo `KeyEventResult.ignored` no Tab, para o atalho padrão do Flutter levar o foco ao próximo (Shift+Tab, ao anterior); se o navegador ficar com o evento, a página chama `FocusScope.nextFocus/previousFocus` e devolve `handled`. Recuo continua nos botões da barra. Barra: `QuillSimpleToolbar` com os mesmos `show*` de hoje, `showDividers: true`, ícones em `ink`, fundo `surface`, dentro de `Semantics(container, label: 'Formatação do texto')` e `FocusTraversalGroup`. Vazio = `document.toPlainText().trim().isEmpty`. A letra da música continua opcional.
- **Formulários por tipo:** cada um é um `StatefulWidget` com `GlobalKey<PostEditorFormState>`; a página pede `fields` (ordem do resumo, já com os campos da lateral na ordem da tela), `buildBody(FileModel image)` e escuta `onChanged`. Campos e validadores são os de hoje, só com `FormTextField`/`PanelSelectField` e as mensagens novas onde a spec diz; listas suspensas de tipo (categoria do livro, filme, revista, documento e produção; abrangência do evento; estado da pesquisa) com `PanelSelectField`.
- **Resumo do que falta:** `FormErrorAlert`-like com título e lista de `InkWell`s (links), `liveRegion`; recebe o foco ao aparecer (`Focus` com `skipTraversal: false`). Cada link chama `Scrollable.ensureVisible` e foca o campo. Some ao salvar com sucesso; atualiza a cada tentativa.
- **Sair sem salvar:** `onExit` nas duas rotas pergunta à página (`PostEditorPage.confirmLeave`, por um `ValueNotifier<bool>` estático de alteração ou por `GlobalKey`); com alteração, `showConfirmDialog(title: 'Sair sem salvar?', confirmText: 'Sair sem salvar', cancelText: 'Continuar editando', confirmIcon: null)` com foco inicial em "Continuar editando". Se a pessoa continuar depois do voltar do navegador, a página repõe o endereço do editor com `SystemNavigator.routeInformationUpdated`. Fechar ou recarregar a aba: `beforeunload` ligado só enquanto há alteração (`package:web`, já dependência).
- **Alteração:** um `bool` que vira `true` no primeiro `onChanged` de campo, caixa, lista, interruptor, autor, imagem ou mudança de documento do Quill (`document.changes`), e volta a `false` ao salvar com sucesso. Sem comparar conteúdo.
- **Barra:** `Wrap` com "← {tipo}" (`AppTextButton`/ghost com ícone), título (`Semantics(header)`, reticências no celular), `StatusBadge` (`ok`/`neutral`), "Salvo pela última vez em {`updatedAt.shortDate`}" ou "Ainda não salvo" em `inkSecondary` (some abaixo de 600) e as ações (`SecondaryButton` + `PrimaryButton`, `Expanded` meio a meio abaixo de 600).
- **Foco ao abrir:** o primeiro campo (título; na música, nome da música) com `autofocus` depois de carregar. Ordem de Tab: barra, principal, lateral (`FocusTraversalGroup` por região, `OrderedTraversalPolicy` só se a ordem natural falhar).
- **Botão "Novo …" da seção e "Editar" da linha:** `GoRouter.go`. O `isActionDisabled` da seção deixa de depender das categorias.

## Dependências e geração de código
- Nenhum pacote novo (`flutter_quill` 11.6.0, `go_router` 14.2.8 com `onExit`, `web` e `file_picker` já existem).
- `build_runner` depois de criar o `PostEditorStore`.
- Rotas novas em `AppRoutes` e `app_router.dart`; as existentes não mudam.
- `PanelSetup` registra o store novo. O app de teste (`scratchpad/obs/lib/main_harness.dart`, fora do git) precisa do `getPost` no repositório falso e das rotas novas no roteador dele.

## Riscos e cuidados
- **Gravado igual ao de hoje:** antes de trocar o código, registrar no app de teste o JSON completo que os 10 diálogos mandam ao salvar (criar e editar), e comparar depois tipo a tipo. Diferenças esperadas, e só elas: `isPublished`/`isHighlighted` conforme o botão e `updatedAt`.
- **Tab no Quill:** o `onKeyPressed` é marcado como experimental; conferir Tab e Shift+Tab nas três caixas de texto (artigo, filme, documento, música) e que Ctrl+M (recuo) continua.
- **Quill sem rolagem própria dentro da página:** conferir cursor e seleção num texto longo (o cursor fica visível ao digitar no fim) e que a barra continua fixa.
- **`onExit` e voltar do navegador:** o endereço pode ficar na lista com o editor na tela se a pessoa escolher continuar; conferir no Chrome e, se a reposição não funcionar, registrar como ressalva.
- **`PanelImageField` e `FormTextField` são usados pelos painéis laterais (032) e pelo site:** parâmetros novos só opcionais; conferir categoria, membro e mídia (imagem) e Contato, Colabore e login sem mudança.
- **`showConfirmDialog`:** já abre com foco no botão de cancelar ("Continuar editando") e o confirmar é `DangerButton`; usado sem mudar o componente. Conferir que a exclusão continua igual.
- **Seção de publicações:** depois de voltar do editor a lista recarrega (o `PostsSection` busca de novo ao montar) e mostra a publicação salva; conferir também publicar, destacar e excluir pela lista.
- **Recarregar a página do editor:** depende da sessão voltar a tempo, como nas abas do painel; sem credenciais, conferido só no app de teste.
- **Apagar campos antigos:** só depois do `grep` sem uso; o `view_image_dialog` ainda usa o `RightAlignedDialog`.

## Como conferir
- `fvm flutter analyze` e `fvm dart format` na cópia ASCII (`scratchpad/obs`, roteiros `tools/fmt.sh` e `tools/bh.sh`); projeto inteiro com `--set-exit-if-changed`.
- App de teste ampliado: uma publicação de cada tipo, com imagem boa, quebrada e ausente, título longo, 10 autores e texto longo; atraso de 800 ms ao salvar; `?falha=salvar`, `?falha=proibido`, `?falha=carregar` e id inexistente; usuário `VIEWER`; registro `SAVE_CALL` com o JSON completo.
- Chrome headless (CDP) em 390, 768 e 1280 contra a aba "Editor" do protótipo (`.ed-bar`, `.ed-grid`, `.ed-card`, `.drop`, `.author`, `.alert`): `scrollWidth` igual à largura, barra fixa ao rolar, resumo, autores, imagem, os 10 tipos.
- Teclado: Tab da barra ao fim da lateral, passando pelos editores de texto sem ficar preso; links do resumo; confirmação de saída.
- Uma vez em `fvm flutter run -d web-server` (debug) com o app de teste, sem asserção, exceção ou `overflow`.
- Não conferido sem credenciais: salvar no Firestore, enviar ao Storage e destaques da Home lendo o Firestore de verdade (conferido pelo que chega ao repositório).
