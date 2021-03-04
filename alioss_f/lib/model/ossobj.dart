class OssObject{
  String key;
  String lastM;
  String etag;
  String type;
  int size;
  String storage_class;
  OssObject({this.key, this.lastM, this.etag, this.type, this.size, this.storage_class});

  OssObject.fromMap(Map map){
    key = map["Key"];
    lastM = map["LastModified"];
    etag = map["ETag"];
    type = map["Type"];
    size = int.parse(map["Size"]);
    storage_class = map["StorageClass"];
  }
}