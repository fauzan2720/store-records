import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:store_records/core.dart';
import 'package:store_records/service/sortir_service.dart';
import 'package:store_records/util/currency_format.dart';
import 'package:store_records/util/show_confirmation.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  Widget build(context, HomeController controller) {
    controller.view = this;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: 64.0,
              height: 64.0,
            ),
            const Text("Store Records"),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Get.to(const PosView()),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () => Get.to(const ProductView()),
            icon: const Icon(Icons.list),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: ScrollController(),
                child: Row(
                  children: [
                    Card(
                      child: Container(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Incomes Today",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Text(CurrencyFormat.convertToIdr(
                                controller.handleIncomesToday(), 2)),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Transactions Today",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Text("${controller.handleTransactionsToday()}x"),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Items Sold Today",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Text("${controller.handleItemsSoldToday()} items"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Transaction History"),
                    Row(
                      children: [
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            TextButton(
                                              onPressed: () => SortHistory
                                                  .sortByRecentTransactions(),
                                              child: const Text(
                                                "Sort by Recent Transactions",
                                                style: TextStyle(
                                                    color: Colors.blueGrey),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () => SortHistory
                                                  .sortByOldestTransactions(),
                                              child: const Text(
                                                "Sort by Oldest Transactions",
                                                style: TextStyle(
                                                    color: Colors.blueGrey),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () => SortHistory
                                                  .sortByMostRevenue(),
                                              child: const Text(
                                                "Sort by Most Revenue",
                                                style: TextStyle(
                                                    color: Colors.blueGrey),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () => SortHistory
                                                  .sortByBestSellingProducts(),
                                              child: const Text(
                                                "Sort by Best Selling Products",
                                                style: TextStyle(
                                                    color: Colors.blueGrey),
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
                  ],
                ),
              ),
              HistoryService().history.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: Text("No Data"),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: HistoryService()
                          .history
                          .map(
                            (event) => InkWell(
                              onTap: () => showConfirmation(
                                  message: "Delete this history ?",
                                  onPressed: () =>
                                      controller.deleteHistory(event["id"])),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: (event["products"]
                                                    as List)
                                                .map((e) => Text(
                                                      e,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16.0,
                                                      ),
                                                    ))
                                                .toList(),
                                          ),
                                          const SizedBox(
                                            height: 4.0,
                                          ),
                                          Text(DateFormat("H:mm - dd MMM y")
                                              .format(DateTime.parse(
                                                  event["created_at"]))),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                              "${event["total_quantity"]} items"),
                                          const SizedBox(
                                            height: 4.0,
                                          ),
                                          Text(CurrencyFormat.convertToIdr(
                                              event["total_payment"], 2)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  State<HomeView> createState() => HomeController();
}
