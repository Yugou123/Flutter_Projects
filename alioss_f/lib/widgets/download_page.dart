
import 'dart:io';

import 'package:alioss_f/config/constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DownloadPage extends StatefulWidget{
  final String url;
  DownloadPage(this.url);
  @override
  State<StatefulWidget> createState() {
    return DownloadPageState();
  }
}

class DownloadPageState extends State<DownloadPage> {
  double currentProgress;
  File image=null;

  @override
  void initState() {
    currentProgress = 0.0;
    downLoadPicture(widget.url, widget.url.substring(widget.url.lastIndexOf("/")+1,widget.url.lastIndexOf("?")));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.backgroundColor,
      appBar: AppBar(title: Text("下载"),),
      body: Container(
        padding: EdgeInsets.all(48),
        child:
        Column(
          children: [
            Center(
              child: Image(image: image==null?AssetImage("images/bottombar_icon_file_nor.png"):FileImage(image),width: 400,height: 400,fit: BoxFit.cover,),
            ),
            SizedBox(
              height: 46,
            ),
            Center(
              child: LinearProgressIndicator(
                value: currentProgress,
              ),
            ),
            Center(
              child: Text("${currentProgress*100}%"),
            ),
            Center(
              child: Text(image==null?"":"${image.path}"),
            ),
          ],
        ),
      ),
    );
  }

  void downLoadPicture(String url,String name) async{
    var directory = await getExternalStorageDirectory();
    String path = directory.path;
    path = path+"/image-recover/";
    print(path);
    Dio dio = Dio();
    Response response = await dio.download(url, "$path$name", onReceiveProgress: (rec,tol){
      if(tol!=-1){
        setState(() {
          currentProgress = rec/tol;
        });
      }else{
        print("错误");
      }
    });

    setState(() {
      image = File("$path$name");
    });
  }
}