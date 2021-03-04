
import 'package:alioss_f/buket_page.dart';
import 'package:alioss_f/config/app_config.dart';
import 'package:alioss_f/config/constant.dart';
import 'package:alioss_f/oss_info_setting_page.dart';
import 'package:alioss_f/upload_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'display_page.dart';

class MainPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }

}

class _MainPageState extends State<MainPage>{
  final _pages = [BucketPage(),UpLoadPage(),DisplayPage()];
  final btnvgts = [
    BottomNavigationBarItem(icon: Icon(Icons.archive),label: "bucket"),
    BottomNavigationBarItem(icon: Icon(Icons.upload_file),label: "上传"),
    BottomNavigationBarItem(icon: Icon(Icons.grid_view),label: "本地保存图片"),
  ];
  int _currentP = 0;

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Constant.backgroundColor,
      appBar: AppBar(title: Text("图片备份"),),
      body: IndexedStack(
        children:_pages,
        index: _currentP,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: btnvgts,
        currentIndex: _currentP,
        onTap: (index){
          setState(() {
            _currentP = index;
          });
        },
      ),
        drawer: InfoNavigator(),
        drawerEdgeDragWidth: 64.0,
    );
  }

  Widget InfoNavigator(){
    return
      Container(
        height: 400,
        width: 300,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Constant.backgroundColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8),
        ),
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text("Oss信息",style: TextStyle(fontSize: 24),),

            Container(
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black,width: 1)
              ),
              child: Text("AccesskeyID:"+"\n"+"${AppConfig.instance.userInfo.accessKeyID}",textAlign: TextAlign.left,style: Constant.drawerText,),
            ),
            SizedBox(height: 8,),
            Container(
              padding: EdgeInsets.all(4.0),
              child: Text("bucket:"+"\n"+"${AppConfig.instance.userInfo.bucket}",textAlign: TextAlign.left,style: Constant.drawerText,),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black,width: 1)
              ),
            ),
            SizedBox(height: 8,),
            Container(
                padding: EdgeInsets.all(4.0),
                child: Text("endpoint:"+"\n"+"${AppConfig.instance.userInfo.endpoint}",textAlign: TextAlign.left,style: Constant.drawerText)
              ,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black,width: 1)
              ),
            ),
            SizedBox(height: 8,),
            Container(
              padding: EdgeInsets.all(4.0),
                alignment: Alignment.center,
                child: FlatButton(onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                    return OssInfoSettingPage();
                  }));
                },
                  child:Text("修改信息"),
                  color: Colors.white54,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.black,
                          width: 1
                      ),
                      borderRadius: BorderRadius.circular(8)
                  ),
                ),
            )
          ],
        ),
      );
  }
}