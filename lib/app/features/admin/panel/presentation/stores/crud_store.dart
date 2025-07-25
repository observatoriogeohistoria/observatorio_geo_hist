import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/models/states/crud_states.dart';

abstract class CrudStore<T> {
  ObservableList<T> items = ObservableList<T>();
  CrudState state = CrudInitialState();

  Future<void> getItems() async {}
  Future<void> createOrUpdateItem(T item, {dynamic extra}) async {}
  Future<void> deleteItem(T item) async {}
}
