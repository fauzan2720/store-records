import 'package:flutter/material.dart';
import 'package:store_records/core.dart';
import 'package:store_records/util/currency_format.dart';

class PosView extends StatefulWidget {
  const PosView({Key? key}) : super(key: key);

  Widget build(context, PosController controller) {
    controller.view = this;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Point of Sales"),
        actions: const [],
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
                        (event) => Card(
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    Text(CurrencyFormat.convertToIdr(
                                        event["price"], 2)),
                                  ],
                                ),
                                event["quantity"] == 0
                                    ? ElevatedButton(
                                        onPressed: () =>
                                            controller.addQuantity(event["id"]),
                                        child: const Text(
                                          "Select",
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                      )
                                    : Row(
                                        children: [
                                          IconButton(
                                            onPressed: () => controller
                                                .reduceQuantity(event["id"]),
                                            icon:
                                                const Icon(Icons.remove_circle),
                                          ),
                                          Text(event["quantity"].toString()),
                                          IconButton(
                                            onPressed: () => controller
                                                .addQuantity(event["id"]),
                                            icon: const Icon(Icons.add_circle),
                                          ),
                                        ],
                                      )
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(14.0),
        height: 120.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
                "${ProductService().totalQuantity().toString()} items selected"),
            const SizedBox(
              height: 4.0,
            ),
            ElevatedButton(
              onPressed: () => controller.checkoutNow(),
              child: SizedBox(
                height: 50.0,
                width: Get.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Checkout Now",
                      style: TextStyle(
                        color: Colors.blueGrey,
                      ),
                    ),
                    Text(
                      CurrencyFormat.convertToIdr(
                          ProductService().totalPayment(), 2),
                      style: const TextStyle(
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  State<PosView> createState() => PosController();
}
