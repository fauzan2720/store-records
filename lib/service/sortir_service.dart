import 'package:store_records/core.dart';

class SortHistory {
  static void sortByRecentTransactions() {
    HistoryService()
        .history
        .sort((b, a) => a["created_at"].compareTo(b["created_at"]));
    HomeController.instance.refresh();
    Get.back();
    HistoryService().saveToLocalStorage();
  }

  static void sortByOldestTransactions() {
    HistoryService()
        .history
        .sort((a, b) => a["created_at"].compareTo(b["created_at"]));
    HomeController.instance.refresh();
    Get.back();
    HistoryService().saveToLocalStorage();
  }

  static void sortByMostRevenue() {
    HistoryService()
        .history
        .sort((b, a) => a["total_payment"].compareTo(b["total_payment"]));
    HomeController.instance.refresh();
    Get.back();
    HistoryService().saveToLocalStorage();
  }

  static void sortByBestSellingProducts() {
    HistoryService()
        .history
        .sort((b, a) => a["total_quantity"].compareTo(b["total_quantity"]));
    HomeController.instance.refresh();
    Get.back();
    HistoryService().saveToLocalStorage();
  }
}

class SortProduct {
  static void sortByProductName() {
    ProductService()
        .product
        .sort((a, b) => a["product_name"].compareTo(b["product_name"]));
    ProductController.instance.refresh();
    Get.back();
    ProductService().saveToLocalStorage();
  }

  static void sortByRecentProduct() {
    ProductService()
        .product
        .sort((b, a) => a["created_at"].compareTo(b["created_at"]));
    ProductController.instance.refresh();
    Get.back();
    ProductService().saveToLocalStorage();
  }

  static void sortByOldestProduct() {
    ProductService()
        .product
        .sort((a, b) => a["created_at"].compareTo(b["created_at"]));
    ProductController.instance.refresh();
    Get.back();
    ProductService().saveToLocalStorage();
  }

  static void sortByCheapestProduct() {
    ProductService().product.sort((a, b) => a["price"].compareTo(b["price"]));
    ProductController.instance.refresh();
    Get.back();
    ProductService().saveToLocalStorage();
  }

  static void sortByMostExpensiveProduct() {
    ProductService().product.sort((b, a) => a["price"].compareTo(b["price"]));
    ProductController.instance.refresh();
    Get.back();
    ProductService().saveToLocalStorage();
  }
}
