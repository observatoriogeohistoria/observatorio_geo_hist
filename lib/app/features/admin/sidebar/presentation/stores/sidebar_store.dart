import 'package:mobx/mobx.dart';

part 'sidebar_store.g.dart';

class SidebarStore = SidebarStoreBase with _$SidebarStore;

abstract class SidebarStoreBase with Store {
  @observable
  bool isCollapsed = false;

  @action
  void toggleCollapse() {
    isCollapsed = !isCollapsed;
  }
}
