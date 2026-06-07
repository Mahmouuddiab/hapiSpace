import 'package:bloc/bloc.dart';
import 'package:habiSpace/features/History/domain/entities/order_entity.dart';
import '../../../../../core/error/app_exception.dart';
import '../../../domain/Use Cases/Get_Orders.dart';
part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final GetOrders getOrders;

  HistoryCubit(this.getOrders) : super(HistoryInitial());

  Future<void> getHistory() async {
    emit(HistoryLoading());
    try {
      final result = await getOrders();
      emit(HistorySuccess(orders: result));
    } catch (e) {
      emit(HistoryError(error: handleException(e).message));
    }
  }

  void search(String query) {
    final current = state;
    if (current is HistorySuccess) {
      emit(current.copyWith(searchQuery: query));
    }
  }
}
