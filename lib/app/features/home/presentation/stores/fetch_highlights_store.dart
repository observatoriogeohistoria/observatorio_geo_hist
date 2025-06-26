import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/repositories/fetch_highlights_repository.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/stores/states/fetch_highlights_states.dart';

part 'fetch_highlights_store.g.dart';

class FetchHighlightsStore = FetchHighlightsStoreBase with _$FetchHighlightsStore;

abstract class FetchHighlightsStoreBase with Store {
  final FetchHighlightsRepository _repository;

  FetchHighlightsStoreBase(this._repository);

  @observable
  ObservableList<PostModel> highlights = ObservableList<PostModel>();

  @observable
  FetchHighlightsState state = FetchHighlightsInitialState();

  @observable
  bool highlightsDialogWasShown = false;

  @observable
  bool highlightsDialogIsOpen = false;

  @action
  Future<void> fetchHighlights(List<CategoryModel> categories) async {
    state = FetchHighlightsLoadingState();

    final result = await _repository.fetchHighlights(categories);

    result.fold(
      (error) {
        state = FetchHighlightsErrorState(error.message);
      },
      (highlights) {
        this.highlights = highlights.asObservable();
        state = FetchHighlightsSuccessState();
      },
    );
  }

  @action
  void showHighlights() {
    highlightsDialogWasShown = true;
    highlightsDialogIsOpen = true;
  }

  @action
  void hideHighlights() {
    highlightsDialogIsOpen = false;
  }
}
