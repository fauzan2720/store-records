import 'package:flutter/material.dart';
import 'package:store_records/core.dart';
import 'package:store_records/util/show_alert.dart';
import 'package:store_records/util/show_success.dart';

class PosController extends State<PosView> implements MvcController {
  static late PosController instance;
  late PosView view;

  @override
  void initState() {
    instance = this;
    super.initState();
  }

  @override
  void dispose() => super.dispose();

  void addQuantity(String id) {
    ProductService().addQuantity(id);
    setState(() {});
  }

  void reduceQuantity(String id) {
    ProductService().reduceQuantity(id);
    setState(() {});
  }

  void checkoutNow() async {
    if (ProductService().totalQuantity() != 0) {
      // print("list: ${HistoryService().history}");
      await HistoryService().addHistory(
        products: ProductService()
            .product
            .where((element) => element["quantity"] > 0)
            .map((e) => "${e["quantity"]}x | ${e["product_name"]}")
            .toList(),
        totalQuantity: ProductService().totalQuantity(),
        totalPayment: ProductService().totalPayment(),
      );
      Get.back();
      showSuccess();
      ProductService().clearQuantity();
      HomeController.instance.setState(() {});
    } else {
      showAlert("Oppsss", "No products found");
    }
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}
