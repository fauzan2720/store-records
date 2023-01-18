import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:store_records/core.dart';
import 'package:store_records/service/sortir_service.dart';
import 'package:store_records/util/currency_format.dart';
import 'package:store_records/util/show_confirmation.dart';
import 'package:store_records/widget/input_text.dart';

class ProductView extends StatefulWidget {
  const ProductView({Key? key}) : super(key: key);

  Widget build(context, ProductController controller) {
    controller.view = this;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Product"),
        actions: [
          IconButton(
            onPressed: () async {
              bool confirm = false;
              await showDialog<void>(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Center(child: Text('Add Product')),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          FozInputText(
                            value: controller.productName,
                            onChanged: (value) {
                              controller.productName = value;
                            },
                            hintText: "Product Name",
                            prefixIcon: const Icon(Icons.inventory),
                          ),
                          FozInputText(
                            value: controller.price,
                            onChanged: (value) {
                              controller.price = value;
                            },
                            hintText: "Price",
                            prefixIcon: const Icon(Icons.payment),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          confirm = true;
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );

              if (confirm) {
                controller.saveProduct();
              }
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () => controller.exportToExcel(),
            icon: const Icon(Icons.print),
          ),
          IconButton(
            onPressed: () async {
              await showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    padding: const EdgeInsets.all(30.0),
                    child: Wrap(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    SortProduct.sortByProductName(),
                                child: const Text(
                                  "Sort by Product Name",
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    SortProduct.sortByRecentProduct(),
                                child: const Text(
                                  "Sort by Recent Product",
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    SortProduct.sortByOldestProduct(),
                                child: const Text(
                                  "Sort by Oldest Product",
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    SortProduct.sortByCheapestProduct(),
                                child: const Text(
                                  "Sort by Cheapest Product",
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    SortProduct.sortByMostExpensiveProduct(),
                                child: const Text(
                                  "Sort by Most Expensive Product",
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.sort_by_alpha),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: ProductService().product.isEmpty
              ? SizedBox(
                  height: Get.height - 200,
                  child: const Center(
                    child: Text("No Data"),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: ProductService()
                      .product
                      .map(
                        (event) => InkWell(
                          onTap: () => showConfirmation(
                              message: "Delete this product ?",
                              onPressed: () =>
                                  controller.deleteProduct(event["id"])),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        event["product_name"],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4.0,
                                      ),
                                      Text(DateFormat("H:mm - dd MMM y").format(
                                          DateTime.parse(event["created_at"]))),
                                    ],
                                  ),
                                  Text(CurrencyFormat.convertToIdr(
                                      event["price"], 2)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
      ),
    );
  }

  @override
  State<ProductView> createState() => ProductController();
}
