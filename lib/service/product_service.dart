import 'package:store_records/session.dart';
import 'package:uuid/uuid.dart';

class ProductService {
  List product = mainStorage.get("product") ?? [];

  saveToLocalStorage() async {
    await mainStorage.put("product", product);
  }

  addProduct({
    required String productName,
    required double price,
  }) {
    product.add({
      "id": const Uuid().v4(),
      "product_name": productName,
      "price": price,
      "quantity": 0,
      "created_at": DateTime.now().toString(),
    });

    product.sort((a, b) => a["product_name"].compareTo(b["product_name"]));

    saveToLocalStorage();
    print('Successfully: $product');
  }

  deleteProduct(String id) {
    product.removeWhere((element) => element["id"] == id);
    saveToLocalStorage();
    print('Successfully: $product');
  }

  isProduct(String id) {
    if (product.indexWhere((element) => element["id"] == id) == -1) {
      return false;
    } else {
      return true;
    }
  }

  addQuantity(String id) {
    var targetIndex = product.indexWhere((waste) => waste["id"] == id);
    product[targetIndex]["quantity"]++;
    saveToLocalStorage();
  }

  reduceQuantity(String id) {
    var targetIndex = product.indexWhere((waste) => waste["id"] == id);
    if (product[targetIndex]["quantity"] > 0) {
      product[targetIndex]["quantity"]--;
      saveToLocalStorage();
    }
  }

  int totalQuantity() {
    double totalQuantity = 0;

    for (var i = 0; i < product.length; i++) {
      totalQuantity += product[i]["quantity"];
    }

    return totalQuantity.toInt();
  }

  double totalPayment() {
    double totalPayment = 0;

    for (var i = 0; i < product.length; i++) {
      totalPayment += (product[i]["quantity"] * product[i]["price"]);
    }

    return totalPayment;
  }

  clearQuantity() {
    for (var i = 0; i < product.length; i++) {
      product[i]["quantity"] = 0;
      saveToLocalStorage();
    }
  }
}
