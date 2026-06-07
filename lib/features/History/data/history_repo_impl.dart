import '../domain/Repository/history_repo.dart';
import '../domain/entities/order_entity.dart';
import 'history_data_source.dart';

class HistoryRepoImpl implements HistoryRepo {
  final HistoryDatasource historyDataSource;

  HistoryRepoImpl({required this.historyDataSource});

  @override
  Future<List<OrderEntity>> getHistory() async {
    return await historyDataSource.getHistory();
  }
}
