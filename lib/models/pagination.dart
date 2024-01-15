class Pagination<T> {
  int? currentPage;
  int? lastPage;
  List<T>? data;

  Pagination(){
    data =[];
  }

  Pagination.fromMap(Map<String, dynamic> map){
    currentPage = map['current_page'];
    lastPage = map['last_page'];
    data = [];
  }
}