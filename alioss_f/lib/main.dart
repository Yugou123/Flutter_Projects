
import 'package:alioss_f/config/app_config.dart';
import 'package:alioss_f/oss_info_setting_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'main_page.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  Future.wait([AppConfig.instance.init()]).then((value) =>
      runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 图片上传恢复',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AppConfig.instance.isFirstStart==1?OssInfoSettingPage():MainPage(),
    );
  }
}