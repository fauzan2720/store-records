import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:store_records/service/history_service.dart';
import 'package:store_records/state_util.dart';
import 'package:store_records/util/currency_format.dart';
import 'package:store_records/util/show_success.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../view/home_view.dart';

class HomeController extends State<HomeView> implements MvcController {
  static late HomeController instance;
  late HomeView view;

  refresh() => setState(() {});

  String productName = '', price = '';
  int transactionsToday = 0;
  int itemsSoldToday = 0;
  double incomesToday = 0;

  String today = DateFormat("dd MMM y").format(DateTime.now());

  List headerExcel = [
    'Transaction ID',
    'Purchase Date',
    'Products (Quantity | Product Name)',
    'Total Quantity',
    'Total Payment',
  ];

  @override
  void initState() {
    instance = this;
    super.initState();
  }

  @override
  void dispose() => super.dispose();

  void deleteHistory(String id) async {
    await HistoryService().deleteHistory(id);
    showSuccess();
    setState(() {});
  }

  double handleIncomesToday() {
    incomesToday = 0;
    List listHistory = HistoryService()
        .history
        .where((element) =>
            DateFormat("dd MMM y")
                .format(DateTime.parse(element['created_at'])) ==
            today)
        .toList();
    for (var i = 0; i < listHistory.length; i++) {
      if (DateFormat("dd MMM y")
              .format(DateTime.parse(listHistory[0]['created_at'])) ==
          today) {
        incomesToday +=
            double.parse(listHistory[i]['total_payment'].toString());
      }
    }
    return incomesToday;
  }

  int handleTransactionsToday() {
    transactionsToday = HistoryService()
        .history
        .where((element) =>
            DateFormat("dd MMM y")
                .format(DateTime.parse(element['created_at'])) ==
            today)
        .length;
    return transactionsToday;
  }

  int handleItemsSoldToday() {
    itemsSoldToday = 0;
    List listHistory = HistoryService()
        .history
        .where((element) =>
            DateFormat("dd MMM y")
                .format(DateTime.parse(element['created_at'])) ==
            today)
        .toList();
    for (var i = 0; i < listHistory.length; i++) {
      itemsSoldToday += int.parse(listHistory[i]['total_quantity'].toString());
    }
    return itemsSoldToday;
  }

  Future<void> exportToExcel() async {
    final Workbook workbook = Workbook();

    final Worksheet sheet = workbook.worksheets[0];

    for (var i = 1; i <= headerExcel.length; i++) {
      sheet.getRangeByIndex(1, i).setText(headerExcel[i - 1]);
    }

    for (var i = 1; i <= HistoryService().history.length; i++) {
      List valueData = [
        HistoryService().history[i - 1]["id"],
        DateFormat("H:mm - dd MMM y").format(
            DateTime.parse(HistoryService().history[i - 1]["created_at"])),
        HistoryService().history[i - 1]["products"],
        HistoryService().history[i - 1]["total_quantity"],
        CurrencyFormat.convertToIdr(
            HistoryService().history[i - 1]["total_payment"], 2),
      ];

      for (var j = 1; j <= valueData.length; j++) {
        sheet.getRangeByIndex(i + 1, j).setText('${valueData[j - 1]}');
      }
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = '$path/store-records.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    await OpenFile.open(fileName);
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}
