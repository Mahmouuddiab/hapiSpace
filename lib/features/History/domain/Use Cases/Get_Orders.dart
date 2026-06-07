import '../Repository/history_repo.dart';
import '../entities/order_entity.dart';

class GetOrders {
  final HistoryRepo historyRepo;

  GetOrders(this.historyRepo);

  Future<List<OrderEntity>> call() {
    return historyRepo.getHistory();
  }
}
