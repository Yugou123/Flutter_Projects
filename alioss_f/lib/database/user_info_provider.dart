import 'package:alioss_f/config/constant.dart';
import 'package:alioss_f/database/dataprovider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String tableName = "users";
final String columnID = "accessKeyID";
final String columnKey = "accessKey";
final String columnBucket = "bucket";
final String columnEndpoint = "endpoint";
final String columnPwd = "pwd";
final String columnSave = "savePass";
class UserInfo{


  String accessKeyID;
  String accessKey;
  String bucket;
  String endpoint;
  String pwd;
  int savePass;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnID: accessKeyID,
      columnKey: accessKey,
      columnBucket:bucket,
      columnEndpoint:endpoint,
      columnPwd:pwd,
      columnSave:savePass
    };
    if (accessKeyID != null) {
      map[columnID] = accessKeyID;
    }
    return map;
  }

  UserInfo();
  UserInfo.fromMap(Map<String, dynamic> map) {
    accessKeyID = map[columnID];
    accessKey = map[columnKey];
    bucket = map[columnBucket];
    endpoint = map[columnEndpoint];
    pwd = map[columnPwd];
    savePass = map[columnSave];
  }
}

class UserInfoProvider extends DataProvider<UserInfo>{
  Database db;
  @override
  Future<int> delete(List arguments) async {
    return await db.delete(
      tableName,
      where: '$columnID = ?',
      whereArgs: arguments
    );
  }

  //accessId和pwd访问
  @override
  Future<UserInfo> get(List arguments) async {
    List<Map> maps;
    if(arguments.length==1){
      maps = await db.query(tableName,
          columns: [columnID, columnBucket, columnEndpoint,columnKey],
          where: '$columnSave = 1 and $columnID = ?',
          whereArgs: arguments);
    }else{
      maps = await db.query(tableName,
          columns: [columnID, columnBucket, columnEndpoint,columnKey],
          where: '$columnID = ? and $columnPwd =?',
          whereArgs: arguments);
    }
    if (maps.length > 0) {
      return UserInfo.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<UserInfo>> getAll([List arguments]) async{
    List<Map> maps;
    maps = await db.rawQuery("select *from $tableName");
    if (maps.length > 0) {
      return [UserInfo.fromMap(maps.first)];
    }
    return null;
  }

  @override
  Future<UserInfo> insert(UserInfo data) async {
    await db.insert(tableName, data.toMap());
    return data;
  }

  @override
  Future open(String path) async {
    String sql = '''
create table $tableName ( 
  $columnID text primary key, 
  $columnKey text,
  $columnBucket text,
  $columnEndpoint text,
  $columnPwd text,
  $columnSave int
  )
''';
    String databasePath = await getDatabasesPath();
    String ph = join(databasePath,Constant.dbName);
    db = await openDatabase(ph, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(sql);
        });
  }

  @override
  Future<int> update(UserInfo data) async{
    return await db.update(tableName, data.toMap(),
        where: '$columnID = ?', whereArgs: [data.accessKeyID]);
  }

  @override
  Future close() async{
    await db.close();
  }
}