import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/state_message_box.dart';
import 'package:observatorio_geo_hist/app/core/errors/failures.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/models/states/crud_states.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/browser/leave_guard.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/core/utils/messenger/messenger.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/admin/admin_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/errors/auth_failure.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/errors/posts_failures.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/confirm_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/forms/post_editor_forms.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_bar.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_form.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_labels.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_layout.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_missing_alert.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_side.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_skeleton.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/categories_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/panel_counts_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/post_editor_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/labels/post_type_panel_labels.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/stores/sidebar_store.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PostEditorPage extends StatefulWidget {
  const PostEditorPage.create({required PostType this.type, super.key})
      : categoryKey = null,
        postId = null;

  const PostEditorPage.edit(
      {required String this.categoryKey, required String this.postId, super.key})
      : type = null;

  final PostType? type;
  final String? categoryKey;
  final String? postId;

  static final _unsaved = ValueNotifier<bool>(false);
  static String? _location;

  /// Chamado pelo `onExit` das rotas do editor: o voltar, o voltar do navegador e os links.
  static Future<bool> confirmLeave(BuildContext context) async {
    if (!_unsaved.value) return true;

    final leave = await showConfirmDialog(
      context,
      title: 'Sair sem salvar?',
      message: 'As alterações feitas desde a última vez que você salvou serão perdidas.',
      confirmText: 'Sair sem salvar',
      confirmIcon: null,
      cancelText: 'Continuar editando',
    );
    if (leave) {
      _unsaved.value = false;
      return true;
    }

    // No voltar do navegador o endereço já mudou; sem isto ele ficaria na lista com o editor
    // na tela.
    final location = _location;
    final current = browserLocation();
    if (context.mounted && location != null && current != null && current != location) {
      final router = GoRouter.of(context);
      final info = router.routeInformationParser
          .restoreRouteInformation(router.routerDelegate.currentConfiguration);
      if (info != null) {
        router.routeInformationProvider
            .routerReportsNewRouteInformation(info, type: RouteInformationReportingType.navigate);
      }
    }
    return false;
  }

  @override
  State<PostEditorPage> createState() => _PostEditorPageState();
}

class _PostEditorPageState extends State<PostEditorPage> {
  late final _store = PanelSetup.getIt<PostEditorStore>();
  late final _authStore = AdminSetup.getIt<AuthStore>();
  late final _categoriesStore = PanelSetup.getIt<CategoriesStore>();
  late final _sidebarStore = PanelSetup.getIt<SidebarStore>();

  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _alertFocus = FocusNode();
  final _keys = PostEditorSideKeys();
  List<ReactionDisposer> _reactions = [];

  bool _hasAccess = false;
  PostType? _type;
  PostModel? _post;
  PostEditorForm? _form;
  PostEditorImage? _image;

  List<PostsAreas> _areas = [];
  CategoryModel? _category;
  bool _highlighted = false;

  bool _submitted = false;
  List<PostEditorField>? _missing;
  String _missingTitle = '';
  PostEditorAction? _saving;

  bool get _isNew => _post?.id == null && widget.postId == null;

  @override
  void initState() {
    super.initState();
    _type = widget.type;
    PostEditorPage._unsaved.value = false;
    PostEditorPage._unsaved.addListener(_syncLeaveWarning);

    _reactions = [
      reaction((_) => _authStore.user, (UserModel? user) {
        if (user == null) _leave(AppRoutes.admin);
      }),
      reaction((_) => _store.loadState, (CrudState state) {
        if (state is CrudSuccessState && _form == null) setState(() => _setup(_store.post));
      }),
    ];

    if (_categoriesStore.items.isEmpty) _categoriesStore.getItems();
    _checkAccess();
    _load();
  }

  @override
  void didUpdateWidget(covariant PostEditorPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Salvar uma publicação nova (ou mudar a categoria) troca o endereço sem recriar a página.
    final isCurrent = widget.postId == null || widget.postId == _post?.id;
    if (!isCurrent) {
      _reset();
      _load();
    }
  }

  @override
  void dispose() {
    for (final reaction in _reactions) {
      reaction.reaction.dispose();
    }
    PostEditorPage._unsaved.removeListener(_syncLeaveWarning);
    PostEditorPage._unsaved.value = false;
    setLeaveWarning(false);
    _form?.dispose();
    _image?.dispose();
    _keys.dispose();
    _alertFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _syncLeaveWarning() => setLeaveWarning(PostEditorPage._unsaved.value);

  Future<void> _checkAccess() async {
    await _authStore.currentUser();
    if (!mounted) return;

    final user = _authStore.user;
    if (user == null) return _leave(AppRoutes.admin);
    if (!user.permissions.canEditPostsSection) return _leave(AppRoutes.panelPosts(_backType.value));
    setState(() => _hasAccess = true);
  }

  void _leave(String location) {
    PostEditorPage._unsaved.value = false;
    if (mounted) GoRouter.of(context).go(location);
  }

  void _load() {
    final categoryKey = widget.categoryKey;
    final postId = widget.postId;
    if (categoryKey != null && postId != null) {
      _store.load(categoryKey, postId);
    } else {
      _setup(null);
    }
  }

  void _retry() {
    if (_categoriesStore.items.isEmpty) _categoriesStore.getItems();
    _load();
  }

  void _reset() {
    _form?.dispose();
    _image?.dispose();
    _form = null;
    _image = null;
    _post = null;
    _type = widget.type;
    _submitted = false;
    _missing = null;
  }

  void _setup(PostModel? post) {
    final type = post?.type ?? widget.type!;
    final form = postEditorFormFor(type, post?.body);
    final image =
        PostEditorImage(url: post?.body?.image.url, caption: postEditorCaptionOf(post?.body));

    _type = type;
    _post = post;
    _form = form;
    _image = image;
    _areas = [...?post?.areas];
    _category = post?.category ??
        _categoriesStore.items.firstWhereOrNull((category) => category.key == post?.categoryId);
    _highlighted = post?.isHighlighted ?? false;

    form.onEdited = _markUnsaved;
    form.addListener(_rebuild);
    _onTextChange(image.url);
    _onTextChange(image.caption);
    image.file.addListener(_markUnsaved);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) form.firstFocus.requestFocus();
    });
  }

  void _rebuild() => setState(() {});

  void _onTextChange(TextEditingController controller) {
    var last = controller.text;
    controller.addListener(() {
      if (controller.text == last) return;
      last = controller.text;
      _markUnsaved();
    });
  }

  // Depois de salvar a página troca o arquivo pelo endereço; isso não é alteração da pessoa.
  void _markUnsaved() {
    if (_saving == null) PostEditorPage._unsaved.value = true;
  }

  PostType get _backType => _type ?? _sidebarStore.selectedPostType ?? PostType.article;

  void _goBack() => GoRouter.of(context).go(AppRoutes.panelPosts(_backType.value));

  void _changeAreas(List<PostsAreas> areas) {
    final category = _category;
    setState(() {
      _areas = areas;
      if (category != null && !category.areas.any(areas.contains)) _category = null;
    });
    _markUnsaved();
  }

  void _changeCategory(CategoryModel? category) {
    setState(() => _category = category);
    _markUnsaved();
  }

  void _changeHighlight(bool value) {
    setState(() => _highlighted = value);
    _markUnsaved();
  }

  void _removeImage() {
    final image = _image!;
    image.file.value = null;
    image.url.clear();
    _keys.imageFocus.requestFocus();
  }

  List<PostEditorField> get _fields => [
        ..._form!.mainFields,
        ..._keys.fields(hasCaption: _form!.hasCaption),
        ..._form!.sideFields,
      ];

  void _showMissing(PostEditorAction action) {
    final missing = _fields.where((field) => field.key.currentState?.hasError ?? false).toList();
    setState(() {
      _missing = missing;
      _missingTitle = action == PostEditorAction.publish
          ? 'Para publicar, falta preencher:'
          : 'Para salvar, falta preencher:';
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _scrollController.jumpTo(0);
      _alertFocus.requestFocus();
    });
  }

  void _goToField(PostEditorField field) {
    final fieldContext = field.key.currentContext;
    if (fieldContext != null) Scrollable.ensureVisible(fieldContext, alignment: 0.2);
    field.focusNode?.requestFocus();
  }

  Future<void> _save(PostEditorAction action) async {
    final form = _form;
    final image = _image;
    final type = _type;
    if (_saving != null || form == null || image == null || type == null) return;

    setState(() => _submitted = true);
    if (!_formKey.currentState!.validate()) return _showMissing(action);

    final focused = FocusManager.instance.primaryFocus;
    final base = _post;
    final category = _category!;
    final now = DateTime.now();
    final post = PostModel(
      id: base?.id,
      categoryId: category.key,
      category: category,
      areas: [
        if (_areas.contains(PostsAreas.history)) PostsAreas.history,
        if (_areas.contains(PostsAreas.geography)) PostsAreas.geography,
      ],
      type: type,
      body: form.buildBody(image),
      createdAt: base?.createdAt ?? now,
      updatedAt: now,
      isPublished: action.publishes,
      isHighlighted: _highlighted,
    );
    final pastCategory = base?.id != null && base!.categoryId != category.key
        ? base.category ??
            _categoriesStore.items.firstWhereOrNull((item) => item.key == base.categoryId)
        : null;

    setState(() {
      _missing = null;
      _saving = action;
    });

    final result = await _store.save(post, pastCategory);
    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() => _saving = null);
        Messenger.showError(context, failure.message);
        if (failure is Forbidden) {
          PostEditorPage._unsaved.value = false;
          _authStore.logout();
        }
      },
      (saved) {
        // A imagem enviada vira endereço, para salvar de novo não a enviar outra vez.
        image.file.value = null;
        image.url.text = saved.body?.image.url ?? '';
        setState(() {
          _post = _store.post;
          _saving = null;
        });
        PostEditorPage._unsaved.value = false;
        Messenger.showSuccess(
            context,
            switch (action) {
              PostEditorAction.publish => 'Publicado. Já aparece no site.',
              PostEditorAction.saveDraft => 'Rascunho salvo. Não aparece no site.',
              PostEditorAction.saveChanges => 'Alterações salvas.',
              PostEditorAction.unpublish => 'Despublicado. Continua salvo aqui no painel.',
            });
        PanelSetup.getIt<PanelCountsStore>().refresh();

        final moved = base?.id == null || base!.categoryId != saved.categoryId;
        if (moved) {
          Router.neglect(
            context,
            () => GoRouter.of(context).go(AppRoutes.panelPostEdit(saved.categoryId, saved.id!)),
          );
        }
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && focused != null && focused.context != null) focused.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    PostEditorPage._location = GoRouterState.of(context).uri.toString();
    final colors = AppTheme.colors;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Observer(
        builder: (context) {
          final type = _type;
          final loadState = _store.loadState;
          final categoriesState = _categoriesStore.state;
          final loadFailure = loadState is CrudErrorState ? loadState.failure : null;
          final categoriesFailure =
              categoriesState is CrudErrorState && _categoriesStore.items.isEmpty
                  ? categoriesState.failure
                  : null;
          final failure = loadFailure ?? categoriesFailure;
          final isReady = _hasAccess &&
              _form != null &&
              failure == null &&
              (_categoriesStore.items.isNotEmpty || categoriesState is CrudSuccessState);
          final barType = type ?? _backType;

          return FocusTraversalGroup(
            policy: WidgetOrderTraversalPolicy(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FocusTraversalGroup(
                  child: PostEditorBar(
                    type: barType,
                    title: _isNew ? barType.editorNewTitle : barType.editorEditTitle,
                    isLoaded: isReady,
                    isNew: _isNew,
                    isPublished: _post?.isPublished ?? false,
                    savedAt: _post?.updatedAt ?? _post?.createdAt,
                    saving: _saving,
                    onBack: _goBack,
                    onAction: _save,
                  ),
                ),
                Expanded(
                  child: failure != null
                      ? _error(failure)
                      : isReady
                          ? _content(context)
                          : PostEditorSkeleton(controller: _scrollController),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _error(Failure failure) {
    final components = AppTheme.dimensions.components;
    final notFound = failure is PostNotFoundFailure;

    return SingleChildScrollView(
      padding: EdgeInsets.all(components.editorPadding(ScreenUtils.breakpointOf(context))),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: components.editorMaxWidth),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppTheme.colors.page,
              borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r18),
            ),
            child: StateMessageBox(
              icon: Icons.close,
              tone: StateMessageTone.error,
              title: notFound ? 'Publicação não encontrada' : 'Não foi possível carregar',
              message: failure.message,
              action: Wrap(
                alignment: WrapAlignment.center,
                spacing: components.editorBarActionsGap,
                runSpacing: components.editorBarActionsGap,
                children: [
                  if (!notFound) PrimaryButton.small(text: 'Tentar de novo', onPressed: _retry),
                  SecondaryButton.small(
                    text: 'Voltar para ${_backType.panelPlural}',
                    onPressed: _goBack,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    final form = _form!;
    final missing = _missing;
    final isSaving = _saving != null;

    // Trocar os campos para só leitura quebra a entrada de texto no navegador; tirar o foco e
    // o toque já impede a edição enquanto salva.
    return ExcludeFocus(
      excluding: isSaving,
      child: AbsorbPointer(
        absorbing: isSaving,
        child: Form(
          key: _formKey,
          autovalidateMode:
              _submitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
          child: PostEditorLayout(
            controller: _scrollController,
            main: [
              if (missing != null && missing.isNotEmpty)
                PostEditorMissingAlert(
                  title: _missingTitle,
                  fields: missing,
                  focusNode: _alertFocus,
                  onSelect: _goToField,
                ),
              ...form.buildMain(context),
            ],
            side: [
              PostEditorSide(
                keys: _keys,
                isPublished: _post?.isPublished ?? false,
                isHighlighted: _highlighted,
                onHighlightChanged: _changeHighlight,
                areas: _areas,
                onAreasChanged: _changeAreas,
                categories: _categoriesStore.items,
                category: _category,
                onCategoryChanged: _changeCategory,
                image: _image!,
                hasCaption: form.hasCaption,
                onRemoveImage: _removeImage,
                extra: form.buildSide(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
