import 'package:alioss_f/config/app_config.dart';
import 'package:alioss_f/config/constant.dart';
import 'package:alioss_f/database/user_info_provider.dart';
import 'package:flutter/material.dart';

class OssInfoSettingPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return OssInfoSettingPageState();
   }
}

class OssInfoSettingPageState extends State<OssInfoSettingPage>{

  final  _scaffoldKey = GlobalKey<ScaffoldState>();
  final  _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  UserInfo userInfo = UserInfo();
  UserInfoProvider infoProvider = UserInfoProvider();

  @override
  void initState() {
    infoProvider.open("");
    if(AppConfig.instance.userInfo!=null)
      userInfo = AppConfig.instance.userInfo;
    super.initState();
  }

  @override
  void dispose() {
    infoProvider.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("OSS信息设置"),),
      backgroundColor: Constant.backgroundColor,
      key: _scaffoldKey,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidate?AutovalidateMode.always:AutovalidateMode.disabled,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: InfoSetting(),
          ),
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(value)
    ));
  }

  void _handleSubmitted() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidate = true; // Start validating on every change.
      showInSnackBar('表单信息存在错误');
    }
    else {
      form.save();
      showInSnackBar('提交中...');
      if(AppConfig.instance.isFirstStart==1){
        infoProvider.insert(userInfo);
      }else{
        infoProvider.update(userInfo);
      }
      Navigator.of(context).pop(true);
    }
  }

  String _validateEmpty(String value) {
    if (value.isEmpty)
      return 'Name is required.';
    return null;
  }

  String _validateName(String value) {
    if (value.isEmpty)
      return 'Name is required.';
    return null;
  }
  Widget InfoSetting(){
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: 24.0),
        TextFormField(
          initialValue:userInfo.accessKeyID,
          keyboardType: TextInputType.text,
          onSaved: (String value) { userInfo.accessKeyID = value; },
          validator: _validateEmpty,
          decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'AccessKey ID',
              suffixStyle: TextStyle(color: Colors.green)
          ),
          maxLines: 1,
        ),
        const SizedBox(height: 24.0),
        TextFormField(
          initialValue:userInfo.accessKey,
          keyboardType: TextInputType.text,
          onSaved: (String value) { userInfo.accessKey = value; },
          validator: _validateEmpty,
          decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Access Key Secret',
              suffixStyle: TextStyle(color: Colors.green)
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 24.0),
        TextFormField(
          initialValue:userInfo.bucket,
          onSaved: (String value) {userInfo.bucket = value; },
          keyboardType: TextInputType.text,
          validator: _validateEmpty,
          decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Bucket',
              suffixStyle: TextStyle(color: Colors.green)
          ),
          maxLines: 1,
        ),
        const SizedBox(height: 24.0),
        TextFormField(
          onSaved: (String value) { userInfo.endpoint = value; },
          keyboardType: TextInputType.text,
          initialValue:userInfo.endpoint,
          validator: _validateEmpty,
          decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Domain',
              prefixText: 'https://',
              suffixStyle: TextStyle(color: Colors.green)
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 24.0),
        TextFormField(
          initialValue: userInfo.pwd,
          validator: _validateName,
          onSaved: (String value) { userInfo.pwd = value; },
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Passcode *',
            suffixStyle: TextStyle(color: Colors.green),
          ),
          maxLines: 1,
        ),
        const SizedBox(height: 24.0),
    Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
    Text('记住密码'),
    Checkbox(
    value: userInfo.savePass==null?false:(userInfo.savePass==1?true:false), onChanged:(v){
      setState(() {
        v?userInfo.savePass =1:userInfo.savePass =0;
      });
    })
    ],
    ),
        const SizedBox(height: 24.0),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          child: Text("submit"),
          onPressed: _handleSubmitted,
        ),
        const SizedBox(height: 24.0),
        // widget.first? Text('你必须先添加一个OSS账户信息才能进入系统',style: Theme.of(context).textTheme.caption ):const SizedBox(height: 24.0),
      ],
    );
  }
}