import 'dart:io';
import 'package:alioss_f/database/user_info_provider.dart';

import 'package:permission_handler/permission_handler.dart';

class AppConfig {


  int isFirstStart=1;
  UserInfo _userInfo;

  UserInfo get userInfo => _userInfo;

  factory AppConfig() => _getInstance();

  static AppConfig get instance => _getInstance();
  static AppConfig _instance;

  AppConfig._internal() {}

  static AppConfig _getInstance() {
    if (_instance == null) {
      _instance = AppConfig._internal();
    }
    return _instance;
  }

  Future<bool> requestPermissions()async{
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    print(statuses[Permission.storage]);
    return true;
  }

  Future<void> init()async{
    requestPermissions();
    UserInfoProvider infoProvider = UserInfoProvider();
    await infoProvider.open("");
    await infoProvider.getAll([]).then((value){
      if(value==null){
        isFirstStart = 1;
      }else{
        _userInfo=value.first;
        isFirstStart = 0;
      }
    });
    await infoProvider.close();
  }

}
