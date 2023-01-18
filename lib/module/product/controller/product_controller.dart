import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:store_records/core.dart';
import 'package:store_records/util/currency_format.dart';
import 'package:store_records/util/show_alert.dart';
import 'package:store_records/util/show_success.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ProductController extends State<ProductView> implements MvcController {
  static late ProductController instance;
  late ProductView view;

  refresh() => setState(() {});

  String productName = '', price = '';

  List headerExcel = [
    'Product ID',
    'Created At',
    'Product Name',
    'Price',
  ];

  @override
  void initState() {
    instance = this;
    super.initState();
  }

  @override
  void dispose() => super.dispose();

  void saveProduct() async {
    if (productName != '' && price != '') {
      await ProductService().addProduct(
        productName: productName,
        price: double.parse(price),
      );
      setState(() {});
      showSuccess();
    } else {
      showAlert("Oppsss", "Form input is required!");
    }
  }

  void deleteProduct(String id) async {
    await ProductService().deleteProduct(id);
    showSuccess();
    setState(() {});
  }

  Future<void> exportToExcel() async {
    final Workbook workbook = Workbook();

    final Worksheet sheet = workbook.worksheets[0];

    for (var i = 1; i <= headerExcel.length; i++) {
      sheet.getRangeByIndex(1, i).setText(headerExcel[i - 1]);
    }

    for (var i = 1; i <= ProductService().product.length; i++) {
      List valueData = [
        ProductService().product[i - 1]["id"],
        DateFormat("H:mm - dd MMM y").format(
            DateTime.parse(ProductService().product[i - 1]["created_at"])),
        ProductService().product[i - 1]["product_name"],
        CurrencyFormat.convertToIdr(
            ProductService().product[i - 1]["price"], 2),
      ];

      for (var j = 1; j <= valueData.length; j++) {
        sheet.getRangeByIndex(i + 1, j).setText('${valueData[j - 1]}');
      }
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = '$path/your-product.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    await OpenFile.open(fileName);
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}
