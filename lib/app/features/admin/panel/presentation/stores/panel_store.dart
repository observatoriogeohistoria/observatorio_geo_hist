import 'package:mobx/mobx.dart';

part 'panel_store.g.dart';

class PanelStore = PanelStoreBase with _$PanelStore;

abstract class PanelStoreBase with Store {
  @observable
  bool passwordVisible = false;

  @action
  void togglePasswordVisibility() {
    passwordVisible = !passwordVisible;
  }
}
