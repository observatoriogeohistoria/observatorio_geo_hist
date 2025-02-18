import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/enums/sidebar_item.dart';

part 'sidebar_store.g.dart';

class SidebarStore = SidebarStoreBase with _$SidebarStore;

abstract class SidebarStoreBase with Store {
  @observable
  bool isCollapsed = false;

  @observable
  SidebarItem selectedItem = SidebarItem.users;

  @action
  void toggleCollapse() {
    isCollapsed = !isCollapsed;
  }

  @action
  void selectItem(SidebarItem item) {
    selectedItem = item;
  }
}
