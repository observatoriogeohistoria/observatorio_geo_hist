import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/enums/sidebar_item.dart';

part 'sidebar_store.g.dart';

class SidebarStore = SidebarStoreBase with _$SidebarStore;

abstract class SidebarStoreBase with Store {
  @observable
  bool isCollapsed = false;

  @observable
  bool showPostsSubItems = false;

  @observable
  SidebarItem selectedItem = SidebarItem.users;

  @observable
  PostType? selectedPostType;

  @action
  void toggleCollapse() {
    isCollapsed = !isCollapsed;
  }

  @action
  void toggleShowPostsSubItems() {
    showPostsSubItems = !showPostsSubItems;
  }

  @action
  void selectItem(SidebarItem item) {
    selectedItem = item;
  }

  @action
  void selectPostType(PostType item) {
    selectedPostType = item;
  }
}
