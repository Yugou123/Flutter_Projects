
import 'dart:io';

abstract class FileStore{
  Future<List<File>> list(String dir,{String order = 'name',int start=0,int limit=1000});
}

