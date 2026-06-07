import 'order_model.dart';

abstract class HistoryDatasource {
  Future<List<OrderModel>> getHistory();
}
