
import 'dart:io';
import 'dart:math';

import 'package:alioss_f/config/constant.dart';
import 'package:alioss_f/model/sys_file_store.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'animations/animation_1.dart';


class DisplayPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return DisplayPageState();
  }
}

class DisplayPageState extends State<DisplayPage> with SingleTickerProviderStateMixin{

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SystemFileStore store = SystemFileStore();
  List<File> fileList = List();
  bool pic = true;
  String dir ="/image-recover/";

  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    getImages();
    controller = AnimationController(duration: Duration(milliseconds: 600),vsync: this);
    animation = Tween(begin: 0.0,end:2*pi).animate(controller);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.backgroundColor,
      key: _scaffoldKey,
      body:
      gallary(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(pic){
            dir = "/image-recover/";
          }else{
            dir = "/Pictures/";
          }
          if(controller.isCompleted){
            controller.reverse();
          }else{
            controller.forward();
          }
          getImages();
          _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text(dir),
              duration: Duration(milliseconds: 500),
          ));
          pic=!pic;
        },
        child: MyAnimatedWidget(Icon(Icons.cached),animation: animation,),
      ),
    );
  }

  Widget gallary(){
    return fileList.isEmpty?
    GestureDetector(
      child: Center(
        child: Text("没有本地图片"),
      ),
      onTap: getImages,
    ):
    RefreshIndicator(
      child: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

            crossAxisCount: 2,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 16.0
            ,
            childAspectRatio: 1.0
        ), itemBuilder: _itemBuilder,scrollDirection: Axis.vertical,itemCount: fileList.length,),
      onRefresh: getImages,
    );
  }

  Widget _itemBuilder(context,index){
    return Container(
      width: 100.0,
      height: 100.0,
      child: Image.file(fileList[index]),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1,color:Colors.black),
          color: Constant.backgroundColor
      ),
    );
  }


  Future<void>  getImages()async{
    fileList.clear();
    var directory = await getExternalStorageDirectory();
    String path = directory.path;
    path = path+dir;
    //"/Pictures“
    directory = Directory(path);
    directory.list(followLinks: false).listen((file) {
      fileList.add(file);
    },onDone: (){
      setState(() {

      });
    });
  }
}