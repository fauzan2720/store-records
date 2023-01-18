import 'package:store_records/session.dart';
import 'package:uuid/uuid.dart';

class HistoryService {
  List history = mainStorage.get("history") ?? [];

  saveToLocalStorage() async {
    await mainStorage.put("history", history);
  }

  addHistory({
    required List products,
    required int totalQuantity,
    required double totalPayment,
  }) {
    history.add({
      "id": const Uuid().v4(),
      "products": products,
      "total_quantity": totalQuantity,
      "total_payment": totalPayment,
      "created_at": DateTime.now().toString(),
    });

    history.sort((b, a) => a["created_at"].compareTo(b["created_at"]));

    saveToLocalStorage();
    print('Successfully: $history');
  }

  deleteHistory(String id) {
    history.removeWhere((element) => element["id"] == id);
    saveToLocalStorage();
    print('Successfully: $history');
  }
}
