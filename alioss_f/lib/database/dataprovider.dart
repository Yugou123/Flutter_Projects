abstract class DataProvider<T>{
  Future<T> get(List<dynamic> arguments);
  Future<List<T>> getAll([List<dynamic> arguments]);
  Future<int> update(T data);
  Future<T> insert(T data);
  Future<int> delete(List<dynamic> arguments);
  Future open(String path);
  Future close();
}
