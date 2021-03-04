import 'dart:io';
import 'dart:math';

import 'package:alioss_f/config/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'ossutil/oss_helper.dart';

class UpLoadPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return UpLoadPageState();
  }
}

class UpLoadPageState extends State<UpLoadPage>{

  String _imageUrl = "images/bottombar_icon_file_nor.png";
  File _image;
  final picker = ImagePicker();
  Oss oss = Oss.instance;
  @override
  Widget build(BuildContext context) {
    return
      Center(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  width: 300,
                  margin: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 1,color:Colors.black),
                    color: Constant.backgroundColor
                  ),
                  child:
                  Center(
                    child: _image==null?Image.asset(_imageUrl):Image.file(_image,fit: BoxFit.cover,width: 250,height: 250,),
                  ),
                ),
                Transform(transform: Transform.translate(offset:Offset(300.0-24.0,24.0)).transform,
                child: IconButton(icon: Icon(Icons.delete,color: _image==null?Colors.grey:Colors.redAccent,), onPressed: _image==null?null:(){
                  setState(() {
                    _image = null;
                  });
                }),)
              ],
            ),

            FlatButton(onPressed: ()async{
              final pickedFile = await picker.getImage(source: ImageSource.gallery);
              setState(() {
                if(pickedFile!=null){
                  _image = File(pickedFile.path);
                }
              });
            }, child:Text("相册选择"),shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Colors.black,
                    width: 1
                ),
                borderRadius: BorderRadius.circular(8)
            ),
            ),
            FlatButton(onPressed: ()async{
              final pickedFile = await picker.getImage(source: ImageSource.camera);
              setState(() {
                if(pickedFile!=null){
                  _image = File(pickedFile.path);
                }
              });
            }, child:Text("相机拍照"),shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.black,
                width: 1
              ),
              borderRadius: BorderRadius.circular(8)
            ),),
            FlatButton(onPressed: _image==null?null:(){
              oss.uploadImage(_image);
            },

              child:Text("上传"),disabledColor: Colors.black26,
              color: Colors.greenAccent,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Colors.black,
                      width: 1
                  ),
                  borderRadius: BorderRadius.circular(8)
              ),
            ),
          ],
        ),
      );
  }

}