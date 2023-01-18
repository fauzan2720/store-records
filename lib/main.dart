import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:store_records/module/home/view/home_view.dart';
import 'package:store_records/session.dart';
import 'package:store_records/state_util.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var path = await getTemporaryDirectory();
  Hive.init(path.path);
  mainStorage = await Hive.openBox('mainStorage');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Get.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomeView(),
    );
  }
}
