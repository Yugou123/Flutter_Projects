import 'dart:async';
import 'dart:io';

import 'FileStore.dart';


class SystemFileStore with FileStore{
  


  @override
  Future<List<File>> list(String dir, {String order = 'name', int start = 0, int limit = 1000}) async {
    var diskFiles = List<File>();
    var dirs = List<File>();
    if(null==dir) return diskFiles;

    Directory directory = Directory(dir);
    int count = 0;
    var _diskFilesComplete = Completer();
    var listOfFiles = directory.list(followLinks: false);

    listOfFiles.listen((file) {
      var fileName = file.path.substring(file.path.lastIndexOf('/')+1);
      //TODO文件路径判断
      if(file.path==null||(fileName.substring(0,1)=='_')||(fileName.substring(0,1)=='.')||count++<start) return;

      if(count>(start+limit)) {
        _diskFilesComplete.isCompleted?null:_diskFilesComplete.complete('');
        return;
      }
    },
        onDone: (){
      _diskFilesComplete.isCompleted?null:_diskFilesComplete.complete('');
      },
        onError: (e)=>_diskFilesComplete.completeError(e)
    );

    await _diskFilesComplete.future;

    // FileStore.sortFiles(dirs, order);
    // FileStore.sortFiles(diskFiles, order);
    dirs.addAll(diskFiles);
    return dirs;
  }
}