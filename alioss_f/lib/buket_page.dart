import 'dart:io';

import 'package:alioss_f/config/constant.dart';
import 'package:alioss_f/widgets/download_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

import 'model/ossobj.dart';
import 'ossutil/oss_helper.dart';

class BucketPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _BucketPageState();
  }
}

enum LoadState{loading,loaded,fail}

class _BucketPageState extends State<BucketPage> {

  LoadState _loadState;
  Oss oss = Oss.instance;
  List<OssObject> ossObjList = List();

  @override
  void initState() {
    _loadState = LoadState.loading;
    _getBucketObj();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _bucketView()
          ],
        ),
      ),
    );
  }

  Widget _bucketView() {
    switch (_loadState) {
      case LoadState.loading:
        return Center(
          child: Column(
            children: [
              SizedBox(height: 200,),
              CircularProgressIndicator(strokeWidth: 4.0,),
              Text('正在加载')
            ],
          ),
        );
        break;
      case LoadState.loaded:
        return
            RefreshIndicator(child:
            ListView.builder(
                itemCount: ossObjList.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(right: 4,left: 4),
                itemBuilder: (BuildContext context, int index){
                  return _ossObjItem(ossObjList[index]);
                }), onRefresh: _getBucketObj);
      case LoadState.fail:
       return Center(
         child: Column(
           children: [
             SizedBox(height: 200,),
             Text('加载失败')
           ],
         ),
       );
    }
  }

  Widget _ossObjItem(OssObject obj) {
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                    width: 1,
                    color:Colors.orange)
        ),
        child: ListTile(
          title: Row(
            children: [
              Container(
                  padding: EdgeInsets.all(4),
                  child:Image(
                fit: BoxFit.contain,
          width: 36,
          height: 36,
          image: NetworkImage(oss.objectUrl("images"+obj.key.substring(obj.key.lastIndexOf('/')))))

    ),
              Expanded(child: Text(obj.key.substring(obj.key.lastIndexOf('/'))))
            ],
          ),
          subtitle: Text("大小： ${obj.size}B"),
        ),
      ),
      onTap: (){
        print(oss.objectUrl("images"+obj.key.substring(obj.key.lastIndexOf('/'))));
      },
      onLongPress: (){
        showDialog(context: context,
            builder: (BuildContext context){
              return SimpleDialog(
                children: [
                   SimpleDialogOption(
                    child: Text("分享"),
                     onPressed: (){
                      Share.share("图片临时分享链接："+oss.objectUrl("images"+obj.key.substring(obj.key.lastIndexOf('/'))));
                     },
                  ),
                  SimpleDialogOption(
                    child: Text("备份到本地"),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                        return DownloadPage(oss.objectUrl("images"+obj.key.substring(obj.key.lastIndexOf('/'))));
                      }));
                    },
                  ),
                ],
              );
            });
      },
    );
  }


  Future<void> _getBucketObj() async {
    ossObjList.clear();
    await oss.bucket().then((map) {
      List contents = List();
      contents = map["contents"];
      contents.forEach((element) {
        ossObjList.add(OssObject.fromMap(element));
      });
      ossObjList.removeAt(0);
      setState(() {
        _loadState = LoadState.loaded;
      });
    });
  }
}
