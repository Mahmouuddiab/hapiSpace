import '../entities/order_entity.dart';

abstract class HistoryRepo {
  Future<List<OrderEntity>> getHistory();
}
