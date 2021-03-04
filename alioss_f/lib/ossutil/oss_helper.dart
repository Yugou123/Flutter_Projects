import 'dart:convert';
import 'dart:io';

import 'package:alioss_f/config/app_config.dart';
import 'package:alioss_f/ossutil/util.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

import 'gmt.dart';

class Oss {
  factory Oss() => _getInstance();

  static Oss get instance => _getInstance();
  static Oss _instance;
  Oss._internal();

  static Oss _getInstance() {
    if (_instance == null) {
      _instance = Oss._internal();
    }
    return _instance;
  }

  Future<void> init() async {}

  uploadImage(File file) async {
    String policyText =
        '{"expiration": "2090-01-01T12:00:00.000Z","conditions": [["content-length-range", 0, 1048576000]]}';
    //进行utf8编码
    List<int> policyTextUtf8 = utf8.encode(policyText);
    //进行base64编码
    String policyBase64 = base64.encode(policyTextUtf8);
    //再次进行utf8编码
    List<int> policy = utf8.encode(policyBase64);

    //进行utf8 编码
    List<int> key = utf8.encode(AppConfig.instance.userInfo.accessKey);
    //通过hmac,使用sha1进行加密
    List<int> signaturePre = Hmac(sha1, key).convert(policy).bytes;

    //最后一步，将上述所得进行base64 编码
    String signature = base64.encode(signaturePre);

    Dio dio = Dio();
    dio.options.responseType = ResponseType.plain;
    dio.options.contentType = "multipart/form-data";
    //上传到文件名
    String fileName =
        file.path.substring(file.path.lastIndexOf("/") + 1, file.path.length);
    FormData data = FormData.fromMap({
      'key': "images/" + fileName,
      'policy': policyBase64,
      'OSSAccessKeyId': AppConfig.instance.userInfo.accessKeyID,
      'success_action_status': '200',
      'signature': signature,
      'file': MultipartFile.fromFileSync(file.path, filename: fileName)
    });
    try {
      Response response = await dio
          .post("http://${AppConfig.instance.userInfo.bucket}${AppConfig.instance.userInfo.endpoint}", data: data);
      if (response.statusCode == 200) {
        print(response.headers);
        print(response.data);
        print("https://image-recover.oss-cn-beijing.aliyuncs.com/images/" +
            fileName);
      }
    } on DioError catch (e) {
      print(e.message);
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
    }
  }

  //header的签名信息
  Options headerSign({String args}) {
    String gmt = Gmt.format(DateTime.now().millisecondsSinceEpoch +
        10 *
            1000);
    print("gmt $gmt");
    if (args == null) {
      args = '/';
    } else {
      args = "/$args/";
    }
    String signature = base64.encode(
        Hmac(sha1, utf8.encode(AppConfig.instance.userInfo.accessKey))
            .convert(utf8.encode("GET\n\n\n$gmt\n$args"))
            .bytes);

    Options options = Options(headers: {
      'Authorization':
          "OSS " + AppConfig.instance.userInfo.accessKeyID + ":" + signature,
      'Date': gmt,
    });
    return options;
  }

  Future<Map> buckets() async {
    Dio dio = Dio();
    Map returns = Map();
    try {
      Response response = await dio.get("https://oss-cn-beijing.aliyuncs.com",
          options: headerSign());
      Map map = xml2map(response.data);
      print(map);
      returns['code'] = 0;
      returns['bucket'] = map['ListAllMyBucketsResult']['Buckets']['Bucket'];
    } on DioError catch (e) {
      print(e.message);
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
    }
    return returns;
  }

  Future<Map> bucket(
      {String prefix,
      String delimiter = '/',
      int maxKeys = 1000,
      String marker}) async {
    //创建dio对象
    String endpoint = AppConfig.instance.userInfo.endpoint;
    String bucketName = AppConfig.instance.userInfo.bucket;
    prefix = "images/";

    Dio dio =  Dio();
    Map returns = Map();
    String url = "https://$bucketName.$endpoint?max-keys=$maxKeys";
    try {
      if (delimiter != null) {
        url = "$url&delimiter=$delimiter";
      }
      if (prefix != null) {
        url = "$url&prefix=$prefix";
      }
      print("oss bucket marker $marker");
      if (marker != null) {
        url = "$url&marker=$marker";
      }
      print(url);
      Response response =
          await dio.get(url, options: headerSign(args: bucketName));
      Map map = xml2map(response.data);
      print(map);
      returns['code'] = 0;

      returns['contents'] = map['ListBucketResult']['Contents'] ?? [];
      if (returns['contents'] is Map) {
        returns['contents'] = [returns['contents']];
      }
      returns['commonPrefixes'] =
          map['ListBucketResult']['CommonPrefixes'] ?? [];
      if (returns['commonPrefixes'] is Map) {
        returns['commonPrefixes'] = [returns['commonPrefixes']];
      }
      returns['more'] = map['ListBucketResult']['IsTruncated'] == 'true';
      returns['marker'] =
          returns['more'] ? map['ListBucketResult']['NextMarker'] : null;
      returns['prefix'] = map['ListBucketResult']['Prefix'];
      print(returns);
      return returns;
    } on DioError catch (e) {
      return _error(e, returns);
    }
  }

  Map _error(DioError e, Map returns) {
    print(e.message);
    Map map = xml2map(e.response.data);
    if (map.containsKey('Error')) {
      returns['code'] = map['Error']['Code'];
      returns['message'] = map['Error']['Message'];
    }
    print(e.response.data);
    print(e.response.headers);
    print(e.response.request);
    return returns;
  }

  //获取图片的URL
  objectUrl(String name) {
    int expire = DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600;
    String stringToSign =
        "GET\n\n\n$expire\n/${AppConfig.instance.userInfo.bucket}/$name";
    String sign = Uri.encodeComponent(base64.encode(
        Hmac(sha1, utf8.encode(AppConfig.instance.userInfo.accessKey))
            .convert(utf8.encode(stringToSign))
            .bytes));
    return "https://${AppConfig.instance.userInfo.bucket}.${AppConfig.instance.userInfo.endpoint}/$name?OSSAccessKeyId=${AppConfig.instance.userInfo.accessKeyID}&Expires=$expire&Signature=$sign";
  }
}
